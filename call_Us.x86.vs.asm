	.model	flat
_TEXT SEGMENT
_add_size	PROC
	; enter
	push 	ebp
	mov 	ebp, esp
	sub 	esp, 32
	; t0 := p + 12
	mov 	eax, DWORD PTR [ebp+12]
	add 	eax, 12
	mov 	DWORD PTR [ebp-8], eax
	; t1 := *t0
	mov 	eax, DWORD PTR [ebp-8]
	mov	eax, [eax]
	mov 	DWORD PTR [ebp-12], eax
	; t2 := n + t1
	mov 	eax, DWORD PTR [ebp+8]
	add 	eax, DWORD PTR [ebp-12]
	mov 	DWORD PTR [ebp-16], eax
	; return t2
	mov 	eax, DWORD PTR [ebp-16]
	; leave
	mov 	esp, ebp
	leave
	ret
_add_size	ENDP
_TEXT ENDS
_TEXT SEGMENT
	PUBLIC	_call_Us
_call_Us	PROC
	; enter
	push 	ebp
	mov 	ebp, esp
	sub 	esp, 464
	; rvp := *r
	mov 	eax, DWORD PTR [ebp+8]
	mov	eax, [eax]
	mov 	DWORD PTR [ebp-28], eax
	; if rvp == .pointer16 goto label0
	mov 	eax, DWORD PTR [ebp-28]
	cmp	eax, 0
	je	_call_Us0000013442DF1420$
	; t3 := 4
	mov	eax, 4
	mov 	DWORD PTR [ebp-32], eax
	; goto label1
	jmp	_call_Us0000013442DF0A60$
	; label0:
_call_Us0000013442DF1420$:
	; t3 := 0
	mov	eax, 0
	mov 	DWORD PTR [ebp-32], eax
	; label1:
_call_Us0000013442DF0A60$:
	; offset := t3
	mov 	eax, DWORD PTR [ebp-32]
	mov 	DWORD PTR [ebp-24], eax
	; n := t3
	mov 	eax, DWORD PTR [ebp-32]
	mov 	DWORD PTR [ebp-48], eax
	; p := begin
	mov 	eax, DWORD PTR [ebp+16]
	mov 	DWORD PTR [ebp-60], eax
	; end := end
	mov 	eax, DWORD PTR [ebp+20]
	mov 	DWORD PTR [ebp-44], eax
	; add := &add_size
	lea 	ebx, _add_size
	mov 	DWORD PTR [ebp-52], ebx
	; label2:
_call_Us0000013442DF0160$:
	; if p == end goto label3
	mov 	eax, DWORD PTR [ebp-60]
	cmp	eax, DWORD PTR [ebp-44]
	je	_call_Us0000013442DF1120$
	; param n
	mov 	eax, DWORD PTR [ebp-48]
	mov	DWORD PTR 0[esp], eax
	; param p
	mov 	eax, DWORD PTR [ebp-60]
	mov	DWORD PTR 4[esp], eax
	; t4 := call add
	mov 	eax, DWORD PTR [ebp-52]
	call	eax
	mov 	DWORD PTR [ebp-64], eax
	; n := t4
	mov 	eax, DWORD PTR [ebp-64]
	mov 	DWORD PTR [ebp-48], eax
	; p := p + 16
	mov 	eax, DWORD PTR [ebp-60]
	add 	eax, 16
	mov 	DWORD PTR [ebp-60], eax
	; goto label2
	jmp	_call_Us0000013442DF0160$
	; label3:
_call_Us0000013442DF1120$:
	; t5 := n
	mov 	eax, DWORD PTR [ebp-48]
	mov 	DWORD PTR [ebp-56], eax
	; goto label4
	jmp	_call_Us0000013442DF08E0$
	; label4:
_call_Us0000013442DF08E0$:
	; delta := t5
	mov 	eax, DWORD PTR [ebp-56]
	mov 	DWORD PTR [ebp-8], eax
	; n := t5 & 15
	mov 	eax, DWORD PTR [ebp-56]
	and 	eax, 15
	mov 	DWORD PTR [ebp-16], eax
	; if n == 0 goto label5
	mov 	eax, DWORD PTR [ebp-16]
	cmp	eax, 0
	je	_call_Us0000013442DF03A0$
	; t6 := 16 - n
	mov	eax, 16
	sub 	eax, DWORD PTR [ebp-16]
	mov 	DWORD PTR [ebp-36], eax
	; label5:
_call_Us0000013442DF03A0$:
	; asm "mov	eax, DWORD PTR [ebp-8]"
	mov	eax, DWORD PTR [ebp-8]
	; asm "sub	esp, eax"
	sub	esp, eax
	; asm "mov	DWORD PTR [ebp-12], esp"
	mov	DWORD PTR [ebp-12], esp
	; if rvp == .pointer16 goto label6
	mov 	eax, DWORD PTR [ebp-28]
	cmp	eax, 0
	je	_call_Us0000013442E02880$
	; t7 := (void **)esp
	mov 	eax, DWORD PTR [ebp-12]
	mov 	DWORD PTR [ebp-40], eax
	; *t7 := rvp
	mov 	ecx, DWORD PTR [ebp-40]
	mov 	eax, DWORD PTR [ebp-28]
	mov	[ecx], eax
	; label6:
_call_Us0000013442E02880$:
	; narg := 0
	mov	eax, 0
	mov 	DWORD PTR [ebp-20], eax
	; p := begin
	mov 	eax, DWORD PTR [ebp+16]
	mov 	DWORD PTR [ebp-68], eax
	; label7:
_call_Us0000013442E01B00$:
	; if p == end goto label8
	mov 	eax, DWORD PTR [ebp-68]
	cmp	eax, DWORD PTR [ebp+20]
	je	_call_Us0000013442E03000$
	; t8 := p + 8
	mov 	eax, DWORD PTR [ebp-68]
	add 	eax, 8
	mov 	DWORD PTR [ebp-76], eax
	; kind := *t8
	mov 	eax, DWORD PTR [ebp-76]
	mov	eax, [eax]
	mov 	DWORD PTR [ebp-72], eax
	; goto label9
	jmp	_call_Us0000013442E1F790$
	; label10:
_call_Us0000013442E030C0$:
	; t9 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-80], eax
	; t10 := (long double *)t9
	mov 	eax, DWORD PTR [ebp-80]
	mov 	DWORD PTR [ebp-84], eax
	; t11 := *p
	mov 	eax, DWORD PTR [ebp-68]
	fld	QWORD PTR [eax]
	fstp 	QWORD PTR [ebp-96]
	; *t10 := t11
	mov 	ebx, DWORD PTR [ebp-84]
	mov	eax, DWORD PTR [ebp-96]
	mov	edx, DWORD PTR [ebp-92]
	mov 	[ebx  ], eax
	mov 	[ebx+4], edx
	; t12 := (unsigned int)offset
	mov 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-100], eax
	; t13 := t12 + .integer43
	mov 	eax, DWORD PTR [ebp-100]
	add 	eax, 8
	mov 	DWORD PTR [ebp-104], eax
	; offset := (int)t13
	mov 	eax, DWORD PTR [ebp-104]
	mov 	DWORD PTR [ebp-24], eax
	; goto label11
	jmp	_call_Us0000013442E1EC50$
	; label12:
_call_Us0000013442E03840$:
	; t14 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-108], eax
	; t15 := (double *)t14
	mov 	eax, DWORD PTR [ebp-108]
	mov 	DWORD PTR [ebp-112], eax
	; t16 := *p
	mov 	eax, DWORD PTR [ebp-68]
	fld	QWORD PTR [eax]
	fstp 	QWORD PTR [ebp-120]
	; *t15 := t16
	mov 	ebx, DWORD PTR [ebp-112]
	mov	eax, DWORD PTR [ebp-120]
	mov	edx, DWORD PTR [ebp-116]
	mov 	[ebx  ], eax
	mov 	[ebx+4], edx
	; t17 := (unsigned int)offset
	mov 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-124], eax
	; t18 := t17 + .integer43
	mov 	eax, DWORD PTR [ebp-124]
	add 	eax, 8
	mov 	DWORD PTR [ebp-128], eax
	; offset := (int)t18
	mov 	eax, DWORD PTR [ebp-128]
	mov 	DWORD PTR [ebp-24], eax
	; goto label11
	jmp	_call_Us0000013442E1EC50$
	; label13:
_call_Us0000013442E02400$:
	; if nth > narg goto label14
	mov 	eax, DWORD PTR [ebp+24]
	cmp	eax, DWORD PTR [ebp-20]
	jg	_call_Us0000013442E01D40$
	; t19 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-132], eax
	; t20 := (double *)t19
	mov 	eax, DWORD PTR [ebp-132]
	mov 	DWORD PTR [ebp-136], eax
	; t21 := *p
	mov 	eax, DWORD PTR [ebp-68]
	fld	DWORD PTR [eax]
	fstp 	DWORD PTR [ebp-140]
	; t22 := (double)t21
	fld	DWORD PTR [ebp-140]
	fstp 	QWORD PTR [ebp-152]
	; *t20 := t22
	mov 	ebx, DWORD PTR [ebp-136]
	mov	eax, DWORD PTR [ebp-152]
	mov	edx, DWORD PTR [ebp-148]
	mov 	[ebx  ], eax
	mov 	[ebx+4], edx
	; t23 := (unsigned int)offset
	mov 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-156], eax
	; t24 := t23 + .integer43
	mov 	eax, DWORD PTR [ebp-156]
	add 	eax, 8
	mov 	DWORD PTR [ebp-160], eax
	; offset := (int)t24
	mov 	eax, DWORD PTR [ebp-160]
	mov 	DWORD PTR [ebp-24], eax
	; goto label15
	jmp	_call_Us0000013442E02D00$
	; label14:
_call_Us0000013442E01D40$:
	; t25 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-164], eax
	; t26 := (float *)t25
	mov 	eax, DWORD PTR [ebp-164]
	mov 	DWORD PTR [ebp-168], eax
	; t27 := *p
	mov 	eax, DWORD PTR [ebp-68]
	fld	DWORD PTR [eax]
	fstp 	DWORD PTR [ebp-172]
	; *t26 := t27
	mov 	ecx, DWORD PTR [ebp-168]
	mov 	eax, DWORD PTR [ebp-172]
	mov	[ecx], eax
	; t28 := (unsigned int)offset
	mov 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-176], eax
	; t29 := t28 + .integer44
	mov 	eax, DWORD PTR [ebp-176]
	add 	eax, 4
	mov 	DWORD PTR [ebp-180], eax
	; offset := (int)t29
	mov 	eax, DWORD PTR [ebp-180]
	mov 	DWORD PTR [ebp-24], eax
	; label15:
_call_Us0000013442E02D00$:
	; goto label11
	jmp	_call_Us0000013442E1EC50$
	; label16:
_call_Us0000013442E02E80$:
	; label17:
_call_Us0000013442E01E00$:
	; t30 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-184], eax
	; t31 := (unsigned long long int *)t30
	mov 	eax, DWORD PTR [ebp-184]
	mov 	DWORD PTR [ebp-188], eax
	; t32 := *p
	mov 	eax, DWORD PTR [ebp-68]
	mov	edx, [eax+4]
	mov	eax, [eax]
	mov	DWORD PTR [ebp-200], eax
	mov	DWORD PTR [ebp-196], edx
	; *t31 := t32
	mov 	ebx, DWORD PTR [ebp-188]
	mov	eax, DWORD PTR [ebp-200]
	mov	edx, DWORD PTR [ebp-196]
	mov 	[ebx  ], eax
	mov 	[ebx+4], edx
	; t33 := (unsigned int)offset
	mov 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-204], eax
	; t34 := t33 + .integer43
	mov 	eax, DWORD PTR [ebp-204]
	add 	eax, 8
	mov 	DWORD PTR [ebp-208], eax
	; offset := (int)t34
	mov 	eax, DWORD PTR [ebp-208]
	mov 	DWORD PTR [ebp-24], eax
	; goto label11
	jmp	_call_Us0000013442E1EC50$
	; label18:
_call_Us0000013442E02580$:
	; label19:
_call_Us0000013442E024C0$:
	; t35 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-212], eax
	; t36 := (unsigned int *)t35
	mov 	eax, DWORD PTR [ebp-212]
	mov 	DWORD PTR [ebp-216], eax
	; t37 := *p
	mov 	eax, DWORD PTR [ebp-68]
	mov	eax, [eax]
	mov 	DWORD PTR [ebp-220], eax
	; *t36 := t37
	mov 	ecx, DWORD PTR [ebp-216]
	mov 	eax, DWORD PTR [ebp-220]
	mov	[ecx], eax
	; t38 := (unsigned int)offset
	mov 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-224], eax
	; t39 := t38 + .integer44
	mov 	eax, DWORD PTR [ebp-224]
	add 	eax, 4
	mov 	DWORD PTR [ebp-228], eax
	; offset := (int)t39
	mov 	eax, DWORD PTR [ebp-228]
	mov 	DWORD PTR [ebp-24], eax
	; goto label11
	jmp	_call_Us0000013442E1EC50$
	; label20:
_call_Us0000013442E02A00$:
	; t40 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-232], eax
	; t41 := (unsigned short int *)t40
	mov 	eax, DWORD PTR [ebp-232]
	mov 	DWORD PTR [ebp-236], eax
	; t42 := *p
	mov 	eax, DWORD PTR [ebp-68]
	mov	ax, [eax]
	mov 	WORD PTR [ebp-238], ax
	; *t41 := t42
	mov 	ecx, DWORD PTR [ebp-236]
	mov 	ax, WORD PTR [ebp-238]
	mov	[ecx], ax
	; t43 := (unsigned int)offset
	mov 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-244], eax
	; t44 := t43 + .integer44
	mov 	eax, DWORD PTR [ebp-244]
	add 	eax, 4
	mov 	DWORD PTR [ebp-248], eax
	; offset := (int)t44
	mov 	eax, DWORD PTR [ebp-248]
	mov 	DWORD PTR [ebp-24], eax
	; goto label11
	jmp	_call_Us0000013442E1EC50$
	; label21:
_call_Us0000013442E02B80$:
	; if nth > narg goto label22
	mov 	eax, DWORD PTR [ebp+24]
	cmp	eax, DWORD PTR [ebp-20]
	jg	_call_Us0000013442E1ED10$
	; t45 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-260], eax
	; t46 := (int *)t45
	mov 	eax, DWORD PTR [ebp-260]
	mov 	DWORD PTR [ebp-264], eax
	; t47 := *p
	mov 	eax, DWORD PTR [ebp-68]
	mov	ax, [eax]
	mov 	WORD PTR [ebp-266], ax
	; t48 := (int)t47
	mov 	ax, WORD PTR [ebp-266]
	movsx	eax, ax
	mov 	DWORD PTR [ebp-272], eax
	; *t46 := t48
	mov 	ecx, DWORD PTR [ebp-264]
	mov 	eax, DWORD PTR [ebp-272]
	mov	[ecx], eax
	; goto label23
	jmp	_call_Us0000013442E1EAD0$
	; label22:
_call_Us0000013442E1ED10$:
	; t49 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-276], eax
	; t50 := (short int *)t49
	mov 	eax, DWORD PTR [ebp-276]
	mov 	DWORD PTR [ebp-280], eax
	; t51 := *p
	mov 	eax, DWORD PTR [ebp-68]
	mov	ax, [eax]
	mov 	WORD PTR [ebp-282], ax
	; *t50 := t51
	mov 	ecx, DWORD PTR [ebp-280]
	mov 	ax, WORD PTR [ebp-282]
	mov	[ecx], ax
	; label23:
_call_Us0000013442E1EAD0$:
	; t52 := (unsigned int)offset
	mov 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-252], eax
	; t53 := t52 + .integer44
	mov 	eax, DWORD PTR [ebp-252]
	add 	eax, 4
	mov 	DWORD PTR [ebp-256], eax
	; offset := (int)t53
	mov 	eax, DWORD PTR [ebp-256]
	mov 	DWORD PTR [ebp-24], eax
	; goto label11
	jmp	_call_Us0000013442E1EC50$
	; label24:
_call_Us0000013442E1EDD0$:
	; t54 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-288], eax
	; t55 := (unsigned char *)t54
	mov 	eax, DWORD PTR [ebp-288]
	mov 	DWORD PTR [ebp-292], eax
	; t56 := *p
	mov 	eax, DWORD PTR [ebp-68]
	mov	al, [eax]
	mov 	BYTE PTR [ebp-293], al
	; *t55 := t56
	mov 	ecx, DWORD PTR [ebp-292]
	mov 	al, BYTE PTR [ebp-293]
	mov	[ecx], al
	; t57 := (unsigned int)offset
	mov 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-300], eax
	; t58 := t57 + .integer44
	mov 	eax, DWORD PTR [ebp-300]
	add 	eax, 4
	mov 	DWORD PTR [ebp-304], eax
	; offset := (int)t58
	mov 	eax, DWORD PTR [ebp-304]
	mov 	DWORD PTR [ebp-24], eax
	; goto label11
	jmp	_call_Us0000013442E1EC50$
	; label25:
_call_Us0000013442E1EE90$:
	; if nth > narg goto label26
	mov 	eax, DWORD PTR [ebp+24]
	cmp	eax, DWORD PTR [ebp-20]
	jg	_call_Us0000013442E1EB90$
	; t59 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-316], eax
	; t60 := (int *)t59
	mov 	eax, DWORD PTR [ebp-316]
	mov 	DWORD PTR [ebp-320], eax
	; t61 := *p
	mov 	eax, DWORD PTR [ebp-68]
	mov	al, [eax]
	mov 	BYTE PTR [ebp-321], al
	; t62 := (int)t61
	mov 	al, BYTE PTR [ebp-321]
	movsx	eax, al
	mov 	DWORD PTR [ebp-328], eax
	; *t60 := t62
	mov 	ecx, DWORD PTR [ebp-320]
	mov 	eax, DWORD PTR [ebp-328]
	mov	[ecx], eax
	; goto label27
	jmp	_call_Us0000013442E1EF50$
	; label26:
_call_Us0000013442E1EB90$:
	; t63 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-332], eax
	; t64 := *p
	mov 	eax, DWORD PTR [ebp-68]
	mov	al, [eax]
	mov 	BYTE PTR [ebp-333], al
	; *t63 := t64
	mov 	ecx, DWORD PTR [ebp-332]
	mov 	al, BYTE PTR [ebp-333]
	mov	[ecx], al
	; label27:
_call_Us0000013442E1EF50$:
	; t65 := (unsigned int)offset
	mov 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-308], eax
	; t66 := t65 + .integer44
	mov 	eax, DWORD PTR [ebp-308]
	add 	eax, 4
	mov 	DWORD PTR [ebp-312], eax
	; offset := (int)t66
	mov 	eax, DWORD PTR [ebp-312]
	mov 	DWORD PTR [ebp-24], eax
	; goto label11
	jmp	_call_Us0000013442E1EC50$
	; label28:
_call_Us0000013442E1E050$:
	; t67 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-340], eax
	; t68 := (void **)t67
	mov 	eax, DWORD PTR [ebp-340]
	mov 	DWORD PTR [ebp-344], eax
	; t69 := *p
	mov 	eax, DWORD PTR [ebp-68]
	mov	eax, [eax]
	mov 	DWORD PTR [ebp-348], eax
	; *t68 := t69
	mov 	ecx, DWORD PTR [ebp-344]
	mov 	eax, DWORD PTR [ebp-348]
	mov	[ecx], eax
	; t70 := (unsigned int)offset
	mov 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-352], eax
	; t71 := t70 + .integer44
	mov 	eax, DWORD PTR [ebp-352]
	add 	eax, 4
	mov 	DWORD PTR [ebp-356], eax
	; offset := (int)t71
	mov 	eax, DWORD PTR [ebp-356]
	mov 	DWORD PTR [ebp-24], eax
	; goto label11
	jmp	_call_Us0000013442E1EC50$
	; label29:
_call_Us0000013442E1F010$:
	; t72 := p + 12
	mov 	eax, DWORD PTR [ebp-68]
	add 	eax, 12
	mov 	DWORD PTR [ebp-364], eax
	; size := *t72
	mov 	eax, DWORD PTR [ebp-364]
	mov	eax, [eax]
	mov 	DWORD PTR [ebp-360], eax
	; t73 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-368], eax
	; t74 := (void *)t73
	mov 	eax, DWORD PTR [ebp-368]
	mov 	DWORD PTR [ebp-372], eax
	; t75 := *p
	mov 	eax, DWORD PTR [ebp-68]
	mov	eax, [eax]
	mov 	DWORD PTR [ebp-376], eax
	; t76 := (unsigned int)size
	mov 	eax, DWORD PTR [ebp-360]
	mov 	DWORD PTR [ebp-380], eax
	; param t74
	mov 	eax, DWORD PTR [ebp-372]
	mov	DWORD PTR 0[esp], eax
	; param t75
	mov 	eax, DWORD PTR [ebp-376]
	mov	DWORD PTR 4[esp], eax
	; param t76
	mov 	eax, DWORD PTR [ebp-380]
	mov	DWORD PTR 8[esp], eax
	; call memcpy
	call	_memcpy
	; offset := offset + size
	mov 	eax, DWORD PTR [ebp-24]
	add 	eax, DWORD PTR [ebp-360]
	mov 	DWORD PTR [ebp-24], eax
	; goto label11
	jmp	_call_Us0000013442E1EC50$
	; goto label11
	jmp	_call_Us0000013442E1EC50$
	; label9:
_call_Us0000013442E1F790$:
	; if kind == 1 goto label10
	mov 	eax, DWORD PTR [ebp-72]
	cmp	eax, 1
	je	_call_Us0000013442E030C0$
	; if kind == 2 goto label12
	mov 	eax, DWORD PTR [ebp-72]
	cmp	eax, 2
	je	_call_Us0000013442E03840$
	; if kind == 3 goto label13
	mov 	eax, DWORD PTR [ebp-72]
	cmp	eax, 3
	je	_call_Us0000013442E02400$
	; if kind == 4 goto label16
	mov 	eax, DWORD PTR [ebp-72]
	cmp	eax, 4
	je	_call_Us0000013442E02E80$
	; if kind == 5 goto label17
	mov 	eax, DWORD PTR [ebp-72]
	cmp	eax, 5
	je	_call_Us0000013442E01E00$
	; if kind == 6 goto label18
	mov 	eax, DWORD PTR [ebp-72]
	cmp	eax, 6
	je	_call_Us0000013442E02580$
	; if kind == 7 goto label19
	mov 	eax, DWORD PTR [ebp-72]
	cmp	eax, 7
	je	_call_Us0000013442E024C0$
	; if kind == 8 goto label20
	mov 	eax, DWORD PTR [ebp-72]
	cmp	eax, 8
	je	_call_Us0000013442E02A00$
	; if kind == 9 goto label21
	mov 	eax, DWORD PTR [ebp-72]
	cmp	eax, 9
	je	_call_Us0000013442E02B80$
	; if kind == 10 goto label24
	mov 	eax, DWORD PTR [ebp-72]
	cmp	eax, 10
	je	_call_Us0000013442E1EDD0$
	; if kind == 11 goto label25
	mov 	eax, DWORD PTR [ebp-72]
	cmp	eax, 11
	je	_call_Us0000013442E1EE90$
	; if kind == 12 goto label28
	mov 	eax, DWORD PTR [ebp-72]
	cmp	eax, 12
	je	_call_Us0000013442E1E050$
	; if kind == 13 goto label29
	mov 	eax, DWORD PTR [ebp-72]
	cmp	eax, 13
	je	_call_Us0000013442E1F010$
	; label11:
_call_Us0000013442E1EC50$:
	; p := p + 16
	mov 	eax, DWORD PTR [ebp-68]
	add 	eax, 16
	mov 	DWORD PTR [ebp-68], eax
	; narg := narg + 1
	mov 	eax, DWORD PTR [ebp-20]
	add 	eax, 1
	mov 	DWORD PTR [ebp-20], eax
	; goto label7
	jmp	_call_Us0000013442E01B00$
	; label8:
_call_Us0000013442E03000$:
	; goto label30
	jmp	_call_Us0000013442E1F310$
	; label31:
_call_Us0000013442E1F250$:
	; label32:
_call_Us0000013442E1DA50$:
	; t77 := (void (*)(void))pf
	mov 	eax, DWORD PTR [ebp+12]
	mov 	DWORD PTR [ebp-384], eax
	; call t77
	mov 	eax, DWORD PTR [ebp-384]
	call	eax
	; goto label33
	jmp	_call_Us0000013442E1F3D0$
	; label34:
_call_Us0000013442E1DD50$:
	; t78 := r
	mov 	eax, DWORD PTR [ebp+8]
	mov 	DWORD PTR [ebp-388], eax
	; t79 := (long double (*)(void))pf
	mov 	eax, DWORD PTR [ebp+12]
	mov 	DWORD PTR [ebp-392], eax
	; t80 := call t79
	mov 	eax, DWORD PTR [ebp-392]
	call	eax
	fstp 	QWORD PTR [ebp-400]
	; *t78 := t80
	mov 	ebx, DWORD PTR [ebp-388]
	mov	eax, DWORD PTR [ebp-400]
	mov	edx, DWORD PTR [ebp-396]
	mov 	[ebx  ], eax
	mov 	[ebx+4], edx
	; goto label33
	jmp	_call_Us0000013442E1F3D0$
	; label35:
_call_Us0000013442E1DB10$:
	; t81 := r
	mov 	eax, DWORD PTR [ebp+8]
	mov 	DWORD PTR [ebp-404], eax
	; t82 := (double (*)(void))pf
	mov 	eax, DWORD PTR [ebp+12]
	mov 	DWORD PTR [ebp-408], eax
	; t83 := call t82
	mov 	eax, DWORD PTR [ebp-408]
	call	eax
	fstp 	QWORD PTR [ebp-416]
	; *t81 := t83
	mov 	ebx, DWORD PTR [ebp-404]
	mov	eax, DWORD PTR [ebp-416]
	mov	edx, DWORD PTR [ebp-412]
	mov 	[ebx  ], eax
	mov 	[ebx+4], edx
	; goto label33
	jmp	_call_Us0000013442E1F3D0$
	; label36:
_call_Us0000013442E1E350$:
	; t84 := r
	mov 	eax, DWORD PTR [ebp+8]
	mov 	DWORD PTR [ebp-420], eax
	; t85 := (float (*)(void))pf
	mov 	eax, DWORD PTR [ebp+12]
	mov 	DWORD PTR [ebp-424], eax
	; t86 := call t85
	mov 	eax, DWORD PTR [ebp-424]
	call	eax
	fstp 	DWORD PTR [ebp-428]
	; *t84 := t86
	mov 	ecx, DWORD PTR [ebp-420]
	mov 	eax, DWORD PTR [ebp-428]
	mov	[ecx], eax
	; goto label33
	jmp	_call_Us0000013442E1F3D0$
	; label37:
_call_Us0000013442E1E410$:
	; t87 := r
	mov 	eax, DWORD PTR [ebp+8]
	mov 	DWORD PTR [ebp-432], eax
	; t88 := (unsigned long long int (*)(void))pf
	mov 	eax, DWORD PTR [ebp+12]
	mov 	DWORD PTR [ebp-436], eax
	; t89 := call t88
	mov 	eax, DWORD PTR [ebp-436]
	call	eax
	mov	DWORD PTR [ebp-448], eax
	mov	DWORD PTR [ebp-444], edx
	; *t87 := t89
	mov 	ebx, DWORD PTR [ebp-432]
	mov	eax, DWORD PTR [ebp-448]
	mov	edx, DWORD PTR [ebp-444]
	mov 	[ebx  ], eax
	mov 	[ebx+4], edx
	; goto label33
	jmp	_call_Us0000013442E1F3D0$
	; goto label33
	jmp	_call_Us0000013442E1F3D0$
	; label30:
_call_Us0000013442E1F310$:
	; if rk == 0 goto label31
	mov 	eax, DWORD PTR [ebp+28]
	cmp	eax, 0
	je	_call_Us0000013442E1F250$
	; if rk == 13 goto label32
	mov 	eax, DWORD PTR [ebp+28]
	cmp	eax, 13
	je	_call_Us0000013442E1DA50$
	; if rk == 1 goto label34
	mov 	eax, DWORD PTR [ebp+28]
	cmp	eax, 1
	je	_call_Us0000013442E1DD50$
	; if rk == 2 goto label35
	mov 	eax, DWORD PTR [ebp+28]
	cmp	eax, 2
	je	_call_Us0000013442E1DB10$
	; if rk == 3 goto label36
	mov 	eax, DWORD PTR [ebp+28]
	cmp	eax, 3
	je	_call_Us0000013442E1E350$
	; goto label37
	jmp	_call_Us0000013442E1E410$
	; label33:
_call_Us0000013442E1F3D0$:
	; leave
	mov 	esp, ebp
	leave
	ret
_call_Us	ENDP
_TEXT ENDS
EXTERN _memcpy:PROC
END
