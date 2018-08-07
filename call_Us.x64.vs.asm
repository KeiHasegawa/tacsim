CONST SEGMENT
pointer15$:
	DD	0
	DD	0
CONST ENDS
CONST SEGMENT
pointer16$:
	DD	0
	DD	0
CONST ENDS
CONST SEGMENT
pointer17$:
	DD	0
	DD	0
CONST ENDS
CONST SEGMENT
pointer18$:
	DD	0
	DD	0
CONST ENDS
CONST SEGMENT
pointer19$:
	DD	0
	DD	0
CONST ENDS
CONST SEGMENT
pointer20$:
	DD	0
	DD	0
CONST ENDS
CONST SEGMENT
pointer21$:
	DD	0
	DD	0
CONST ENDS
CONST SEGMENT
pointer22$:
	DD	0
	DD	0
CONST ENDS
CONST SEGMENT
pointer23$:
	DD	0
	DD	0
CONST ENDS
CONST SEGMENT
pointer24$:
	DD	0
	DD	0
CONST ENDS
CONST SEGMENT
pointer25$:
	DD	0
	DD	0
CONST ENDS
CONST SEGMENT
pointer32$:
	DD	0
	DD	0
CONST ENDS
CONST SEGMENT
pointer34$:
	DD	0
	DD	0
CONST ENDS
_DATA SEGMENT
COMM	NOTREF:QWORD
_DATA ENDS
_DATA SEGMENT
COMM	R8_REG:QWORD
_DATA ENDS
_DATA SEGMENT
COMM	R9_REG:QWORD
_DATA ENDS
_DATA SEGMENT
COMM	RCX_REG:QWORD
_DATA ENDS
_DATA SEGMENT
COMM	RDX_REG:QWORD
_DATA ENDS
_DATA SEGMENT
COMM	RSP_REG:QWORD
_DATA ENDS
_DATA SEGMENT
COMM	XMM0_FLT:DWORD
_DATA ENDS
_DATA SEGMENT
COMM	XMM0_REG:QWORD
_DATA ENDS
_DATA SEGMENT
COMM	XMM1_FLT:DWORD
_DATA ENDS
_DATA SEGMENT
COMM	XMM1_REG:QWORD
_DATA ENDS
_DATA SEGMENT
COMM	XMM2_FLT:DWORD
_DATA ENDS
_DATA SEGMENT
COMM	XMM2_REG:QWORD
_DATA ENDS
_DATA SEGMENT
COMM	XMM3_FLT:DWORD
_DATA ENDS
_DATA SEGMENT
COMM	XMM3_REG:QWORD
_DATA ENDS
.code
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
	mov 	eax, [rax]
	mov 	DWORD PTR [rbp-12], eax
	; goto label0
	jmp	call_Us_subr00000281C640D5D0$
	; label1:
call_Us_subr00000281C63E5E10$:
	; label2:
call_Us_subr00000281C63E5BD0$:
	; label3:
call_Us_subr00000281C63E6050$:
	; if nth > narg goto label4
	mov 	eax, DWORD PTR [rbp+24]
	cmp 	eax, DWORD PTR [rbp+32]
	jg	call_Us_subr00000281C63DED50$
	; if kind != 3 goto label5
	mov 	eax, DWORD PTR [rbp-12]
	cmp 	eax, 3
	jne	call_Us_subr00000281C63F60D0$
	; t1 := *p
	mov 	rax, QWORD PTR [rbp+16]
	fld 	DWORD PTR [rax]
	fstp 	DWORD PTR [rbp-84]
	; t2 := (double)t1
	movss	xmm0, DWORD PTR [rbp-84]
	cvtss2sd	xmm0, xmm0
	movsd	QWORD PTR [rbp-96], xmm0
	; goto label6
	jmp	call_Us_subr00000281C63F5350$
	; label5:
call_Us_subr00000281C63F60D0$:
	; t2 := *p
	mov 	rax, QWORD PTR [rbp+16]
	fld 	QWORD PTR [rax]
	fstp 	QWORD PTR [rbp-96]
	; label6:
call_Us_subr00000281C63F5350$:
	; d := t2
	movsd	xmm0, QWORD PTR [rbp-96]
	movsd	QWORD PTR [rbp-80], xmm0
	; *xmm := t2
	mov 	rbx, QWORD PTR [rbp+48]
	mov 	rax, QWORD PTR [rbp-96]
	mov 	[rbx], rax
	; *xmm_flt := 0
	mov 	rbx, QWORD PTR [rbp+56]
	mov	eax, 0
	mov 	[rbx], eax
	; if rvp == .pointer15 goto label7
	mov 	rax, QWORD PTR [rbp+40]
	cmp 	rax, QWORD PTR pointer15$
	je	call_Us_subr00000281C63F66D0$
	; *gpr2 := d
	mov 	rbx, QWORD PTR [rbp+72]
	mov 	rax, QWORD PTR [rbp-80]
	mov 	[rbx], rax
	; goto label8
	jmp	call_Us_subr00000281C63F6910$
	; label7:
call_Us_subr00000281C63F66D0$:
	; *gpr1 := d
	mov 	rbx, QWORD PTR [rbp+64]
	mov 	rax, QWORD PTR [rbp-80]
	mov 	[rbx], rax
	; label8:
call_Us_subr00000281C63F6910$:
	; goto label9
	jmp	call_Us_subr00000281C63F6610$
	; label4:
call_Us_subr00000281C63DED50$:
	; if kind != 3 goto label10
	mov 	eax, DWORD PTR [rbp-12]
	cmp 	eax, 3
	jne	call_Us_subr00000281C63F6D90$
	; t3 := *p
	mov 	rax, QWORD PTR [rbp+16]
	fld 	DWORD PTR [rax]
	fstp 	DWORD PTR [rbp-100]
	; *xmm := t3
	mov 	rbx, QWORD PTR [rbp+48]
	mov 	eax, DWORD PTR [rbp-100]
	mov 	[rbx], eax
	; *xmm_flt := 1
	mov 	rbx, QWORD PTR [rbp+56]
	mov	eax, 1
	mov 	[rbx], eax
	; goto label11
	jmp	call_Us_subr00000281C63F6B50$
	; label10:
call_Us_subr00000281C63F6D90$:
	; t4 := *p
	mov 	rax, QWORD PTR [rbp+16]
	fld 	QWORD PTR [rax]
	fstp 	QWORD PTR [rbp-112]
	; *xmm := t4
	mov 	rbx, QWORD PTR [rbp+48]
	mov 	rax, QWORD PTR [rbp-112]
	mov 	[rbx], rax
	; *xmm_flt := 0
	mov 	rbx, QWORD PTR [rbp+56]
	mov	eax, 0
	mov 	[rbx], eax
	; label11:
call_Us_subr00000281C63F6B50$:
	; label9:
call_Us_subr00000281C63F6610$:
	; goto label12
	jmp	call_Us_subr00000281C640E590$
	; label13:
call_Us_subr00000281C63F5410$:
	; label14:
call_Us_subr00000281C63F6A90$:
	; if rvp == .pointer16 goto label15
	mov 	rax, QWORD PTR [rbp+40]
	cmp 	rax, QWORD PTR pointer16$
	je	call_Us_subr00000281C63F69D0$
	; t5 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov 	rax, [rax]
	mov 	QWORD PTR [rbp-32], rax
	; *gpr2 := t5
	mov 	rbx, QWORD PTR [rbp+72]
	mov 	rax, QWORD PTR [rbp-32]
	mov 	[rbx], rax
	; goto label16
	jmp	call_Us_subr00000281C63F54D0$
	; label15:
call_Us_subr00000281C63F69D0$:
	; t6 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov 	rax, [rax]
	mov 	QWORD PTR [rbp-40], rax
	; *gpr1 := t6
	mov 	rbx, QWORD PTR [rbp+64]
	mov 	rax, QWORD PTR [rbp-40]
	mov 	[rbx], rax
	; label16:
call_Us_subr00000281C63F54D0$:
	; goto label12
	jmp	call_Us_subr00000281C640E590$
	; label17:
call_Us_subr00000281C63F5C50$:
	; label18:
call_Us_subr00000281C63F6E50$:
	; if rvp == .pointer17 goto label19
	mov 	rax, QWORD PTR [rbp+40]
	cmp 	rax, QWORD PTR pointer17$
	je	call_Us_subr00000281C63F6F10$
	; t7 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov 	eax, [rax]
	mov 	DWORD PTR [rbp-44], eax
	; *gpr2 := t7
	mov 	rbx, QWORD PTR [rbp+72]
	mov 	eax, DWORD PTR [rbp-44]
	mov 	[rbx], eax
	; goto label20
	jmp	call_Us_subr00000281C63F5650$
	; label19:
call_Us_subr00000281C63F6F10$:
	; t8 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov 	eax, [rax]
	mov 	DWORD PTR [rbp-48], eax
	; *gpr1 := t8
	mov 	rbx, QWORD PTR [rbp+64]
	mov 	eax, DWORD PTR [rbp-48]
	mov 	[rbx], eax
	; label20:
call_Us_subr00000281C63F5650$:
	; goto label12
	jmp	call_Us_subr00000281C640E590$
	; label21:
call_Us_subr00000281C63F6FD0$:
	; if rvp == .pointer18 goto label22
	mov 	rax, QWORD PTR [rbp+40]
	cmp 	rax, QWORD PTR pointer18$
	je	call_Us_subr00000281C63F7090$
	; t9 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov 	ax, [rax]
	mov 	WORD PTR [rbp-50], ax
	; *gpr2 := t9
	mov 	rbx, QWORD PTR [rbp+72]
	mov 	ax, WORD PTR [rbp-50]
	mov 	[rbx], ax
	; goto label23
	jmp	call_Us_subr00000281C63F5D10$
	; label22:
call_Us_subr00000281C63F7090$:
	; t10 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov 	ax, [rax]
	mov 	WORD PTR [rbp-52], ax
	; *gpr1 := t10
	mov 	rbx, QWORD PTR [rbp+64]
	mov 	ax, WORD PTR [rbp-52]
	mov 	[rbx], ax
	; label23:
call_Us_subr00000281C63F5D10$:
	; goto label12
	jmp	call_Us_subr00000281C640E590$
	; label24:
call_Us_subr00000281C63F5DD0$:
	; if nth > narg goto label25
	mov 	eax, DWORD PTR [rbp+24]
	cmp 	eax, DWORD PTR [rbp+32]
	jg	call_Us_subr00000281C63F57D0$
	; if rvp == .pointer19 goto label26
	mov 	rax, QWORD PTR [rbp+40]
	cmp 	rax, QWORD PTR pointer19$
	je	call_Us_subr00000281C63F5AD0$
	; t11 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov 	ax, [rax]
	mov 	WORD PTR [rbp-114], ax
	; t12 := (int)t11
	mov 	ax, WORD PTR [rbp-114]
	movsx	eax, ax
	mov 	DWORD PTR [rbp-120], eax
	; *gpr2 := t12
	mov 	rbx, QWORD PTR [rbp+72]
	mov 	eax, DWORD PTR [rbp-120]
	mov 	[rbx], eax
	; goto label27
	jmp	call_Us_subr00000281C63F6310$
	; label26:
call_Us_subr00000281C63F5AD0$:
	; t13 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov 	ax, [rax]
	mov 	WORD PTR [rbp-122], ax
	; t14 := (int)t13
	mov 	ax, WORD PTR [rbp-122]
	movsx	eax, ax
	mov 	DWORD PTR [rbp-128], eax
	; *gpr1 := t14
	mov 	rbx, QWORD PTR [rbp+64]
	mov 	eax, DWORD PTR [rbp-128]
	mov 	[rbx], eax
	; label27:
call_Us_subr00000281C63F6310$:
	; goto label28
	jmp	call_Us_subr00000281C63F51D0$
	; label25:
call_Us_subr00000281C63F57D0$:
	; if rvp == .pointer20 goto label29
	mov 	rax, QWORD PTR [rbp+40]
	cmp 	rax, QWORD PTR pointer20$
	je	call_Us_subr00000281C63F6490$
	; t15 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov 	ax, [rax]
	mov 	WORD PTR [rbp-130], ax
	; *gpr2 := t15
	mov 	rbx, QWORD PTR [rbp+72]
	mov 	ax, WORD PTR [rbp-130]
	mov 	[rbx], ax
	; goto label30
	jmp	call_Us_subr00000281C63F5710$
	; label29:
call_Us_subr00000281C63F6490$:
	; t16 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov 	ax, [rax]
	mov 	WORD PTR [rbp-132], ax
	; *gpr1 := t16
	mov 	rbx, QWORD PTR [rbp+64]
	mov 	ax, WORD PTR [rbp-132]
	mov 	[rbx], ax
	; label30:
call_Us_subr00000281C63F5710$:
	; label28:
call_Us_subr00000281C63F51D0$:
	; goto label12
	jmp	call_Us_subr00000281C640E590$
	; label31:
call_Us_subr00000281C63F6550$:
	; if rvp == .pointer21 goto label32
	mov 	rax, QWORD PTR [rbp+40]
	cmp 	rax, QWORD PTR pointer21$
	je	call_Us_subr00000281C63F6850$
	; t17 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov 	al, [rax]
	mov 	BYTE PTR [rbp-53], al
	; *gpr2 := t17
	mov 	rbx, QWORD PTR [rbp+72]
	mov 	al, BYTE PTR [rbp-53]
	mov 	[rbx], al
	; goto label33
	jmp	call_Us_subr00000281C63F5890$
	; label32:
call_Us_subr00000281C63F6850$:
	; t18 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov 	al, [rax]
	mov 	BYTE PTR [rbp-54], al
	; *gpr1 := t18
	mov 	rbx, QWORD PTR [rbp+64]
	mov 	al, BYTE PTR [rbp-54]
	mov 	[rbx], al
	; label33:
call_Us_subr00000281C63F5890$:
	; goto label12
	jmp	call_Us_subr00000281C640E590$
	; label34:
call_Us_subr00000281C63F6010$:
	; if nth > narg goto label35
	mov 	eax, DWORD PTR [rbp+24]
	cmp 	eax, DWORD PTR [rbp+32]
	jg	call_Us_subr00000281C63F5950$
	; if rvp == .pointer22 goto label36
	mov 	rax, QWORD PTR [rbp+40]
	cmp 	rax, QWORD PTR pointer22$
	je	call_Us_subr00000281C640EAD0$
	; t19 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov 	al, [rax]
	mov 	BYTE PTR [rbp-133], al
	; t20 := (int)t19
	mov 	al, BYTE PTR [rbp-133]
	movsx	eax, al
	mov 	DWORD PTR [rbp-140], eax
	; *gpr2 := t20
	mov 	rbx, QWORD PTR [rbp+72]
	mov 	eax, DWORD PTR [rbp-140]
	mov 	[rbx], eax
	; goto label37
	jmp	call_Us_subr00000281C640E650$
	; label36:
call_Us_subr00000281C640EAD0$:
	; t21 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov 	al, [rax]
	mov 	BYTE PTR [rbp-141], al
	; t22 := (int)t21
	mov 	al, BYTE PTR [rbp-141]
	movsx	eax, al
	mov 	DWORD PTR [rbp-148], eax
	; *gpr1 := t22
	mov 	rbx, QWORD PTR [rbp+64]
	mov 	eax, DWORD PTR [rbp-148]
	mov 	[rbx], eax
	; label37:
call_Us_subr00000281C640E650$:
	; goto label38
	jmp	call_Us_subr00000281C63F5A10$
	; label35:
call_Us_subr00000281C63F5950$:
	; if rvp == .pointer23 goto label39
	mov 	rax, QWORD PTR [rbp+40]
	cmp 	rax, QWORD PTR pointer23$
	je	call_Us_subr00000281C640DF90$
	; t23 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov 	al, [rax]
	mov 	BYTE PTR [rbp-149], al
	; *gpr2 := t23
	mov 	rbx, QWORD PTR [rbp+72]
	mov 	al, BYTE PTR [rbp-149]
	mov 	[rbx], al
	; goto label40
	jmp	call_Us_subr00000281C640E110$
	; label39:
call_Us_subr00000281C640DF90$:
	; t24 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov 	al, [rax]
	mov 	BYTE PTR [rbp-150], al
	; *gpr1 := t24
	mov 	rbx, QWORD PTR [rbp+64]
	mov 	al, BYTE PTR [rbp-150]
	mov 	[rbx], al
	; label40:
call_Us_subr00000281C640E110$:
	; label38:
call_Us_subr00000281C63F5A10$:
	; goto label12
	jmp	call_Us_subr00000281C640E590$
	; label41:
call_Us_subr00000281C640DE10$:
	; label42:
call_Us_subr00000281C640E710$:
	; if rvp == .pointer24 goto label43
	mov 	rax, QWORD PTR [rbp+40]
	cmp 	rax, QWORD PTR pointer24$
	je	call_Us_subr00000281C640E350$
	; t25 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov 	rax, [rax]
	mov 	QWORD PTR [rbp-64], rax
	; *gpr2 := t25
	mov 	rbx, QWORD PTR [rbp+72]
	mov 	rax, QWORD PTR [rbp-64]
	mov 	[rbx], rax
	; goto label44
	jmp	call_Us_subr00000281C640D450$
	; label43:
call_Us_subr00000281C640E350$:
	; t26 := *p
	mov 	rax, QWORD PTR [rbp+16]
	mov 	rax, [rax]
	mov 	QWORD PTR [rbp-72], rax
	; *gpr1 := t26
	mov 	rbx, QWORD PTR [rbp+64]
	mov 	rax, QWORD PTR [rbp-72]
	mov 	[rbx], rax
	; label44:
call_Us_subr00000281C640D450$:
	; goto label12
	jmp	call_Us_subr00000281C640E590$
	; goto label12
	jmp	call_Us_subr00000281C640E590$
	; label0:
call_Us_subr00000281C640D5D0$:
	; if kind == 1 goto label1
	mov 	eax, DWORD PTR [rbp-12]
	cmp 	eax, 1
	je	call_Us_subr00000281C63E5E10$
	; if kind == 2 goto label2
	mov 	eax, DWORD PTR [rbp-12]
	cmp 	eax, 2
	je	call_Us_subr00000281C63E5BD0$
	; if kind == 3 goto label3
	mov 	eax, DWORD PTR [rbp-12]
	cmp 	eax, 3
	je	call_Us_subr00000281C63E6050$
	; if kind == 4 goto label13
	mov 	eax, DWORD PTR [rbp-12]
	cmp 	eax, 4
	je	call_Us_subr00000281C63F5410$
	; if kind == 5 goto label14
	mov 	eax, DWORD PTR [rbp-12]
	cmp 	eax, 5
	je	call_Us_subr00000281C63F6A90$
	; if kind == 6 goto label17
	mov 	eax, DWORD PTR [rbp-12]
	cmp 	eax, 6
	je	call_Us_subr00000281C63F5C50$
	; if kind == 7 goto label18
	mov 	eax, DWORD PTR [rbp-12]
	cmp 	eax, 7
	je	call_Us_subr00000281C63F6E50$
	; if kind == 8 goto label21
	mov 	eax, DWORD PTR [rbp-12]
	cmp 	eax, 8
	je	call_Us_subr00000281C63F6FD0$
	; if kind == 9 goto label24
	mov 	eax, DWORD PTR [rbp-12]
	cmp 	eax, 9
	je	call_Us_subr00000281C63F5DD0$
	; if kind == 10 goto label31
	mov 	eax, DWORD PTR [rbp-12]
	cmp 	eax, 10
	je	call_Us_subr00000281C63F6550$
	; if kind == 11 goto label34
	mov 	eax, DWORD PTR [rbp-12]
	cmp 	eax, 11
	je	call_Us_subr00000281C63F6010$
	; if kind == 12 goto label41
	mov 	eax, DWORD PTR [rbp-12]
	cmp 	eax, 12
	je	call_Us_subr00000281C640DE10$
	; if kind == 13 goto label42
	mov 	eax, DWORD PTR [rbp-12]
	cmp 	eax, 13
	je	call_Us_subr00000281C640E710$
	; label12:
call_Us_subr00000281C640E590$:
	; leave
	mov 	rsp, rbp
	leave
	ret
call_Us_subr	ENDP
.code
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

	sub 	rsp, 640
	; XMM3_REG[0] := .pointer25
	lea 	rax, 	pointer25$
	mov 	rax, QWORD PTR [rax]
	mov 	QWORD PTR XMM3_REG, rax
	; XMM2_REG[0] := .pointer25
	lea 	rax, 	pointer25$
	mov 	rax, QWORD PTR [rax]
	mov 	QWORD PTR XMM2_REG, rax
	; XMM1_REG[0] := .pointer25
	lea 	rax, 	pointer25$
	mov 	rax, QWORD PTR [rax]
	mov 	QWORD PTR XMM1_REG, rax
	; XMM0_REG[0] := .pointer25
	lea 	rax, 	pointer25$
	mov 	rax, QWORD PTR [rax]
	mov 	QWORD PTR XMM0_REG, rax
	; R9_REG[0] := .pointer25
	lea 	rax, 	pointer25$
	mov 	rax, QWORD PTR [rax]
	mov 	QWORD PTR R9_REG, rax
	; R8_REG[0] := .pointer25
	lea 	rax, 	pointer25$
	mov 	rax, QWORD PTR [rax]
	mov 	QWORD PTR R8_REG, rax
	; RDX_REG[0] := .pointer25
	lea 	rax, 	pointer25$
	mov 	rax, QWORD PTR [rax]
	mov 	QWORD PTR RDX_REG, rax
	; RCX_REG[0] := .pointer25
	lea 	rax, 	pointer25$
	mov 	rax, QWORD PTR [rax]
	mov 	QWORD PTR RCX_REG, rax
	; XMM3_FLT := 0
	mov	eax, 0
	mov 	rbx, rax
	lea 	rax, XMM3_FLT
	mov 	DWORD PTR [rax], ebx
	; XMM2_FLT := 0
	mov	eax, 0
	mov 	rbx, rax
	lea 	rax, XMM2_FLT
	mov 	DWORD PTR [rax], ebx
	; XMM1_FLT := 0
	mov	eax, 0
	mov 	rbx, rax
	lea 	rax, XMM1_FLT
	mov 	DWORD PTR [rax], ebx
	; XMM0_FLT := 0
	mov	eax, 0
	mov 	rbx, rax
	lea 	rax, XMM0_FLT
	mov 	DWORD PTR [rax], ebx
	; t27 := end - begin
	mov 	rax, QWORD PTR [rbp+40]
	sub 	rax, QWORD PTR [rbp+32]
	mov 	DWORD PTR [rbp-44], eax
	; N := t27 >> 4
	mov 	eax, DWORD PTR [rbp-44]
	sar 	eax, 4
	mov 	DWORD PTR [rbp-20], eax
	; t28 := N & .integer26
	mov 	eax, DWORD PTR [rbp-20]
	and 	eax, 1
	mov 	DWORD PTR [rbp-48], eax
	; if t28 == .integer30 goto label45
	mov 	eax, DWORD PTR [rbp-48]
	cmp 	eax, 0
	je	call_Us00000281C65B1C20$
	; t29 := N + .integer27
	mov 	eax, DWORD PTR [rbp-20]
	add 	eax, 1
	mov 	DWORD PTR [rbp-52], eax
	; t30 := t29 << 3
	mov 	eax, DWORD PTR [rbp-52]
	sal 	eax, 3
	mov 	DWORD PTR [rbp-56], eax
	; goto label46
	jmp	call_Us00000281C65B1E60$
	; label45:
call_Us00000281C65B1C20$:
	; t30 := N << 3
	mov 	eax, DWORD PTR [rbp-20]
	sal 	eax, 3
	mov 	DWORD PTR [rbp-56], eax
	; label46:
call_Us00000281C65B1E60$:
	; rsp := rsp - t30
	mov 	ebx, DWORD PTR [rbp-56]
	movsxd	rbx, ebx
	sub 	rsp, rbx
	; rvp := *r
	mov 	rax, QWORD PTR [rbp+16]
	mov 	rax, [rax]
	mov 	QWORD PTR [rbp-40], rax
	; if rvp == .pointer32 goto label47
	mov 	rax, QWORD PTR [rbp-40]
	cmp 	rax, QWORD PTR pointer32$
	je	call_Us00000281C65B11A0$
	; RCX_REG[0] := rvp
	mov 	rax, QWORD PTR [rbp-40]
	mov 	QWORD PTR RCX_REG, rax
	; label47:
call_Us00000281C65B11A0$:
	; p := begin
	mov 	rax, QWORD PTR [rbp+32]
	mov 	QWORD PTR [rbp-32], rax
	; narg := 0
	mov	eax, 0
	mov 	DWORD PTR [rbp-24], eax
	; if begin != end goto label48
	mov 	rax, QWORD PTR [rbp+32]
	cmp 	rax, QWORD PTR [rbp+40]
	jne	call_Us00000281C65B0C60$
	; goto label49
	jmp	call_Us00000281C65CB070$
	; label48:
call_Us00000281C65B0C60$:
	; t31 := &XMM0_REG
	lea 	rbx, XMM0_REG
	mov 	QWORD PTR [rbp-64], rbx
	; t32 := &XMM0_FLT
	lea 	rbx, XMM0_FLT
	mov 	QWORD PTR [rbp-72], rbx
	; t33 := &RCX_REG
	lea 	rbx, RCX_REG
	mov 	QWORD PTR [rbp-80], rbx
	; t34 := &RDX_REG
	lea 	rbx, RDX_REG
	mov 	QWORD PTR [rbp-88], rbx
	; param p
	mov 	rax, QWORD PTR [rbp-32]
	mov 	rcx, rax
	; param nth
	mov 	eax, DWORD PTR [rbp+48]
	mov 	edx, eax
	; param narg
	mov 	eax, DWORD PTR [rbp-24]
	mov 	r8d, eax
	; param rvp
	mov 	rax, QWORD PTR [rbp-40]
	mov 	r9, rax
	; param t31
	mov 	rax, QWORD PTR [rbp-64]
	mov 	[rsp+32], rax
	; param t32
	mov 	rax, QWORD PTR [rbp-72]
	mov 	[rsp+40], rax
	; param t33
	mov 	rax, QWORD PTR [rbp-80]
	mov 	[rsp+48], rax
	; param t34
	mov 	rax, QWORD PTR [rbp-88]
	mov 	[rsp+56], rax
	; call call_Us_subr
	call	call_Us_subr
	; narg := narg + 1
	mov 	eax, DWORD PTR [rbp-24]
	add 	eax, 1
	mov 	DWORD PTR [rbp-24], eax
	; p := p + 16
	mov 	rax, QWORD PTR [rbp-32]
	mov	ebx, 16
	movsxd	rbx, ebx
	add 	rax, rbx
	mov 	QWORD PTR [rbp-32], rax
	; if p != end goto label50
	mov 	rax, QWORD PTR [rbp-32]
	cmp 	rax, QWORD PTR [rbp+40]
	jne	call_Us00000281C65B0DE0$
	; goto label49
	jmp	call_Us00000281C65CB070$
	; label50:
call_Us00000281C65B0DE0$:
	; t35 := &XMM1_REG
	lea 	rbx, XMM1_REG
	mov 	QWORD PTR [rbp-96], rbx
	; t36 := &XMM1_FLT
	lea 	rbx, XMM1_FLT
	mov 	QWORD PTR [rbp-104], rbx
	; t37 := &RDX_REG
	lea 	rbx, RDX_REG
	mov 	QWORD PTR [rbp-112], rbx
	; t38 := &R8_REG
	lea 	rbx, R8_REG
	mov 	QWORD PTR [rbp-120], rbx
	; param p
	mov 	rax, QWORD PTR [rbp-32]
	mov 	rcx, rax
	; param nth
	mov 	eax, DWORD PTR [rbp+48]
	mov 	edx, eax
	; param narg
	mov 	eax, DWORD PTR [rbp-24]
	mov 	r8d, eax
	; param rvp
	mov 	rax, QWORD PTR [rbp-40]
	mov 	r9, rax
	; param t35
	mov 	rax, QWORD PTR [rbp-96]
	mov 	[rsp+32], rax
	; param t36
	mov 	rax, QWORD PTR [rbp-104]
	mov 	[rsp+40], rax
	; param t37
	mov 	rax, QWORD PTR [rbp-112]
	mov 	[rsp+48], rax
	; param t38
	mov 	rax, QWORD PTR [rbp-120]
	mov 	[rsp+56], rax
	; call call_Us_subr
	call	call_Us_subr
	; narg := narg + 1
	mov 	eax, DWORD PTR [rbp-24]
	add 	eax, 1
	mov 	DWORD PTR [rbp-24], eax
	; p := p + 16
	mov 	rax, QWORD PTR [rbp-32]
	mov	ebx, 16
	movsxd	rbx, ebx
	add 	rax, rbx
	mov 	QWORD PTR [rbp-32], rax
	; if p != end goto label51
	mov 	rax, QWORD PTR [rbp-32]
	cmp 	rax, QWORD PTR [rbp+40]
	jne	call_Us00000281C65B1AA0$
	; goto label49
	jmp	call_Us00000281C65CB070$
	; label51:
call_Us00000281C65B1AA0$:
	; t39 := &XMM2_REG
	lea 	rbx, XMM2_REG
	mov 	QWORD PTR [rbp-128], rbx
	; t40 := &XMM2_FLT
	lea 	rbx, XMM2_FLT
	mov 	QWORD PTR [rbp-136], rbx
	; t41 := &R8_REG
	lea 	rbx, R8_REG
	mov 	QWORD PTR [rbp-144], rbx
	; t42 := &R9_REG
	lea 	rbx, R9_REG
	mov 	QWORD PTR [rbp-152], rbx
	; param p
	mov 	rax, QWORD PTR [rbp-32]
	mov 	rcx, rax
	; param nth
	mov 	eax, DWORD PTR [rbp+48]
	mov 	edx, eax
	; param narg
	mov 	eax, DWORD PTR [rbp-24]
	mov 	r8d, eax
	; param rvp
	mov 	rax, QWORD PTR [rbp-40]
	mov 	r9, rax
	; param t39
	mov 	rax, QWORD PTR [rbp-128]
	mov 	[rsp+32], rax
	; param t40
	mov 	rax, QWORD PTR [rbp-136]
	mov 	[rsp+40], rax
	; param t41
	mov 	rax, QWORD PTR [rbp-144]
	mov 	[rsp+48], rax
	; param t42
	mov 	rax, QWORD PTR [rbp-152]
	mov 	[rsp+56], rax
	; call call_Us_subr
	call	call_Us_subr
	; narg := narg + 1
	mov 	eax, DWORD PTR [rbp-24]
	add 	eax, 1
	mov 	DWORD PTR [rbp-24], eax
	; p := p + 16
	mov 	rax, QWORD PTR [rbp-32]
	mov	ebx, 16
	movsxd	rbx, ebx
	add 	rax, rbx
	mov 	QWORD PTR [rbp-32], rax
	; if p != end goto label52
	mov 	rax, QWORD PTR [rbp-32]
	cmp 	rax, QWORD PTR [rbp+40]
	jne	call_Us00000281C65B1620$
	; goto label49
	jmp	call_Us00000281C65CB070$
	; label52:
call_Us00000281C65B1620$:
	; if rvp != .pointer34 goto label53
	mov 	rax, QWORD PTR [rbp-40]
	cmp 	rax, QWORD PTR pointer34$
	jne	call_Us00000281C65B0720$
	; t43 := &XMM3_REG
	lea 	rbx, XMM3_REG
	mov 	QWORD PTR [rbp-160], rbx
	; t44 := &XMM3_FLT
	lea 	rbx, XMM3_FLT
	mov 	QWORD PTR [rbp-168], rbx
	; t45 := &R9_REG
	lea 	rbx, R9_REG
	mov 	QWORD PTR [rbp-176], rbx
	; t46 := &NOTREF
	lea 	rbx, NOTREF
	mov 	QWORD PTR [rbp-184], rbx
	; param p
	mov 	rax, QWORD PTR [rbp-32]
	mov 	rcx, rax
	; param nth
	mov 	eax, DWORD PTR [rbp+48]
	mov 	edx, eax
	; param narg
	mov 	eax, DWORD PTR [rbp-24]
	mov 	r8d, eax
	; param rvp
	mov 	rax, QWORD PTR [rbp-40]
	mov 	r9, rax
	; param t43
	mov 	rax, QWORD PTR [rbp-160]
	mov 	[rsp+32], rax
	; param t44
	mov 	rax, QWORD PTR [rbp-168]
	mov 	[rsp+40], rax
	; param t45
	mov 	rax, QWORD PTR [rbp-176]
	mov 	[rsp+48], rax
	; param t46
	mov 	rax, QWORD PTR [rbp-184]
	mov 	[rsp+56], rax
	; call call_Us_subr
	call	call_Us_subr
	; narg := narg + 1
	mov 	eax, DWORD PTR [rbp-24]
	add 	eax, 1
	mov 	DWORD PTR [rbp-24], eax
	; p := p + 16
	mov 	rax, QWORD PTR [rbp-32]
	mov	ebx, 16
	movsxd	rbx, ebx
	add 	rax, rbx
	mov 	QWORD PTR [rbp-32], rax
	; label53:
call_Us00000281C65B0720$:
	; offset := 32
	mov	eax, 32
	mov 	DWORD PTR [rbp-188], eax
	; label54:
call_Us00000281C65B1320$:
	; if p == end goto label55
	mov 	rax, QWORD PTR [rbp-32]
	cmp 	rax, QWORD PTR [rbp+40]
	je	call_Us00000281C65B0EA0$
	; t47 := p + 8
	mov 	rax, QWORD PTR [rbp-32]
	mov	ebx, 8
	movsxd	rbx, ebx
	add 	rax, rbx
	mov 	QWORD PTR [rbp-200], rax
	; kind := *t47
	mov 	rax, QWORD PTR [rbp-200]
	mov 	eax, [rax]
	mov 	DWORD PTR [rbp-192], eax
	; goto label56
	jmp	call_Us00000281C65CA170$
	; label57:
call_Us00000281C65B0F60$:
	; label58:
call_Us00000281C65B1560$:
	; t48 := rsp + offset
	mov 	ebx, DWORD PTR [rbp-188]
	movsxd	rbx, ebx
	mov 	rax, rsp
	add 	rax, rbx
	mov 	QWORD PTR [rbp-208], rax
	; t49 := (double *)t48
	mov 	rax, QWORD PTR [rbp-208]
	mov 	QWORD PTR [rbp-216], rax
	; t50 := *p
	mov 	rax, QWORD PTR [rbp-32]
	fld 	QWORD PTR [rax]
	fstp 	QWORD PTR [rbp-224]
	; *t49 := t50
	mov 	rbx, QWORD PTR [rbp-216]
	mov 	rax, QWORD PTR [rbp-224]
	mov 	[rbx], rax
	; goto label59
	jmp	call_Us00000281C65CB2B0$
	; label60:
call_Us00000281C65B1CE0$:
	; f := *p
	mov 	rax, QWORD PTR [rbp-32]
	fld 	DWORD PTR [rax]
	fstp 	DWORD PTR [rbp-348]
	; if nth > narg goto label61
	mov 	eax, DWORD PTR [rbp+48]
	cmp 	eax, DWORD PTR [rbp-24]
	jg	call_Us00000281C65B08A0$
	; t51 := (double)f
	movss	xmm0, DWORD PTR [rbp-348]
	cvtss2sd	xmm0, xmm0
	movsd	QWORD PTR [rbp-376], xmm0
	; t52 := rsp + offset
	mov 	ebx, DWORD PTR [rbp-188]
	movsxd	rbx, ebx
	mov 	rax, rsp
	add 	rax, rbx
	mov 	QWORD PTR [rbp-384], rax
	; t53 := (double *)t52
	mov 	rax, QWORD PTR [rbp-384]
	mov 	QWORD PTR [rbp-392], rax
	; *t53 := t51
	mov 	rbx, QWORD PTR [rbp-392]
	mov 	rax, QWORD PTR [rbp-376]
	mov 	[rbx], rax
	; goto label62
	jmp	call_Us00000281C65B1020$
	; label61:
call_Us00000281C65B08A0$:
	; t54 := rsp + offset
	mov 	ebx, DWORD PTR [rbp-188]
	movsxd	rbx, ebx
	mov 	rax, rsp
	add 	rax, rbx
	mov 	QWORD PTR [rbp-360], rax
	; t55 := (float *)t54
	mov 	rax, QWORD PTR [rbp-360]
	mov 	QWORD PTR [rbp-368], rax
	; *t55 := f
	mov 	rbx, QWORD PTR [rbp-368]
	mov 	eax, DWORD PTR [rbp-348]
	mov 	[rbx], eax
	; label62:
call_Us00000281C65B1020$:
	; goto label59
	jmp	call_Us00000281C65CB2B0$
	; label63:
call_Us00000281C65B0120$:
	; label64:
call_Us00000281C65B01E0$:
	; t56 := rsp + offset
	mov 	ebx, DWORD PTR [rbp-188]
	movsxd	rbx, ebx
	mov 	rax, rsp
	add 	rax, rbx
	mov 	QWORD PTR [rbp-232], rax
	; t57 := (unsigned long long int *)t56
	mov 	rax, QWORD PTR [rbp-232]
	mov 	QWORD PTR [rbp-240], rax
	; t58 := *p
	mov 	rax, QWORD PTR [rbp-32]
	mov 	rax, [rax]
	mov 	QWORD PTR [rbp-248], rax
	; *t57 := t58
	mov 	rbx, QWORD PTR [rbp-240]
	mov 	rax, QWORD PTR [rbp-248]
	mov 	[rbx], rax
	; goto label59
	jmp	call_Us00000281C65CB2B0$
	; label65:
call_Us00000281C65B0660$:
	; label66:
call_Us00000281C65B13E0$:
	; t59 := rsp + offset
	mov 	ebx, DWORD PTR [rbp-188]
	movsxd	rbx, ebx
	mov 	rax, rsp
	add 	rax, rbx
	mov 	QWORD PTR [rbp-256], rax
	; t60 := (unsigned int *)t59
	mov 	rax, QWORD PTR [rbp-256]
	mov 	QWORD PTR [rbp-264], rax
	; t61 := *p
	mov 	rax, QWORD PTR [rbp-32]
	mov 	eax, [rax]
	mov 	DWORD PTR [rbp-268], eax
	; *t60 := t61
	mov 	rbx, QWORD PTR [rbp-264]
	mov 	eax, DWORD PTR [rbp-268]
	mov 	[rbx], eax
	; goto label59
	jmp	call_Us00000281C65CB2B0$
	; label67:
call_Us00000281C65B0360$:
	; t62 := rsp + offset
	mov 	ebx, DWORD PTR [rbp-188]
	movsxd	rbx, ebx
	mov 	rax, rsp
	add 	rax, rbx
	mov 	QWORD PTR [rbp-280], rax
	; t63 := (unsigned short int *)t62
	mov 	rax, QWORD PTR [rbp-280]
	mov 	QWORD PTR [rbp-288], rax
	; t64 := *p
	mov 	rax, QWORD PTR [rbp-32]
	mov 	ax, [rax]
	mov 	WORD PTR [rbp-290], ax
	; *t63 := t64
	mov 	rbx, QWORD PTR [rbp-288]
	mov 	ax, WORD PTR [rbp-290]
	mov 	[rbx], ax
	; goto label59
	jmp	call_Us00000281C65CB2B0$
	; label68:
call_Us00000281C65B0A20$:
	; s16 := *p
	mov 	rax, QWORD PTR [rbp-32]
	mov 	ax, [rax]
	mov 	WORD PTR [rbp-394], ax
	; if nth > narg goto label69
	mov 	eax, DWORD PTR [rbp+48]
	cmp 	eax, DWORD PTR [rbp-24]
	jg	call_Us00000281C65B1DA0$
	; t65 := (int)s16
	mov 	ax, WORD PTR [rbp-394]
	movsx	eax, ax
	mov 	DWORD PTR [rbp-420], eax
	; t66 := rsp + offset
	mov 	ebx, DWORD PTR [rbp-188]
	movsxd	rbx, ebx
	mov 	rax, rsp
	add 	rax, rbx
	mov 	QWORD PTR [rbp-432], rax
	; t67 := (int *)t66
	mov 	rax, QWORD PTR [rbp-432]
	mov 	QWORD PTR [rbp-440], rax
	; *t67 := t65
	mov 	rbx, QWORD PTR [rbp-440]
	mov 	eax, DWORD PTR [rbp-420]
	mov 	[rbx], eax
	; goto label70
	jmp	call_Us00000281C65B0420$
	; label69:
call_Us00000281C65B1DA0$:
	; t68 := rsp + offset
	mov 	ebx, DWORD PTR [rbp-188]
	movsxd	rbx, ebx
	mov 	rax, rsp
	add 	rax, rbx
	mov 	QWORD PTR [rbp-408], rax
	; t69 := (short int *)t68
	mov 	rax, QWORD PTR [rbp-408]
	mov 	QWORD PTR [rbp-416], rax
	; *t69 := s16
	mov 	rbx, QWORD PTR [rbp-416]
	mov 	ax, WORD PTR [rbp-394]
	mov 	[rbx], ax
	; label70:
call_Us00000281C65B0420$:
	; goto label59
	jmp	call_Us00000281C65CB2B0$
	; label71:
call_Us00000281C65B1860$:
	; t70 := rsp + offset
	mov 	ebx, DWORD PTR [rbp-188]
	movsxd	rbx, ebx
	mov 	rax, rsp
	add 	rax, rbx
	mov 	QWORD PTR [rbp-304], rax
	; t71 := (unsigned char *)t70
	mov 	rax, QWORD PTR [rbp-304]
	mov 	QWORD PTR [rbp-312], rax
	; t72 := *p
	mov 	rax, QWORD PTR [rbp-32]
	mov 	al, [rax]
	mov 	BYTE PTR [rbp-313], al
	; *t71 := t72
	mov 	rbx, QWORD PTR [rbp-312]
	mov 	al, BYTE PTR [rbp-313]
	mov 	[rbx], al
	; goto label59
	jmp	call_Us00000281C65CB2B0$
	; label72:
call_Us00000281C65B1920$:
	; s8 := *p
	mov 	rax, QWORD PTR [rbp-32]
	mov 	al, [rax]
	mov 	BYTE PTR [rbp-441], al
	; if nth > narg goto label73
	mov 	eax, DWORD PTR [rbp+48]
	cmp 	eax, DWORD PTR [rbp-24]
	jg	call_Us00000281C65CB1F0$
	; t73 := (int)s8
	mov 	al, BYTE PTR [rbp-441]
	movsx	eax, al
	mov 	DWORD PTR [rbp-460], eax
	; t74 := rsp + offset
	mov 	ebx, DWORD PTR [rbp-188]
	movsxd	rbx, ebx
	mov 	rax, rsp
	add 	rax, rbx
	mov 	QWORD PTR [rbp-472], rax
	; t75 := (int *)t74
	mov 	rax, QWORD PTR [rbp-472]
	mov 	QWORD PTR [rbp-480], rax
	; *t75 := t73
	mov 	rbx, QWORD PTR [rbp-480]
	mov 	eax, DWORD PTR [rbp-460]
	mov 	[rbx], eax
	; goto label74
	jmp	call_Us00000281C65C9630$
	; label73:
call_Us00000281C65CB1F0$:
	; t76 := rsp + offset
	mov 	ebx, DWORD PTR [rbp-188]
	movsxd	rbx, ebx
	mov 	rax, rsp
	add 	rax, rbx
	mov 	QWORD PTR [rbp-456], rax
	; *t76 := s8
	mov 	rbx, QWORD PTR [rbp-456]
	mov 	al, BYTE PTR [rbp-441]
	mov 	[rbx], al
	; label74:
call_Us00000281C65C9630$:
	; goto label59
	jmp	call_Us00000281C65CB2B0$
	; label75:
call_Us00000281C65CAEF0$:
	; label76:
call_Us00000281C65CAFB0$:
	; t77 := rsp + offset
	mov 	ebx, DWORD PTR [rbp-188]
	movsxd	rbx, ebx
	mov 	rax, rsp
	add 	rax, rbx
	mov 	QWORD PTR [rbp-328], rax
	; t78 := (void **)t77
	mov 	rax, QWORD PTR [rbp-328]
	mov 	QWORD PTR [rbp-336], rax
	; t79 := *p
	mov 	rax, QWORD PTR [rbp-32]
	mov 	rax, [rax]
	mov 	QWORD PTR [rbp-344], rax
	; *t78 := t79
	mov 	rbx, QWORD PTR [rbp-336]
	mov 	rax, QWORD PTR [rbp-344]
	mov 	[rbx], rax
	; goto label59
	jmp	call_Us00000281C65CB2B0$
	; goto label59
	jmp	call_Us00000281C65CB2B0$
	; label56:
call_Us00000281C65CA170$:
	; if kind == 1 goto label57
	mov 	eax, DWORD PTR [rbp-192]
	cmp 	eax, 1
	je	call_Us00000281C65B0F60$
	; if kind == 2 goto label58
	mov 	eax, DWORD PTR [rbp-192]
	cmp 	eax, 2
	je	call_Us00000281C65B1560$
	; if kind == 3 goto label60
	mov 	eax, DWORD PTR [rbp-192]
	cmp 	eax, 3
	je	call_Us00000281C65B1CE0$
	; if kind == 4 goto label63
	mov 	eax, DWORD PTR [rbp-192]
	cmp 	eax, 4
	je	call_Us00000281C65B0120$
	; if kind == 5 goto label64
	mov 	eax, DWORD PTR [rbp-192]
	cmp 	eax, 5
	je	call_Us00000281C65B01E0$
	; if kind == 6 goto label65
	mov 	eax, DWORD PTR [rbp-192]
	cmp 	eax, 6
	je	call_Us00000281C65B0660$
	; if kind == 7 goto label66
	mov 	eax, DWORD PTR [rbp-192]
	cmp 	eax, 7
	je	call_Us00000281C65B13E0$
	; if kind == 8 goto label67
	mov 	eax, DWORD PTR [rbp-192]
	cmp 	eax, 8
	je	call_Us00000281C65B0360$
	; if kind == 9 goto label68
	mov 	eax, DWORD PTR [rbp-192]
	cmp 	eax, 9
	je	call_Us00000281C65B0A20$
	; if kind == 10 goto label71
	mov 	eax, DWORD PTR [rbp-192]
	cmp 	eax, 10
	je	call_Us00000281C65B1860$
	; if kind == 11 goto label72
	mov 	eax, DWORD PTR [rbp-192]
	cmp 	eax, 11
	je	call_Us00000281C65B1920$
	; if kind == 12 goto label75
	mov 	eax, DWORD PTR [rbp-192]
	cmp 	eax, 12
	je	call_Us00000281C65CAEF0$
	; if kind == 13 goto label76
	mov 	eax, DWORD PTR [rbp-192]
	cmp 	eax, 13
	je	call_Us00000281C65CAFB0$
	; label59:
call_Us00000281C65CB2B0$:
	; p := p + 16
	mov 	rax, QWORD PTR [rbp-32]
	mov	ebx, 16
	movsxd	rbx, ebx
	add 	rax, rbx
	mov 	QWORD PTR [rbp-32], rax
	; narg := narg + 1
	mov 	eax, DWORD PTR [rbp-24]
	add 	eax, 1
	mov 	DWORD PTR [rbp-24], eax
	; offset := offset + 8
	mov 	eax, DWORD PTR [rbp-188]
	add 	eax, 8
	mov 	DWORD PTR [rbp-188], eax
	; goto label54
	jmp	call_Us00000281C65B1320$
	; label55:
call_Us00000281C65B0EA0$:
	; label49:
call_Us00000281C65CB070$:
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
	cmp 	eax, 0
	je	call_Us00000281C65E3060$
	; asm "movss xmm0, DWORD PTR XMM0_REG"
	movss xmm0, DWORD PTR XMM0_REG
	; goto label78
	jmp	call_Us00000281C65F1E20$
	; label77:
call_Us00000281C65E3060$:
	; asm "movsd xmm0, QWORD PTR XMM0_REG"
	movsd xmm0, QWORD PTR XMM0_REG
	; label78:
call_Us00000281C65F1E20$:
	; if XMM1_FLT == 0 goto label79
	lea 	rax, 	XMM1_FLT
	mov 	eax, DWORD PTR [rax]
	cmp 	eax, 0
	je	call_Us00000281C65F1A60$
	; asm "movss xmm1, DWORD PTR XMM1_REG"
	movss xmm1, DWORD PTR XMM1_REG
	; goto label80
	jmp	call_Us00000281C65F4220$
	; label79:
call_Us00000281C65F1A60$:
	; asm "movsd xmm1, QWORD PTR XMM1_REG"
	movsd xmm1, QWORD PTR XMM1_REG
	; label80:
call_Us00000281C65F4220$:
	; if XMM2_FLT == 0 goto label81
	lea 	rax, 	XMM2_FLT
	mov 	eax, DWORD PTR [rax]
	cmp 	eax, 0
	je	call_Us00000281C660AB00$
	; asm "movss xmm2, DWORD PTR XMM2_REG"
	movss xmm2, DWORD PTR XMM2_REG
	; goto label82
	jmp	call_Us00000281C660C600$
	; label81:
call_Us00000281C660AB00$:
	; asm "movsd xmm2, QWORD PTR XMM2_REG"
	movsd xmm2, QWORD PTR XMM2_REG
	; label82:
call_Us00000281C660C600$:
	; if XMM3_FLT == 0 goto label83
	lea 	rax, 	XMM3_FLT
	mov 	eax, DWORD PTR [rax]
	cmp 	eax, 0
	je	call_Us00000281C661E2B0$
	; asm "movss xmm3, DWORD PTR XMM3_REG"
	movss xmm3, DWORD PTR XMM3_REG
	; goto label84
	jmp	call_Us00000281C661B970$
	; label83:
call_Us00000281C661E2B0$:
	; asm "movsd xmm3, QWORD PTR XMM3_REG"
	movsd xmm3, QWORD PTR XMM3_REG
	; label84:
call_Us00000281C661B970$:
	; goto label85
	jmp	call_Us00000281C661B370$
	; label86:
call_Us00000281C661C3F0$:
	; label87:
call_Us00000281C661B2B0$:
	; t80 := (void (*)(...))pf
	mov 	rax, QWORD PTR [rbp+24]
	mov 	QWORD PTR [rbp-488], rax
	; call t80
	mov 	rax, QWORD PTR [rbp-488]
	call	rax
	; goto label88
	jmp	call_Us00000281C661D6B0$
	; label89:
call_Us00000281C661AD70$:
	; label90:
call_Us00000281C661C870$:
	; t81 := r
	mov 	rax, QWORD PTR [rbp+16]
	mov 	QWORD PTR [rbp-496], rax
	; t82 := (double (*)(...))pf
	mov 	rax, QWORD PTR [rbp+24]
	mov 	QWORD PTR [rbp-504], rax
	; t83 := call t82
	mov 	rax, QWORD PTR [rbp-504]
	call	rax
	movsd	QWORD PTR [rbp-512], xmm0
	; *t81 := t83
	mov 	rbx, QWORD PTR [rbp-496]
	mov 	rax, QWORD PTR [rbp-512]
	mov 	[rbx], rax
	; goto label88
	jmp	call_Us00000281C661D6B0$
	; label91:
call_Us00000281C661C9F0$:
	; t84 := r
	mov 	rax, QWORD PTR [rbp+16]
	mov 	QWORD PTR [rbp-520], rax
	; t85 := (float (*)(...))pf
	mov 	rax, QWORD PTR [rbp+24]
	mov 	QWORD PTR [rbp-528], rax
	; t86 := call t85
	mov 	rax, QWORD PTR [rbp-528]
	call	rax
	movss	DWORD PTR [rbp-532], xmm0
	; *t84 := t86
	mov 	rbx, QWORD PTR [rbp-520]
	mov 	eax, DWORD PTR [rbp-532]
	mov 	[rbx], eax
	; goto label88
	jmp	call_Us00000281C661D6B0$
	; label92:
call_Us00000281C661AB30$:
	; t87 := r
	mov 	rax, QWORD PTR [rbp+16]
	mov 	QWORD PTR [rbp-544], rax
	; t88 := (unsigned long long int (*)(...))pf
	mov 	rax, QWORD PTR [rbp+24]
	mov 	QWORD PTR [rbp-552], rax
	; t89 := call t88
	mov 	rax, QWORD PTR [rbp-552]
	call	rax
	mov 	QWORD PTR [rbp-560], rax
	; *t87 := t89
	mov 	rbx, QWORD PTR [rbp-544]
	mov 	rax, QWORD PTR [rbp-560]
	mov 	[rbx], rax
	; goto label88
	jmp	call_Us00000281C661D6B0$
	; goto label88
	jmp	call_Us00000281C661D6B0$
	; label85:
call_Us00000281C661B370$:
	; if rk == 0 goto label86
	mov 	eax, DWORD PTR [rbp+56]
	cmp 	eax, 0
	je	call_Us00000281C661C3F0$
	; if rk == 13 goto label87
	mov 	eax, DWORD PTR [rbp+56]
	cmp 	eax, 13
	je	call_Us00000281C661B2B0$
	; if rk == 1 goto label89
	mov 	eax, DWORD PTR [rbp+56]
	cmp 	eax, 1
	je	call_Us00000281C661AD70$
	; if rk == 2 goto label90
	mov 	eax, DWORD PTR [rbp+56]
	cmp 	eax, 2
	je	call_Us00000281C661C870$
	; if rk == 3 goto label91
	mov 	eax, DWORD PTR [rbp+56]
	cmp 	eax, 3
	je	call_Us00000281C661C9F0$
	; goto label92
	jmp	call_Us00000281C661AB30$
	; label88:
call_Us00000281C661D6B0$:
	; leave
	mov 	rsp, rbp
	leave
	ret
call_Us	ENDP
END
