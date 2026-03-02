	.arch armv8.5-a
	.build_version macos,  16, 0
	.text
	.align	2
	.globl ____ghost_safe_model__range64IP
____ghost_safe_model__range64IP:
LFB2:
	sub	sp, sp, #16
LCFI0:
	ldp	x0, x1, [sp]
	add	sp, sp, 16
LCFI1:
	ret
LFE2:
	.align	2
	.globl ____ghost_safe_model__ownership_stateH
____ghost_safe_model__ownership_stateH:
LFB3:
	sub	sp, sp, #16
LCFI2:
	stp	x0, x1, [sp]
	ldr	x0, [sp, 8]
	ldr	w0, [x0]
	ldr	x1, [sp, 8]
	ldr	w1, [x1, 4]
	cmp	w1, w0
	blt	L3
	sub	w6, w1, w0
	add	w6, w6, 1
	b	L4
L3:
	mov	w6, 0
L4:
	sxtw	x7, w0
	cmp	w1, w0
	cmp	w1, w0
	blt	L8
	sxtw	x9, w1
	sxtw	x8, w0
	sub	x8, x9, x8
	add	x8, x8, 1
	mov	x2, x8
	mov	x3, 0
	lsr	x8, x2, 61
	lsl	x5, x3, 3
	mov	x9, x5
	add	x8, x8, x9
	mov	x5, x8
	lsl	x4, x2, 3
L8:
	cmp	w1, w0
	sub	w8, w0, #1
	mov	w4, 0
	mov	w3, 0
	mov	w1, 0
L12:
	cmp	w1, 0
	bgt	L11
	sxtw	x2, w1
	adrp	x0, _ownership_stateP.3@PAGE
	add	x0, x0, _ownership_stateP.3@PAGEOFF;
	ldr	w0, [x0, x2, lsl 2]
	cmp	w6, w0
	blt	L11
	ldr	x2, [sp]
	sxtw	x5, w1
	adrp	x0, _ownership_stateP.3@PAGE
	add	x0, x0, _ownership_stateP.3@PAGEOFF;
	ldr	w0, [x0, x5, lsl 2]
	add	w0, w8, w0
	sxtw	x0, w0
	sub	x0, x0, x7
	ldrsb	w0, [x2, x0]
	and	w0, w0, 255
	mov	w5, w0
	sxtw	x0, w1
	adrp	x2, _ownership_stateT1.2@PAGE
	add	x2, x2, _ownership_stateT1.2@PAGEOFF;
	ldrb	w0, [x2, x0]
	mul	w0, w5, w0
	add	w4, w4, w0
	mov	w0, 11
	sdiv	w2, w4, w0
	mov	w0, w2
	lsl	w0, w0, 2
	add	w0, w0, w2
	lsl	w0, w0, 1
	add	w0, w0, w2
	sub	w4, w4, w0
	sxtw	x0, w1
	adrp	x2, _ownership_stateT2.1@PAGE
	add	x2, x2, _ownership_stateT2.1@PAGEOFF;
	ldrb	w0, [x2, x0]
	mul	w0, w5, w0
	add	w3, w3, w0
	mov	w0, 11
	sdiv	w2, w3, w0
	mov	w0, w2
	lsl	w0, w0, 2
	add	w0, w0, w2
	lsl	w0, w0, 1
	add	w0, w0, w2
	sub	w3, w3, w0
	add	w1, w1, 1
	b	L12
L11:
	sxtw	x0, w4
	adrp	x1, _ownership_stateG.0@PAGE
	add	x1, x1, _ownership_stateG.0@PAGEOFF;
	ldrb	w0, [x1, x0]
	mov	w2, w0
	sxtw	x0, w3
	adrp	x1, _ownership_stateG.0@PAGE
	add	x1, x1, _ownership_stateG.0@PAGEOFF;
	ldrb	w0, [x1, x0]
	add	w1, w2, w0
	mov	w0, 5
	sdiv	w2, w1, w0
	mov	w0, w2
	lsl	w0, w0, 2
	add	w0, w0, w2
	sub	w0, w1, w0
	add	sp, sp, 16
LCFI3:
	ret
LFE3:
	.align	2
	.globl ____ghost_safe_model__channel_stateIP
____ghost_safe_model__channel_stateIP:
LFB4:
	sub	sp, sp, #16
LCFI4:
	ldr	x0, [sp, 8]
	add	sp, sp, 16
LCFI5:
	ret
LFE4:
	.align	2
	.globl ____ghost_safe_model__Ttask_var_mapBIP
____ghost_safe_model__Ttask_var_mapBIP:
LFB5:
	sub	sp, sp, #16
LCFI6:
	stp	x0, x1, [sp]
	add	sp, sp, 16
LCFI7:
	ret
LFE5:
	.align	2
	.globl ____ghost_safe_model__is_valid_range
____ghost_safe_model__is_valid_range:
LFB6:
	sub	sp, sp, #16
LCFI8:
	stp	x0, x1, [sp]
	ldr	x1, [sp]
	ldr	x0, [sp, 8]
	cmp	x1, x0
	cset	w0, le
	and	w0, w0, 255
	add	sp, sp, 16
LCFI9:
	ret
LFE6:
	.const
	.align	3
lC3:
	.ascii "safe_model.ads"
	.space 1
	.align	3
lC4:
	.ascii "failed precondition from safe_model.ads:45"
	.text
	.align	2
	.globl ____ghost_safe_model__contains
____ghost_safe_model__contains:
LFB7:
	stp	x29, x30, [sp, -64]!
LCFI10:
	mov	x29, sp
LCFI11:
	stp	x20, x21, [sp, 16]
LCFI12:
	stp	x0, x1, [x29, 48]
	str	x2, [x29, 40]
	ldp	x0, x1, [x29, 48]
	bl	____ghost_safe_model__is_valid_range
	mov	w1, w0
	cmp	w1, 1
	bls	L20
	mov	w1, 45
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L20:
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L21
	adrp	x0, lC4@PAGE
	add	x20, x0, lC4@PAGEOFF;
	adrp	x0, lC0@PAGE
	add	x21, x0, lC0@PAGEOFF;
	mov	x0, x20
	mov	x1, x21
	bl	_system__assertions__raise_assert_failure
L21:
	ldr	x0, [x29, 48]
	ldr	x1, [x29, 40]
	cmp	x1, x0
	blt	L22
	ldr	x0, [x29, 56]
	ldr	x1, [x29, 40]
	cmp	x1, x0
	bgt	L22
	mov	w0, 1
	b	L23
L22:
	mov	w0, 0
L23:
	ldp	x20, x21, [sp, 16]
	ldp	x29, x30, [sp], 64
LCFI13:
	ret
LFE7:
	.const
	.align	2
lC0:
	.word	1
	.word	42
	.text
	.const
	.align	3
lC5:
	.ascii "failed precondition from safe_model.ads:51"
	.text
	.align	2
	.globl ____ghost_safe_model__subset
____ghost_safe_model__subset:
LFB8:
	stp	x29, x30, [sp, -80]!
LCFI14:
	mov	x29, sp
LCFI15:
	stp	x20, x21, [sp, 16]
	stp	x22, x23, [sp, 32]
LCFI16:
	stp	x0, x1, [x29, 64]
	stp	x2, x3, [x29, 48]
	ldp	x0, x1, [x29, 64]
	bl	____ghost_safe_model__is_valid_range
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L26
	adrp	x0, lC5@PAGE
	add	x22, x0, lC5@PAGEOFF;
	adrp	x0, lC0@PAGE
	add	x23, x0, lC0@PAGEOFF;
	mov	x0, x22
	mov	x1, x23
	bl	_system__assertions__raise_assert_failure
L26:
	ldp	x0, x1, [x29, 48]
	bl	____ghost_safe_model__is_valid_range
	mov	w1, w0
	cmp	w1, 1
	bls	L27
	mov	w1, 51
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L27:
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L28
	adrp	x0, lC5@PAGE
	add	x20, x0, lC5@PAGEOFF;
	adrp	x0, lC0@PAGE
	add	x21, x0, lC0@PAGEOFF;
	mov	x0, x20
	mov	x1, x21
	bl	_system__assertions__raise_assert_failure
L28:
	ldr	x1, [x29, 64]
	ldr	x0, [x29, 48]
	cmp	x1, x0
	blt	L29
	ldr	x1, [x29, 72]
	ldr	x0, [x29, 56]
	cmp	x1, x0
	bgt	L29
	mov	w0, 1
	b	L30
L29:
	mov	w0, 0
L30:
	ldp	x20, x21, [sp, 16]
	ldp	x22, x23, [sp, 32]
	ldp	x29, x30, [sp], 80
LCFI17:
	ret
LFE8:
	.const
	.align	3
lC6:
	.ascii "failed precondition from safe_model.ads:58"
	.align	3
lC7:
	.ascii "failed precondition from safe_model.ads:59"
	.align	3
lC8:
	.ascii "failed precondition from safe_model.ads:60"
	.text
	.align	2
	.globl ____ghost_safe_model__intersect
____ghost_safe_model__intersect:
LFB9:
	stp	x29, x30, [sp, -112]!
LCFI18:
	mov	x29, sp
LCFI19:
	stp	x20, x21, [sp, 16]
	stp	x22, x23, [sp, 32]
	stp	x24, x25, [sp, 48]
	stp	x26, x27, [sp, 64]
LCFI20:
	stp	x0, x1, [x29, 96]
	stp	x2, x3, [x29, 80]
	ldp	x0, x1, [x29, 96]
	bl	____ghost_safe_model__is_valid_range
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L33
	adrp	x0, lC6@PAGE
	add	x24, x0, lC6@PAGEOFF;
	adrp	x0, lC0@PAGE
	add	x25, x0, lC0@PAGEOFF;
	mov	x0, x24
	mov	x1, x25
	bl	_system__assertions__raise_assert_failure
L33:
	ldp	x0, x1, [x29, 80]
	bl	____ghost_safe_model__is_valid_range
	mov	w1, w0
	cmp	w1, 1
	bls	L34
	mov	w1, 59
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L34:
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L35
	adrp	x0, lC7@PAGE
	add	x22, x0, lC7@PAGEOFF;
	adrp	x0, lC0@PAGE
	add	x23, x0, lC0@PAGEOFF;
	mov	x0, x22
	mov	x1, x23
	bl	_system__assertions__raise_assert_failure
L35:
	ldr	x1, [x29, 96]
	ldr	x0, [x29, 80]
	cmp	x1, x0
	csel	x2, x1, x0, ge
	ldr	x1, [x29, 104]
	ldr	x0, [x29, 88]
	cmp	x1, x0
	csel	x0, x1, x0, le
	cmp	x2, x0
	ble	L36
	adrp	x0, lC8@PAGE
	add	x20, x0, lC8@PAGEOFF;
	adrp	x0, lC0@PAGE
	add	x21, x0, lC0@PAGEOFF;
	mov	x0, x20
	mov	x1, x21
	bl	_system__assertions__raise_assert_failure
L36:
	ldr	x1, [x29, 96]
	ldr	x0, [x29, 80]
	cmp	x1, x0
	csel	x0, x1, x0, ge
	mov	x26, x0
	ldr	x1, [x29, 104]
	ldr	x0, [x29, 88]
	cmp	x1, x0
	csel	x0, x1, x0, le
	mov	x27, x0
	mov	x0, x26
	mov	x1, x27
	ldp	x20, x21, [sp, 16]
	ldp	x22, x23, [sp, 32]
	ldp	x24, x25, [sp, 48]
	ldp	x26, x27, [sp, 64]
	ldp	x29, x30, [sp], 112
LCFI21:
	ret
LFE9:
	.const
	.align	3
lC9:
	.ascii "failed precondition from safe_model.ads:68"
	.text
	.align	2
	.globl ____ghost_safe_model__widen
____ghost_safe_model__widen:
LFB10:
	stp	x29, x30, [sp, -96]!
LCFI22:
	mov	x29, sp
LCFI23:
	stp	x20, x21, [sp, 16]
	stp	x22, x23, [sp, 32]
	stp	x24, x25, [sp, 48]
LCFI24:
	stp	x0, x1, [x29, 80]
	stp	x2, x3, [x29, 64]
	ldp	x0, x1, [x29, 80]
	bl	____ghost_safe_model__is_valid_range
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L39
	adrp	x0, lC9@PAGE
	add	x22, x0, lC9@PAGEOFF;
	adrp	x0, lC0@PAGE
	add	x23, x0, lC0@PAGEOFF;
	mov	x0, x22
	mov	x1, x23
	bl	_system__assertions__raise_assert_failure
L39:
	ldp	x0, x1, [x29, 64]
	bl	____ghost_safe_model__is_valid_range
	mov	w1, w0
	cmp	w1, 1
	bls	L40
	mov	w1, 68
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L40:
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L41
	adrp	x0, lC9@PAGE
	add	x20, x0, lC9@PAGEOFF;
	adrp	x0, lC0@PAGE
	add	x21, x0, lC0@PAGEOFF;
	mov	x0, x20
	mov	x1, x21
	bl	_system__assertions__raise_assert_failure
L41:
	ldr	x1, [x29, 80]
	ldr	x0, [x29, 64]
	cmp	x1, x0
	csel	x0, x1, x0, le
	mov	x24, x0
	ldr	x1, [x29, 88]
	ldr	x0, [x29, 72]
	cmp	x1, x0
	csel	x0, x1, x0, ge
	mov	x25, x0
	mov	x0, x24
	mov	x1, x25
	ldp	x20, x21, [sp, 16]
	ldp	x22, x23, [sp, 32]
	ldp	x24, x25, [sp, 48]
	ldp	x29, x30, [sp], 96
LCFI25:
	ret
LFE10:
	.const
	.align	3
lC10:
	.ascii "failed precondition from safe_model.ads:74"
	.text
	.align	2
	.globl ____ghost_safe_model__excludes_zero
____ghost_safe_model__excludes_zero:
LFB11:
	stp	x29, x30, [sp, -48]!
LCFI26:
	mov	x29, sp
LCFI27:
	stp	x20, x21, [sp, 16]
LCFI28:
	stp	x0, x1, [x29, 32]
	ldp	x0, x1, [x29, 32]
	bl	____ghost_safe_model__is_valid_range
	mov	w1, w0
	cmp	w1, 1
	bls	L44
	mov	w1, 74
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L44:
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L45
	adrp	x0, lC10@PAGE
	add	x20, x0, lC10@PAGEOFF;
	adrp	x0, lC0@PAGE
	add	x21, x0, lC0@PAGEOFF;
	mov	x0, x20
	mov	x1, x21
	bl	_system__assertions__raise_assert_failure
L45:
	ldr	x0, [x29, 40]
	cmp	x0, 0
	blt	L46
	ldr	x0, [x29, 32]
	cmp	x0, 0
	ble	L47
L46:
	mov	w0, 1
	b	L48
L47:
	mov	w0, 0
L48:
	ldp	x20, x21, [sp, 16]
	ldp	x29, x30, [sp], 48
LCFI29:
	ret
LFE11:
	.align	2
	.globl ____ghost_safe_model__is_valid_channel
____ghost_safe_model__is_valid_channel:
LFB12:
	stp	x29, x30, [sp, -32]!
LCFI30:
	mov	x29, sp
LCFI31:
	str	x0, [x29, 24]
	ldr	w0, [x29, 28]
	cmp	w0, 0
	bge	L51
	mov	w1, 126
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L51:
	ldr	w0, [x29, 28]
	cmp	w0, 0
	cset	w0, gt
	and	w0, w0, 255
	cmp	w0, 0
	beq	L52
	ldr	w0, [x29, 24]
	cmp	w0, 0
	bge	L53
	mov	w1, 126
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L53:
	ldr	w0, [x29, 28]
	cmp	w0, 0
	bge	L54
	mov	w1, 126
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L54:
	ldr	w1, [x29, 24]
	ldr	w0, [x29, 28]
	cmp	w1, w0
	cset	w0, le
	and	w0, w0, 255
	cmp	w0, 0
	beq	L52
	mov	w0, 1
	b	L55
L52:
	mov	w0, 0
L55:
	ldp	x29, x30, [sp], 32
LCFI32:
	ret
LFE12:
	.const
	.align	3
lC11:
	.ascii "failed precondition from safe_model.ads:132"
	.text
	.align	2
	.globl ____ghost_safe_model__len
____ghost_safe_model__len:
LFB13:
	stp	x29, x30, [sp, -48]!
LCFI33:
	mov	x29, sp
LCFI34:
	stp	x20, x21, [sp, 16]
LCFI35:
	str	x0, [x29, 40]
	ldr	x0, [x29, 40]
	bl	____ghost_safe_model__is_valid_channel
	mov	w1, w0
	cmp	w1, 1
	bls	L58
	mov	w1, 132
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L58:
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L59
	adrp	x0, lC11@PAGE
	add	x20, x0, lC11@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x21, x0, lC1@PAGEOFF;
	mov	x0, x20
	mov	x1, x21
	bl	_system__assertions__raise_assert_failure
L59:
	ldr	w0, [x29, 40]
	cmp	w0, 0
	bge	L60
	mov	w1, 130
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L60:
	ldr	w0, [x29, 40]
	ldp	x20, x21, [sp, 16]
	ldp	x29, x30, [sp], 48
LCFI36:
	ret
LFE13:
	.const
	.align	2
lC1:
	.word	1
	.word	43
	.text
	.const
	.align	3
lC12:
	.ascii "failed precondition from safe_model.ads:137"
	.text
	.align	2
	.globl ____ghost_safe_model__is_empty
____ghost_safe_model__is_empty:
LFB14:
	stp	x29, x30, [sp, -48]!
LCFI37:
	mov	x29, sp
LCFI38:
	stp	x20, x21, [sp, 16]
LCFI39:
	str	x0, [x29, 40]
	ldr	x0, [x29, 40]
	bl	____ghost_safe_model__is_valid_channel
	mov	w1, w0
	cmp	w1, 1
	bls	L63
	mov	w1, 137
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L63:
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L64
	adrp	x0, lC12@PAGE
	add	x20, x0, lC12@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x21, x0, lC1@PAGEOFF;
	mov	x0, x20
	mov	x1, x21
	bl	_system__assertions__raise_assert_failure
L64:
	ldr	w0, [x29, 40]
	cmp	w0, 0
	bge	L65
	mov	w1, 135
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L65:
	ldr	w0, [x29, 40]
	cmp	w0, 0
	cset	w0, eq
	and	w0, w0, 255
	ldp	x20, x21, [sp, 16]
	ldp	x29, x30, [sp], 48
LCFI40:
	ret
LFE14:
	.const
	.align	3
lC13:
	.ascii "failed precondition from safe_model.ads:142"
	.text
	.align	2
	.globl ____ghost_safe_model__is_full
____ghost_safe_model__is_full:
LFB15:
	stp	x29, x30, [sp, -48]!
LCFI41:
	mov	x29, sp
LCFI42:
	stp	x20, x21, [sp, 16]
LCFI43:
	str	x0, [x29, 40]
	ldr	x0, [x29, 40]
	bl	____ghost_safe_model__is_valid_channel
	mov	w1, w0
	cmp	w1, 1
	bls	L68
	mov	w1, 142
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L68:
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L69
	adrp	x0, lC13@PAGE
	add	x20, x0, lC13@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x21, x0, lC1@PAGEOFF;
	mov	x0, x20
	mov	x1, x21
	bl	_system__assertions__raise_assert_failure
L69:
	ldr	w0, [x29, 40]
	cmp	w0, 0
	bge	L70
	mov	w1, 140
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L70:
	ldr	w0, [x29, 44]
	cmp	w0, 0
	bge	L71
	mov	w1, 140
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L71:
	ldr	w1, [x29, 40]
	ldr	w0, [x29, 44]
	cmp	w1, w0
	cset	w0, eq
	and	w0, w0, 255
	ldp	x20, x21, [sp, 16]
	ldp	x29, x30, [sp], 48
LCFI44:
	ret
LFE15:
	.const
	.align	3
lC14:
	.ascii "failed precondition from safe_model.ads:147"
	.text
	.align	2
	.globl ____ghost_safe_model__cap
____ghost_safe_model__cap:
LFB16:
	stp	x29, x30, [sp, -48]!
LCFI45:
	mov	x29, sp
LCFI46:
	stp	x20, x21, [sp, 16]
LCFI47:
	str	x0, [x29, 40]
	ldr	x0, [x29, 40]
	bl	____ghost_safe_model__is_valid_channel
	mov	w1, w0
	cmp	w1, 1
	bls	L74
	mov	w1, 147
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L74:
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L75
	adrp	x0, lC14@PAGE
	add	x20, x0, lC14@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x21, x0, lC1@PAGEOFF;
	mov	x0, x20
	mov	x1, x21
	bl	_system__assertions__raise_assert_failure
L75:
	ldr	w0, [x29, 44]
	cmp	w0, 0
	bge	L76
	mov	w1, 145
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L76:
	ldr	w0, [x29, 44]
	ldp	x20, x21, [sp, 16]
	ldp	x29, x30, [sp], 48
LCFI48:
	ret
LFE16:
	.align	2
____ghost_safe_model__after_append___wrapped_statements:
LFB18:
	stp	x29, x30, [sp, -32]!
LCFI49:
	mov	x29, sp
LCFI50:
	mov	x0, x16
	str	x16, [x29, 24]
	ldr	x2, [x0]
	ldr	w2, [x2]
	cmp	w2, 0
	bge	L79
	mov	w1, 150
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L79:
	ldr	x2, [x0]
	ldr	w3, [x2]
	mov	w2, 2147483647
	cmp	w3, w2
	bne	L80
	mov	w1, 150
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Overflow_Check
L80:
	ldr	x2, [x0]
	ldr	w2, [x2]
	add	w2, w2, 1
	bfi	x1, x2, 0, 32
	ldr	x0, [x0]
	ldr	w0, [x0, 4]
	bfi	x1, x0, 32, 32
	mov	x0, x1
	ldp	x29, x30, [sp], 32
LCFI51:
	ret
LFE18:
	.const
	.align	3
lC15:
	.ascii "failed precondition from safe_model.ads:153"
	.align	3
lC16:
	.ascii "failed postcondition from safe_model.ads:154"
	.align	3
lC17:
	.ascii "failed postcondition from safe_model.ads:155"
	.text
	.align	2
	.globl ____ghost_safe_model__after_append
____ghost_safe_model__after_append:
LFB17:
	stp	x29, x30, [sp, -144]!
LCFI52:
	mov	x29, sp
LCFI53:
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	str	x27, [sp, 80]
LCFI54:
	str	x0, [x29, 104]
	add	x1, x29, 144
	add	x0, x29, 104
	str	x1, [x29, 136]
	str	x0, [x29, 128]
	ldr	x0, [x29, 104]
	bl	____ghost_safe_model__is_valid_channel
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L83
	adrp	x0, lC15@PAGE
	add	x26, x0, lC15@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x27, x0, lC1@PAGEOFF;
	mov	x0, x26
	mov	x1, x27
	bl	_system__assertions__raise_assert_failure
L83:
	ldr	x0, [x29, 104]
	bl	____ghost_safe_model__is_full
	mov	w1, w0
	cmp	w1, 1
	bls	L84
	mov	w1, 153
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L84:
	eor	w0, w0, 1
	and	w0, w0, 255
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L85
	adrp	x0, lC15@PAGE
	add	x24, x0, lC15@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x25, x0, lC1@PAGEOFF;
	mov	x0, x24
	mov	x1, x25
	bl	_system__assertions__raise_assert_failure
L85:
	add	x0, x29, 128
	mov	x16, x0
	bl	____ghost_safe_model__after_append___wrapped_statements
	str	x0, [x29, 120]
	ldr	x0, [x29, 120]
	bl	____ghost_safe_model__is_valid_channel
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L86
	adrp	x0, lC16@PAGE
	add	x22, x0, lC16@PAGEOFF;
	adrp	x0, lC2@PAGE
	add	x23, x0, lC2@PAGEOFF;
	mov	x0, x22
	mov	x1, x23
	bl	_system__assertions__raise_assert_failure
L86:
	ldr	x0, [x29, 104]
	bl	____ghost_safe_model__len
	mov	w19, w0
	cmp	w19, 0
	bge	L87
	mov	w1, 155
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L87:
	ldr	x0, [x29, 120]
	bl	____ghost_safe_model__len
	cmp	w0, 0
	bge	L88
	mov	w1, 155
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L88:
	mov	w1, 2147483647
	cmp	w19, w1
	bne	L89
	mov	w1, 155
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Overflow_Check
L89:
	add	w1, w19, 1
	cmp	w1, w0
	cset	w0, eq
	and	w0, w0, 255
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L90
	adrp	x0, lC17@PAGE
	add	x20, x0, lC17@PAGEOFF;
	adrp	x0, lC2@PAGE
	add	x21, x0, lC2@PAGEOFF;
	mov	x0, x20
	mov	x1, x21
	bl	_system__assertions__raise_assert_failure
L90:
	ldr	x0, [x29, 120]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 144
LCFI55:
	ret
LFE17:
	.const
	.align	2
lC2:
	.word	1
	.word	44
	.text
	.align	2
____ghost_safe_model__after_remove___wrapped_statements:
LFB20:
	stp	x29, x30, [sp, -32]!
LCFI56:
	mov	x29, sp
LCFI57:
	mov	x1, x16
	str	x16, [x29, 24]
	ldr	x2, [x1]
	ldr	w2, [x2]
	cmp	w2, 0
	bge	L93
	mov	w1, 159
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L93:
	ldr	x2, [x1]
	ldr	w2, [x2]
	sub	w2, w2, #1
	cmp	w2, 0
	bge	L94
	mov	w1, 159
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Range_Check
L94:
	bfi	x0, x2, 0, 32
	ldr	x1, [x1]
	ldr	w1, [x1, 4]
	bfi	x0, x1, 32, 32
	ldp	x29, x30, [sp], 32
LCFI58:
	ret
LFE20:
	.const
	.align	3
lC18:
	.ascii "failed precondition from safe_model.ads:162"
	.align	3
lC19:
	.ascii "failed postcondition from safe_model.ads:163"
	.align	3
lC20:
	.ascii "failed postcondition from safe_model.ads:164"
	.text
	.align	2
	.globl ____ghost_safe_model__after_remove
____ghost_safe_model__after_remove:
LFB19:
	stp	x29, x30, [sp, -144]!
LCFI59:
	mov	x29, sp
LCFI60:
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	str	x27, [sp, 80]
LCFI61:
	str	x0, [x29, 104]
	add	x1, x29, 144
	add	x0, x29, 104
	str	x1, [x29, 136]
	str	x0, [x29, 128]
	ldr	x0, [x29, 104]
	bl	____ghost_safe_model__is_valid_channel
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L97
	adrp	x0, lC18@PAGE
	add	x26, x0, lC18@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x27, x0, lC1@PAGEOFF;
	mov	x0, x26
	mov	x1, x27
	bl	_system__assertions__raise_assert_failure
L97:
	ldr	x0, [x29, 104]
	bl	____ghost_safe_model__is_empty
	mov	w1, w0
	cmp	w1, 1
	bls	L98
	mov	w1, 162
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L98:
	eor	w0, w0, 1
	and	w0, w0, 255
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L99
	adrp	x0, lC18@PAGE
	add	x24, x0, lC18@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x25, x0, lC1@PAGEOFF;
	mov	x0, x24
	mov	x1, x25
	bl	_system__assertions__raise_assert_failure
L99:
	add	x0, x29, 128
	mov	x16, x0
	bl	____ghost_safe_model__after_remove___wrapped_statements
	str	x0, [x29, 120]
	ldr	x0, [x29, 120]
	bl	____ghost_safe_model__is_valid_channel
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L100
	adrp	x0, lC19@PAGE
	add	x22, x0, lC19@PAGEOFF;
	adrp	x0, lC2@PAGE
	add	x23, x0, lC2@PAGEOFF;
	mov	x0, x22
	mov	x1, x23
	bl	_system__assertions__raise_assert_failure
L100:
	ldr	x0, [x29, 104]
	bl	____ghost_safe_model__len
	mov	w19, w0
	cmp	w19, 0
	bge	L101
	mov	w1, 164
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L101:
	ldr	x0, [x29, 120]
	bl	____ghost_safe_model__len
	cmp	w0, 0
	bge	L102
	mov	w1, 164
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L102:
	sub	w1, w19, #1
	cmp	w0, w1
	cset	w0, eq
	and	w0, w0, 255
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L103
	adrp	x0, lC20@PAGE
	add	x20, x0, lC20@PAGEOFF;
	adrp	x0, lC2@PAGE
	add	x21, x0, lC2@PAGEOFF;
	mov	x0, x20
	mov	x1, x21
	bl	_system__assertions__raise_assert_failure
L103:
	ldr	x0, [x29, 120]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 144
LCFI62:
	ret
LFE19:
	.align	2
____ghost_safe_model__make_channel___wrapped_statements:
LFB22:
	stp	x29, x30, [sp, -32]!
LCFI63:
	mov	x29, sp
LCFI64:
	mov	x1, x16
	str	x16, [x29, 24]
	ldr	w2, [x1]
	cmp	w2, 0
	beq	L106
	ldr	w2, [x1]
	cmp	w2, 0
	bge	L107
L106:
	mov	w1, 168
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L107:
	and	x0, x0, -4294967296
	ldr	w1, [x1]
	bfi	x0, x1, 32, 32
	ldp	x29, x30, [sp], 32
LCFI65:
	ret
LFE22:
	.const
	.align	3
lC21:
	.ascii "failed postcondition from safe_model.ads:170"
	.align	3
lC22:
	.ascii "failed postcondition from safe_model.ads:171"
	.text
	.align	2
	.globl ____ghost_safe_model__make_channel
____ghost_safe_model__make_channel:
LFB21:
	stp	x29, x30, [sp, -96]!
LCFI66:
	mov	x29, sp
LCFI67:
	stp	x20, x21, [sp, 16]
	stp	x22, x23, [sp, 32]
LCFI68:
	str	w0, [x29, 60]
	add	x0, x29, 96
	str	x0, [x29, 88]
	ldr	w0, [x29, 60]
	str	w0, [x29, 80]
	add	x0, x29, 80
	mov	x16, x0
	bl	____ghost_safe_model__make_channel___wrapped_statements
	str	x0, [x29, 72]
	ldr	x0, [x29, 72]
	bl	____ghost_safe_model__is_valid_channel
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L110
	adrp	x0, lC21@PAGE
	add	x22, x0, lC21@PAGEOFF;
	adrp	x0, lC2@PAGE
	add	x23, x0, lC2@PAGEOFF;
	mov	x0, x22
	mov	x1, x23
	bl	_system__assertions__raise_assert_failure
L110:
	ldr	x0, [x29, 72]
	bl	____ghost_safe_model__is_empty
	mov	w1, w0
	cmp	w1, 1
	bls	L111
	mov	w1, 171
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L111:
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L112
	adrp	x0, lC22@PAGE
	add	x20, x0, lC22@PAGEOFF;
	adrp	x0, lC2@PAGE
	add	x21, x0, lC2@PAGEOFF;
	mov	x0, x20
	mov	x1, x21
	bl	_system__assertions__raise_assert_failure
L112:
	ldr	x0, [x29, 72]
	ldp	x20, x21, [sp, 16]
	ldp	x22, x23, [sp, 32]
	ldp	x29, x30, [sp], 96
LCFI69:
	ret
LFE21:
	.align	2
	.globl ____ghost_safe_model__is_accessible
____ghost_safe_model__is_accessible:
LFB23:
	stp	x29, x30, [sp, -32]!
LCFI70:
	mov	x29, sp
LCFI71:
	strb	w0, [x29, 31]
	ldrb	w0, [x29, 31]
	cmp	w0, 4
	bls	L115
	mov	w1, 194
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L115:
	ldrb	w0, [x29, 31]
	cmp	w0, 1
	cset	w0, eq
	and	w0, w0, 255
	cmp	w0, 0
	bne	L116
	ldrb	w0, [x29, 31]
	cmp	w0, 3
	beq	L116
	ldrb	w0, [x29, 31]
	cmp	w0, 4
	bne	L117
L116:
	mov	w0, 1
	b	L118
L117:
	mov	w0, 0
L118:
	ldp	x29, x30, [sp], 32
LCFI72:
	ret
LFE23:
	.align	2
	.globl ____ghost_safe_model__is_dereferenceable
____ghost_safe_model__is_dereferenceable:
LFB24:
	stp	x29, x30, [sp, -32]!
LCFI73:
	mov	x29, sp
LCFI74:
	strb	w0, [x29, 31]
	ldrb	w0, [x29, 31]
	cmp	w0, 4
	bls	L121
	mov	w1, 201
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L121:
	ldrb	w0, [x29, 31]
	cmp	w0, 1
	cset	w0, eq
	and	w0, w0, 255
	cmp	w0, 0
	bne	L122
	ldrb	w0, [x29, 31]
	cmp	w0, 3
	beq	L122
	ldrb	w0, [x29, 31]
	cmp	w0, 4
	bne	L123
L122:
	mov	w0, 1
	b	L124
L123:
	mov	w0, 0
L124:
	ldp	x29, x30, [sp], 32
LCFI75:
	ret
LFE24:
	.align	2
	.globl ____ghost_safe_model__is_movable
____ghost_safe_model__is_movable:
LFB25:
	stp	x29, x30, [sp, -32]!
LCFI76:
	mov	x29, sp
LCFI77:
	strb	w0, [x29, 31]
	ldrb	w0, [x29, 31]
	cmp	w0, 4
	bls	L127
	mov	w1, 206
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L127:
	ldrb	w0, [x29, 31]
	cmp	w0, 1
	cset	w0, eq
	and	w0, w0, 255
	ldp	x29, x30, [sp], 32
LCFI78:
	ret
LFE25:
	.align	2
	.globl ____ghost_safe_model__is_borrowable
____ghost_safe_model__is_borrowable:
LFB26:
	stp	x29, x30, [sp, -32]!
LCFI79:
	mov	x29, sp
LCFI80:
	strb	w0, [x29, 31]
	ldrb	w0, [x29, 31]
	cmp	w0, 4
	bls	L130
	mov	w1, 212
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L130:
	ldrb	w0, [x29, 31]
	cmp	w0, 1
	cset	w0, eq
	and	w0, w0, 255
	ldp	x29, x30, [sp], 32
LCFI81:
	ret
LFE26:
	.align	2
	.globl ____ghost_safe_model__is_observable
____ghost_safe_model__is_observable:
LFB27:
	stp	x29, x30, [sp, -32]!
LCFI82:
	mov	x29, sp
LCFI83:
	strb	w0, [x29, 31]
	ldrb	w0, [x29, 31]
	cmp	w0, 4
	bls	L133
	mov	w1, 218
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L133:
	ldrb	w0, [x29, 31]
	cmp	w0, 1
	cset	w0, eq
	and	w0, w0, 255
	cmp	w0, 0
	bne	L134
	ldrb	w0, [x29, 31]
	cmp	w0, 4
	bne	L135
L134:
	mov	w0, 1
	b	L136
L135:
	mov	w0, 0
L136:
	ldp	x29, x30, [sp], 32
LCFI84:
	ret
LFE27:
	.align	2
	.globl ____ghost_safe_model__is_valid_transition
____ghost_safe_model__is_valid_transition:
LFB28:
	stp	x29, x30, [sp, -32]!
LCFI85:
	mov	x29, sp
LCFI86:
	strb	w0, [x29, 31]
	mov	w0, w1
	strb	w0, [x29, 30]
	ldrb	w0, [x29, 31]
	cmp	w0, 4
	bls	L139
	mov	w1, 227
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L139:
	ldrb	w0, [x29, 31]
	cmp	w0, 4
	bls	L140
	mov	w1, 227
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L140:
	ldrb	w0, [x29, 31]
	cmp	w0, 3
	beq	L141
	ldrb	w0, [x29, 31]
	cmp	w0, 3
	bhi	L142
	ldrb	w0, [x29, 31]
	cmp	w0, 2
	beq	L143
	ldrb	w0, [x29, 31]
	cmp	w0, 2
	bhi	L142
	ldrb	w0, [x29, 31]
	cmp	w0, 0
	beq	L144
	ldrb	w0, [x29, 31]
	cmp	w0, 1
	beq	L145
	b	L142
L144:
	ldrb	w0, [x29, 30]
	cmp	w0, 4
	bls	L146
	mov	w1, 229
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L146:
	ldrb	w0, [x29, 30]
	cmp	w0, 1
	cset	w0, eq
	and	w0, w0, 255
	b	L147
L145:
	ldrb	w0, [x29, 30]
	cmp	w0, 2
	beq	L148
	ldrb	w0, [x29, 30]
	cmp	w0, 3
	beq	L148
	ldrb	w0, [x29, 30]
	cmp	w0, 4
	beq	L148
	ldrb	w0, [x29, 30]
	cmp	w0, 0
	bne	L149
L148:
	mov	w0, 1
	b	L147
L149:
	mov	w0, 0
	b	L147
L143:
	ldrb	w0, [x29, 30]
	cmp	w0, 1
	beq	L151
	ldrb	w0, [x29, 30]
	cmp	w0, 0
	bne	L152
L151:
	mov	w0, 1
	b	L147
L152:
	mov	w0, 0
	b	L147
L141:
	ldrb	w0, [x29, 30]
	cmp	w0, 1
	cset	w0, eq
	and	w0, w0, 255
	b	L147
L142:
	ldrb	w0, [x29, 30]
	cmp	w0, 1
	beq	L154
	ldrb	w0, [x29, 30]
	cmp	w0, 4
	bne	L155
L154:
	mov	w0, 1
	b	L147
L155:
	mov	w0, 0
L147:
	ldp	x29, x30, [sp], 32
LCFI87:
	ret
LFE28:
	.align	2
	.globl ____ghost_safe_model__exclusive_owner
____ghost_safe_model__exclusive_owner:
LFB29:
	stp	x29, x30, [sp, -32]!
LCFI88:
	mov	x29, sp
LCFI89:
	str	w0, [x29, 28]
	str	x1, [x29, 16]
	ldr	w0, [x29, 28]
	cmp	w0, 1023
	bls	L158
	mov	w1, 277
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L158:
	ldrsw	x1, [x29, 28]
	ldr	x0, [x29, 16]
	ldr	w0, [x0, x1, lsl 2]
	cmp	w0, 64
	bls	L159
	mov	w1, 277
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L159:
	ldrsw	x1, [x29, 28]
	ldr	x0, [x29, 16]
	ldr	w0, [x0, x1, lsl 2]
	cmp	w0, 0
	cset	w0, ne
	and	w0, w0, 255
	ldp	x29, x30, [sp], 32
LCFI90:
	ret
LFE29:
	.align	2
	.globl ____ghost_safe_model__is_unowned
____ghost_safe_model__is_unowned:
LFB30:
	stp	x29, x30, [sp, -32]!
LCFI91:
	mov	x29, sp
LCFI92:
	str	w0, [x29, 28]
	str	x1, [x29, 16]
	ldr	w0, [x29, 28]
	cmp	w0, 1023
	bls	L162
	mov	w1, 288
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L162:
	ldrsw	x1, [x29, 28]
	ldr	x0, [x29, 16]
	ldr	w0, [x0, x1, lsl 2]
	cmp	w0, 64
	bls	L163
	mov	w1, 288
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L163:
	ldrsw	x1, [x29, 28]
	ldr	x0, [x29, 16]
	ldr	w0, [x0, x1, lsl 2]
	cmp	w0, 0
	cset	w0, eq
	and	w0, w0, 255
	ldp	x29, x30, [sp], 32
LCFI93:
	ret
LFE30:
	.align	2
	.globl ____ghost_safe_model__owner_of
____ghost_safe_model__owner_of:
LFB31:
	stp	x29, x30, [sp, -32]!
LCFI94:
	mov	x29, sp
LCFI95:
	str	w0, [x29, 28]
	str	x1, [x29, 16]
	ldr	w0, [x29, 28]
	cmp	w0, 1023
	bls	L166
	mov	w1, 296
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L166:
	ldrsw	x1, [x29, 28]
	ldr	x0, [x29, 16]
	ldr	w0, [x0, x1, lsl 2]
	cmp	w0, 64
	bls	L167
	mov	w1, 296
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L167:
	ldrsw	x1, [x29, 28]
	ldr	x0, [x29, 16]
	ldr	w0, [x0, x1, lsl 2]
	ldp	x29, x30, [sp], 32
LCFI96:
	ret
LFE31:
	.const
	.align	3
lC23:
	.ascii "safe_model.adb"
	.space 1
	.text
	.align	2
____ghost_safe_model__assign_owner___wrapped_statements:
LFB33:
	mov	x12, 4144
	sub	sp, sp, x12
LCFI97:
	stp	x29, x30, [sp]
LCFI98:
	mov	x29, sp
LCFI99:
	stp	x19, x20, [sp, 16]
LCFI100:
	mov	x20, x8
	mov	x19, x16
	str	x16, [x29, 40]
	ldr	x1, [x19]
	add	x0, x29, 48
	mov	x3, x1
	mov	x1, 4096
	mov	x2, x1
	mov	x1, x3
	bl	_memcpy
	ldr	w0, [x19, 12]
	cmp	w0, 1023
	bls	L170
	mov	w1, 29
	adrp	x0, lC23@PAGE
	add	x0, x0, lC23@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L170:
	ldr	w0, [x19, 8]
	cmp	w0, 64
	bls	L171
	mov	w1, 29
	adrp	x0, lC23@PAGE
	add	x0, x0, lC23@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L171:
	ldr	w0, [x19, 12]
	sxtw	x0, w0
	ldr	w2, [x19, 8]
	lsl	x0, x0, 2
	add	x1, x29, 48
	str	w2, [x1, x0]
	mov	x3, x20
	add	x0, x29, 48
	mov	x1, 4096
	mov	x2, x1
	mov	x1, x0
	mov	x0, x3
	bl	_memcpy
	ldp	x29, x30, [sp]
	ldp	x19, x20, [sp, 16]
	mov	x12, 4144
	add	sp, sp, x12
LCFI101:
	ret
LFE33:
	.const
	.align	3
lC24:
	.ascii "failed precondition from safe_model.ads:305"
	.align	3
lC25:
	.ascii "failed postcondition from safe_model.ads:306"
	.align	3
lC26:
	.ascii "failed postcondition from safe_model.ads:307"
	.text
	.align	2
	.globl ____ghost_safe_model__assign_owner
____ghost_safe_model__assign_owner:
LFB32:
	mov	x12, 4208
	sub	sp, sp, x12
LCFI102:
	stp	x29, x30, [sp]
LCFI103:
	mov	x29, sp
LCFI104:
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	str	x23, [sp, 48]
LCFI105:
	mov	x19, x8
	str	w0, [x29, 76]
	str	w1, [x29, 72]
	str	x2, [x29, 64]
	add	x0, x29, 4096
	add	x0, x0, 112
	str	x0, [x29, 4192]
	ldr	w0, [x29, 76]
	str	w0, [x29, 4188]
	ldr	w0, [x29, 72]
	str	w0, [x29, 4184]
	ldr	x0, [x29, 64]
	str	x0, [x29, 4176]
	ldr	w0, [x29, 4188]
	cmp	w0, 1023
	bls	L174
	mov	w1, 305
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L174:
	ldr	w0, [x29, 4188]
	sxtw	x1, w0
	ldr	x0, [x29, 4176]
	ldr	w0, [x0, x1, lsl 2]
	cmp	w0, 64
	bls	L175
	mov	w1, 305
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L175:
	ldr	w0, [x29, 4188]
	sxtw	x1, w0
	ldr	x0, [x29, 4176]
	ldr	w0, [x0, x1, lsl 2]
	cmp	w0, 0
	cset	w0, eq
	and	w0, w0, 255
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L176
	ldr	w0, [x29, 4188]
	sxtw	x1, w0
	ldr	x0, [x29, 4176]
	ldr	w0, [x0, x1, lsl 2]
	cmp	w0, 64
	bls	L177
	mov	w1, 305
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L177:
	ldr	w0, [x29, 4184]
	cmp	w0, 64
	bls	L178
	mov	w1, 305
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L178:
	ldr	w0, [x29, 4188]
	sxtw	x1, w0
	ldr	x0, [x29, 4176]
	ldr	w0, [x0, x1, lsl 2]
	ldr	w1, [x29, 4184]
	cmp	w1, w0
	cset	w0, eq
	and	w0, w0, 255
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L176
	adrp	x0, lC24@PAGE
	add	x4, x0, lC24@PAGEOFF;
	adrp	x0, lC1@PAGE
	add	x5, x0, lC1@PAGEOFF;
	mov	x0, x4
	mov	x1, x5
	bl	_system__assertions__raise_assert_failure
L176:
	add	x0, x29, 4096
	add	x0, x0, 80
	add	x1, x29, 80
	mov	x8, x1
	mov	x16, x0
	bl	____ghost_safe_model__assign_owner___wrapped_statements
	ldr	w0, [x29, 4188]
	cmp	w0, 1023
	bls	L179
	mov	w1, 306
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L179:
	ldr	w0, [x29, 4188]
	sxtw	x0, w0
	lsl	x0, x0, 2
	add	x1, x29, 80
	ldr	w0, [x1, x0]
	cmp	w0, 64
	bls	L180
	mov	w1, 306
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L180:
	ldr	w0, [x29, 4184]
	cmp	w0, 64
	bls	L181
	mov	w1, 306
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L181:
	ldr	w0, [x29, 4188]
	sxtw	x0, w0
	lsl	x0, x0, 2
	add	x1, x29, 80
	ldr	w0, [x1, x0]
	ldr	w1, [x29, 4184]
	cmp	w1, w0
	cset	w0, eq
	and	w0, w0, 255
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L182
	adrp	x0, lC25@PAGE
	add	x22, x0, lC25@PAGEOFF;
	adrp	x0, lC2@PAGE
	add	x23, x0, lC2@PAGEOFF;
	mov	x0, x22
	mov	x1, x23
	bl	_system__assertions__raise_assert_failure
L182:
	mov	w1, 1
	str	wzr, [x29, 4204]
L191:
	ldr	w0, [x29, 4204]
	cmp	w0, 1023
	bgt	L183
	ldr	w0, [x29, 4188]
	cmp	w0, 1023
	bls	L184
	mov	w1, 308
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L184:
	ldr	w0, [x29, 4188]
	ldr	w2, [x29, 4204]
	cmp	w2, w0
	beq	L185
	ldrsw	x0, [x29, 4204]
	lsl	x0, x0, 2
	add	x2, x29, 80
	ldr	w0, [x2, x0]
	cmp	w0, 64
	bls	L186
	mov	w1, 309
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L186:
	ldrsw	x2, [x29, 4204]
	ldr	x0, [x29, 4176]
	ldr	w0, [x0, x2, lsl 2]
	cmp	w0, 64
	bls	L187
	mov	w1, 309
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L187:
	ldrsw	x0, [x29, 4204]
	lsl	x0, x0, 2
	add	x2, x29, 80
	ldr	w2, [x2, x0]
	ldrsw	x3, [x29, 4204]
	ldr	x0, [x29, 4176]
	ldr	w0, [x0, x3, lsl 2]
	cmp	w2, w0
	cset	w0, eq
	and	w0, w0, 255
	b	L188
L185:
	mov	w0, 1
L188:
	mov	w2, w0
	cmp	w2, 1
	bls	L189
	mov	w1, 308
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;
	bl	___gnat_rcheck_CE_Invalid_Data
L189:
	eor	w0, w0, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L190
	mov	w1, 0
	b	L183
L190:
	ldr	w0, [x29, 4204]
	add	w0, w0, 1
	str	w0, [x29, 4204]
	b	L191
L183:
	eor	w0, w1, 1
	and	w0, w0, 255
	cmp	w0, 0
	beq	L192
	adrp	x0, lC26@PAGE
	add	x20, x0, lC26@PAGEOFF;
	adrp	x0, lC2@PAGE
	add	x21, x0, lC2@PAGEOFF;
	mov	x0, x20
	mov	x1, x21
	bl	_system__assertions__raise_assert_failure
L192:
	mov	x3, x19
	add	x0, x29, 80
	mov	x1, 4096
	mov	x2, x1
	mov	x1, x0
	mov	x0, x3
	bl	_memcpy
	ldp	x29, x30, [sp]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	mov	x12, 4208
	add	sp, sp, x12
LCFI106:
	ret
LFE32:
	.align	2
	.globl ____ghost_safe_model__no_shared_variables
____ghost_safe_model__no_shared_variables:
LFB34:
	sub	sp, sp, #16
LCFI107:
	str	x0, [sp, 8]
	mov	w0, 1
	add	sp, sp, 16
LCFI108:
	ret
LFE34:
	.globl _safe_model_E
	.data
	.align	1
_safe_model_E:
	.space 2
	.globl ____ghost_safe_model__no_task
	.const
	.align	2
____ghost_safe_model__no_task:
	.space 4
	.globl ____ghost_safe_model__range_int8
	.align	3
____ghost_safe_model__range_int8:
	.xword	-128
	.xword	127
	.globl ____ghost_safe_model__range_uint8
	.align	3
____ghost_safe_model__range_uint8:
	.xword	0
	.xword	255
	.globl ____ghost_safe_model__range_int16
	.align	3
____ghost_safe_model__range_int16:
	.xword	-32768
	.xword	32767
	.globl ____ghost_safe_model__range_uint16
	.align	3
____ghost_safe_model__range_uint16:
	.xword	0
	.xword	65535
	.globl ____ghost_safe_model__range_int32
	.align	3
____ghost_safe_model__range_int32:
	.xword	-2147483648
	.xword	2147483647
	.globl ____ghost_safe_model__range_uint32
	.align	3
____ghost_safe_model__range_uint32:
	.xword	0
	.xword	4294967295
	.globl ____ghost_safe_model__range_int64
	.align	3
____ghost_safe_model__range_int64:
	.xword	-9223372036854775808
	.xword	9223372036854775807
	.globl ____ghost_safe_model__range_positive
	.align	3
____ghost_safe_model__range_positive:
	.xword	1
	.xword	9223372036854775807
	.globl ____ghost_safe_model__range_natural
	.align	3
____ghost_safe_model__range_natural:
	.xword	0
	.xword	9223372036854775807
	.globl ____ghost_safe_model__ownership_stateS
	.align	3
____ghost_safe_model__ownership_stateS:
	.ascii "NULL_STATEOWNEDMOVEDBORROWEDOBSERVED"
	.globl ____ghost_safe_model__ownership_stateN
	.align	3
____ghost_safe_model__ownership_stateN:
	.byte	1
	.byte	11
	.byte	16
	.byte	21
	.byte	29
	.byte	37
	.space 2
	.align	2
_ownership_stateP.3:
	.word	3
_ownership_stateT1.2:
	.byte	3
_ownership_stateT2.1:
	.byte	9
	.align	3
_ownership_stateG.0:
	.byte	0
	.byte	3
	.byte	0
	.byte	0
	.byte	0
	.byte	2
	.byte	0
	.byte	0
	.byte	0
	.byte	1
	.byte	4
	.space 5
	.section __TEXT,__eh_frame,coalesced,no_toc+strip_static_syms+live_support
EH_frame1:
	.set L$set$0,LECIE1-LSCIE1
	.long L$set$0
LSCIE1:
	.long	0
	.byte	0x3
	.ascii "zR\0"
	.uleb128 0x1
	.sleb128 -8
	.uleb128 0x1e
	.uleb128 0x1
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
	.quad	LFB2-.
	.set L$set$2,LFE2-LFB2
	.quad L$set$2
	.uleb128 0
	.byte	0x4
	.set L$set$3,LCFI0-LFB2
	.long L$set$3
	.byte	0xe
	.uleb128 0x10
	.byte	0x4
	.set L$set$4,LCFI1-LCFI0
	.long L$set$4
	.byte	0xe
	.uleb128 0
	.align	3
LEFDE1:
LSFDE3:
	.set L$set$5,LEFDE3-LASFDE3
	.long L$set$5
LASFDE3:
	.long	LASFDE3-EH_frame1
	.quad	LFB3-.
	.set L$set$6,LFE3-LFB3
	.quad L$set$6
	.uleb128 0
	.byte	0x4
	.set L$set$7,LCFI2-LFB3
	.long L$set$7
	.byte	0xe
	.uleb128 0x10
	.byte	0x4
	.set L$set$8,LCFI3-LCFI2
	.long L$set$8
	.byte	0xe
	.uleb128 0
	.align	3
LEFDE3:
LSFDE5:
	.set L$set$9,LEFDE5-LASFDE5
	.long L$set$9
LASFDE5:
	.long	LASFDE5-EH_frame1
	.quad	LFB4-.
	.set L$set$10,LFE4-LFB4
	.quad L$set$10
	.uleb128 0
	.byte	0x4
	.set L$set$11,LCFI4-LFB4
	.long L$set$11
	.byte	0xe
	.uleb128 0x10
	.byte	0x4
	.set L$set$12,LCFI5-LCFI4
	.long L$set$12
	.byte	0xe
	.uleb128 0
	.align	3
LEFDE5:
LSFDE7:
	.set L$set$13,LEFDE7-LASFDE7
	.long L$set$13
LASFDE7:
	.long	LASFDE7-EH_frame1
	.quad	LFB5-.
	.set L$set$14,LFE5-LFB5
	.quad L$set$14
	.uleb128 0
	.byte	0x4
	.set L$set$15,LCFI6-LFB5
	.long L$set$15
	.byte	0xe
	.uleb128 0x10
	.byte	0x4
	.set L$set$16,LCFI7-LCFI6
	.long L$set$16
	.byte	0xe
	.uleb128 0
	.align	3
LEFDE7:
LSFDE9:
	.set L$set$17,LEFDE9-LASFDE9
	.long L$set$17
LASFDE9:
	.long	LASFDE9-EH_frame1
	.quad	LFB6-.
	.set L$set$18,LFE6-LFB6
	.quad L$set$18
	.uleb128 0
	.byte	0x4
	.set L$set$19,LCFI8-LFB6
	.long L$set$19
	.byte	0xe
	.uleb128 0x10
	.byte	0x4
	.set L$set$20,LCFI9-LCFI8
	.long L$set$20
	.byte	0xe
	.uleb128 0
	.align	3
LEFDE9:
LSFDE11:
	.set L$set$21,LEFDE11-LASFDE11
	.long L$set$21
LASFDE11:
	.long	LASFDE11-EH_frame1
	.quad	LFB7-.
	.set L$set$22,LFE7-LFB7
	.quad L$set$22
	.uleb128 0
	.byte	0x4
	.set L$set$23,LCFI10-LFB7
	.long L$set$23
	.byte	0xe
	.uleb128 0x40
	.byte	0x9d
	.uleb128 0x8
	.byte	0x9e
	.uleb128 0x7
	.byte	0x4
	.set L$set$24,LCFI11-LCFI10
	.long L$set$24
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$25,LCFI12-LCFI11
	.long L$set$25
	.byte	0x94
	.uleb128 0x6
	.byte	0x95
	.uleb128 0x5
	.byte	0x4
	.set L$set$26,LCFI13-LCFI12
	.long L$set$26
	.byte	0xde
	.byte	0xdd
	.byte	0xd4
	.byte	0xd5
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE11:
LSFDE13:
	.set L$set$27,LEFDE13-LASFDE13
	.long L$set$27
LASFDE13:
	.long	LASFDE13-EH_frame1
	.quad	LFB8-.
	.set L$set$28,LFE8-LFB8
	.quad L$set$28
	.uleb128 0
	.byte	0x4
	.set L$set$29,LCFI14-LFB8
	.long L$set$29
	.byte	0xe
	.uleb128 0x50
	.byte	0x9d
	.uleb128 0xa
	.byte	0x9e
	.uleb128 0x9
	.byte	0x4
	.set L$set$30,LCFI15-LCFI14
	.long L$set$30
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$31,LCFI16-LCFI15
	.long L$set$31
	.byte	0x94
	.uleb128 0x8
	.byte	0x95
	.uleb128 0x7
	.byte	0x96
	.uleb128 0x6
	.byte	0x97
	.uleb128 0x5
	.byte	0x4
	.set L$set$32,LCFI17-LCFI16
	.long L$set$32
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
	.set L$set$33,LEFDE15-LASFDE15
	.long L$set$33
LASFDE15:
	.long	LASFDE15-EH_frame1
	.quad	LFB9-.
	.set L$set$34,LFE9-LFB9
	.quad L$set$34
	.uleb128 0
	.byte	0x4
	.set L$set$35,LCFI18-LFB9
	.long L$set$35
	.byte	0xe
	.uleb128 0x70
	.byte	0x9d
	.uleb128 0xe
	.byte	0x9e
	.uleb128 0xd
	.byte	0x4
	.set L$set$36,LCFI19-LCFI18
	.long L$set$36
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$37,LCFI20-LCFI19
	.long L$set$37
	.byte	0x94
	.uleb128 0xc
	.byte	0x95
	.uleb128 0xb
	.byte	0x96
	.uleb128 0xa
	.byte	0x97
	.uleb128 0x9
	.byte	0x98
	.uleb128 0x8
	.byte	0x99
	.uleb128 0x7
	.byte	0x9a
	.uleb128 0x6
	.byte	0x9b
	.uleb128 0x5
	.byte	0x4
	.set L$set$38,LCFI21-LCFI20
	.long L$set$38
	.byte	0xde
	.byte	0xdd
	.byte	0xda
	.byte	0xdb
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
LEFDE15:
LSFDE17:
	.set L$set$39,LEFDE17-LASFDE17
	.long L$set$39
LASFDE17:
	.long	LASFDE17-EH_frame1
	.quad	LFB10-.
	.set L$set$40,LFE10-LFB10
	.quad L$set$40
	.uleb128 0
	.byte	0x4
	.set L$set$41,LCFI22-LFB10
	.long L$set$41
	.byte	0xe
	.uleb128 0x60
	.byte	0x9d
	.uleb128 0xc
	.byte	0x9e
	.uleb128 0xb
	.byte	0x4
	.set L$set$42,LCFI23-LCFI22
	.long L$set$42
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$43,LCFI24-LCFI23
	.long L$set$43
	.byte	0x94
	.uleb128 0xa
	.byte	0x95
	.uleb128 0x9
	.byte	0x96
	.uleb128 0x8
	.byte	0x97
	.uleb128 0x7
	.byte	0x98
	.uleb128 0x6
	.byte	0x99
	.uleb128 0x5
	.byte	0x4
	.set L$set$44,LCFI25-LCFI24
	.long L$set$44
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
LEFDE17:
LSFDE19:
	.set L$set$45,LEFDE19-LASFDE19
	.long L$set$45
LASFDE19:
	.long	LASFDE19-EH_frame1
	.quad	LFB11-.
	.set L$set$46,LFE11-LFB11
	.quad L$set$46
	.uleb128 0
	.byte	0x4
	.set L$set$47,LCFI26-LFB11
	.long L$set$47
	.byte	0xe
	.uleb128 0x30
	.byte	0x9d
	.uleb128 0x6
	.byte	0x9e
	.uleb128 0x5
	.byte	0x4
	.set L$set$48,LCFI27-LCFI26
	.long L$set$48
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$49,LCFI28-LCFI27
	.long L$set$49
	.byte	0x94
	.uleb128 0x4
	.byte	0x95
	.uleb128 0x3
	.byte	0x4
	.set L$set$50,LCFI29-LCFI28
	.long L$set$50
	.byte	0xde
	.byte	0xdd
	.byte	0xd4
	.byte	0xd5
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE19:
LSFDE21:
	.set L$set$51,LEFDE21-LASFDE21
	.long L$set$51
LASFDE21:
	.long	LASFDE21-EH_frame1
	.quad	LFB12-.
	.set L$set$52,LFE12-LFB12
	.quad L$set$52
	.uleb128 0
	.byte	0x4
	.set L$set$53,LCFI30-LFB12
	.long L$set$53
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$54,LCFI31-LCFI30
	.long L$set$54
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$55,LCFI32-LCFI31
	.long L$set$55
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE21:
LSFDE23:
	.set L$set$56,LEFDE23-LASFDE23
	.long L$set$56
LASFDE23:
	.long	LASFDE23-EH_frame1
	.quad	LFB13-.
	.set L$set$57,LFE13-LFB13
	.quad L$set$57
	.uleb128 0
	.byte	0x4
	.set L$set$58,LCFI33-LFB13
	.long L$set$58
	.byte	0xe
	.uleb128 0x30
	.byte	0x9d
	.uleb128 0x6
	.byte	0x9e
	.uleb128 0x5
	.byte	0x4
	.set L$set$59,LCFI34-LCFI33
	.long L$set$59
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$60,LCFI35-LCFI34
	.long L$set$60
	.byte	0x94
	.uleb128 0x4
	.byte	0x95
	.uleb128 0x3
	.byte	0x4
	.set L$set$61,LCFI36-LCFI35
	.long L$set$61
	.byte	0xde
	.byte	0xdd
	.byte	0xd4
	.byte	0xd5
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE23:
LSFDE25:
	.set L$set$62,LEFDE25-LASFDE25
	.long L$set$62
LASFDE25:
	.long	LASFDE25-EH_frame1
	.quad	LFB14-.
	.set L$set$63,LFE14-LFB14
	.quad L$set$63
	.uleb128 0
	.byte	0x4
	.set L$set$64,LCFI37-LFB14
	.long L$set$64
	.byte	0xe
	.uleb128 0x30
	.byte	0x9d
	.uleb128 0x6
	.byte	0x9e
	.uleb128 0x5
	.byte	0x4
	.set L$set$65,LCFI38-LCFI37
	.long L$set$65
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$66,LCFI39-LCFI38
	.long L$set$66
	.byte	0x94
	.uleb128 0x4
	.byte	0x95
	.uleb128 0x3
	.byte	0x4
	.set L$set$67,LCFI40-LCFI39
	.long L$set$67
	.byte	0xde
	.byte	0xdd
	.byte	0xd4
	.byte	0xd5
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE25:
LSFDE27:
	.set L$set$68,LEFDE27-LASFDE27
	.long L$set$68
LASFDE27:
	.long	LASFDE27-EH_frame1
	.quad	LFB15-.
	.set L$set$69,LFE15-LFB15
	.quad L$set$69
	.uleb128 0
	.byte	0x4
	.set L$set$70,LCFI41-LFB15
	.long L$set$70
	.byte	0xe
	.uleb128 0x30
	.byte	0x9d
	.uleb128 0x6
	.byte	0x9e
	.uleb128 0x5
	.byte	0x4
	.set L$set$71,LCFI42-LCFI41
	.long L$set$71
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$72,LCFI43-LCFI42
	.long L$set$72
	.byte	0x94
	.uleb128 0x4
	.byte	0x95
	.uleb128 0x3
	.byte	0x4
	.set L$set$73,LCFI44-LCFI43
	.long L$set$73
	.byte	0xde
	.byte	0xdd
	.byte	0xd4
	.byte	0xd5
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE27:
LSFDE29:
	.set L$set$74,LEFDE29-LASFDE29
	.long L$set$74
LASFDE29:
	.long	LASFDE29-EH_frame1
	.quad	LFB16-.
	.set L$set$75,LFE16-LFB16
	.quad L$set$75
	.uleb128 0
	.byte	0x4
	.set L$set$76,LCFI45-LFB16
	.long L$set$76
	.byte	0xe
	.uleb128 0x30
	.byte	0x9d
	.uleb128 0x6
	.byte	0x9e
	.uleb128 0x5
	.byte	0x4
	.set L$set$77,LCFI46-LCFI45
	.long L$set$77
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$78,LCFI47-LCFI46
	.long L$set$78
	.byte	0x94
	.uleb128 0x4
	.byte	0x95
	.uleb128 0x3
	.byte	0x4
	.set L$set$79,LCFI48-LCFI47
	.long L$set$79
	.byte	0xde
	.byte	0xdd
	.byte	0xd4
	.byte	0xd5
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE29:
LSFDE31:
	.set L$set$80,LEFDE31-LASFDE31
	.long L$set$80
LASFDE31:
	.long	LASFDE31-EH_frame1
	.quad	LFB18-.
	.set L$set$81,LFE18-LFB18
	.quad L$set$81
	.uleb128 0
	.byte	0x4
	.set L$set$82,LCFI49-LFB18
	.long L$set$82
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$83,LCFI50-LCFI49
	.long L$set$83
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$84,LCFI51-LCFI50
	.long L$set$84
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE31:
LSFDE33:
	.set L$set$85,LEFDE33-LASFDE33
	.long L$set$85
LASFDE33:
	.long	LASFDE33-EH_frame1
	.quad	LFB17-.
	.set L$set$86,LFE17-LFB17
	.quad L$set$86
	.uleb128 0
	.byte	0x4
	.set L$set$87,LCFI52-LFB17
	.long L$set$87
	.byte	0xe
	.uleb128 0x90
	.byte	0x9d
	.uleb128 0x12
	.byte	0x9e
	.uleb128 0x11
	.byte	0x4
	.set L$set$88,LCFI53-LCFI52
	.long L$set$88
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$89,LCFI54-LCFI53
	.long L$set$89
	.byte	0x93
	.uleb128 0x10
	.byte	0x94
	.uleb128 0xf
	.byte	0x95
	.uleb128 0xe
	.byte	0x96
	.uleb128 0xd
	.byte	0x97
	.uleb128 0xc
	.byte	0x98
	.uleb128 0xb
	.byte	0x99
	.uleb128 0xa
	.byte	0x9a
	.uleb128 0x9
	.byte	0x9b
	.uleb128 0x8
	.byte	0x4
	.set L$set$90,LCFI55-LCFI54
	.long L$set$90
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
LEFDE33:
LSFDE35:
	.set L$set$91,LEFDE35-LASFDE35
	.long L$set$91
LASFDE35:
	.long	LASFDE35-EH_frame1
	.quad	LFB20-.
	.set L$set$92,LFE20-LFB20
	.quad L$set$92
	.uleb128 0
	.byte	0x4
	.set L$set$93,LCFI56-LFB20
	.long L$set$93
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$94,LCFI57-LCFI56
	.long L$set$94
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$95,LCFI58-LCFI57
	.long L$set$95
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE35:
LSFDE37:
	.set L$set$96,LEFDE37-LASFDE37
	.long L$set$96
LASFDE37:
	.long	LASFDE37-EH_frame1
	.quad	LFB19-.
	.set L$set$97,LFE19-LFB19
	.quad L$set$97
	.uleb128 0
	.byte	0x4
	.set L$set$98,LCFI59-LFB19
	.long L$set$98
	.byte	0xe
	.uleb128 0x90
	.byte	0x9d
	.uleb128 0x12
	.byte	0x9e
	.uleb128 0x11
	.byte	0x4
	.set L$set$99,LCFI60-LCFI59
	.long L$set$99
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$100,LCFI61-LCFI60
	.long L$set$100
	.byte	0x93
	.uleb128 0x10
	.byte	0x94
	.uleb128 0xf
	.byte	0x95
	.uleb128 0xe
	.byte	0x96
	.uleb128 0xd
	.byte	0x97
	.uleb128 0xc
	.byte	0x98
	.uleb128 0xb
	.byte	0x99
	.uleb128 0xa
	.byte	0x9a
	.uleb128 0x9
	.byte	0x9b
	.uleb128 0x8
	.byte	0x4
	.set L$set$101,LCFI62-LCFI61
	.long L$set$101
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
	.set L$set$102,LEFDE39-LASFDE39
	.long L$set$102
LASFDE39:
	.long	LASFDE39-EH_frame1
	.quad	LFB22-.
	.set L$set$103,LFE22-LFB22
	.quad L$set$103
	.uleb128 0
	.byte	0x4
	.set L$set$104,LCFI63-LFB22
	.long L$set$104
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$105,LCFI64-LCFI63
	.long L$set$105
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$106,LCFI65-LCFI64
	.long L$set$106
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE39:
LSFDE41:
	.set L$set$107,LEFDE41-LASFDE41
	.long L$set$107
LASFDE41:
	.long	LASFDE41-EH_frame1
	.quad	LFB21-.
	.set L$set$108,LFE21-LFB21
	.quad L$set$108
	.uleb128 0
	.byte	0x4
	.set L$set$109,LCFI66-LFB21
	.long L$set$109
	.byte	0xe
	.uleb128 0x60
	.byte	0x9d
	.uleb128 0xc
	.byte	0x9e
	.uleb128 0xb
	.byte	0x4
	.set L$set$110,LCFI67-LCFI66
	.long L$set$110
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$111,LCFI68-LCFI67
	.long L$set$111
	.byte	0x94
	.uleb128 0xa
	.byte	0x95
	.uleb128 0x9
	.byte	0x96
	.uleb128 0x8
	.byte	0x97
	.uleb128 0x7
	.byte	0x4
	.set L$set$112,LCFI69-LCFI68
	.long L$set$112
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
LEFDE41:
LSFDE43:
	.set L$set$113,LEFDE43-LASFDE43
	.long L$set$113
LASFDE43:
	.long	LASFDE43-EH_frame1
	.quad	LFB23-.
	.set L$set$114,LFE23-LFB23
	.quad L$set$114
	.uleb128 0
	.byte	0x4
	.set L$set$115,LCFI70-LFB23
	.long L$set$115
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$116,LCFI71-LCFI70
	.long L$set$116
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$117,LCFI72-LCFI71
	.long L$set$117
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE43:
LSFDE45:
	.set L$set$118,LEFDE45-LASFDE45
	.long L$set$118
LASFDE45:
	.long	LASFDE45-EH_frame1
	.quad	LFB24-.
	.set L$set$119,LFE24-LFB24
	.quad L$set$119
	.uleb128 0
	.byte	0x4
	.set L$set$120,LCFI73-LFB24
	.long L$set$120
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$121,LCFI74-LCFI73
	.long L$set$121
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$122,LCFI75-LCFI74
	.long L$set$122
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE45:
LSFDE47:
	.set L$set$123,LEFDE47-LASFDE47
	.long L$set$123
LASFDE47:
	.long	LASFDE47-EH_frame1
	.quad	LFB25-.
	.set L$set$124,LFE25-LFB25
	.quad L$set$124
	.uleb128 0
	.byte	0x4
	.set L$set$125,LCFI76-LFB25
	.long L$set$125
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$126,LCFI77-LCFI76
	.long L$set$126
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$127,LCFI78-LCFI77
	.long L$set$127
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE47:
LSFDE49:
	.set L$set$128,LEFDE49-LASFDE49
	.long L$set$128
LASFDE49:
	.long	LASFDE49-EH_frame1
	.quad	LFB26-.
	.set L$set$129,LFE26-LFB26
	.quad L$set$129
	.uleb128 0
	.byte	0x4
	.set L$set$130,LCFI79-LFB26
	.long L$set$130
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$131,LCFI80-LCFI79
	.long L$set$131
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$132,LCFI81-LCFI80
	.long L$set$132
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE49:
LSFDE51:
	.set L$set$133,LEFDE51-LASFDE51
	.long L$set$133
LASFDE51:
	.long	LASFDE51-EH_frame1
	.quad	LFB27-.
	.set L$set$134,LFE27-LFB27
	.quad L$set$134
	.uleb128 0
	.byte	0x4
	.set L$set$135,LCFI82-LFB27
	.long L$set$135
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$136,LCFI83-LCFI82
	.long L$set$136
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$137,LCFI84-LCFI83
	.long L$set$137
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE51:
LSFDE53:
	.set L$set$138,LEFDE53-LASFDE53
	.long L$set$138
LASFDE53:
	.long	LASFDE53-EH_frame1
	.quad	LFB28-.
	.set L$set$139,LFE28-LFB28
	.quad L$set$139
	.uleb128 0
	.byte	0x4
	.set L$set$140,LCFI85-LFB28
	.long L$set$140
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$141,LCFI86-LCFI85
	.long L$set$141
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$142,LCFI87-LCFI86
	.long L$set$142
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE53:
LSFDE55:
	.set L$set$143,LEFDE55-LASFDE55
	.long L$set$143
LASFDE55:
	.long	LASFDE55-EH_frame1
	.quad	LFB29-.
	.set L$set$144,LFE29-LFB29
	.quad L$set$144
	.uleb128 0
	.byte	0x4
	.set L$set$145,LCFI88-LFB29
	.long L$set$145
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$146,LCFI89-LCFI88
	.long L$set$146
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$147,LCFI90-LCFI89
	.long L$set$147
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE55:
LSFDE57:
	.set L$set$148,LEFDE57-LASFDE57
	.long L$set$148
LASFDE57:
	.long	LASFDE57-EH_frame1
	.quad	LFB30-.
	.set L$set$149,LFE30-LFB30
	.quad L$set$149
	.uleb128 0
	.byte	0x4
	.set L$set$150,LCFI91-LFB30
	.long L$set$150
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$151,LCFI92-LCFI91
	.long L$set$151
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$152,LCFI93-LCFI92
	.long L$set$152
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE57:
LSFDE59:
	.set L$set$153,LEFDE59-LASFDE59
	.long L$set$153
LASFDE59:
	.long	LASFDE59-EH_frame1
	.quad	LFB31-.
	.set L$set$154,LFE31-LFB31
	.quad L$set$154
	.uleb128 0
	.byte	0x4
	.set L$set$155,LCFI94-LFB31
	.long L$set$155
	.byte	0xe
	.uleb128 0x20
	.byte	0x9d
	.uleb128 0x4
	.byte	0x9e
	.uleb128 0x3
	.byte	0x4
	.set L$set$156,LCFI95-LCFI94
	.long L$set$156
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$157,LCFI96-LCFI95
	.long L$set$157
	.byte	0xde
	.byte	0xdd
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE59:
LSFDE61:
	.set L$set$158,LEFDE61-LASFDE61
	.long L$set$158
LASFDE61:
	.long	LASFDE61-EH_frame1
	.quad	LFB33-.
	.set L$set$159,LFE33-LFB33
	.quad L$set$159
	.uleb128 0
	.byte	0x4
	.set L$set$160,LCFI97-LFB33
	.long L$set$160
	.byte	0xe
	.uleb128 0x1030
	.byte	0x4
	.set L$set$161,LCFI98-LCFI97
	.long L$set$161
	.byte	0x9d
	.uleb128 0x206
	.byte	0x9e
	.uleb128 0x205
	.byte	0x4
	.set L$set$162,LCFI99-LCFI98
	.long L$set$162
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$163,LCFI100-LCFI99
	.long L$set$163
	.byte	0x93
	.uleb128 0x204
	.byte	0x94
	.uleb128 0x203
	.byte	0x4
	.set L$set$164,LCFI101-LCFI100
	.long L$set$164
	.byte	0xd3
	.byte	0xd4
	.byte	0xdd
	.byte	0xde
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE61:
LSFDE63:
	.set L$set$165,LEFDE63-LASFDE63
	.long L$set$165
LASFDE63:
	.long	LASFDE63-EH_frame1
	.quad	LFB32-.
	.set L$set$166,LFE32-LFB32
	.quad L$set$166
	.uleb128 0
	.byte	0x4
	.set L$set$167,LCFI102-LFB32
	.long L$set$167
	.byte	0xe
	.uleb128 0x1070
	.byte	0x4
	.set L$set$168,LCFI103-LCFI102
	.long L$set$168
	.byte	0x9d
	.uleb128 0x20e
	.byte	0x9e
	.uleb128 0x20d
	.byte	0x4
	.set L$set$169,LCFI104-LCFI103
	.long L$set$169
	.byte	0xd
	.uleb128 0x1d
	.byte	0x4
	.set L$set$170,LCFI105-LCFI104
	.long L$set$170
	.byte	0x93
	.uleb128 0x20c
	.byte	0x94
	.uleb128 0x20b
	.byte	0x95
	.uleb128 0x20a
	.byte	0x96
	.uleb128 0x209
	.byte	0x97
	.uleb128 0x208
	.byte	0x4
	.set L$set$171,LCFI106-LCFI105
	.long L$set$171
	.byte	0xd7
	.byte	0xd5
	.byte	0xd6
	.byte	0xd3
	.byte	0xd4
	.byte	0xdd
	.byte	0xde
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LEFDE63:
LSFDE65:
	.set L$set$172,LEFDE65-LASFDE65
	.long L$set$172
LASFDE65:
	.long	LASFDE65-EH_frame1
	.quad	LFB34-.
	.set L$set$173,LFE34-LFB34
	.quad L$set$173
	.uleb128 0
	.byte	0x4
	.set L$set$174,LCFI107-LFB34
	.long L$set$174
	.byte	0xe
	.uleb128 0x10
	.byte	0x4
	.set L$set$175,LCFI108-LCFI107
	.long L$set$175
	.byte	0xe
	.uleb128 0
	.align	3
LEFDE65:
	.ident	"GCC: (GNU) 15.0.1 20250418 (prerelease)"
	.subsections_via_symbols
