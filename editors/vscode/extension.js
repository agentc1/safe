"use strict";

const vscode = require("vscode");
const childProcess = require("child_process");
const path = require("path");

let activeClient = null;

class SafeLspClient {
  constructor(context) {
    this.context = context;
    this.buffer = Buffer.alloc(0);
    this.nextRequestId = 1;
    this.pending = new Map();
    this.collection = vscode.languages.createDiagnosticCollection("safe");
    this.disposables = [this.collection];

    const repoRoot = path.resolve(context.extensionPath, "..", "..");
    const pythonCommand = process.env.SAFE_PYTHON || process.env.PYTHON || "python3";
    const serverPath = path.join(repoRoot, "scripts", "safe_lsp.py");

    this.process = childProcess.spawn(pythonCommand, [serverPath], {
      cwd: repoRoot,
      stdio: ["pipe", "pipe", "pipe"],
    });

    this.process.stdout.on("data", (chunk) => this.onData(chunk));
    this.process.stderr.on("data", (chunk) => {
      const text = chunk.toString("utf8").trim();
      if (text.length > 0) {
        console.warn("[safe-lsp]", text);
      }
    });
    this.process.on("error", (error) => {
      vscode.window.showWarningMessage(`Safe diagnostics shim failed to start: ${error.message}`);
    });
    this.process.on("exit", () => {
      for (const [, handlers] of this.pending.entries()) {
        handlers.reject(new Error("Safe diagnostics shim exited"));
      }
      this.pending.clear();
    });

    this.disposables.push(
      vscode.workspace.onDidOpenTextDocument((document) => this.didOpen(document)),
      vscode.workspace.onDidSaveTextDocument((document) => this.didSave(document)),
      vscode.workspace.onDidCloseTextDocument((document) => this.didClose(document))
    );
  }

  isSafeDocument(document) {
    return document && (document.languageId === "safe" || document.fileName.endsWith(".safe"));
  }

  start() {
    return this.request("initialize", {
      processId: process.pid,
      rootUri: vscode.workspace.workspaceFolders && vscode.workspace.workspaceFolders.length > 0
        ? vscode.workspace.workspaceFolders[0].uri.toString()
        : null,
      capabilities: {}
    }).then(() => {
      this.notify("initialized", {});
      for (const document of vscode.workspace.textDocuments) {
        if (this.isSafeDocument(document)) {
          this.didOpen(document);
        }
      }
      return this;
    });
  }

  didOpen(document) {
    if (!this.isSafeDocument(document)) {
      return;
    }
    this.notify("textDocument/didOpen", {
      textDocument: {
        uri: document.uri.toString(),
        languageId: "safe",
        version: document.version,
        text: document.getText(),
      },
    });
  }

  didSave(document) {
    if (!this.isSafeDocument(document)) {
      return;
    }
    this.notify("textDocument/didSave", {
      textDocument: {
        uri: document.uri.toString(),
      },
    });
  }

  didClose(document) {
    if (!this.isSafeDocument(document)) {
      return;
    }
    this.collection.delete(document.uri);
    this.notify("textDocument/didClose", {
      textDocument: {
        uri: document.uri.toString(),
      },
    });
  }

  request(method, params) {
    const id = this.nextRequestId++;
    return new Promise((resolve, reject) => {
      this.pending.set(id, { resolve, reject });
      this.send({ jsonrpc: "2.0", id, method, params });
    });
  }

  notify(method, params) {
    this.send({ jsonrpc: "2.0", method, params });
  }

  send(payload) {
    const body = Buffer.from(JSON.stringify(payload), "utf8");
    const header = Buffer.from(`Content-Length: ${body.length}\r\n\r\n`, "utf8");
    this.process.stdin.write(Buffer.concat([header, body]));
  }

  onData(chunk) {
    this.buffer = Buffer.concat([this.buffer, chunk]);
    while (true) {
      const headerEnd = this.buffer.indexOf("\r\n\r\n");
      if (headerEnd === -1) {
        return;
      }
      const headerText = this.buffer.slice(0, headerEnd).toString("utf8");
      const match = /^Content-Length:\s*(\d+)$/im.exec(headerText);
      if (!match) {
        this.buffer = Buffer.alloc(0);
        return;
      }
      const length = Number(match[1]);
      const bodyStart = headerEnd + 4;
      if (this.buffer.length < bodyStart + length) {
        return;
      }
      const body = this.buffer.slice(bodyStart, bodyStart + length).toString("utf8");
      this.buffer = this.buffer.slice(bodyStart + length);
      this.handleMessage(JSON.parse(body));
    }
  }

  handleMessage(message) {
    if (message.method === "textDocument/publishDiagnostics") {
      const params = message.params || {};
      const uri = vscode.Uri.parse(params.uri);
      const diagnostics = Array.isArray(params.diagnostics) ? params.diagnostics.map((item) => {
        const start = new vscode.Position(
          item.range.start.line,
          item.range.start.character
        );
        const end = new vscode.Position(
          item.range.end.line,
          item.range.end.character
        );
        const diagnostic = new vscode.Diagnostic(
          new vscode.Range(start, end),
          item.message,
          vscode.DiagnosticSeverity.Error
        );
        diagnostic.source = item.source || "safec";
        if (item.code !== undefined) {
          diagnostic.code = item.code;
        }
        return diagnostic;
      }) : [];
      this.collection.set(uri, diagnostics);
      return;
    }

    if (Object.prototype.hasOwnProperty.call(message, "id")) {
      const handlers = this.pending.get(message.id);
      if (!handlers) {
        return;
      }
      this.pending.delete(message.id);
      if (message.error) {
        handlers.reject(new Error(message.error.message || "LSP request failed"));
      } else {
        handlers.resolve(message.result);
      }
    }
  }

  dispose() {
    try {
      this.request("shutdown", {}).catch(() => undefined).finally(() => {
        this.notify("exit", {});
      });
    } catch (_error) {
      // Best effort only: this shim is intentionally disposable.
    }
    for (const disposable of this.disposables) {
      disposable.dispose();
    }
    if (this.process) {
      this.process.kill();
    }
  }
}

function activate(context) {
  activeClient = new SafeLspClient(context);
  context.subscriptions.push({
    dispose() {
      if (activeClient) {
        activeClient.dispose();
        activeClient = null;
      }
    }
  });
  return activeClient.start();
}

function deactivate() {
  if (activeClient) {
    activeClient.dispose();
    activeClient = null;
  }
}

module.exports = {
  activate,
  deactivate,
};
