	.arch armv8.5-a
	.build_version macos,  16, 0
	.text
	.const
	.align	3
lC3:
	.ascii "safe_po.adb"
	.space 1
	.text
	.align	2
_safe_po__safe_div___wrapped_statements.0:
LFB3:
	stp	x29, x30, [sp, -32]!
LCFI0:
	mov	x29, sp
LCFI1:
	mov	x0, x16
	str	x16, [x29, 24]
	ldr	x1, [x0, 16]
	cmp	x1, 0
	bne	L2
	mov	w1, 32
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Divide_By_Zero
L2:
	ldr	x2, [x0, 8]
	ldr	x1, [x0, 16]
	mov	x3, -9223372036854775808
	cmp	x2, x3
	bne	L3
	cmn	x1, #1
	bne	L3
	mov	w1, 32
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Overflow_Check
L3:
	sdiv	x1, x2, x1
	str	x1, [x0]
	nop
	ldp	x29, x30, [sp], 32
LCFI2:
	ret
LFE3:
	.const
	.align	3
lC4:
	.ascii "failed precondition from safe_po.ads:41"
	.align	3
lC5:
	.ascii "failed precondition from safe_po.ads:42"
	.align	3
lC6:
	.ascii "safe_po.ads"
	.space 1
	.align	3
lC7:
	.ascii "failed postcondition from safe_po.ads:43"
	.text
	.align	2
	.globl _safe_po__safe_div
_safe_po__safe_div:
LFB2:
	stp	x29, x30, [sp, -96]!
LCFI3:
	mov	x29, sp
LCFI4:
LEHB0:
LEHE0:
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
LCFI5:
	str	x0, [x29, 56]
	str	x1, [x29, 48]
	add	x0, x29, 96
	str	x0, [x29, 88]
	ldr	x0, [x29, 56]
	str	x0, [x29, 72]
	ldr	x0, [x29, 48]
	str	x0, [x29, 80]
	ldr	x0, [x29, 80]
	cmp	x0, 0
	bne	L6
	adrp	x0, lC4@PAGE
	add	x4, x0, lC4@PAGEOFF;
	adrp	x0, lC0@PAGE
	add	x5, x0, lC0@PAGEOFF;
	mov	x0, x4
	mov	x1, x5
LEHB1:
	bl	_system__assertions__raise_assert_failure
L6:
	ldr	x1, [x29, 72]
	mov	x0, -9223372036854775808
	cmp	x1, x0
	bne	L7
	ldr	x0, [x29, 80]
	cmn	x0, #1
	bne	L7
	adrp	x0, lC5@PAGE
	add	x2, x0, lC5@PAGEOFF;
	adrp	x0, lC0@PAGE
	add	x3, x0, lC0@PAGEOFF;
	mov	x0, x2
	mov	x1, x3
	bl	_system__assertions__raise_assert_failure
L7:
	add	x0, x29, 64
	mov	x16, x0
	bl	_safe_po__safe_div___wrapped_statements.0
	ldr	x0, [x29, 80]
	cmp	x0, 0
	bne	L8
	mov	w1, 43
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Divide_By_Zero
L8:
	ldr	x1, [x29, 72]
	ldr	x0, [x29, 80]
	mov	x2, -9223372036854775808
	cmp	x1, x2
	bne	L9
	cmn	x0, #1
	bne	L9
	mov	w1, 43
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Overflow_Check
L9:
	sdiv	x1, x1, x0
	ldr	x0, [x29, 64]
	cmp	x1, x0
	beq	L18
	adrp	x0, lC7@PAGE
	add	x20, x0, lC7@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x21, x0, lC1@PAGEOFF;
	mov	x0, x20
	mov	x1, x21
	bl	_system__assertions__raise_assert_failure
LEHE1:
L18:
	nop
	ldr	x19, [x29, 64]
	mov	w0, 0
L14:
	cmp	w0, 1
	beq	L11
	mov	x0, x19
	b	L17
L15:
	mov	x22, x0
	mov	w0, 1
	b	L14
L11:
	mov	x0, x22
LEHB2:
	bl	__Unwind_Resume
L17:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
LEHE2:
	ldp	x29, x30, [sp], 96
LCFI6:
	ret
LFE2:
	.section __TEXT,__gcc_except_tab
	.p2align	2
GCC_except_table0:
LLSDA2:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 LLSDACSE2-LLSDACSB2
LLSDACSB2:
	.uleb128 LEHB0-LFB2
	.uleb128 LEHE0-LEHB0
	.uleb128 0
	.uleb128 0
	.uleb128 LEHB1-LFB2
	.uleb128 LEHE1-LEHB1
	.uleb128 L15-LFB2
	.uleb128 0
	.uleb128 LEHB2-LFB2
	.uleb128 LEHE2-LEHB2
	.uleb128 0
	.uleb128 0
LLSDACSE2:
	.text
	.const
	.align	2
lC0:
	.word	1
	.word	39
	.align	2
lC1:
	.word	1
	.word	40
	.text
	.const
	.align	3
lC8:
	.ascii "failed precondition from safe_po.ads:55"
	.align	3
lC9:
	.ascii "failed precondition from safe_po.ads:56"
	.text
	.align	2
	.globl ____ghost_safe_po__narrow_assignment
____ghost_safe_po__narrow_assignment:
LFB4:
	stp	x29, x30, [sp, -80]!
LCFI7:
	mov	x29, sp
LCFI8:
	stp	x20, x21, [sp, 16]
	stp	x22, x23, [sp, 32]
LCFI9:
	str	x0, [x29, 72]
	stp	x1, x2, [x29, 56]
	ldp	x0, x1, [x29, 56]
	bl	____ghost_safe_model__is_valid_range
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L20
	adrp	x0, lC8@PAGE
	add	x22, x0, lC8@PAGEOFF;
	adrp	x0, lC0@PAGE
	add	x23, x0, lC0@PAGEOFF;
	mov	x0, x22
	mov	x1, x23
	bl	_system__assertions__raise_assert_failure
L20:
	ldr	x2, [x29, 72]
	ldp	x0, x1, [x29, 56]
	bl	____ghost_safe_model__contains
	mov	w1, w0
	cmp	w1, 1
	bls	L21
	mov	w1, 56
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L21:
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L25
	adrp	x0, lC9@PAGE
	add	x20, x0, lC9@PAGEOFF;
	adrp	x0, lC0@PAGE
	add	x21, x0, lC0@PAGEOFF;
	mov	x0, x20
	mov	x1, x21
	bl	_system__assertions__raise_assert_failure
L25:
	nop
	nop
	ldp	x20, x21, [sp, 16]
	ldp	x22, x23, [sp, 32]
	ldp	x29, x30, [sp], 80
LCFI10:
	ret
LFE4:
	.const
	.align	3
lC10:
	.ascii "failed precondition from safe_po.ads:68"
	.align	3
lC11:
	.ascii "failed precondition from safe_po.ads:69"
	.text
	.align	2
	.globl ____ghost_safe_po__narrow_parameter
____ghost_safe_po__narrow_parameter:
LFB5:
	stp	x29, x30, [sp, -80]!
LCFI11:
	mov	x29, sp
LCFI12:
	stp	x20, x21, [sp, 16]
	stp	x22, x23, [sp, 32]
LCFI13:
	str	x0, [x29, 72]
	stp	x1, x2, [x29, 56]
	ldp	x0, x1, [x29, 56]
	bl	____ghost_safe_model__is_valid_range
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L27
	adrp	x0, lC10@PAGE
	add	x22, x0, lC10@PAGEOFF;
	adrp	x0, lC0@PAGE
	add	x23, x0, lC0@PAGEOFF;
	mov	x0, x22
	mov	x1, x23
	bl	_system__assertions__raise_assert_failure
L27:
	ldr	x2, [x29, 72]
	ldp	x0, x1, [x29, 56]
	bl	____ghost_safe_model__contains
	mov	w1, w0
	cmp	w1, 1
	bls	L28
	mov	w1, 69
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L28:
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L32
	adrp	x0, lC11@PAGE
	add	x20, x0, lC11@PAGEOFF;
	adrp	x0, lC0@PAGE
	add	x21, x0, lC0@PAGEOFF;
	mov	x0, x20
	mov	x1, x21
	bl	_system__assertions__raise_assert_failure
L32:
	nop
	nop
	ldp	x20, x21, [sp, 16]
	ldp	x22, x23, [sp, 32]
	ldp	x29, x30, [sp], 80
LCFI14:
	ret
LFE5:
	.const
	.align	3
lC12:
	.ascii "failed precondition from safe_po.ads:81"
	.align	3
lC13:
	.ascii "failed precondition from safe_po.ads:82"
	.text
	.align	2
	.globl ____ghost_safe_po__narrow_return
____ghost_safe_po__narrow_return:
LFB6:
	stp	x29, x30, [sp, -80]!
LCFI15:
	mov	x29, sp
LCFI16:
	stp	x20, x21, [sp, 16]
	stp	x22, x23, [sp, 32]
LCFI17:
	str	x0, [x29, 72]
	stp	x1, x2, [x29, 56]
	ldp	x0, x1, [x29, 56]
	bl	____ghost_safe_model__is_valid_range
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L34
	adrp	x0, lC12@PAGE
	add	x22, x0, lC12@PAGEOFF;
	adrp	x0, lC0@PAGE
	add	x23, x0, lC0@PAGEOFF;
	mov	x0, x22
	mov	x1, x23
	bl	_system__assertions__raise_assert_failure
L34:
	ldr	x2, [x29, 72]
	ldp	x0, x1, [x29, 56]
	bl	____ghost_safe_model__contains
	mov	w1, w0
	cmp	w1, 1
	bls	L35
	mov	w1, 82
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L35:
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L39
	adrp	x0, lC13@PAGE
	add	x20, x0, lC13@PAGEOFF;
	adrp	x0, lC0@PAGE
	add	x21, x0, lC0@PAGEOFF;
	mov	x0, x20
	mov	x1, x21
	bl	_system__assertions__raise_assert_failure
L39:
	nop
	nop
	ldp	x20, x21, [sp, 16]
	ldp	x22, x23, [sp, 32]
	ldp	x29, x30, [sp], 80
LCFI18:
	ret
LFE6:
	.const
	.align	3
lC14:
	.ascii "failed precondition from safe_po.ads:94"
	.align	3
lC15:
	.ascii "failed precondition from safe_po.ads:95"
	.text
	.align	2
	.globl ____ghost_safe_po__narrow_indexing
____ghost_safe_po__narrow_indexing:
LFB7:
	stp	x29, x30, [sp, -80]!
LCFI19:
	mov	x29, sp
LCFI20:
	stp	x20, x21, [sp, 16]
	stp	x22, x23, [sp, 32]
LCFI21:
	str	x0, [x29, 72]
	stp	x1, x2, [x29, 56]
	ldp	x0, x1, [x29, 56]
	bl	____ghost_safe_model__is_valid_range
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L41
	adrp	x0, lC14@PAGE
	add	x22, x0, lC14@PAGEOFF;
	adrp	x0, lC0@PAGE
	add	x23, x0, lC0@PAGEOFF;
	mov	x0, x22
	mov	x1, x23
	bl	_system__assertions__raise_assert_failure
L41:
	ldr	x2, [x29, 72]
	ldp	x0, x1, [x29, 56]
	bl	____ghost_safe_model__contains
	mov	w1, w0
	cmp	w1, 1
	bls	L42
	mov	w1, 95
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L42:
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L46
	adrp	x0, lC15@PAGE
	add	x20, x0, lC15@PAGEOFF;
	adrp	x0, lC0@PAGE
	add	x21, x0, lC0@PAGEOFF;
	mov	x0, x20
	mov	x1, x21
	bl	_system__assertions__raise_assert_failure
L46:
	nop
	nop
	ldp	x20, x21, [sp, 16]
	ldp	x22, x23, [sp, 32]
	ldp	x29, x30, [sp], 80
LCFI22:
	ret
LFE7:
	.const
	.align	3
lC16:
	.ascii "failed precondition from safe_po.ads:107"
	.align	3
lC17:
	.ascii "failed precondition from safe_po.ads:108"
	.text
	.align	2
	.globl ____ghost_safe_po__narrow_conversion
____ghost_safe_po__narrow_conversion:
LFB8:
	stp	x29, x30, [sp, -80]!
LCFI23:
	mov	x29, sp
LCFI24:
	stp	x20, x21, [sp, 16]
	stp	x22, x23, [sp, 32]
LCFI25:
	str	x0, [x29, 72]
	stp	x1, x2, [x29, 56]
	ldp	x0, x1, [x29, 56]
	bl	____ghost_safe_model__is_valid_range
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L48
	adrp	x0, lC16@PAGE
	add	x22, x0, lC16@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x23, x0, lC1@PAGEOFF;
	mov	x0, x22
	mov	x1, x23
	bl	_system__assertions__raise_assert_failure
L48:
	ldr	x2, [x29, 72]
	ldp	x0, x1, [x29, 56]
	bl	____ghost_safe_model__contains
	mov	w1, w0
	cmp	w1, 1
	bls	L49
	mov	w1, 108
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L49:
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L53
	adrp	x0, lC17@PAGE
	add	x20, x0, lC17@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x21, x0, lC1@PAGEOFF;
	mov	x0, x20
	mov	x1, x21
	bl	_system__assertions__raise_assert_failure
L53:
	nop
	nop
	ldp	x20, x21, [sp, 16]
	ldp	x22, x23, [sp, 32]
	ldp	x29, x30, [sp], 80
LCFI26:
	ret
LFE8:
	.const
	.align	3
lC18:
	.ascii "failed precondition from safe_po.ads:129"
	.align	3
lC19:
	.ascii "failed precondition from safe_po.ads:130"
	.align	3
lC20:
	.ascii "failed precondition from safe_po.ads:131"
	.text
	.align	2
	.globl ____ghost_safe_po__safe_index
____ghost_safe_po__safe_index:
LFB9:
	stp	x29, x30, [sp, -48]!
LCFI27:
	mov	x29, sp
LCFI28:
	str	x0, [x29, 40]
	str	x1, [x29, 32]
	str	x2, [x29, 24]
	ldr	x1, [x29, 40]
	ldr	x0, [x29, 32]
	cmp	x1, x0
	ble	L55
	adrp	x0, lC18@PAGE
	add	x8, x0, lC18@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x9, x0, lC1@PAGEOFF;
	mov	x0, x8
	mov	x1, x9
	bl	_system__assertions__raise_assert_failure
L55:
	ldr	x1, [x29, 24]
	ldr	x0, [x29, 40]
	cmp	x1, x0
	bge	L56
	adrp	x0, lC19@PAGE
	add	x6, x0, lC19@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x7, x0, lC1@PAGEOFF;
	mov	x0, x6
	mov	x1, x7
	bl	_system__assertions__raise_assert_failure
L56:
	ldr	x1, [x29, 24]
	ldr	x0, [x29, 32]
	cmp	x1, x0
	ble	L60
	adrp	x0, lC20@PAGE
	add	x4, x0, lC20@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x5, x0, lC1@PAGEOFF;
	mov	x0, x4
	mov	x1, x5
	bl	_system__assertions__raise_assert_failure
L60:
	nop
	nop
	ldp	x29, x30, [sp], 48
LCFI29:
	ret
LFE9:
	.const
	.align	3
lC21:
	.ascii "failed precondition from safe_po.ads:148"
	.text
	.align	2
	.globl ____ghost_safe_po__nonzero
____ghost_safe_po__nonzero:
LFB10:
	stp	x29, x30, [sp, -32]!
LCFI30:
	mov	x29, sp
LCFI31:
	str	x0, [x29, 24]
	ldr	x0, [x29, 24]
	cmp	x0, 0
	bne	L65
	adrp	x0, lC21@PAGE
	add	x2, x0, lC21@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x3, x0, lC1@PAGEOFF;
	mov	x0, x2
	mov	x1, x3
	bl	_system__assertions__raise_assert_failure
L65:
	nop
	nop
	ldp	x29, x30, [sp], 32
LCFI32:
	ret
LFE10:
	.align	2
_safe_po__safe_mod___wrapped_statements.1:
LFB12:
	stp	x29, x30, [sp, -32]!
LCFI33:
	mov	x29, sp
LCFI34:
	mov	x2, x16
	str	x16, [x29, 24]
	ldr	x0, [x2, 16]
	cmp	x0, 0
	bne	L67
	mov	w1, 142
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Divide_By_Zero
L67:
	ldr	x0, [x2, 16]
	cmn	x0, #1
	beq	L68
	ldr	x3, [x2, 8]
	ldr	x1, [x2, 16]
	mov	x0, x3
	cmp	x1, 0
	blt	L70
	cmp	x0, 0
	blt	L69
	sdiv	x0, x0, x1
	b	L73
L69:
	add	x0, x0, 1
	b	L72
L70:
	cmp	x0, 0
	bgt	L71
	sdiv	x0, x0, x1
	b	L73
L71:
	sub	x0, x0, #1
L72:
	sdiv	x0, x0, x1
	sub	x0, x0, #1
L73:
	mul	x0, x0, x1
	sub	x0, x3, x0
	b	L74
L68:
	mov	x0, 0
L74:
	str	x0, [x2]
	nop
	ldp	x29, x30, [sp], 32
LCFI35:
	ret
LFE12:
	.const
	.align	3
lC22:
	.ascii "failed precondition from safe_po.ads:160"
	.align	3
lC23:
	.ascii "failed postcondition from safe_po.ads:161"
	.text
	.align	2
	.globl _safe_po__safe_mod
_safe_po__safe_mod:
LFB11:
	stp	x29, x30, [sp, -96]!
LCFI36:
	mov	x29, sp
LCFI37:
LEHB3:
LEHE3:
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
LCFI38:
	str	x0, [x29, 56]
	str	x1, [x29, 48]
	add	x0, x29, 96
	str	x0, [x29, 88]
	ldr	x0, [x29, 56]
	str	x0, [x29, 72]
	ldr	x0, [x29, 48]
	str	x0, [x29, 80]
	ldr	x0, [x29, 80]
	cmp	x0, 0
	bne	L77
	adrp	x0, lC22@PAGE
	add	x2, x0, lC22@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x3, x0, lC1@PAGEOFF;
	mov	x0, x2
	mov	x1, x3
LEHB4:
	bl	_system__assertions__raise_assert_failure
L77:
	add	x0, x29, 64
	mov	x16, x0
	bl	_safe_po__safe_mod___wrapped_statements.1
	ldr	x0, [x29, 80]
	cmp	x0, 0
	bne	L78
	mov	w1, 161
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Divide_By_Zero
L78:
	ldr	x0, [x29, 80]
	cmn	x0, #1
	beq	L79
	ldr	x2, [x29, 72]
	ldr	x1, [x29, 80]
	mov	x0, x2
	cmp	x1, 0
	blt	L81
	cmp	x0, 0
	blt	L80
	sdiv	x0, x0, x1
	b	L84
L80:
	add	x0, x0, 1
	b	L83
L81:
	cmp	x0, 0
	bgt	L82
	sdiv	x0, x0, x1
	b	L84
L82:
	sub	x0, x0, #1
L83:
	sdiv	x0, x0, x1
	sub	x0, x0, #1
L84:
	mul	x0, x0, x1
	sub	x0, x2, x0
	b	L85
L79:
	mov	x0, 0
L85:
	ldr	x1, [x29, 64]
	cmp	x0, x1
	beq	L94
	adrp	x0, lC23@PAGE
	add	x20, x0, lC23@PAGEOFF;
	adrp	x0, lC2@PAGE
	add	x21, x0, lC2@PAGEOFF;
	mov	x0, x20
	mov	x1, x21
	bl	_system__assertions__raise_assert_failure
LEHE4:
L94:
	nop
	ldr	x19, [x29, 64]
	mov	w0, 0
L90:
	cmp	w0, 1
	beq	L87
	mov	x0, x19
	b	L93
L91:
	mov	x22, x0
	mov	w0, 1
	b	L90
L87:
	mov	x0, x22
LEHB5:
	bl	__Unwind_Resume
L93:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
LEHE5:
	ldp	x29, x30, [sp], 96
LCFI39:
	ret
LFE11:
	.section __TEXT,__gcc_except_tab
	.p2align	2
GCC_except_table1:
LLSDA11:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 LLSDACSE11-LLSDACSB11
LLSDACSB11:
	.uleb128 LEHB3-LFB11
	.uleb128 LEHE3-LEHB3
	.uleb128 0
	.uleb128 0
	.uleb128 LEHB4-LFB11
	.uleb128 LEHE4-LEHB4
	.uleb128 L91-LFB11
	.uleb128 0
	.uleb128 LEHB5-LFB11
	.uleb128 LEHE5-LEHB5
	.uleb128 0
	.uleb128 0
LLSDACSE11:
	.text
	.const
	.align	2
lC2:
	.word	1
	.word	41
	.text
	.align	2
_safe_po__safe_rem___wrapped_statements.2:
LFB14:
	stp	x29, x30, [sp, -32]!
LCFI40:
	mov	x29, sp
LCFI41:
	mov	x0, x16
	str	x16, [x29, 24]
	ldr	x1, [x0, 16]
	cmp	x1, 0
	bne	L96
	mov	w1, 155
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Divide_By_Zero
L96:
	ldr	x1, [x0, 16]
	cmn	x1, #1
	beq	L97
	ldr	x1, [x0, 8]
	ldr	x2, [x0, 16]
	sdiv	x3, x1, x2
	mul	x2, x3, x2
	sub	x1, x1, x2
	b	L98
L97:
	mov	x1, 0
L98:
	str	x1, [x0]
	nop
	ldp	x29, x30, [sp], 32
LCFI42:
	ret
LFE14:
	.const
	.align	3
lC24:
	.ascii "failed precondition from safe_po.ads:172"
	.align	3
lC25:
	.ascii "failed postcondition from safe_po.ads:173"
	.text
	.align	2
	.globl _safe_po__safe_rem
_safe_po__safe_rem:
LFB13:
	stp	x29, x30, [sp, -96]!
LCFI43:
	mov	x29, sp
LCFI44:
LEHB6:
LEHE6:
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
LCFI45:
	str	x0, [x29, 56]
	str	x1, [x29, 48]
	add	x0, x29, 96
	str	x0, [x29, 88]
	ldr	x0, [x29, 56]
	str	x0, [x29, 72]
	ldr	x0, [x29, 48]
	str	x0, [x29, 80]
	ldr	x0, [x29, 80]
	cmp	x0, 0
	bne	L101
	adrp	x0, lC24@PAGE
	add	x2, x0, lC24@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x3, x0, lC1@PAGEOFF;
	mov	x0, x2
	mov	x1, x3
LEHB7:
	bl	_system__assertions__raise_assert_failure
L101:
	add	x0, x29, 64
	mov	x16, x0
	bl	_safe_po__safe_rem___wrapped_statements.2
	ldr	x0, [x29, 80]
	cmp	x0, 0
	bne	L102
	mov	w1, 173
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Divide_By_Zero
L102:
	ldr	x0, [x29, 80]
	cmn	x0, #1
	beq	L103
	ldr	x0, [x29, 72]
	ldr	x1, [x29, 80]
	sdiv	x2, x0, x1
	mul	x1, x2, x1
	sub	x0, x0, x1
	b	L104
L103:
	mov	x0, 0
L104:
	ldr	x1, [x29, 64]
	cmp	x0, x1
	beq	L113
	adrp	x0, lC25@PAGE
	add	x20, x0, lC25@PAGEOFF;
	adrp	x0, lC2@PAGE
	add	x21, x0, lC2@PAGEOFF;
	mov	x0, x20
	mov	x1, x21
	bl	_system__assertions__raise_assert_failure
LEHE7:
L113:
	nop
	ldr	x19, [x29, 64]
	mov	w0, 0
L109:
	cmp	w0, 1
	beq	L106
	mov	x0, x19
	b	L112
L110:
	mov	x22, x0
	mov	w0, 1
	b	L109
L106:
	mov	x0, x22
LEHB8:
	bl	__Unwind_Resume
L112:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
LEHE8:
	ldp	x29, x30, [sp], 96
LCFI46:
	ret
LFE13:
	.section __TEXT,__gcc_except_tab
	.p2align	2
GCC_except_table2:
LLSDA13:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 LLSDACSE13-LLSDACSB13
LLSDACSB13:
	.uleb128 LEHB6-LFB13
	.uleb128 LEHE6-LEHB6
	.uleb128 0
	.uleb128 0
	.uleb128 LEHB7-LFB13
	.uleb128 LEHE7-LEHB7
	.uleb128 L110-LFB13
	.uleb128 0
	.uleb128 LEHB8-LFB13
	.uleb128 LEHE8-LEHB8
	.uleb128 0
	.uleb128 0
LLSDACSE13:
	.text
	.const
	.align	3
lC26:
	.ascii "failed precondition from safe_po.ads:191"
	.text
	.align	2
	.globl ____ghost_safe_po__not_null_ptr
____ghost_safe_po__not_null_ptr:
LFB15:
	stp	x29, x30, [sp, -32]!
LCFI47:
	mov	x29, sp
LCFI48:
	strb	w0, [x29, 31]
	ldrb	w0, [x29, 31]
	cmp	w0, 1
	bls	L115
	mov	w1, 191
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L115:
	ldrb	w0, [x29, 31]
	cmp	w0, 0
	beq	L119
	adrp	x0, lC26@PAGE
	add	x2, x0, lC26@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x3, x0, lC1@PAGEOFF;
	mov	x0, x2
	mov	x1, x3
	bl	_system__assertions__raise_assert_failure
L119:
	nop
	nop
	ldp	x29, x30, [sp], 32
LCFI49:
	ret
LFE15:
	.const
	.align	3
lC27:
	.ascii "failed precondition from safe_po.ads:201"
	.text
	.align	2
	.globl ____ghost_safe_po__safe_deref
____ghost_safe_po__safe_deref:
LFB16:
	stp	x29, x30, [sp, -32]!
LCFI50:
	mov	x29, sp
LCFI51:
	strb	w0, [x29, 31]
	ldrb	w0, [x29, 31]
	cmp	w0, 1
	bls	L121
	mov	w1, 201
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L121:
	ldrb	w0, [x29, 31]
	cmp	w0, 0
	beq	L125
	adrp	x0, lC27@PAGE
	add	x2, x0, lC27@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x3, x0, lC1@PAGEOFF;
	mov	x0, x2
	mov	x1, x3
	bl	_system__assertions__raise_assert_failure
L125:
	nop
	nop
	ldp	x29, x30, [sp], 32
LCFI52:
	ret
LFE16:
	.const
	.align	3
lC28:
	.ascii "failed precondition from safe_po.ads:220"
	.text
	.align	2
	.globl ____ghost_safe_po__fp_not_nan
____ghost_safe_po__fp_not_nan:
LFB17:
	stp	x29, x30, [sp, -48]!
LCFI53:
	mov	x29, sp
LCFI54:
	stp	x20, x21, [sp, 16]
LCFI55:
	str	d0, [x29, 40]
	add	x0, x29, 40
	mov	w1, 0
	bl	_system__fat_lflt__attr_long_float__valid
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L127
	mov	w1, 220
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L127:
	add	x0, x29, 40
	mov	w1, 0
	bl	_system__fat_lflt__attr_long_float__valid
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L128
	mov	w1, 220
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L128:
	ldr	d30, [x29, 40]
	ldr	d31, [x29, 40]
	fcmp	d30, d31
	beq	L132
	adrp	x0, lC28@PAGE
	add	x20, x0, lC28@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x21, x0, lC1@PAGEOFF;
	mov	x0, x20
	mov	x1, x21
	bl	_system__assertions__raise_assert_failure
L132:
	nop
	nop
	ldp	x20, x21, [sp, 16]
	ldp	x29, x30, [sp], 48
LCFI56:
	ret
LFE17:
	.const
	.align	3
lC29:
	.ascii "failed precondition from safe_po.ads:232"
	.align	3
lC30:
	.ascii "failed precondition from safe_po.ads:233"
	.align	3
lC31:
	.ascii "failed precondition from safe_po.ads:234"
	.text
	.align	2
	.globl ____ghost_safe_po__fp_not_infinity
____ghost_safe_po__fp_not_infinity:
LFB18:
	stp	x29, x30, [sp, -80]!
LCFI57:
	mov	x29, sp
LCFI58:
	stp	x20, x21, [sp, 16]
	stp	x22, x23, [sp, 32]
	stp	x24, x25, [sp, 48]
LCFI59:
	str	d0, [x29, 72]
	add	x0, x29, 72
	mov	w1, 0
	bl	_system__fat_lflt__attr_long_float__valid
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L134
	mov	w1, 232
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L134:
	add	x0, x29, 72
	mov	w1, 0
	bl	_system__fat_lflt__attr_long_float__valid
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L135
	mov	w1, 232
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L135:
	ldr	d30, [x29, 72]
	ldr	d31, [x29, 72]
	fcmp	d30, d31
	cset	w0, eq
	and	w0, w0, 255
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L136
	adrp	x0, lC29@PAGE
	add	x24, x0, lC29@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x25, x0, lC1@PAGEOFF;
	mov	x0, x24
	mov	x1, x25
	bl	_system__assertions__raise_assert_failure
L136:
	add	x0, x29, 72
	mov	w1, 0
	bl	_system__fat_lflt__attr_long_float__valid
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L137
	mov	w1, 233
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L137:
	ldr	d31, [x29, 72]
	mov	x0, -4503599627370497
	fmov	d30, x0
	fcmpe	d31, d30
	cset	w0, ge
	and	w0, w0, 255
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L138
	adrp	x0, lC30@PAGE
	add	x22, x0, lC30@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x23, x0, lC1@PAGEOFF;
	mov	x0, x22
	mov	x1, x23
	bl	_system__assertions__raise_assert_failure
L138:
	add	x0, x29, 72
	mov	w1, 0
	bl	_system__fat_lflt__attr_long_float__valid
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L139
	mov	w1, 234
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L139:
	ldr	d31, [x29, 72]
	mov	x0, 9218868437227405311
	fmov	d30, x0
	fcmpe	d31, d30
	cset	w0, ls
	and	w0, w0, 255
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L143
	adrp	x0, lC31@PAGE
	add	x20, x0, lC31@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x21, x0, lC1@PAGEOFF;
	mov	x0, x20
	mov	x1, x21
	bl	_system__assertions__raise_assert_failure
L143:
	nop
	nop
	ldp	x20, x21, [sp, 16]
	ldp	x22, x23, [sp, 32]
	ldp	x24, x25, [sp, 48]
	ldp	x29, x30, [sp], 80
LCFI60:
	ret
LFE18:
	.align	2
_safe_po__fp_safe_div___wrapped_statements.3:
LFB20:
	stp	x29, x30, [sp, -64]!
LCFI61:
	mov	x29, sp
LCFI62:
	str	x19, [sp, 16]
LCFI63:
	mov	x19, x16
	str	x16, [x29, 40]
	add	x0, x19, 16
	mov	w1, 0
	bl	_system__fat_lflt__attr_long_float__valid
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L145
	mov	w1, 220
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L145:
	add	x0, x19, 8
	mov	w1, 0
	bl	_system__fat_lflt__attr_long_float__valid
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L146
	mov	w1, 220
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L146:
	ldr	d30, [x19, 16]
	ldr	d31, [x19, 8]
	fdiv	d31, d30, d31
	str	d31, [x29, 56]
	add	x0, x29, 56
	mov	w1, 0
	bl	_system__fat_lflt__attr_long_float__valid
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L147
	mov	w1, 220
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L147:
	ldr	d30, [x19, 16]
	ldr	d31, [x19, 8]
	fdiv	d31, d30, d31
	str	d31, [x19]
	nop
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 64
LCFI64:
	ret
LFE20:
	.const
	.align	3
lC32:
	.ascii "failed precondition from safe_po.ads:247"
	.align	3
lC33:
	.ascii "failed precondition from safe_po.ads:248"
	.align	3
lC34:
	.ascii "failed precondition from safe_po.ads:249"
	.align	3
lC35:
	.ascii "failed precondition from safe_po.ads:250"
	.align	3
lC36:
	.ascii "failed precondition from safe_po.ads:251"
	.align	3
lC37:
	.ascii "failed precondition from safe_po.ads:252"
	.align	3
lC38:
	.ascii "failed precondition from safe_po.ads:253"
	.align	3
lC39:
	.ascii "failed postcondition from safe_po.ads:254"
	.text
	.align	2
	.globl _safe_po__fp_safe_div
_safe_po__fp_safe_div:
LFB19:
	stp	x29, x30, [sp, -240]!
LCFI65:
	mov	x29, sp
LCFI66:
LEHB9:
LEHE9:
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	str	x27, [sp, 80]
LCFI67:
	str	d0, [x29, 184]
	str	d1, [x29, 176]
	add	x0, x29, 240
	ldr	d30, [x29, 184]
	str	x0, [x29, 224]
	ldr	d31, [x29, 176]
	str	d30, [x29, 216]
	str	d31, [x29, 208]
	add	x0, x29, 200
	add	x0, x0, 8
	mov	w1, 0
LEHB10:
	bl	_system__fat_lflt__attr_long_float__valid
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L150
	mov	w1, 247
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L150:
	ldr	d31, [x29, 208]
	fcmp	d31, #0.0
	cset	w0, ne
	and	w0, w0, 255
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L151
	adrp	x0, lC32@PAGE
	add	x0, x0, lC32@PAGEOFF;
	str	x0, [x29, 112]
	adrp	x0, lC1@PAGE
	add	x0, x0, lC1@PAGEOFF;
	str	x0, [x29, 120]
	ldp	x0, x1, [x29, 112]
	bl	_system__assertions__raise_assert_failure
L151:
	add	x0, x29, 200
	add	x0, x0, 8
	mov	w1, 0
	bl	_system__fat_lflt__attr_long_float__valid
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L152
	mov	w1, 248
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L152:
	add	x0, x29, 200
	add	x0, x0, 8
	mov	w1, 0
	bl	_system__fat_lflt__attr_long_float__valid
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L153
	mov	w1, 248
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L153:
	ldr	d30, [x29, 208]
	ldr	d31, [x29, 208]
	fcmp	d30, d31
	cset	w0, eq
	and	w0, w0, 255
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L154
	adrp	x0, lC33@PAGE
	add	x0, x0, lC33@PAGEOFF;
	str	x0, [x29, 128]
	adrp	x0, lC1@PAGE
	add	x0, x0, lC1@PAGEOFF;
	str	x0, [x29, 136]
	ldp	x0, x1, [x29, 128]
	bl	_system__assertions__raise_assert_failure
L154:
	add	x0, x29, 200
	add	x0, x0, 16
	mov	w1, 0
	bl	_system__fat_lflt__attr_long_float__valid
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L155
	mov	w1, 249
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L155:
	add	x0, x29, 200
	add	x0, x0, 16
	mov	w1, 0
	bl	_system__fat_lflt__attr_long_float__valid
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L156
	mov	w1, 249
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L156:
	ldr	d30, [x29, 216]
	ldr	d31, [x29, 216]
	fcmp	d30, d31
	cset	w0, eq
	and	w0, w0, 255
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L157
	adrp	x0, lC34@PAGE
	add	x0, x0, lC34@PAGEOFF;
	str	x0, [x29, 144]
	adrp	x0, lC1@PAGE
	add	x0, x0, lC1@PAGEOFF;
	str	x0, [x29, 152]
	ldp	x0, x1, [x29, 144]
	bl	_system__assertions__raise_assert_failure
L157:
	add	x0, x29, 200
	add	x0, x0, 16
	mov	w1, 0
	bl	_system__fat_lflt__attr_long_float__valid
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L158
	mov	w1, 250
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L158:
	ldr	d31, [x29, 216]
	mov	x0, -4503599627370497
	fmov	d30, x0
	fcmpe	d31, d30
	cset	w0, ge
	and	w0, w0, 255
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L159
	adrp	x0, lC35@PAGE
	add	x0, x0, lC35@PAGEOFF;
	str	x0, [x29, 160]
	adrp	x0, lC1@PAGE
	add	x0, x0, lC1@PAGEOFF;
	str	x0, [x29, 168]
	ldp	x0, x1, [x29, 160]
	bl	_system__assertions__raise_assert_failure
L159:
	add	x0, x29, 200
	add	x0, x0, 16
	mov	w1, 0
	bl	_system__fat_lflt__attr_long_float__valid
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L160
	mov	w1, 251
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L160:
	ldr	d31, [x29, 216]
	mov	x0, 9218868437227405311
	fmov	d30, x0
	fcmpe	d31, d30
	cset	w0, ls
	and	w0, w0, 255
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L161
	adrp	x0, lC36@PAGE
	add	x26, x0, lC36@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x27, x0, lC1@PAGEOFF;
	mov	x0, x26
	mov	x1, x27
	bl	_system__assertions__raise_assert_failure
L161:
	add	x0, x29, 200
	add	x0, x0, 8
	mov	w1, 0
	bl	_system__fat_lflt__attr_long_float__valid
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L162
	mov	w1, 252
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L162:
	ldr	d31, [x29, 208]
	mov	x0, -4503599627370497
	fmov	d30, x0
	fcmpe	d31, d30
	cset	w0, ge
	and	w0, w0, 255
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L163
	adrp	x0, lC37@PAGE
	add	x24, x0, lC37@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x25, x0, lC1@PAGEOFF;
	mov	x0, x24
	mov	x1, x25
	bl	_system__assertions__raise_assert_failure
L163:
	add	x0, x29, 200
	add	x0, x0, 8
	mov	w1, 0
	bl	_system__fat_lflt__attr_long_float__valid
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L164
	mov	w1, 253
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L164:
	ldr	d31, [x29, 208]
	mov	x0, 9218868437227405311
	fmov	d30, x0
	fcmpe	d31, d30
	cset	w0, ls
	and	w0, w0, 255
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L165
	adrp	x0, lC38@PAGE
	add	x22, x0, lC38@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x23, x0, lC1@PAGEOFF;
	mov	x0, x22
	mov	x1, x23
	bl	_system__assertions__raise_assert_failure
L165:
	add	x0, x29, 200
	mov	x16, x0
	bl	_safe_po__fp_safe_div___wrapped_statements.3
	add	x0, x29, 200
	add	x0, x0, 16
	mov	w1, 0
	bl	_system__fat_lflt__attr_long_float__valid
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L166
	mov	w1, 254
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L166:
	add	x0, x29, 200
	add	x0, x0, 8
	mov	w1, 0
	bl	_system__fat_lflt__attr_long_float__valid
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L167
	mov	w1, 254
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L167:
	ldr	d31, [x29, 200]
	str	d31, [x29, 192]
	add	x0, x29, 192
	mov	w1, 0
	bl	_system__fat_lflt__attr_long_float__valid
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L168
	mov	w1, 254
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L168:
	ldr	d30, [x29, 216]
	ldr	d31, [x29, 208]
	fdiv	d31, d30, d31
	str	d31, [x29, 232]
	add	x0, x29, 232
	mov	w1, 0
	bl	_system__fat_lflt__attr_long_float__valid
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L169
	mov	w1, 254
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L169:
	ldr	d30, [x29, 216]
	ldr	d31, [x29, 208]
	fdiv	d30, d30, d31
	ldr	d31, [x29, 192]
	fcmp	d30, d31
	beq	L170
	adrp	x0, lC39@PAGE
	add	x20, x0, lC39@PAGEOFF;
	adrp	x0, lC2@PAGE
	add	x21, x0, lC2@PAGEOFF;
	mov	x0, x20
	mov	x1, x21
	bl	_system__assertions__raise_assert_failure
LEHE10:
L170:
	ldr	d31, [x29, 200]
	str	d31, [x29, 104]
	mov	w0, 0
L174:
	cmp	w0, 1
	beq	L171
	ldr	d31, [x29, 104]
	b	L176
L175:
	mov	x19, x0
	mov	w0, 1
	b	L174
L171:
	mov	x0, x19
LEHB11:
	bl	__Unwind_Resume
L176:
	fmov	d0, d31
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
LEHE11:
	ldp	x29, x30, [sp], 240
LCFI68:
	ret
LFE19:
	.section __TEXT,__gcc_except_tab
	.p2align	2
GCC_except_table3:
LLSDA19:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 LLSDACSE19-LLSDACSB19
LLSDACSB19:
	.uleb128 LEHB9-LFB19
	.uleb128 LEHE9-LEHB9
	.uleb128 0
	.uleb128 0
	.uleb128 LEHB10-LFB19
	.uleb128 LEHE10-LEHB10
	.uleb128 L175-LFB19
	.uleb128 0
	.uleb128 LEHB11-LFB19
	.uleb128 LEHE11-LEHB11
	.uleb128 0
	.uleb128 0
LLSDACSE19:
	.text
	.const
	.align	3
lC40:
	.ascii "failed precondition from safe_po.ads:269"
	.text
	.align	2
	.globl ____ghost_safe_po__check_not_moved
____ghost_safe_po__check_not_moved:
LFB21:
	stp	x29, x30, [sp, -32]!
LCFI69:
	mov	x29, sp
LCFI70:
	strb	w0, [x29, 31]
	ldrb	w0, [x29, 31]
	cmp	w0, 4
	bls	L178
	mov	w1, 269
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L178:
	ldrb	w0, [x29, 31]
	cmp	w0, 2
	bne	L182
	adrp	x0, lC40@PAGE
	add	x2, x0, lC40@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x3, x0, lC1@PAGEOFF;
	mov	x0, x2
	mov	x1, x3
	bl	_system__assertions__raise_assert_failure
L182:
	nop
	nop
	ldp	x29, x30, [sp], 32
LCFI71:
	ret
LFE21:
	.const
	.align	3
lC41:
	.ascii "failed precondition from safe_po.ads:279"
	.text
	.align	2
	.globl ____ghost_safe_po__check_owned_for_move
____ghost_safe_po__check_owned_for_move:
LFB22:
	stp	x29, x30, [sp, -32]!
LCFI72:
	mov	x29, sp
LCFI73:
	strb	w0, [x29, 31]
	ldrb	w0, [x29, 31]
	cmp	w0, 4
	bls	L184
	mov	w1, 279
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L184:
	ldrb	w0, [x29, 31]
	cmp	w0, 1
	beq	L188
	adrp	x0, lC41@PAGE
	add	x2, x0, lC41@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x3, x0, lC1@PAGEOFF;
	mov	x0, x2
	mov	x1, x3
	bl	_system__assertions__raise_assert_failure
L188:
	nop
	nop
	ldp	x29, x30, [sp], 32
LCFI74:
	ret
LFE22:
	.const
	.align	3
lC42:
	.ascii "failed precondition from safe_po.ads:289"
	.text
	.align	2
	.globl ____ghost_safe_po__check_borrow_exclusive
____ghost_safe_po__check_borrow_exclusive:
LFB23:
	stp	x29, x30, [sp, -32]!
LCFI75:
	mov	x29, sp
LCFI76:
	strb	w0, [x29, 31]
	ldrb	w0, [x29, 31]
	cmp	w0, 4
	bls	L190
	mov	w1, 289
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L190:
	ldrb	w0, [x29, 31]
	cmp	w0, 1
	beq	L194
	adrp	x0, lC42@PAGE
	add	x2, x0, lC42@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x3, x0, lC1@PAGEOFF;
	mov	x0, x2
	mov	x1, x3
	bl	_system__assertions__raise_assert_failure
L194:
	nop
	nop
	ldp	x29, x30, [sp], 32
LCFI77:
	ret
LFE23:
	.const
	.align	3
lC43:
	.ascii "failed precondition from safe_po.ads:299"
	.text
	.align	2
	.globl ____ghost_safe_po__check_observe_shared
____ghost_safe_po__check_observe_shared:
LFB24:
	stp	x29, x30, [sp, -32]!
LCFI78:
	mov	x29, sp
LCFI79:
	strb	w0, [x29, 31]
	ldrb	w0, [x29, 31]
	cmp	w0, 4
	bls	L196
	mov	w1, 299
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L196:
	ldrb	w0, [x29, 31]
	cmp	w0, 1
	cset	w0, eq
	and	w0, w0, 255
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L200
	ldrb	w0, [x29, 31]
	cmp	w0, 4
	beq	L200
	adrp	x0, lC43@PAGE
	add	x2, x0, lC43@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x3, x0, lC1@PAGEOFF;
	mov	x0, x2
	mov	x1, x3
	bl	_system__assertions__raise_assert_failure
L200:
	nop
	nop
	ldp	x29, x30, [sp], 32
LCFI80:
	ret
LFE24:
	.const
	.align	3
lC44:
	.ascii "failed precondition from safe_po.ads:317"
	.text
	.align	2
	.globl ____ghost_safe_po__check_channel_not_full
____ghost_safe_po__check_channel_not_full:
LFB25:
	stp	x29, x30, [sp, -32]!
LCFI81:
	mov	x29, sp
LCFI82:
	str	w0, [x29, 28]
	str	w1, [x29, 24]
	ldr	w0, [x29, 28]
	cmp	w0, 0
	bge	L202
	mov	w1, 317
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L202:
	ldr	w0, [x29, 24]
	cmp	w0, 0
	bge	L203
	mov	w1, 317
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L203:
	ldr	w1, [x29, 28]
	ldr	w0, [x29, 24]
	cmp	w1, w0
	blt	L207
	adrp	x0, lC44@PAGE
	add	x2, x0, lC44@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x3, x0, lC1@PAGEOFF;
	mov	x0, x2
	mov	x1, x3
	bl	_system__assertions__raise_assert_failure
L207:
	nop
	nop
	ldp	x29, x30, [sp], 32
LCFI83:
	ret
LFE25:
	.const
	.align	3
lC45:
	.ascii "failed precondition from safe_po.ads:327"
	.text
	.align	2
	.globl ____ghost_safe_po__check_channel_not_empty
____ghost_safe_po__check_channel_not_empty:
LFB26:
	stp	x29, x30, [sp, -32]!
LCFI84:
	mov	x29, sp
LCFI85:
	str	w0, [x29, 28]
	ldr	w0, [x29, 28]
	cmp	w0, 0
	bge	L209
	mov	w1, 327
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L209:
	ldr	w0, [x29, 28]
	cmp	w0, 0
	bgt	L213
	adrp	x0, lC45@PAGE
	add	x2, x0, lC45@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x3, x0, lC1@PAGEOFF;
	mov	x0, x2
	mov	x1, x3
	bl	_system__assertions__raise_assert_failure
L213:
	nop
	nop
	ldp	x29, x30, [sp], 32
LCFI86:
	ret
LFE26:
	.const
	.align	3
lC46:
	.ascii "failed precondition from safe_po.ads:337"
	.text
	.align	2
	.globl ____ghost_safe_po__check_channel_capacity_positive
____ghost_safe_po__check_channel_capacity_positive:
LFB27:
	stp	x29, x30, [sp, -32]!
LCFI87:
	mov	x29, sp
LCFI88:
	str	w0, [x29, 28]
	ldr	w0, [x29, 28]
	cmp	w0, 0
	bge	L215
	mov	w1, 337
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L215:
	ldr	w0, [x29, 28]
	cmp	w0, 0
	bgt	L219
	adrp	x0, lC46@PAGE
	add	x2, x0, lC46@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x3, x0, lC1@PAGEOFF;
	mov	x0, x2
	mov	x1, x3
	bl	_system__assertions__raise_assert_failure
L219:
	nop
	nop
	ldp	x29, x30, [sp], 32
LCFI89:
	ret
LFE27:
	.const
	.align	3
lC47:
	.ascii "failed precondition from safe_po.ads:357"
	.align	3
lC48:
	.ascii "failed precondition from safe_po.ads:358"
	.text
	.align	2
	.globl ____ghost_safe_po__check_exclusive_ownership
____ghost_safe_po__check_exclusive_ownership:
LFB28:
	stp	x29, x30, [sp, -32]!
LCFI90:
	mov	x29, sp
LCFI91:
	str	w0, [x29, 28]
	str	w1, [x29, 24]
	str	x2, [x29, 16]
	ldr	w0, [x29, 24]
	cmp	w0, 64
	bls	L221
	mov	w1, 357
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L221:
	ldr	w0, [x29, 24]
	cmp	w0, 0
	cset	w0, ne
	and	w0, w0, 255
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L222
	adrp	x0, lC47@PAGE
	add	x6, x0, lC47@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x7, x0, lC1@PAGEOFF;
	mov	x0, x6
	mov	x1, x7
	bl	_system__assertions__raise_assert_failure
L222:
	ldr	w0, [x29, 28]
	cmp	w0, 1023
	bls	L223
	mov	w1, 358
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L223:
	ldrsw	x1, [x29, 28]
	ldr	x0, [x29, 16]
	ldr	w0, [x0, x1, lsl 2]
	cmp	w0, 64
	bls	L224
	mov	w1, 358
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L224:
	ldrsw	x1, [x29, 28]
	ldr	x0, [x29, 16]
	ldr	w0, [x0, x1, lsl 2]
	cmp	w0, 0
	cset	w0, eq
	and	w0, w0, 255
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L231
	ldr	w0, [x29, 28]
	cmp	w0, 1023
	bls	L226
	mov	w1, 359
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L226:
	ldrsw	x1, [x29, 28]
	ldr	x0, [x29, 16]
	ldr	w0, [x0, x1, lsl 2]
	cmp	w0, 64
	bls	L227
	mov	w1, 359
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L227:
	ldr	w0, [x29, 24]
	cmp	w0, 64
	bls	L228
	mov	w1, 359
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L228:
	ldrsw	x1, [x29, 28]
	ldr	x0, [x29, 16]
	ldr	w0, [x0, x1, lsl 2]
	ldr	w1, [x29, 24]
	cmp	w1, w0
	cset	w0, eq
	and	w0, w0, 255
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L231
	adrp	x0, lC48@PAGE
	add	x4, x0, lC48@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x5, x0, lC1@PAGEOFF;
	mov	x0, x4
	mov	x1, x5
	bl	_system__assertions__raise_assert_failure
L231:
	nop
	nop
	ldp	x29, x30, [sp], 32
LCFI92:
	ret
LFE28:
	.globl _safe_po_E
	.data
	.align	1
_safe_po_E:
	.space 2
	.section __TEXT,__eh_frame,coalesced,no_toc+strip_static_syms+live_support
EH_frame1:
	.set L$set$0,LECIE1-LSCIE1
	.long L$set$0
LSCIE1:
	.long	0
	.byte	0x3
	.ascii "zPLR\0"
	.uleb128 0x1
	.sleb128 -8
	.uleb128 0x1e
	.uleb128 0x7
	.byte	0x9b
L_got_pcr0:
	.long	___gnat_personality_v0@GOT-L_got_pcr0
	.byte	0x10
	.byte	0x10
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LECIE1:
LSFDE1:
	.set L$set$1,LEFDE1-LASFDE1
	.long L$set$1
LASFDE1:
	.long	LASFDE1-EH_frame1
	.quad	LFB3-.
	.set L$set$2,LFE3-LFB3
	.quad L$set$2
	.uleb128 0x8
	.quad	0
	.byte	0x4
	.set L$set$3,LCFI0-LFB3
	.long L$set$3
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$4,LCFI1-LCFI0
	.long L$set$4
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$5,LCFI2-LCFI1
	.long L$set$5
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE1:
LSFDE3:
	.set L$set$6,LEFDE3-LASFDE3
	.long L$set$6
LASFDE3:
	.long	LASFDE3-EH_frame1
	.quad	LFB2-.
	.set L$set$7,LFE2-LFB2
	.quad L$set$7
	.uleb128 0x8
	.quad	LLSDA2-.
	.byte	0x4
	.set L$set$8,LCFI3-LFB2
	.long L$set$8
	.byte	0xe
	.uleb128 0x60
	.byte	0x9d
	.uleb128 0xc
	.byte	0x9e
	.uleb128 0xb
	.byte	0x4
	.set L$set$9,LCFI4-LCFI3
	.long L$set$9
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$10,LCFI5-LCFI4
	.long L$set$10
	.byte	0x93
	.uleb128 0xa
	.byte	0x94
	.uleb128 0x9
	.byte	0x95
	.uleb128 0x8
	.byte	0x96
	.uleb128 0x7
	.byte	0x4
	.set L$set$11,LCFI6-LCFI5
	.long L$set$11
	.byte	0xde
	.byte	0xdd
	.byte	0xd5
	.byte	0xd6
	.byte	0xd3
	.byte	0xd4
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE3:
LSFDE5:
	.set L$set$12,LEFDE5-LASFDE5
	.long L$set$12
LASFDE5:
	.long	LASFDE5-EH_frame1
	.quad	LFB4-.
	.set L$set$13,LFE4-LFB4
	.quad L$set$13
	.uleb128 0x8
	.quad	0
	.byte	0x4
	.set L$set$14,LCFI7-LFB4
	.long L$set$14
	.byte	0xe
	.uleb128 0x50
	.byte	0x9d
	.uleb128 0xa
	.byte	0x9e
	.uleb128 0x9
	.byte	0x4
	.set L$set$15,LCFI8-LCFI7
	.long L$set$15
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$16,LCFI9-LCFI8
	.long L$set$16
	.byte	0x94
	.uleb128 0x8
	.byte	0x95
	.uleb128 0x7
	.byte	0x96
	.uleb128 0x6
	.byte	0x97
	.uleb128 0x5
	.byte	0x4
	.set L$set$17,LCFI10-LCFI9
	.long L$set$17
	.byte	0xde
	.byte	0xdd
	.byte	0xd6
	.byte	0xd7
	.byte	0xd4
	.byte	0xd5
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE5:
LSFDE7:
	.set L$set$18,LEFDE7-LASFDE7
	.long L$set$18
LASFDE7:
	.long	LASFDE7-EH_frame1
	.quad	LFB5-.
	.set L$set$19,LFE5-LFB5
	.quad L$set$19
	.uleb128 0x8
	.quad	0
	.byte	0x4
	.set L$set$20,LCFI11-LFB5
	.long L$set$20
	.byte	0xe
	.uleb128 0x50
	.byte	0x9d
	.uleb128 0xa
	.byte	0x9e
	.uleb128 0x9
	.byte	0x4
	.set L$set$21,LCFI12-LCFI11
	.long L$set$21
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$22,LCFI13-LCFI12
	.long L$set$22
	.byte	0x94
	.uleb128 0x8
	.byte	0x95
	.uleb128 0x7
	.byte	0x96
	.uleb128 0x6
	.byte	0x97
	.uleb128 0x5
	.byte	0x4
	.set L$set$23,LCFI14-LCFI13
	.long L$set$23
	.byte	0xde
	.byte	0xdd
	.byte	0xd6
	.byte	0xd7
	.byte	0xd4
	.byte	0xd5
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE7:
LSFDE9:
	.set L$set$24,LEFDE9-LASFDE9
	.long L$set$24
LASFDE9:
	.long	LASFDE9-EH_frame1
	.quad	LFB6-.
	.set L$set$25,LFE6-LFB6
	.quad L$set$25
	.uleb128 0x8
	.quad	0
	.byte	0x4
	.set L$set$26,LCFI15-LFB6
	.long L$set$26
	.byte	0xe
	.uleb128 0x50
	.byte	0x9d
	.uleb128 0xa
	.byte	0x9e
	.uleb128 0x9
	.byte	0x4
	.set L$set$27,LCFI16-LCFI15
	.long L$set$27
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$28,LCFI17-LCFI16
	.long L$set$28
	.byte	0x94
	.uleb128 0x8
	.byte	0x95
	.uleb128 0x7
	.byte	0x96
	.uleb128 0x6
	.byte	0x97
	.uleb128 0x5
	.byte	0x4
	.set L$set$29,LCFI18-LCFI17
	.long L$set$29
	.byte	0xde
	.byte	0xdd
	.byte	0xd6
	.byte	0xd7
	.byte	0xd4
	.byte	0xd5
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE9:
LSFDE11:
	.set L$set$30,LEFDE11-LASFDE11
	.long L$set$30
LASFDE11:
	.long	LASFDE11-EH_frame1
	.quad	LFB7-.
	.set L$set$31,LFE7-LFB7
	.quad L$set$31
	.uleb128 0x8
	.quad	0
	.byte	0x4
	.set L$set$32,LCFI19-LFB7
	.long L$set$32
	.byte	0xe
	.uleb128 0x50
	.byte	0x9d
	.uleb128 0xa
	.byte	0x9e
	.uleb128 0x9
	.byte	0x4
	.set L$set$33,LCFI20-LCFI19
	.long L$set$33
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$34,LCFI21-LCFI20
	.long L$set$34
	.byte	0x94
	.uleb128 0x8
	.byte	0x95
	.uleb128 0x7
	.byte	0x96
	.uleb128 0x6
	.byte	0x97
	.uleb128 0x5
	.byte	0x4
	.set L$set$35,LCFI22-LCFI21
	.long L$set$35
	.byte	0xde
	.byte	0xdd
	.byte	0xd6
	.byte	0xd7
	.byte	0xd4
	.byte	0xd5
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE11:
LSFDE13:
	.set L$set$36,LEFDE13-LASFDE13
	.long L$set$36
LASFDE13:
	.long	LASFDE13-EH_frame1
	.quad	LFB8-.
	.set L$set$37,LFE8-LFB8
	.quad L$set$37
	.uleb128 0x8
	.quad	0
	.byte	0x4
	.set L$set$38,LCFI23-LFB8
	.long L$set$38
	.byte	0xe
	.uleb128 0x50
	.byte	0x9d
	.uleb128 0xa
	.byte	0x9e
	.uleb128 0x9
	.byte	0x4
	.set L$set$39,LCFI24-LCFI23
	.long L$set$39
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$40,LCFI25-LCFI24
	.long L$set$40
	.byte	0x94
	.uleb128 0x8
	.byte	0x95
	.uleb128 0x7
	.byte	0x96
	.uleb128 0x6
	.byte	0x97
	.uleb128 0x5
	.byte	0x4
	.set L$set$41,LCFI26-LCFI25
	.long L$set$41
	.byte	0xde
	.byte	0xdd
	.byte	0xd6
	.byte	0xd7
	.byte	0xd4
	.byte	0xd5
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE13:
LSFDE15:
	.set L$set$42,LEFDE15-LASFDE15
	.long L$set$42
LASFDE15:
	.long	LASFDE15-EH_frame1
	.quad	LFB9-.
	.set L$set$43,LFE9-LFB9
	.quad L$set$43
	.uleb128 0x8
	.quad	0
	.byte	0x4
	.set L$set$44,LCFI27-LFB9
	.long L$set$44
	.byte	0xe
	.uleb128 0x30
	.byte	0x9d
	.uleb128 0x6
	.byte	0x9e
	.uleb128 0x5
	.byte	0x4
	.set L$set$45,LCFI28-LCFI27
	.long L$set$45
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$46,LCFI29-LCFI28
	.long L$set$46
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE15:
LSFDE17:
	.set L$set$47,LEFDE17-LASFDE17
	.long L$set$47
LASFDE17:
	.long	LASFDE17-EH_frame1
	.quad	LFB10-.
	.set L$set$48,LFE10-LFB10
	.quad L$set$48
	.uleb128 0x8
	.quad	0
	.byte	0x4
	.set L$set$49,LCFI30-LFB10
	.long L$set$49
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$50,LCFI31-LCFI30
	.long L$set$50
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$51,LCFI32-LCFI31
	.long L$set$51
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE17:
LSFDE19:
	.set L$set$52,LEFDE19-LASFDE19
	.long L$set$52
LASFDE19:
	.long	LASFDE19-EH_frame1
	.quad	LFB12-.
	.set L$set$53,LFE12-LFB12
	.quad L$set$53
	.uleb128 0x8
	.quad	0
	.byte	0x4
	.set L$set$54,LCFI33-LFB12
	.long L$set$54
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$55,LCFI34-LCFI33
	.long L$set$55
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$56,LCFI35-LCFI34
	.long L$set$56
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE19:
LSFDE21:
	.set L$set$57,LEFDE21-LASFDE21
	.long L$set$57
LASFDE21:
	.long	LASFDE21-EH_frame1
	.quad	LFB11-.
	.set L$set$58,LFE11-LFB11
	.quad L$set$58
	.uleb128 0x8
	.quad	LLSDA11-.
	.byte	0x4
	.set L$set$59,LCFI36-LFB11
	.long L$set$59
	.byte	0xe
	.uleb128 0x60
	.byte	0x9d
	.uleb128 0xc
	.byte	0x9e
	.uleb128 0xb
	.byte	0x4
	.set L$set$60,LCFI37-LCFI36
	.long L$set$60
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$61,LCFI38-LCFI37
	.long L$set$61
	.byte	0x93
	.uleb128 0xa
	.byte	0x94
	.uleb128 0x9
	.byte	0x95
	.uleb128 0x8
	.byte	0x96
	.uleb128 0x7
	.byte	0x4
	.set L$set$62,LCFI39-LCFI38
	.long L$set$62
	.byte	0xde
	.byte	0xdd
	.byte	0xd5
	.byte	0xd6
	.byte	0xd3
	.byte	0xd4
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE21:
LSFDE23:
	.set L$set$63,LEFDE23-LASFDE23
	.long L$set$63
LASFDE23:
	.long	LASFDE23-EH_frame1
	.quad	LFB14-.
	.set L$set$64,LFE14-LFB14
	.quad L$set$64
	.uleb128 0x8
	.quad	0
	.byte	0x4
	.set L$set$65,LCFI40-LFB14
	.long L$set$65
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$66,LCFI41-LCFI40
	.long L$set$66
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$67,LCFI42-LCFI41
	.long L$set$67
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE23:
LSFDE25:
	.set L$set$68,LEFDE25-LASFDE25
	.long L$set$68
LASFDE25:
	.long	LASFDE25-EH_frame1
	.quad	LFB13-.
	.set L$set$69,LFE13-LFB13
	.quad L$set$69
	.uleb128 0x8
	.quad	LLSDA13-.
	.byte	0x4
	.set L$set$70,LCFI43-LFB13
	.long L$set$70
	.byte	0xe
	.uleb128 0x60
	.byte	0x9d
	.uleb128 0xc
	.byte	0x9e
	.uleb128 0xb
	.byte	0x4
	.set L$set$71,LCFI44-LCFI43
	.long L$set$71
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$72,LCFI45-LCFI44
	.long L$set$72
	.byte	0x93
	.uleb128 0xa
	.byte	0x94
	.uleb128 0x9
	.byte	0x95
	.uleb128 0x8
	.byte	0x96
	.uleb128 0x7
	.byte	0x4
	.set L$set$73,LCFI46-LCFI45
	.long L$set$73
	.byte	0xde
	.byte	0xdd
	.byte	0xd5
	.byte	0xd6
	.byte	0xd3
	.byte	0xd4
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE25:
LSFDE27:
	.set L$set$74,LEFDE27-LASFDE27
	.long L$set$74
LASFDE27:
	.long	LASFDE27-EH_frame1
	.quad	LFB15-.
	.set L$set$75,LFE15-LFB15
	.quad L$set$75
	.uleb128 0x8
	.quad	0
	.byte	0x4
	.set L$set$76,LCFI47-LFB15
	.long L$set$76
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$77,LCFI48-LCFI47
	.long L$set$77
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$78,LCFI49-LCFI48
	.long L$set$78
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE27:
LSFDE29:
	.set L$set$79,LEFDE29-LASFDE29
	.long L$set$79
LASFDE29:
	.long	LASFDE29-EH_frame1
	.quad	LFB16-.
	.set L$set$80,LFE16-LFB16
	.quad L$set$80
	.uleb128 0x8
	.quad	0
	.byte	0x4
	.set L$set$81,LCFI50-LFB16
	.long L$set$81
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$82,LCFI51-LCFI50
	.long L$set$82
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$83,LCFI52-LCFI51
	.long L$set$83
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE29:
LSFDE31:
	.set L$set$84,LEFDE31-LASFDE31
	.long L$set$84
LASFDE31:
	.long	LASFDE31-EH_frame1
	.quad	LFB17-.
	.set L$set$85,LFE17-LFB17
	.quad L$set$85
	.uleb128 0x8
	.quad	0
	.byte	0x4
	.set L$set$86,LCFI53-LFB17
	.long L$set$86
	.byte	0xe
	.uleb128 0x30
	.byte	0x9d
	.uleb128 0x6
	.byte	0x9e
	.uleb128 0x5
	.byte	0x4
	.set L$set$87,LCFI54-LCFI53
	.long L$set$87
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$88,LCFI55-LCFI54
	.long L$set$88
	.byte	0x94
	.uleb128 0x4
	.byte	0x95
	.uleb128 0x3
	.byte	0x4
	.set L$set$89,LCFI56-LCFI55
	.long L$set$89
	.byte	0xde
	.byte	0xdd
	.byte	0xd4
	.byte	0xd5
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE31:
LSFDE33:
	.set L$set$90,LEFDE33-LASFDE33
	.long L$set$90
LASFDE33:
	.long	LASFDE33-EH_frame1
	.quad	LFB18-.
	.set L$set$91,LFE18-LFB18
	.quad L$set$91
	.uleb128 0x8
	.quad	0
	.byte	0x4
	.set L$set$92,LCFI57-LFB18
	.long L$set$92
	.byte	0xe
	.uleb128 0x50
	.byte	0x9d
	.uleb128 0xa
	.byte	0x9e
	.uleb128 0x9
	.byte	0x4
	.set L$set$93,LCFI58-LCFI57
	.long L$set$93
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$94,LCFI59-LCFI58
	.long L$set$94
	.byte	0x94
	.uleb128 0x8
	.byte	0x95
	.uleb128 0x7
	.byte	0x96
	.uleb128 0x6
	.byte	0x97
	.uleb128 0x5
	.byte	0x98
	.uleb128 0x4
	.byte	0x99
	.uleb128 0x3
	.byte	0x4
	.set L$set$95,LCFI60-LCFI59
	.long L$set$95
	.byte	0xde
	.byte	0xdd
	.byte	0xd8
	.byte	0xd9
	.byte	0xd6
	.byte	0xd7
	.byte	0xd4
	.byte	0xd5
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE33:
LSFDE35:
	.set L$set$96,LEFDE35-LASFDE35
	.long L$set$96
LASFDE35:
	.long	LASFDE35-EH_frame1
	.quad	LFB20-.
	.set L$set$97,LFE20-LFB20
	.quad L$set$97
	.uleb128 0x8
	.quad	0
	.byte	0x4
	.set L$set$98,LCFI61-LFB20
	.long L$set$98
	.byte	0xe
	.uleb128 0x40
	.byte	0x9d
	.uleb128 0x8
	.byte	0x9e
	.uleb128 0x7
	.byte	0x4
	.set L$set$99,LCFI62-LCFI61
	.long L$set$99
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$100,LCFI63-LCFI62
	.long L$set$100
	.byte	0x93
	.uleb128 0x6
	.byte	0x4
	.set L$set$101,LCFI64-LCFI63
	.long L$set$101
	.byte	0xde
	.byte	0xdd
	.byte	0xd3
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE35:
LSFDE37:
	.set L$set$102,LEFDE37-LASFDE37
	.long L$set$102
LASFDE37:
	.long	LASFDE37-EH_frame1
	.quad	LFB19-.
	.set L$set$103,LFE19-LFB19
	.quad L$set$103
	.uleb128 0x8
	.quad	LLSDA19-.
	.byte	0x4
	.set L$set$104,LCFI65-LFB19
	.long L$set$104
	.byte	0xe
	.uleb128 0xf0
	.byte	0x9d
	.uleb128 0x1e
	.byte	0x9e
	.uleb128 0x1d
	.byte	0x4
	.set L$set$105,LCFI66-LCFI65
	.long L$set$105
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$106,LCFI67-LCFI66
	.long L$set$106
	.byte	0x93
	.uleb128 0x1c
	.byte	0x94
	.uleb128 0x1b
	.byte	0x95
	.uleb128 0x1a
	.byte	0x96
	.uleb128 0x19
	.byte	0x97
	.uleb128 0x18
	.byte	0x98
	.uleb128 0x17
	.byte	0x99
	.uleb128 0x16
	.byte	0x9a
	.uleb128 0x15
	.byte	0x9b
	.uleb128 0x14
	.byte	0x4
	.set L$set$107,LCFI68-LCFI67
	.long L$set$107
	.byte	0xde
	.byte	0xdd
	.byte	0xdb
	.byte	0xd9
	.byte	0xda
	.byte	0xd7
	.byte	0xd8
	.byte	0xd5
	.byte	0xd6
	.byte	0xd3
	.byte	0xd4
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE37:
LSFDE39:
	.set L$set$108,LEFDE39-LASFDE39
	.long L$set$108
LASFDE39:
	.long	LASFDE39-EH_frame1
	.quad	LFB21-.
	.set L$set$109,LFE21-LFB21
	.quad L$set$109
	.uleb128 0x8
	.quad	0
	.byte	0x4
	.set L$set$110,LCFI69-LFB21
	.long L$set$110
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$111,LCFI70-LCFI69
	.long L$set$111
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$112,LCFI71-LCFI70
	.long L$set$112
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE39:
LSFDE41:
	.set L$set$113,LEFDE41-LASFDE41
	.long L$set$113
LASFDE41:
	.long	LASFDE41-EH_frame1
	.quad	LFB22-.
	.set L$set$114,LFE22-LFB22
	.quad L$set$114
	.uleb128 0x8
	.quad	0
	.byte	0x4
	.set L$set$115,LCFI72-LFB22
	.long L$set$115
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$116,LCFI73-LCFI72
	.long L$set$116
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$117,LCFI74-LCFI73
	.long L$set$117
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE41:
LSFDE43:
	.set L$set$118,LEFDE43-LASFDE43
	.long L$set$118
LASFDE43:
	.long	LASFDE43-EH_frame1
	.quad	LFB23-.
	.set L$set$119,LFE23-LFB23
	.quad L$set$119
	.uleb128 0x8
	.quad	0
	.byte	0x4
	.set L$set$120,LCFI75-LFB23
	.long L$set$120
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$121,LCFI76-LCFI75
	.long L$set$121
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$122,LCFI77-LCFI76
	.long L$set$122
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE43:
LSFDE45:
	.set L$set$123,LEFDE45-LASFDE45
	.long L$set$123
LASFDE45:
	.long	LASFDE45-EH_frame1
	.quad	LFB24-.
	.set L$set$124,LFE24-LFB24
	.quad L$set$124
	.uleb128 0x8
	.quad	0
	.byte	0x4
	.set L$set$125,LCFI78-LFB24
	.long L$set$125
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$126,LCFI79-LCFI78
	.long L$set$126
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$127,LCFI80-LCFI79
	.long L$set$127
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE45:
LSFDE47:
	.set L$set$128,LEFDE47-LASFDE47
	.long L$set$128
LASFDE47:
	.long	LASFDE47-EH_frame1
	.quad	LFB25-.
	.set L$set$129,LFE25-LFB25
	.quad L$set$129
	.uleb128 0x8
	.quad	0
	.byte	0x4
	.set L$set$130,LCFI81-LFB25
	.long L$set$130
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$131,LCFI82-LCFI81
	.long L$set$131
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$132,LCFI83-LCFI82
	.long L$set$132
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE47:
LSFDE49:
	.set L$set$133,LEFDE49-LASFDE49
	.long L$set$133
LASFDE49:
	.long	LASFDE49-EH_frame1
	.quad	LFB26-.
	.set L$set$134,LFE26-LFB26
	.quad L$set$134
	.uleb128 0x8
	.quad	0
	.byte	0x4
	.set L$set$135,LCFI84-LFB26
	.long L$set$135
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$136,LCFI85-LCFI84
	.long L$set$136
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$137,LCFI86-LCFI85
	.long L$set$137
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE49:
LSFDE51:
	.set L$set$138,LEFDE51-LASFDE51
	.long L$set$138
LASFDE51:
	.long	LASFDE51-EH_frame1
	.quad	LFB27-.
	.set L$set$139,LFE27-LFB27
	.quad L$set$139
	.uleb128 0x8
	.quad	0
	.byte	0x4
	.set L$set$140,LCFI87-LFB27
	.long L$set$140
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$141,LCFI88-LCFI87
	.long L$set$141
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$142,LCFI89-LCFI88
	.long L$set$142
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE51:
LSFDE53:
	.set L$set$143,LEFDE53-LASFDE53
	.long L$set$143
LASFDE53:
	.long	LASFDE53-EH_frame1
	.quad	LFB28-.
	.set L$set$144,LFE28-LFB28
	.quad L$set$144
	.uleb128 0x8
	.quad	0
	.byte	0x4
	.set L$set$145,LCFI90-LFB28
	.long L$set$145
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$146,LCFI91-LCFI90
	.long L$set$146
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$147,LCFI92-LCFI91
	.long L$set$147
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE53:
	.ident	"GCC: (GNU) 15.0.1 20250418 (prerelease)"
	.subsections_via_symbols
