CONST SEGMENT
LC$0:
	DD	0
	DD	0
CONST ENDS
_BSS SEGMENT
COMM	NOTREF:QWORD
_BSS ENDS
_BSS SEGMENT
COMM	R8_REG:QWORD
_BSS ENDS
_BSS SEGMENT
COMM	R9_REG:QWORD
_BSS ENDS
_BSS SEGMENT
COMM	RCX_REG:QWORD
_BSS ENDS
_BSS SEGMENT
COMM	RDX_REG:QWORD
_BSS ENDS
_BSS SEGMENT
COMM	RSP_REG:QWORD
_BSS ENDS
_BSS SEGMENT
COMM	XMM0_FLT:DWORD
_BSS ENDS
_BSS SEGMENT
COMM	XMM0_REG:QWORD
_BSS ENDS
_BSS SEGMENT
COMM	XMM1_FLT:DWORD
_BSS ENDS
_BSS SEGMENT
COMM	XMM1_REG:QWORD
_BSS ENDS
_BSS SEGMENT
COMM	XMM2_FLT:DWORD
_BSS ENDS
_BSS SEGMENT
COMM	XMM2_REG:QWORD
_BSS ENDS
_BSS SEGMENT
COMM	XMM3_FLT:DWORD
_BSS ENDS
_BSS SEGMENT
COMM	XMM3_REG:QWORD
_BSS ENDS
_TEXT SEGMENT
call_Us_subr	PROC
	; enter
	push 	rbp
	mov 	rbp, rsp
	; parameter registers are saved
	mov 	QWORD PTR [rbp+16], rcx
	mov 	DWORD PTR [rbp+24], edx
	mov 	DWORD PTR [rbp+32], r8d
	mov 	QWORD PTR [rbp+40], r9

	sub 	rsp, 160
	; t0 := p + 8
	mov 	rax, QWORD PTR [rbp+16]
	mov	ebx, 8
	movsxd	rbx, ebx
	add 	rax, rbx
	mov 	QWORD PTR [rbp-24], rax
	; kind := *t0
	mov 	rax, QWORD PTR [rbp-24]
	mov	eax, [rax]
	mov 	DWORD PTR [rbp-12], eax
	; goto label0
	jmp	call_Us_subr0000016CB0AC8F30$
	; label1:
call_Us_subr0000016CB0A9F980$:
	; label2:
call_Us_subr0000016CB0A9EF00$:
	; label3:
call_Us_subr0000016CB0A9EFC0$:
	; if nth > narg goto label4
	mov 	eax, DWORD PTR [rbp+24]
	cmp	eax, DWORD PTR [rbp+32]
	jg	call_Us_subr0000016CB0A98630$
	; if kind != 3 goto label5
	mov 	eax, DWORD PTR [rbp-12]
	cmp	eax, 3
	jne	call_Us_subr0000016CB0AACCD0$
	; t1 := *p
	mov 	rax, QWORD PTR [rbp+16]
	fld	DWORD PTR [rax]
	fstp 	DWORD PTR [rbp-84]
	; t2 := (double)t1
	movss	xmm0, DWORD PTR [rbp-84]
	cvtss2sd	xmm0, xmm0
	movsd	QWORD PTR [rbp-96], xmm0
	; goto label6
	jmp	call_Us_subr0000016CB0AADD50$
	; label5:
call_Us_subr0000016CB0AACCD0$:
	; t2 := *p
	mov 	rax, QWORD PTR [rbp+16]
	fld	QWORD PTR [rax]
	fstp 	QWORD PTR [rbp-96]
	; label6:
call_Us_subr0000016CB0AADD50$:
	; d := t2
	movsd	xmm0, QWORD PTR [rbp-96]
	movsd	QWORD PTR [rbp-80], xmm0
	; *xmm := t2
	mov 	rcx, QWORD PTR [rbp+48]
	mov 	rax, QWORD PTR [rbp-96]
	mov	[rcx], rax
	; *xmm_flt := 0
	mov 	rcx, QWORD PTR [rbp+56]
	mov	eax, 0
	mov	[rcx], eax
	; if rvp == .pointer15 goto label7
	mov 	rax, QWORD PTR [rbp+40]
	cmp	rax, QWORD PTR LC$0
	je	call_Us_subr0000016CB0AAD750$
	; *gpr2 := d
	mov 	rcx, QWORD PTR [rbp+72]
	mov 	rax, QWORD PTR [rbp-80]
	mov	[rcx], rax
	; goto label8
	jmp	call_Us_subr0000016CB0AAC0D0$
	; label7:
call_Us_subr0000016CB0AAD750$:
	; *gpr1 := d
	mov 	rcx, QWORD PTR [rbp+64]
	mov 	rax, QWORD PTR [rbp-80]
	mov	[rcx], rax
	; label8:
call_Us_subr0000016CB0AAC0D0$:
	; goto label9
	jmp	call_Us_subr0000016CB0AAD450$
	; label4:
call_Us_subr0000016CB0A98630$:
	; if kind != 3 goto label10
	mov 	eax, DWORD PTR [rbp-12]
	cmp	eax, 3
	jne	call_Us_subr0000016CB0AAD390$
	; t3 := *p
	mov 	rax, QWORD PTR [rbp+16]
	fld	DWORD PTR [rax]
	fstp 	DWORD PTR [rbp-100]
	; *xmm := t3
	mov 	rcx, QWORD PTR [rbp+48]
	mov 	eax, DWORD PTR [rbp-100]
	mov	[rcx], eax
	; *xmm_flt := 1
	mov 	rcx, QWORD PTR [rbp+56]
	mov	eax, 1
	mov	[rcx], eax
	; goto label11
	jmp	call_Us_subr0000016CB0AAC010$
	; label10:
call_Us_subr0000016CB0AAD390$:
	; t4 := *p
	mov 	rax, QWORD PTR [rbp+16]
	fld	QWORD PTR [rax]
	fstp 	QWORD PTR [rbp-112]
	; *xmm := t4
	mov 	rcx, QWORD PTR [rbp+48]
	mov 	rax, QWORD PTR [rbp-112]
	mov	[rcx], rax
	; *xmm_flt := 0
	mov 	rcx, QWORD PTR [rbp+56]
	mov	eax, 0
	mov	[rcx], eax
	; label11:
call_Us_subr0000016CB0AAC010$:
	; label9:
call_Us_subr0000016CB0AAD450$:
	; goto label12
	jmp	call_Us_subr0000016CB0AC90B0$
	; label13:
call_Us_subr0000016CB0AACD90$:
	; label14:
call_Us_subr0000016CB0AAD150$:
	; if rvp == .pointer15 goto label15
	mov 	rax, QWORD PTR [rbp+40]
	cmp	rax, QWORD PTR LC$0
	je	call_Us_subr0000016CB0AADA50$
	; t5 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov	rax, [rax]
	mov 	QWORD PTR [rbp-32], rax
	; *gpr2 := t5
	mov 	rcx, QWORD PTR [rbp+72]
	mov 	rax, QWORD PTR [rbp-32]
	mov	[rcx], rax
	; goto label16
	jmp	call_Us_subr0000016CB0AAC190$
	; label15:
call_Us_subr0000016CB0AADA50$:
	; t6 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov	rax, [rax]
	mov 	QWORD PTR [rbp-40], rax
	; *gpr1 := t6
	mov 	rcx, QWORD PTR [rbp+64]
	mov 	rax, QWORD PTR [rbp-40]
	mov	[rcx], rax
	; label16:
call_Us_subr0000016CB0AAC190$:
	; goto label12
	jmp	call_Us_subr0000016CB0AC90B0$
	; label17:
call_Us_subr0000016CB0AAD210$:
	; label18:
call_Us_subr0000016CB0AACFD0$:
	; if rvp == .pointer15 goto label19
	mov 	rax, QWORD PTR [rbp+40]
	cmp	rax, QWORD PTR LC$0
	je	call_Us_subr0000016CB0AACE50$
	; t7 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov	eax, [rax]
	mov 	DWORD PTR [rbp-44], eax
	; *gpr2 := t7
	mov 	rcx, QWORD PTR [rbp+72]
	mov 	eax, DWORD PTR [rbp-44]
	mov	[rcx], eax
	; goto label20
	jmp	call_Us_subr0000016CB0AABF50$
	; label19:
call_Us_subr0000016CB0AACE50$:
	; t8 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov	eax, [rax]
	mov 	DWORD PTR [rbp-48], eax
	; *gpr1 := t8
	mov 	rcx, QWORD PTR [rbp+64]
	mov 	eax, DWORD PTR [rbp-48]
	mov	[rcx], eax
	; label20:
call_Us_subr0000016CB0AABF50$:
	; goto label12
	jmp	call_Us_subr0000016CB0AC90B0$
	; label21:
call_Us_subr0000016CB0AAD8D0$:
	; if rvp == .pointer15 goto label22
	mov 	rax, QWORD PTR [rbp+40]
	cmp	rax, QWORD PTR LC$0
	je	call_Us_subr0000016CB0AAD5D0$
	; t9 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov	ax, [rax]
	mov 	WORD PTR [rbp-50], ax
	; *gpr2 := t9
	mov 	rcx, QWORD PTR [rbp+72]
	mov 	ax, WORD PTR [rbp-50]
	mov	[rcx], ax
	; goto label23
	jmp	call_Us_subr0000016CB0AADB10$
	; label22:
call_Us_subr0000016CB0AAD5D0$:
	; t10 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov	ax, [rax]
	mov 	WORD PTR [rbp-52], ax
	; *gpr1 := t10
	mov 	rcx, QWORD PTR [rbp+64]
	mov 	ax, WORD PTR [rbp-52]
	mov	[rcx], ax
	; label23:
call_Us_subr0000016CB0AADB10$:
	; goto label12
	jmp	call_Us_subr0000016CB0AC90B0$
	; label24:
call_Us_subr0000016CB0AAC3D0$:
	; if nth > narg goto label25
	mov 	eax, DWORD PTR [rbp+24]
	cmp	eax, DWORD PTR [rbp+32]
	jg	call_Us_subr0000016CB0AAC610$
	; if rvp == .pointer15 goto label26
	mov 	rax, QWORD PTR [rbp+40]
	cmp	rax, QWORD PTR LC$0
	je	call_Us_subr0000016CB0AAD990$
	; t11 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov	ax, [rax]
	mov 	WORD PTR [rbp-114], ax
	; t12 := (int)t11
	mov 	ax, WORD PTR [rbp-114]
	movsx	eax, ax
	mov 	DWORD PTR [rbp-120], eax
	; *gpr2 := t12
	mov 	rcx, QWORD PTR [rbp+72]
	mov 	eax, DWORD PTR [rbp-120]
	mov	[rcx], eax
	; goto label27
	jmp	call_Us_subr0000016CB0AAC490$
	; label26:
call_Us_subr0000016CB0AAD990$:
	; t13 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov	ax, [rax]
	mov 	WORD PTR [rbp-122], ax
	; t14 := (int)t13
	mov 	ax, WORD PTR [rbp-122]
	movsx	eax, ax
	mov 	DWORD PTR [rbp-128], eax
	; *gpr1 := t14
	mov 	rcx, QWORD PTR [rbp+64]
	mov 	eax, DWORD PTR [rbp-128]
	mov	[rcx], eax
	; label27:
call_Us_subr0000016CB0AAC490$:
	; goto label28
	jmp	call_Us_subr0000016CB0AAD510$
	; label25:
call_Us_subr0000016CB0AAC610$:
	; if rvp == .pointer15 goto label29
	mov 	rax, QWORD PTR [rbp+40]
	cmp	rax, QWORD PTR LC$0
	je	call_Us_subr0000016CB0AACF10$
	; t15 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov	ax, [rax]
	mov 	WORD PTR [rbp-130], ax
	; *gpr2 := t15
	mov 	rcx, QWORD PTR [rbp+72]
	mov 	ax, WORD PTR [rbp-130]
	mov	[rcx], ax
	; goto label30
	jmp	call_Us_subr0000016CB0AAC550$
	; label29:
call_Us_subr0000016CB0AACF10$:
	; t16 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov	ax, [rax]
	mov 	WORD PTR [rbp-132], ax
	; *gpr1 := t16
	mov 	rcx, QWORD PTR [rbp+64]
	mov 	ax, WORD PTR [rbp-132]
	mov	[rcx], ax
	; label30:
call_Us_subr0000016CB0AAC550$:
	; label28:
call_Us_subr0000016CB0AAD510$:
	; goto label12
	jmp	call_Us_subr0000016CB0AC90B0$
	; label31:
call_Us_subr0000016CB0AACB50$:
	; if rvp == .pointer15 goto label32
	mov 	rax, QWORD PTR [rbp+40]
	cmp	rax, QWORD PTR LC$0
	je	call_Us_subr0000016CB0AAC6D0$
	; t17 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov	al, [rax]
	mov 	BYTE PTR [rbp-53], al
	; *gpr2 := t17
	mov 	rcx, QWORD PTR [rbp+72]
	mov 	al, BYTE PTR [rbp-53]
	mov	[rcx], al
	; goto label33
	jmp	call_Us_subr0000016CB0AAC790$
	; label32:
call_Us_subr0000016CB0AAC6D0$:
	; t18 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov	al, [rax]
	mov 	BYTE PTR [rbp-54], al
	; *gpr1 := t18
	mov 	rcx, QWORD PTR [rbp+64]
	mov 	al, BYTE PTR [rbp-54]
	mov	[rcx], al
	; label33:
call_Us_subr0000016CB0AAC790$:
	; goto label12
	jmp	call_Us_subr0000016CB0AC90B0$
	; label34:
call_Us_subr0000016CB0AADE10$:
	; if nth > narg goto label35
	mov 	eax, DWORD PTR [rbp+24]
	cmp	eax, DWORD PTR [rbp+32]
	jg	call_Us_subr0000016CB0AAD090$
	; if rvp == .pointer15 goto label36
	mov 	rax, QWORD PTR [rbp+40]
	cmp	rax, QWORD PTR LC$0
	je	call_Us_subr0000016CB0AAD810$
	; t19 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov	al, [rax]
	mov 	BYTE PTR [rbp-133], al
	; t20 := (int)t19
	mov 	al, BYTE PTR [rbp-133]
	movsx	eax, al
	mov 	DWORD PTR [rbp-140], eax
	; *gpr2 := t20
	mov 	rcx, QWORD PTR [rbp+72]
	mov 	eax, DWORD PTR [rbp-140]
	mov	[rcx], eax
	; goto label37
	jmp	call_Us_subr0000016CB0AADBD0$
	; label36:
call_Us_subr0000016CB0AAD810$:
	; t21 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov	al, [rax]
	mov 	BYTE PTR [rbp-141], al
	; t22 := (int)t21
	mov 	al, BYTE PTR [rbp-141]
	movsx	eax, al
	mov 	DWORD PTR [rbp-148], eax
	; *gpr1 := t22
	mov 	rcx, QWORD PTR [rbp+64]
	mov 	eax, DWORD PTR [rbp-148]
	mov	[rcx], eax
	; label37:
call_Us_subr0000016CB0AADBD0$:
	; goto label38
	jmp	call_Us_subr0000016CB0AADC90$
	; label35:
call_Us_subr0000016CB0AAD090$:
	; if rvp == .pointer15 goto label39
	mov 	rax, QWORD PTR [rbp+40]
	cmp	rax, QWORD PTR LC$0
	je	call_Us_subr0000016CB0AAC850$
	; t23 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov	al, [rax]
	mov 	BYTE PTR [rbp-149], al
	; *gpr2 := t23
	mov 	rcx, QWORD PTR [rbp+72]
	mov 	al, BYTE PTR [rbp-149]
	mov	[rcx], al
	; goto label40
	jmp	call_Us_subr0000016CB0AAC910$
	; label39:
call_Us_subr0000016CB0AAC850$:
	; t24 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov	al, [rax]
	mov 	BYTE PTR [rbp-150], al
	; *gpr1 := t24
	mov 	rcx, QWORD PTR [rbp+64]
	mov 	al, BYTE PTR [rbp-150]
	mov	[rcx], al
	; label40:
call_Us_subr0000016CB0AAC910$:
	; label38:
call_Us_subr0000016CB0AADC90$:
	; goto label12
	jmp	call_Us_subr0000016CB0AC90B0$
	; label41:
call_Us_subr0000016CB0AAD690$:
	; label42:
call_Us_subr0000016CB0AAC9D0$:
	; if rvp == .pointer15 goto label43
	mov 	rax, QWORD PTR [rbp+40]
	cmp	rax, QWORD PTR LC$0
	je	call_Us_subr0000016CB0AAD2D0$
	; t25 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov	rax, [rax]
	mov 	QWORD PTR [rbp-64], rax
	; *gpr2 := t25
	mov 	rcx, QWORD PTR [rbp+72]
	mov 	rax, QWORD PTR [rbp-64]
	mov	[rcx], rax
	; goto label44
	jmp	call_Us_subr0000016CB0AC9770$
	; label43:
call_Us_subr0000016CB0AAD2D0$:
	; t26 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov	rax, [rax]
	mov 	QWORD PTR [rbp-72], rax
	; *gpr1 := t26
	mov 	rcx, QWORD PTR [rbp+64]
	mov 	rax, QWORD PTR [rbp-72]
	mov	[rcx], rax
	; label44:
call_Us_subr0000016CB0AC9770$:
	; goto label12
	jmp	call_Us_subr0000016CB0AC90B0$
	; goto label12
	jmp	call_Us_subr0000016CB0AC90B0$
	; label0:
call_Us_subr0000016CB0AC8F30$:
	; if kind == 1 goto label1
	mov 	eax, DWORD PTR [rbp-12]
	cmp	eax, 1
	je	call_Us_subr0000016CB0A9F980$
	; if kind == 2 goto label2
	mov 	eax, DWORD PTR [rbp-12]
	cmp	eax, 2
	je	call_Us_subr0000016CB0A9EF00$
	; if kind == 3 goto label3
	mov 	eax, DWORD PTR [rbp-12]
	cmp	eax, 3
	je	call_Us_subr0000016CB0A9EFC0$
	; if kind == 4 goto label13
	mov 	eax, DWORD PTR [rbp-12]
	cmp	eax, 4
	je	call_Us_subr0000016CB0AACD90$
	; if kind == 5 goto label14
	mov 	eax, DWORD PTR [rbp-12]
	cmp	eax, 5
	je	call_Us_subr0000016CB0AAD150$
	; if kind == 6 goto label17
	mov 	eax, DWORD PTR [rbp-12]
	cmp	eax, 6
	je	call_Us_subr0000016CB0AAD210$
	; if kind == 7 goto label18
	mov 	eax, DWORD PTR [rbp-12]
	cmp	eax, 7
	je	call_Us_subr0000016CB0AACFD0$
	; if kind == 8 goto label21
	mov 	eax, DWORD PTR [rbp-12]
	cmp	eax, 8
	je	call_Us_subr0000016CB0AAD8D0$
	; if kind == 9 goto label24
	mov 	eax, DWORD PTR [rbp-12]
	cmp	eax, 9
	je	call_Us_subr0000016CB0AAC3D0$
	; if kind == 10 goto label31
	mov 	eax, DWORD PTR [rbp-12]
	cmp	eax, 10
	je	call_Us_subr0000016CB0AACB50$
	; if kind == 11 goto label34
	mov 	eax, DWORD PTR [rbp-12]
	cmp	eax, 11
	je	call_Us_subr0000016CB0AADE10$
	; if kind == 12 goto label41
	mov 	eax, DWORD PTR [rbp-12]
	cmp	eax, 12
	je	call_Us_subr0000016CB0AAD690$
	; if kind == 13 goto label42
	mov 	eax, DWORD PTR [rbp-12]
	cmp	eax, 13
	je	call_Us_subr0000016CB0AAC9D0$
	; label12:
call_Us_subr0000016CB0AC90B0$:
	; leave
	mov 	rsp, rbp
	leave
	ret
call_Us_subr	ENDP
_TEXT ENDS
_TEXT SEGMENT
	PUBLIC	call_Us
call_Us	PROC
	; enter
	push 	rbp
	mov 	rbp, rsp
	; parameter registers are saved
	mov 	QWORD PTR [rbp+16], rcx
	mov 	QWORD PTR [rbp+24], rdx
	mov 	QWORD PTR [rbp+32], r8
	mov 	QWORD PTR [rbp+40], r9

	sub 	rsp, 624
	; XMM3_REG[0] := .pointer15
	lea 	rax, 	LC$0
	mov 	rax, QWORD PTR [rax]
	mov	QWORD PTR XMM3_REG, rax
	; XMM2_REG[0] := .pointer15
	lea 	rax, 	LC$0
	mov 	rax, QWORD PTR [rax]
	mov	QWORD PTR XMM2_REG, rax
	; XMM1_REG[0] := .pointer15
	lea 	rax, 	LC$0
	mov 	rax, QWORD PTR [rax]
	mov	QWORD PTR XMM1_REG, rax
	; XMM0_REG[0] := .pointer15
	lea 	rax, 	LC$0
	mov 	rax, QWORD PTR [rax]
	mov	QWORD PTR XMM0_REG, rax
	; R9_REG[0] := .pointer15
	lea 	rax, 	LC$0
	mov 	rax, QWORD PTR [rax]
	mov	QWORD PTR R9_REG, rax
	; R8_REG[0] := .pointer15
	lea 	rax, 	LC$0
	mov 	rax, QWORD PTR [rax]
	mov	QWORD PTR R8_REG, rax
	; RDX_REG[0] := .pointer15
	lea 	rax, 	LC$0
	mov 	rax, QWORD PTR [rax]
	mov	QWORD PTR RDX_REG, rax
	; RCX_REG[0] := .pointer15
	lea 	rax, 	LC$0
	mov 	rax, QWORD PTR [rax]
	mov	QWORD PTR RCX_REG, rax
	; XMM3_FLT := 0
	mov	eax, 0
	mov 	rbx, rax
	lea 	rax, XMM3_FLT
	mov	DWORD PTR [rax], ebx
	; XMM2_FLT := 0
	mov	eax, 0
	mov 	rbx, rax
	lea 	rax, XMM2_FLT
	mov	DWORD PTR [rax], ebx
	; XMM1_FLT := 0
	mov	eax, 0
	mov 	rbx, rax
	lea 	rax, XMM1_FLT
	mov	DWORD PTR [rax], ebx
	; XMM0_FLT := 0
	mov	eax, 0
	mov 	rbx, rax
	lea 	rax, XMM0_FLT
	mov	DWORD PTR [rax], ebx
	; t27 := end - begin
	mov 	rax, QWORD PTR [rbp+40]
	sub 	rax, QWORD PTR [rbp+32]
	mov 	DWORD PTR [rbp-36], eax
	; N := t27 >> 4
	mov 	eax, DWORD PTR [rbp-36]
	sar	eax, 4
	mov 	DWORD PTR [rbp-12], eax
	; t28 := N & .integer16
	mov 	eax, DWORD PTR [rbp-12]
	and 	eax, 1
	mov 	DWORD PTR [rbp-40], eax
	; if t28 == .integer18 goto label45
	mov 	eax, DWORD PTR [rbp-40]
	cmp	eax, 0
	je	call_Us0000016CB0ACA1F0$
	; t29 := N + .integer16
	mov 	eax, DWORD PTR [rbp-12]
	add 	eax, 1
	mov 	DWORD PTR [rbp-44], eax
	; t30 := t29 << 3
	mov 	eax, DWORD PTR [rbp-44]
	sal	eax, 3
	mov 	DWORD PTR [rbp-48], eax
	; goto label46
	jmp	call_Us0000016CB0AC9A70$
	; label45:
call_Us0000016CB0ACA1F0$:
	; t30 := N << 3
	mov 	eax, DWORD PTR [rbp-12]
	sal	eax, 3
	mov 	DWORD PTR [rbp-48], eax
	; label46:
call_Us0000016CB0AC9A70$:
	; rsp := rsp - t30
	mov 	ebx, DWORD PTR [rbp-48]
	movsxd	rbx, ebx
	sub 	rsp, rbx
	; rvp := *r
	mov 	rax, QWORD PTR [rbp+16]
	mov	rax, [rax]
	mov 	QWORD PTR [rbp-32], rax
	; if rvp == .pointer15 goto label47
	mov 	rax, QWORD PTR [rbp-32]
	cmp	rax, QWORD PTR LC$0
	je	call_Us0000016CB0AC9D70$
	; RCX_REG[0] := rvp
	mov 	rax, QWORD PTR [rbp-32]
	mov	QWORD PTR RCX_REG, rax
	; label47:
call_Us0000016CB0AC9D70$:
	; p := begin
	mov 	rax, QWORD PTR [rbp+32]
	mov 	QWORD PTR [rbp-24], rax
	; narg := 0
	mov	eax, 0
	mov 	DWORD PTR [rbp-16], eax
	; if begin != end goto label48
	mov 	rax, QWORD PTR [rbp+32]
	cmp	rax, QWORD PTR [rbp+40]
	jne	call_Us0000016CB0AC84B0$
	; goto label49
	jmp	call_Us0000016CB0C33FD0$
	; label48:
call_Us0000016CB0AC84B0$:
	; t31 := &XMM0_REG
	lea 	rbx, XMM0_REG
	mov 	QWORD PTR [rbp-56], rbx
	; t32 := &XMM0_FLT
	lea 	rbx, XMM0_FLT
	mov 	QWORD PTR [rbp-64], rbx
	; t33 := &RCX_REG
	lea 	rbx, RCX_REG
	mov 	QWORD PTR [rbp-72], rbx
	; t34 := &RDX_REG
	lea 	rbx, RDX_REG
	mov 	QWORD PTR [rbp-80], rbx
	; param p
	mov 	rax, QWORD PTR [rbp-24]
	mov 	rcx, rax
	; param nth
	mov 	eax, DWORD PTR [rbp+48]
	mov 	edx, eax
	; param narg
	mov 	eax, DWORD PTR [rbp-16]
	mov 	r8d, eax
	; param rvp
	mov 	rax, QWORD PTR [rbp-32]
	mov 	r9, rax
	; param t31
	mov 	rax, QWORD PTR [rbp-56]
	mov 	QWORD PTR [rsp+32], rax
	; param t32
	mov 	rax, QWORD PTR [rbp-64]
	mov 	QWORD PTR [rsp+40], rax
	; param t33
	mov 	rax, QWORD PTR [rbp-72]
	mov 	QWORD PTR [rsp+48], rax
	; param t34
	mov 	rax, QWORD PTR [rbp-80]
	mov 	QWORD PTR [rsp+56], rax
	; call call_Us_subr
	call	call_Us_subr
	; narg := narg + 1
	mov 	eax, DWORD PTR [rbp-16]
	add 	eax, 1
	mov 	DWORD PTR [rbp-16], eax
	; p := p + 16
	mov 	rax, QWORD PTR [rbp-24]
	mov	ebx, 16
	movsxd	rbx, ebx
	add 	rax, rbx
	mov 	QWORD PTR [rbp-24], rax
	; if p != end goto label50
	mov 	rax, QWORD PTR [rbp-24]
	cmp	rax, QWORD PTR [rbp+40]
	jne	call_Us0000016CB0AC8DB0$
	; goto label49
	jmp	call_Us0000016CB0C33FD0$
	; label50:
call_Us0000016CB0AC8DB0$:
	; t35 := &XMM1_REG
	lea 	rbx, XMM1_REG
	mov 	QWORD PTR [rbp-88], rbx
	; t36 := &XMM1_FLT
	lea 	rbx, XMM1_FLT
	mov 	QWORD PTR [rbp-96], rbx
	; t37 := &RDX_REG
	lea 	rbx, RDX_REG
	mov 	QWORD PTR [rbp-104], rbx
	; t38 := &R8_REG
	lea 	rbx, R8_REG
	mov 	QWORD PTR [rbp-112], rbx
	; param p
	mov 	rax, QWORD PTR [rbp-24]
	mov 	rcx, rax
	; param nth
	mov 	eax, DWORD PTR [rbp+48]
	mov 	edx, eax
	; param narg
	mov 	eax, DWORD PTR [rbp-16]
	mov 	r8d, eax
	; param rvp
	mov 	rax, QWORD PTR [rbp-32]
	mov 	r9, rax
	; param t35
	mov 	rax, QWORD PTR [rbp-88]
	mov 	QWORD PTR [rsp+32], rax
	; param t36
	mov 	rax, QWORD PTR [rbp-96]
	mov 	QWORD PTR [rsp+40], rax
	; param t37
	mov 	rax, QWORD PTR [rbp-104]
	mov 	QWORD PTR [rsp+48], rax
	; param t38
	mov 	rax, QWORD PTR [rbp-112]
	mov 	QWORD PTR [rsp+56], rax
	; call call_Us_subr
	call	call_Us_subr
	; narg := narg + 1
	mov 	eax, DWORD PTR [rbp-16]
	add 	eax, 1
	mov 	DWORD PTR [rbp-16], eax
	; p := p + 16
	mov 	rax, QWORD PTR [rbp-24]
	mov	ebx, 16
	movsxd	rbx, ebx
	add 	rax, rbx
	mov 	QWORD PTR [rbp-24], rax
	; if p != end goto label51
	mov 	rax, QWORD PTR [rbp-24]
	cmp	rax, QWORD PTR [rbp+40]
	jne	call_Us0000016CB0AC8630$
	; goto label49
	jmp	call_Us0000016CB0C33FD0$
	; label51:
call_Us0000016CB0AC8630$:
	; t39 := &XMM2_REG
	lea 	rbx, XMM2_REG
	mov 	QWORD PTR [rbp-120], rbx
	; t40 := &XMM2_FLT
	lea 	rbx, XMM2_FLT
	mov 	QWORD PTR [rbp-128], rbx
	; t41 := &R8_REG
	lea 	rbx, R8_REG
	mov 	QWORD PTR [rbp-136], rbx
	; t42 := &R9_REG
	lea 	rbx, R9_REG
	mov 	QWORD PTR [rbp-144], rbx
	; param p
	mov 	rax, QWORD PTR [rbp-24]
	mov 	rcx, rax
	; param nth
	mov 	eax, DWORD PTR [rbp+48]
	mov 	edx, eax
	; param narg
	mov 	eax, DWORD PTR [rbp-16]
	mov 	r8d, eax
	; param rvp
	mov 	rax, QWORD PTR [rbp-32]
	mov 	r9, rax
	; param t39
	mov 	rax, QWORD PTR [rbp-120]
	mov 	QWORD PTR [rsp+32], rax
	; param t40
	mov 	rax, QWORD PTR [rbp-128]
	mov 	QWORD PTR [rsp+40], rax
	; param t41
	mov 	rax, QWORD PTR [rbp-136]
	mov 	QWORD PTR [rsp+48], rax
	; param t42
	mov 	rax, QWORD PTR [rbp-144]
	mov 	QWORD PTR [rsp+56], rax
	; call call_Us_subr
	call	call_Us_subr
	; narg := narg + 1
	mov 	eax, DWORD PTR [rbp-16]
	add 	eax, 1
	mov 	DWORD PTR [rbp-16], eax
	; p := p + 16
	mov 	rax, QWORD PTR [rbp-24]
	mov	ebx, 16
	movsxd	rbx, ebx
	add 	rax, rbx
	mov 	QWORD PTR [rbp-24], rax
	; if p != end goto label52
	mov 	rax, QWORD PTR [rbp-24]
	cmp	rax, QWORD PTR [rbp+40]
	jne	call_Us0000016CB0AC86F0$
	; goto label49
	jmp	call_Us0000016CB0C33FD0$
	; label52:
call_Us0000016CB0AC86F0$:
	; if rvp != .pointer15 goto label53
	mov 	rax, QWORD PTR [rbp-32]
	cmp	rax, QWORD PTR LC$0
	jne	call_Us0000016CB0AC8E70$
	; t43 := &XMM3_REG
	lea 	rbx, XMM3_REG
	mov 	QWORD PTR [rbp-152], rbx
	; t44 := &XMM3_FLT
	lea 	rbx, XMM3_FLT
	mov 	QWORD PTR [rbp-160], rbx
	; t45 := &R9_REG
	lea 	rbx, R9_REG
	mov 	QWORD PTR [rbp-168], rbx
	; t46 := &NOTREF
	lea 	rbx, NOTREF
	mov 	QWORD PTR [rbp-176], rbx
	; param p
	mov 	rax, QWORD PTR [rbp-24]
	mov 	rcx, rax
	; param nth
	mov 	eax, DWORD PTR [rbp+48]
	mov 	edx, eax
	; param narg
	mov 	eax, DWORD PTR [rbp-16]
	mov 	r8d, eax
	; param rvp
	mov 	rax, QWORD PTR [rbp-32]
	mov 	r9, rax
	; param t43
	mov 	rax, QWORD PTR [rbp-152]
	mov 	QWORD PTR [rsp+32], rax
	; param t44
	mov 	rax, QWORD PTR [rbp-160]
	mov 	QWORD PTR [rsp+40], rax
	; param t45
	mov 	rax, QWORD PTR [rbp-168]
	mov 	QWORD PTR [rsp+48], rax
	; param t46
	mov 	rax, QWORD PTR [rbp-176]
	mov 	QWORD PTR [rsp+56], rax
	; call call_Us_subr
	call	call_Us_subr
	; narg := narg + 1
	mov 	eax, DWORD PTR [rbp-16]
	add 	eax, 1
	mov 	DWORD PTR [rbp-16], eax
	; p := p + 16
	mov 	rax, QWORD PTR [rbp-24]
	mov	ebx, 16
	movsxd	rbx, ebx
	add 	rax, rbx
	mov 	QWORD PTR [rbp-24], rax
	; label53:
call_Us0000016CB0AC8E70$:
	; offset := 32
	mov	eax, 32
	mov 	DWORD PTR [rbp-180], eax
	; label54:
call_Us0000016CB0C32950$:
	; if p == end goto label55
	mov 	rax, QWORD PTR [rbp-24]
	cmp	rax, QWORD PTR [rbp+40]
	je	call_Us0000016CB0C333D0$
	; t47 := p + 8
	mov 	rax, QWORD PTR [rbp-24]
	mov	ebx, 8
	movsxd	rbx, ebx
	add 	rax, rbx
	mov 	QWORD PTR [rbp-192], rax
	; kind := *t47
	mov 	rax, QWORD PTR [rbp-192]
	mov	eax, [rax]
	mov 	DWORD PTR [rbp-184], eax
	; goto label56
	jmp	call_Us0000016CB0C33790$
	; label57:
call_Us0000016CB0C32F50$:
	; label58:
call_Us0000016CB0C33C10$:
	; t48 := rsp + offset
	mov 	ebx, DWORD PTR [rbp-180]
	movsxd	rbx, ebx
	mov 	rax, rsp
	add 	rax, rbx
	mov 	QWORD PTR [rbp-200], rax
	; t49 := (double *)t48
	mov 	rax, QWORD PTR [rbp-200]
	mov 	QWORD PTR [rbp-208], rax
	; t50 := *p
	mov 	rax, QWORD PTR [rbp-24]
	fld	QWORD PTR [rax]
	fstp 	QWORD PTR [rbp-216]
	; *t49 := t50
	mov 	rcx, QWORD PTR [rbp-208]
	mov 	rax, QWORD PTR [rbp-216]
	mov	[rcx], rax
	; goto label59
	jmp	call_Us0000016CB0C33910$
	; label60:
call_Us0000016CB0C33850$:
	; f := *p
	mov 	rax, QWORD PTR [rbp-24]
	fld	DWORD PTR [rax]
	fstp 	DWORD PTR [rbp-340]
	; if nth > narg goto label61
	mov 	eax, DWORD PTR [rbp+48]
	cmp	eax, DWORD PTR [rbp-16]
	jg	call_Us0000016CB0C33010$
	; t51 := (double)f
	movss	xmm0, DWORD PTR [rbp-340]
	cvtss2sd	xmm0, xmm0
	movsd	QWORD PTR [rbp-368], xmm0
	; t52 := rsp + offset
	mov 	ebx, DWORD PTR [rbp-180]
	movsxd	rbx, ebx
	mov 	rax, rsp
	add 	rax, rbx
	mov 	QWORD PTR [rbp-376], rax
	; t53 := (double *)t52
	mov 	rax, QWORD PTR [rbp-376]
	mov 	QWORD PTR [rbp-384], rax
	; *t53 := t51
	mov 	rcx, QWORD PTR [rbp-384]
	mov 	rax, QWORD PTR [rbp-368]
	mov	[rcx], rax
	; goto label62
	jmp	call_Us0000016CB0C330D0$
	; label61:
call_Us0000016CB0C33010$:
	; t54 := rsp + offset
	mov 	ebx, DWORD PTR [rbp-180]
	movsxd	rbx, ebx
	mov 	rax, rsp
	add 	rax, rbx
	mov 	QWORD PTR [rbp-352], rax
	; t55 := (float *)t54
	mov 	rax, QWORD PTR [rbp-352]
	mov 	QWORD PTR [rbp-360], rax
	; *t55 := f
	mov 	rcx, QWORD PTR [rbp-360]
	mov 	eax, DWORD PTR [rbp-340]
	mov	[rcx], eax
	; label62:
call_Us0000016CB0C330D0$:
	; goto label59
	jmp	call_Us0000016CB0C33910$
	; label63:
call_Us0000016CB0C32650$:
	; label64:
call_Us0000016CB0C33CD0$:
	; t56 := rsp + offset
	mov 	ebx, DWORD PTR [rbp-180]
	movsxd	rbx, ebx
	mov 	rax, rsp
	add 	rax, rbx
	mov 	QWORD PTR [rbp-224], rax
	; t57 := (unsigned long long int *)t56
	mov 	rax, QWORD PTR [rbp-224]
	mov 	QWORD PTR [rbp-232], rax
	; t58 := *p
	mov 	rax, QWORD PTR [rbp-24]
	mov	rax, [rax]
	mov 	QWORD PTR [rbp-240], rax
	; *t57 := t58
	mov 	rcx, QWORD PTR [rbp-232]
	mov 	rax, QWORD PTR [rbp-240]
	mov	[rcx], rax
	; goto label59
	jmp	call_Us0000016CB0C33910$
	; label65:
call_Us0000016CB0C336D0$:
	; label66:
call_Us0000016CB0C32710$:
	; t59 := rsp + offset
	mov 	ebx, DWORD PTR [rbp-180]
	movsxd	rbx, ebx
	mov 	rax, rsp
	add 	rax, rbx
	mov 	QWORD PTR [rbp-248], rax
	; t60 := (unsigned int *)t59
	mov 	rax, QWORD PTR [rbp-248]
	mov 	QWORD PTR [rbp-256], rax
	; t61 := *p
	mov 	rax, QWORD PTR [rbp-24]
	mov	eax, [rax]
	mov 	DWORD PTR [rbp-260], eax
	; *t60 := t61
	mov 	rcx, QWORD PTR [rbp-256]
	mov 	eax, DWORD PTR [rbp-260]
	mov	[rcx], eax
	; goto label59
	jmp	call_Us0000016CB0C33910$
	; label67:
call_Us0000016CB0C32D10$:
	; t62 := rsp + offset
	mov 	ebx, DWORD PTR [rbp-180]
	movsxd	rbx, ebx
	mov 	rax, rsp
	add 	rax, rbx
	mov 	QWORD PTR [rbp-272], rax
	; t63 := (unsigned short int *)t62
	mov 	rax, QWORD PTR [rbp-272]
	mov 	QWORD PTR [rbp-280], rax
	; t64 := *p
	mov 	rax, QWORD PTR [rbp-24]
	mov	ax, [rax]
	mov 	WORD PTR [rbp-282], ax
	; *t63 := t64
	mov 	rcx, QWORD PTR [rbp-280]
	mov 	ax, WORD PTR [rbp-282]
	mov	[rcx], ax
	; goto label59
	jmp	call_Us0000016CB0C33910$
	; label68:
call_Us0000016CB0C32C50$:
	; s16 := *p
	mov 	rax, QWORD PTR [rbp-24]
	mov	ax, [rax]
	mov 	WORD PTR [rbp-386], ax
	; if nth > narg goto label69
	mov 	eax, DWORD PTR [rbp+48]
	cmp	eax, DWORD PTR [rbp-16]
	jg	call_Us0000016CB0C33A90$
	; t65 := (int)s16
	mov 	ax, WORD PTR [rbp-386]
	movsx	eax, ax
	mov 	DWORD PTR [rbp-412], eax
	; t66 := rsp + offset
	mov 	ebx, DWORD PTR [rbp-180]
	movsxd	rbx, ebx
	mov 	rax, rsp
	add 	rax, rbx
	mov 	QWORD PTR [rbp-424], rax
	; t67 := (int *)t66
	mov 	rax, QWORD PTR [rbp-424]
	mov 	QWORD PTR [rbp-432], rax
	; *t67 := t65
	mov 	rcx, QWORD PTR [rbp-432]
	mov 	eax, DWORD PTR [rbp-412]
	mov	[rcx], eax
	; goto label70
	jmp	call_Us0000016CB0C33B50$
	; label69:
call_Us0000016CB0C33A90$:
	; t68 := rsp + offset
	mov 	ebx, DWORD PTR [rbp-180]
	movsxd	rbx, ebx
	mov 	rax, rsp
	add 	rax, rbx
	mov 	QWORD PTR [rbp-400], rax
	; t69 := (short int *)t68
	mov 	rax, QWORD PTR [rbp-400]
	mov 	QWORD PTR [rbp-408], rax
	; *t69 := s16
	mov 	rcx, QWORD PTR [rbp-408]
	mov 	ax, WORD PTR [rbp-386]
	mov	[rcx], ax
	; label70:
call_Us0000016CB0C33B50$:
	; goto label59
	jmp	call_Us0000016CB0C33910$
	; label71:
call_Us0000016CB0C33250$:
	; t70 := rsp + offset
	mov 	ebx, DWORD PTR [rbp-180]
	movsxd	rbx, ebx
	mov 	rax, rsp
	add 	rax, rbx
	mov 	QWORD PTR [rbp-296], rax
	; t71 := (unsigned char *)t70
	mov 	rax, QWORD PTR [rbp-296]
	mov 	QWORD PTR [rbp-304], rax
	; t72 := *p
	mov 	rax, QWORD PTR [rbp-24]
	mov	al, [rax]
	mov 	BYTE PTR [rbp-305], al
	; *t71 := t72
	mov 	rcx, QWORD PTR [rbp-304]
	mov 	al, BYTE PTR [rbp-305]
	mov	[rcx], al
	; goto label59
	jmp	call_Us0000016CB0C33910$
	; label72:
call_Us0000016CB0C33D90$:
	; s8 := *p
	mov 	rax, QWORD PTR [rbp-24]
	mov	al, [rax]
	mov 	BYTE PTR [rbp-433], al
	; if nth > narg goto label73
	mov 	eax, DWORD PTR [rbp+48]
	cmp	eax, DWORD PTR [rbp-16]
	jg	call_Us0000016CB0C33E50$
	; t73 := (int)s8
	mov 	al, BYTE PTR [rbp-433]
	movsx	eax, al
	mov 	DWORD PTR [rbp-452], eax
	; t74 := rsp + offset
	mov 	ebx, DWORD PTR [rbp-180]
	movsxd	rbx, ebx
	mov 	rax, rsp
	add 	rax, rbx
	mov 	QWORD PTR [rbp-464], rax
	; t75 := (int *)t74
	mov 	rax, QWORD PTR [rbp-464]
	mov 	QWORD PTR [rbp-472], rax
	; *t75 := t73
	mov 	rcx, QWORD PTR [rbp-472]
	mov 	eax, DWORD PTR [rbp-452]
	mov	[rcx], eax
	; goto label74
	jmp	call_Us0000016CB0C32A10$
	; label73:
call_Us0000016CB0C33E50$:
	; t76 := rsp + offset
	mov 	ebx, DWORD PTR [rbp-180]
	movsxd	rbx, ebx
	mov 	rax, rsp
	add 	rax, rbx
	mov 	QWORD PTR [rbp-448], rax
	; *t76 := s8
	mov 	rcx, QWORD PTR [rbp-448]
	mov 	al, BYTE PTR [rbp-433]
	mov	[rcx], al
	; label74:
call_Us0000016CB0C32A10$:
	; goto label59
	jmp	call_Us0000016CB0C33910$
	; label75:
call_Us0000016CB0C32B90$:
	; label76:
call_Us0000016CB0C33310$:
	; t77 := rsp + offset
	mov 	ebx, DWORD PTR [rbp-180]
	movsxd	rbx, ebx
	mov 	rax, rsp
	add 	rax, rbx
	mov 	QWORD PTR [rbp-320], rax
	; t78 := (void **)t77
	mov 	rax, QWORD PTR [rbp-320]
	mov 	QWORD PTR [rbp-328], rax
	; t79 := *p
	mov 	rax, QWORD PTR [rbp-24]
	mov	rax, [rax]
	mov 	QWORD PTR [rbp-336], rax
	; *t78 := t79
	mov 	rcx, QWORD PTR [rbp-328]
	mov 	rax, QWORD PTR [rbp-336]
	mov	[rcx], rax
	; goto label59
	jmp	call_Us0000016CB0C33910$
	; goto label59
	jmp	call_Us0000016CB0C33910$
	; label56:
call_Us0000016CB0C33790$:
	; if kind == 1 goto label57
	mov 	eax, DWORD PTR [rbp-184]
	cmp	eax, 1
	je	call_Us0000016CB0C32F50$
	; if kind == 2 goto label58
	mov 	eax, DWORD PTR [rbp-184]
	cmp	eax, 2
	je	call_Us0000016CB0C33C10$
	; if kind == 3 goto label60
	mov 	eax, DWORD PTR [rbp-184]
	cmp	eax, 3
	je	call_Us0000016CB0C33850$
	; if kind == 4 goto label63
	mov 	eax, DWORD PTR [rbp-184]
	cmp	eax, 4
	je	call_Us0000016CB0C32650$
	; if kind == 5 goto label64
	mov 	eax, DWORD PTR [rbp-184]
	cmp	eax, 5
	je	call_Us0000016CB0C33CD0$
	; if kind == 6 goto label65
	mov 	eax, DWORD PTR [rbp-184]
	cmp	eax, 6
	je	call_Us0000016CB0C336D0$
	; if kind == 7 goto label66
	mov 	eax, DWORD PTR [rbp-184]
	cmp	eax, 7
	je	call_Us0000016CB0C32710$
	; if kind == 8 goto label67
	mov 	eax, DWORD PTR [rbp-184]
	cmp	eax, 8
	je	call_Us0000016CB0C32D10$
	; if kind == 9 goto label68
	mov 	eax, DWORD PTR [rbp-184]
	cmp	eax, 9
	je	call_Us0000016CB0C32C50$
	; if kind == 10 goto label71
	mov 	eax, DWORD PTR [rbp-184]
	cmp	eax, 10
	je	call_Us0000016CB0C33250$
	; if kind == 11 goto label72
	mov 	eax, DWORD PTR [rbp-184]
	cmp	eax, 11
	je	call_Us0000016CB0C33D90$
	; if kind == 12 goto label75
	mov 	eax, DWORD PTR [rbp-184]
	cmp	eax, 12
	je	call_Us0000016CB0C32B90$
	; if kind == 13 goto label76
	mov 	eax, DWORD PTR [rbp-184]
	cmp	eax, 13
	je	call_Us0000016CB0C33310$
	; label59:
call_Us0000016CB0C33910$:
	; p := p + 16
	mov 	rax, QWORD PTR [rbp-24]
	mov	ebx, 16
	movsxd	rbx, ebx
	add 	rax, rbx
	mov 	QWORD PTR [rbp-24], rax
	; narg := narg + 1
	mov 	eax, DWORD PTR [rbp-16]
	add 	eax, 1
	mov 	DWORD PTR [rbp-16], eax
	; offset := offset + 8
	mov 	eax, DWORD PTR [rbp-180]
	add 	eax, 8
	mov 	DWORD PTR [rbp-180], eax
	; goto label54
	jmp	call_Us0000016CB0C32950$
	; label55:
call_Us0000016CB0C333D0$:
	; label49:
call_Us0000016CB0C33FD0$:
	; asm "mov rcx, QWORD PTR RCX_REG"
	mov rcx, QWORD PTR RCX_REG
	; asm "mov rdx, QWORD PTR RDX_REG"
	mov rdx, QWORD PTR RDX_REG
	; asm "mov r8,  QWORD PTR R8_REG"
	mov r8,  QWORD PTR R8_REG
	; asm "mov r9,  QWORD PTR R9_REG"
	mov r9,  QWORD PTR R9_REG
	; if XMM0_FLT == 0 goto label77
	lea 	rax, 	XMM0_FLT
	mov 	eax, DWORD PTR [rax]
	cmp	eax, 0
	je	call_Us0000016CB0C4E2F0$
	; asm "movss xmm0, DWORD PTR XMM0_REG"
	movss xmm0, DWORD PTR XMM0_REG
	; goto label78
	jmp	call_Us0000016CB0C4EBF0$
	; label77:
call_Us0000016CB0C4E2F0$:
	; asm "movsd xmm0, QWORD PTR XMM0_REG"
	movsd xmm0, QWORD PTR XMM0_REG
	; label78:
call_Us0000016CB0C4EBF0$:
	; if XMM1_FLT == 0 goto label79
	lea 	rax, 	XMM1_FLT
	mov 	eax, DWORD PTR [rax]
	cmp	eax, 0
	je	call_Us0000016CB0C4E470$
	; asm "movss xmm1, DWORD PTR XMM1_REG"
	movss xmm1, DWORD PTR XMM1_REG
	; goto label80
	jmp	call_Us0000016CB0C4F430$
	; label79:
call_Us0000016CB0C4E470$:
	; asm "movsd xmm1, QWORD PTR XMM1_REG"
	movsd xmm1, QWORD PTR XMM1_REG
	; label80:
call_Us0000016CB0C4F430$:
	; if XMM2_FLT == 0 goto label81
	lea 	rax, 	XMM2_FLT
	mov 	eax, DWORD PTR [rax]
	cmp	eax, 0
	je	call_Us0000016CB0C4DB70$
	; asm "movss xmm2, DWORD PTR XMM2_REG"
	movss xmm2, DWORD PTR XMM2_REG
	; goto label82
	jmp	call_Us0000016CB0C4E5F0$
	; label81:
call_Us0000016CB0C4DB70$:
	; asm "movsd xmm2, QWORD PTR XMM2_REG"
	movsd xmm2, QWORD PTR XMM2_REG
	; label82:
call_Us0000016CB0C4E5F0$:
	; if XMM3_FLT == 0 goto label83
	lea 	rax, 	XMM3_FLT
	mov 	eax, DWORD PTR [rax]
	cmp	eax, 0
	je	call_Us0000016CB0C4D9F0$
	; asm "movss xmm3, DWORD PTR XMM3_REG"
	movss xmm3, DWORD PTR XMM3_REG
	; goto label84
	jmp	call_Us0000016CB0C62950$
	; label83:
call_Us0000016CB0C4D9F0$:
	; asm "movsd xmm3, QWORD PTR XMM3_REG"
	movsd xmm3, QWORD PTR XMM3_REG
	; label84:
call_Us0000016CB0C62950$:
	; goto label85
	jmp	call_Us0000016CB0C61B10$
	; label86:
call_Us0000016CB0C63250$:
	; label87:
call_Us0000016CB0C630D0$:
	; t80 := (void (*)(...))pf
	mov 	rax, QWORD PTR [rbp+24]
	mov 	QWORD PTR [rbp-480], rax
	; call t80
	mov 	rax, QWORD PTR [rbp-480]
	call	rax
	; goto label88
	jmp	call_Us0000016CB0C62710$
	; label89:
call_Us0000016CB0C62C50$:
	; label90:
call_Us0000016CB0C61A50$:
	; t81 := r
	mov 	rax, QWORD PTR [rbp+16]
	mov 	QWORD PTR [rbp-488], rax
	; t82 := (double (*)(...))pf
	mov 	rax, QWORD PTR [rbp+24]
	mov 	QWORD PTR [rbp-496], rax
	; t83 := call t82
	mov 	rax, QWORD PTR [rbp-496]
	call	rax
	movsd	QWORD PTR [rbp-504], xmm0
	; *t81 := t83
	mov 	rcx, QWORD PTR [rbp-488]
	mov 	rax, QWORD PTR [rbp-504]
	mov	[rcx], rax
	; goto label88
	jmp	call_Us0000016CB0C62710$
	; label91:
call_Us0000016CB0C621D0$:
	; t84 := r
	mov 	rax, QWORD PTR [rbp+16]
	mov 	QWORD PTR [rbp-512], rax
	; t85 := (float (*)(...))pf
	mov 	rax, QWORD PTR [rbp+24]
	mov 	QWORD PTR [rbp-520], rax
	; t86 := call t85
	mov 	rax, QWORD PTR [rbp-520]
	call	rax
	movss	DWORD PTR [rbp-524], xmm0
	; *t84 := t86
	mov 	rcx, QWORD PTR [rbp-512]
	mov 	eax, DWORD PTR [rbp-524]
	mov	[rcx], eax
	; goto label88
	jmp	call_Us0000016CB0C62710$
	; label92:
call_Us0000016CB0C63550$:
	; t87 := r
	mov 	rax, QWORD PTR [rbp+16]
	mov 	QWORD PTR [rbp-536], rax
	; t88 := (unsigned long long int (*)(...))pf
	mov 	rax, QWORD PTR [rbp+24]
	mov 	QWORD PTR [rbp-544], rax
	; t89 := call t88
	mov 	rax, QWORD PTR [rbp-544]
	call	rax
	mov 	QWORD PTR [rbp-552], rax
	; *t87 := t89
	mov 	rcx, QWORD PTR [rbp-536]
	mov 	rax, QWORD PTR [rbp-552]
	mov	[rcx], rax
	; goto label88
	jmp	call_Us0000016CB0C62710$
	; goto label88
	jmp	call_Us0000016CB0C62710$
	; label85:
call_Us0000016CB0C61B10$:
	; if rk == 0 goto label86
	mov 	eax, DWORD PTR [rbp+56]
	cmp	eax, 0
	je	call_Us0000016CB0C63250$
	; if rk == 13 goto label87
	mov 	eax, DWORD PTR [rbp+56]
	cmp	eax, 13
	je	call_Us0000016CB0C630D0$
	; if rk == 1 goto label89
	mov 	eax, DWORD PTR [rbp+56]
	cmp	eax, 1
	je	call_Us0000016CB0C62C50$
	; if rk == 2 goto label90
	mov 	eax, DWORD PTR [rbp+56]
	cmp	eax, 2
	je	call_Us0000016CB0C61A50$
	; if rk == 3 goto label91
	mov 	eax, DWORD PTR [rbp+56]
	cmp	eax, 3
	je	call_Us0000016CB0C621D0$
	; goto label92
	jmp	call_Us0000016CB0C63550$
	; label88:
call_Us0000016CB0C62710$:
	; leave
	mov 	rsp, rbp
	leave
	ret
call_Us	ENDP
_TEXT ENDS
END
