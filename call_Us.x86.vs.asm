	.model	flat
_TEXT SEGMENT
_add_size	PROC
	; enter
	push 	ebp
	push	ebx
	mov 	ebp, esp
	sub 	esp, 36
	; t0 := p + 12
	mov 	eax, DWORD PTR [ebp+16]
	add 	eax, 12
	mov 	DWORD PTR [ebp-8], eax
	; t1 := *t0
	mov 	eax, DWORD PTR [ebp-8]
	mov	eax, [eax]
	mov 	DWORD PTR [ebp-12], eax
	; t2 := n + t1
	mov 	eax, DWORD PTR [ebp+12]
	add 	eax, DWORD PTR [ebp-12]
	mov 	DWORD PTR [ebp-16], eax
	; return t2
	mov 	eax, DWORD PTR [ebp-16]
	; leave
	mov 	esp, ebp
	pop	ebx
	pop	ebp
	ret
_add_size	ENDP
_TEXT ENDS
_TEXT SEGMENT
_wa_for_delta	PROC
	; enter
	push 	ebp
	push	ebx
	mov 	ebp, esp
	sub 	esp, 20
	; t3 := n + 3
	mov 	eax, DWORD PTR [ebp+12]
	add 	eax, 3
	mov 	DWORD PTR [ebp-8], eax
	; return t3
	mov 	eax, DWORD PTR [ebp-8]
	; leave
	mov 	esp, ebp
	pop	ebx
	pop	ebp
	ret
_wa_for_delta	ENDP
_TEXT ENDS
_TEXT SEGMENT
	PUBLIC	_call_Us
_call_Us	PROC
	; enter
	push 	ebp
	push	ebx
	mov 	ebp, esp
	sub 	esp, 468
	; rvp := *r
	mov 	eax, DWORD PTR [ebp+12]
	mov	eax, [eax]
	mov 	DWORD PTR [ebp-28], eax
	; if rvp == .pointer16 goto label0
	mov 	eax, DWORD PTR [ebp-28]
	cmp	eax, 0
	je	_call_Us00240460$
	; t4 := 4
	mov	eax, 4
	mov 	DWORD PTR [ebp-32], eax
	; goto label1
	jmp	_call_Us002404D0$
	; label0:
_call_Us00240460$:
	; t4 := 0
	mov	eax, 0
	mov 	DWORD PTR [ebp-32], eax
	; label1:
_call_Us002404D0$:
	; offset := t4
	mov 	eax, DWORD PTR [ebp-32]
	mov 	DWORD PTR [ebp-24], eax
	; n := t4
	mov 	eax, DWORD PTR [ebp-32]
	mov 	DWORD PTR [ebp-48], eax
	; p := begin
	mov 	eax, DWORD PTR [ebp+20]
	mov 	DWORD PTR [ebp-60], eax
	; end := end
	mov 	eax, DWORD PTR [ebp+24]
	mov 	DWORD PTR [ebp-44], eax
	; add := &add_size
	lea 	ebx, _add_size
	mov 	DWORD PTR [ebp-52], ebx
	; label2:
_call_Us00241548$:
	; if p == end goto label3
	mov 	eax, DWORD PTR [ebp-60]
	cmp	eax, DWORD PTR [ebp-44]
	je	_call_Us002415B8$
	; param n
	mov 	eax, DWORD PTR [ebp-48]
	mov	DWORD PTR 0[esp], eax
	; param p
	mov 	eax, DWORD PTR [ebp-60]
	mov	DWORD PTR 4[esp], eax
	; t5 := call add
	mov 	eax, DWORD PTR [ebp-52]
	call	eax
	mov 	DWORD PTR [ebp-64], eax
	; n := t5
	mov 	eax, DWORD PTR [ebp-64]
	mov 	DWORD PTR [ebp-48], eax
	; p := p + 16
	mov 	eax, DWORD PTR [ebp-60]
	add 	eax, 16
	mov 	DWORD PTR [ebp-60], eax
	; goto label2
	jmp	_call_Us00241548$
	; label3:
_call_Us002415B8$:
	; t6 := n
	mov 	eax, DWORD PTR [ebp-48]
	mov 	DWORD PTR [ebp-56], eax
	; goto label4
	jmp	_call_Us00241628$
	; label4:
_call_Us00241628$:
	; delta := t6
	mov 	eax, DWORD PTR [ebp-56]
	mov 	DWORD PTR [ebp-8], eax
	; n := t6 & 15
	mov 	eax, DWORD PTR [ebp-56]
	and 	eax, 15
	mov 	DWORD PTR [ebp-16], eax
	; if n == 0 goto label5
	mov 	eax, DWORD PTR [ebp-16]
	cmp	eax, 0
	je	_call_Us00242DF0$
	; t7 := 16 - n
	mov	eax, 16
	sub 	eax, DWORD PTR [ebp-16]
	mov 	DWORD PTR [ebp-36], eax
	; delta := delta + t7
	mov 	eax, DWORD PTR [ebp-8]
	add 	eax, DWORD PTR [ebp-36]
	mov 	DWORD PTR [ebp-8], eax
	; label5:
_call_Us00242DF0$:
	; param delta
	mov 	eax, DWORD PTR [ebp-8]
	mov	DWORD PTR 0[esp], eax
	; call wa_for_delta
	call	_wa_for_delta
	; asm "mov	eax, DWORD PTR [ebp-8]"
	mov	eax, DWORD PTR [ebp-8]
	; asm "sub	esp, eax"
	sub	esp, eax
	; asm "mov	DWORD PTR [ebp-12], esp"
	mov	DWORD PTR [ebp-12], esp
	; if rvp == .pointer16 goto label6
	mov 	eax, DWORD PTR [ebp-28]
	cmp	eax, 0
	je	_call_Us00242B50$
	; t8 := (void **)esp
	mov 	eax, DWORD PTR [ebp-12]
	mov 	DWORD PTR [ebp-40], eax
	; *t8 := rvp
	mov 	ecx, DWORD PTR [ebp-40]
	mov 	eax, DWORD PTR [ebp-28]
	mov	[ecx], eax
	; label6:
_call_Us00242B50$:
	; narg := 0
	mov	eax, 0
	mov 	DWORD PTR [ebp-20], eax
	; p := begin
	mov 	eax, DWORD PTR [ebp+20]
	mov 	DWORD PTR [ebp-68], eax
	; label7:
_call_Us00242A70$:
	; if p == end goto label8
	mov 	eax, DWORD PTR [ebp-68]
	cmp	eax, DWORD PTR [ebp+24]
	je	_call_Us00242BC0$
	; t9 := p + 8
	mov 	eax, DWORD PTR [ebp-68]
	add 	eax, 8
	mov 	DWORD PTR [ebp-76], eax
	; kind := *t9
	mov 	eax, DWORD PTR [ebp-76]
	mov	eax, [eax]
	mov 	DWORD PTR [ebp-72], eax
	; goto label9
	jmp	_call_Us0025B790$
	; label10:
_call_Us00242840$:
	; t10 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-80], eax
	; t11 := (long double *)t10
	mov 	eax, DWORD PTR [ebp-80]
	mov 	DWORD PTR [ebp-84], eax
	; t12 := *p
	mov 	eax, DWORD PTR [ebp-68]
	fld	QWORD PTR [eax]
	fstp 	QWORD PTR [ebp-96]
	; *t11 := t12
	mov 	ebx, DWORD PTR [ebp-84]
	mov	eax, DWORD PTR [ebp-96]
	mov	edx, DWORD PTR [ebp-92]
	mov 	[ebx  ], eax
	mov 	[ebx+4], edx
	; t13 := (unsigned int)offset
	mov 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-100], eax
	; t14 := t13 + .integer43
	mov 	eax, DWORD PTR [ebp-100]
	add 	eax, 8
	mov 	DWORD PTR [ebp-104], eax
	; offset := (int)t14
	mov 	eax, DWORD PTR [ebp-104]
	mov 	DWORD PTR [ebp-24], eax
	; goto label11
	jmp	_call_Us0025AE60$
	; label12:
_call_Us002428B0$:
	; t15 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-108], eax
	; t16 := (double *)t15
	mov 	eax, DWORD PTR [ebp-108]
	mov 	DWORD PTR [ebp-112], eax
	; t17 := *p
	mov 	eax, DWORD PTR [ebp-68]
	fld	QWORD PTR [eax]
	fstp 	QWORD PTR [ebp-120]
	; *t16 := t17
	mov 	ebx, DWORD PTR [ebp-112]
	mov	eax, DWORD PTR [ebp-120]
	mov	edx, DWORD PTR [ebp-116]
	mov 	[ebx  ], eax
	mov 	[ebx+4], edx
	; t18 := (unsigned int)offset
	mov 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-124], eax
	; t19 := t18 + .integer43
	mov 	eax, DWORD PTR [ebp-124]
	add 	eax, 8
	mov 	DWORD PTR [ebp-128], eax
	; offset := (int)t19
	mov 	eax, DWORD PTR [ebp-128]
	mov 	DWORD PTR [ebp-24], eax
	; goto label11
	jmp	_call_Us0025AE60$
	; label13:
_call_Us00242AE0$:
	; if nth > narg goto label14
	mov 	eax, DWORD PTR [ebp+28]
	cmp	eax, DWORD PTR [ebp-20]
	jg	_call_Us00242E60$
	; t20 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-132], eax
	; t21 := (double *)t20
	mov 	eax, DWORD PTR [ebp-132]
	mov 	DWORD PTR [ebp-136], eax
	; t22 := *p
	mov 	eax, DWORD PTR [ebp-68]
	fld	DWORD PTR [eax]
	fstp 	DWORD PTR [ebp-140]
	; t23 := (double)t22
	fld	DWORD PTR [ebp-140]
	fstp 	QWORD PTR [ebp-152]
	; *t21 := t23
	mov 	ebx, DWORD PTR [ebp-136]
	mov	eax, DWORD PTR [ebp-152]
	mov	edx, DWORD PTR [ebp-148]
	mov 	[ebx  ], eax
	mov 	[ebx+4], edx
	; t24 := (unsigned int)offset
	mov 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-156], eax
	; t25 := t24 + .integer43
	mov 	eax, DWORD PTR [ebp-156]
	add 	eax, 8
	mov 	DWORD PTR [ebp-160], eax
	; offset := (int)t25
	mov 	eax, DWORD PTR [ebp-160]
	mov 	DWORD PTR [ebp-24], eax
	; goto label15
	jmp	_call_Us00242990$
	; label14:
_call_Us00242E60$:
	; t26 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-164], eax
	; t27 := (float *)t26
	mov 	eax, DWORD PTR [ebp-164]
	mov 	DWORD PTR [ebp-168], eax
	; t28 := *p
	mov 	eax, DWORD PTR [ebp-68]
	fld	DWORD PTR [eax]
	fstp 	DWORD PTR [ebp-172]
	; *t27 := t28
	mov 	ecx, DWORD PTR [ebp-168]
	mov 	eax, DWORD PTR [ebp-172]
	mov	[ecx], eax
	; t29 := (unsigned int)offset
	mov 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-176], eax
	; t30 := t29 + .integer44
	mov 	eax, DWORD PTR [ebp-176]
	add 	eax, 4
	mov 	DWORD PTR [ebp-180], eax
	; offset := (int)t30
	mov 	eax, DWORD PTR [ebp-180]
	mov 	DWORD PTR [ebp-24], eax
	; label15:
_call_Us00242990$:
	; goto label11
	jmp	_call_Us0025AE60$
	; label16:
_call_Us00242D10$:
	; label17:
_call_Us00242A00$:
	; t31 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-184], eax
	; t32 := (unsigned long long int *)t31
	mov 	eax, DWORD PTR [ebp-184]
	mov 	DWORD PTR [ebp-188], eax
	; t33 := *p
	mov 	eax, DWORD PTR [ebp-68]
	mov	edx, [eax+4]
	mov	eax, [eax]
	mov	DWORD PTR [ebp-200], eax
	mov	DWORD PTR [ebp-196], edx
	; *t32 := t33
	mov 	ebx, DWORD PTR [ebp-188]
	mov	eax, DWORD PTR [ebp-200]
	mov	edx, DWORD PTR [ebp-196]
	mov 	[ebx  ], eax
	mov 	[ebx+4], edx
	; t34 := (unsigned int)offset
	mov 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-204], eax
	; t35 := t34 + .integer43
	mov 	eax, DWORD PTR [ebp-204]
	add 	eax, 8
	mov 	DWORD PTR [ebp-208], eax
	; offset := (int)t35
	mov 	eax, DWORD PTR [ebp-208]
	mov 	DWORD PTR [ebp-24], eax
	; goto label11
	jmp	_call_Us0025AE60$
	; label18:
_call_Us00242C30$:
	; label19:
_call_Us00242CA0$:
	; t36 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-212], eax
	; t37 := (unsigned int *)t36
	mov 	eax, DWORD PTR [ebp-212]
	mov 	DWORD PTR [ebp-216], eax
	; t38 := *p
	mov 	eax, DWORD PTR [ebp-68]
	mov	eax, [eax]
	mov 	DWORD PTR [ebp-220], eax
	; *t37 := t38
	mov 	ecx, DWORD PTR [ebp-216]
	mov 	eax, DWORD PTR [ebp-220]
	mov	[ecx], eax
	; t39 := (unsigned int)offset
	mov 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-224], eax
	; t40 := t39 + .integer44
	mov 	eax, DWORD PTR [ebp-224]
	add 	eax, 4
	mov 	DWORD PTR [ebp-228], eax
	; offset := (int)t40
	mov 	eax, DWORD PTR [ebp-228]
	mov 	DWORD PTR [ebp-24], eax
	; goto label11
	jmp	_call_Us0025AE60$
	; label20:
_call_Us00242D80$:
	; t41 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-232], eax
	; t42 := (unsigned short int *)t41
	mov 	eax, DWORD PTR [ebp-232]
	mov 	DWORD PTR [ebp-236], eax
	; t43 := *p
	mov 	eax, DWORD PTR [ebp-68]
	mov	ax, [eax]
	mov 	WORD PTR [ebp-238], ax
	; *t42 := t43
	mov 	ecx, DWORD PTR [ebp-236]
	mov 	ax, WORD PTR [ebp-238]
	mov	[ecx], ax
	; t44 := (unsigned int)offset
	mov 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-244], eax
	; t45 := t44 + .integer44
	mov 	eax, DWORD PTR [ebp-244]
	add 	eax, 4
	mov 	DWORD PTR [ebp-248], eax
	; offset := (int)t45
	mov 	eax, DWORD PTR [ebp-248]
	mov 	DWORD PTR [ebp-24], eax
	; goto label11
	jmp	_call_Us0025AE60$
	; label21:
_call_Us00242ED0$:
	; if nth > narg goto label22
	mov 	eax, DWORD PTR [ebp+28]
	cmp	eax, DWORD PTR [ebp-20]
	jg	_call_Us00242F40$
	; t46 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-260], eax
	; t47 := (int *)t46
	mov 	eax, DWORD PTR [ebp-260]
	mov 	DWORD PTR [ebp-264], eax
	; t48 := *p
	mov 	eax, DWORD PTR [ebp-68]
	mov	ax, [eax]
	mov 	WORD PTR [ebp-266], ax
	; t49 := (int)t48
	mov 	ax, WORD PTR [ebp-266]
	movsx	eax, ax
	mov 	DWORD PTR [ebp-272], eax
	; *t47 := t49
	mov 	ecx, DWORD PTR [ebp-264]
	mov 	eax, DWORD PTR [ebp-272]
	mov	[ecx], eax
	; goto label23
	jmp	_call_Us00242FB0$
	; label22:
_call_Us00242F40$:
	; t50 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-276], eax
	; t51 := (short int *)t50
	mov 	eax, DWORD PTR [ebp-276]
	mov 	DWORD PTR [ebp-280], eax
	; t52 := *p
	mov 	eax, DWORD PTR [ebp-68]
	mov	ax, [eax]
	mov 	WORD PTR [ebp-282], ax
	; *t51 := t52
	mov 	ecx, DWORD PTR [ebp-280]
	mov 	ax, WORD PTR [ebp-282]
	mov	[ecx], ax
	; label23:
_call_Us00242FB0$:
	; t53 := (unsigned int)offset
	mov 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-252], eax
	; t54 := t53 + .integer44
	mov 	eax, DWORD PTR [ebp-252]
	add 	eax, 4
	mov 	DWORD PTR [ebp-256], eax
	; offset := (int)t54
	mov 	eax, DWORD PTR [ebp-256]
	mov 	DWORD PTR [ebp-24], eax
	; goto label11
	jmp	_call_Us0025AE60$
	; label24:
_call_Us0025BA30$:
	; t55 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-288], eax
	; t56 := (unsigned char *)t55
	mov 	eax, DWORD PTR [ebp-288]
	mov 	DWORD PTR [ebp-292], eax
	; t57 := *p
	mov 	eax, DWORD PTR [ebp-68]
	mov	al, [eax]
	mov 	BYTE PTR [ebp-293], al
	; *t56 := t57
	mov 	ecx, DWORD PTR [ebp-292]
	mov 	al, BYTE PTR [ebp-293]
	mov	[ecx], al
	; t58 := (unsigned int)offset
	mov 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-300], eax
	; t59 := t58 + .integer44
	mov 	eax, DWORD PTR [ebp-300]
	add 	eax, 4
	mov 	DWORD PTR [ebp-304], eax
	; offset := (int)t59
	mov 	eax, DWORD PTR [ebp-304]
	mov 	DWORD PTR [ebp-24], eax
	; goto label11
	jmp	_call_Us0025AE60$
	; label25:
_call_Us0025B950$:
	; if nth > narg goto label26
	mov 	eax, DWORD PTR [ebp+28]
	cmp	eax, DWORD PTR [ebp-20]
	jg	_call_Us0025B9C0$
	; t60 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-316], eax
	; t61 := (int *)t60
	mov 	eax, DWORD PTR [ebp-316]
	mov 	DWORD PTR [ebp-320], eax
	; t62 := *p
	mov 	eax, DWORD PTR [ebp-68]
	mov	al, [eax]
	mov 	BYTE PTR [ebp-321], al
	; t63 := (int)t62
	mov 	al, BYTE PTR [ebp-321]
	movsx	eax, al
	mov 	DWORD PTR [ebp-328], eax
	; *t61 := t63
	mov 	ecx, DWORD PTR [ebp-320]
	mov 	eax, DWORD PTR [ebp-328]
	mov	[ecx], eax
	; goto label27
	jmp	_call_Us0025BAA0$
	; label26:
_call_Us0025B9C0$:
	; t64 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-332], eax
	; t65 := *p
	mov 	eax, DWORD PTR [ebp-68]
	mov	al, [eax]
	mov 	BYTE PTR [ebp-333], al
	; *t64 := t65
	mov 	ecx, DWORD PTR [ebp-332]
	mov 	al, BYTE PTR [ebp-333]
	mov	[ecx], al
	; label27:
_call_Us0025BAA0$:
	; t66 := (unsigned int)offset
	mov 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-308], eax
	; t67 := t66 + .integer44
	mov 	eax, DWORD PTR [ebp-308]
	add 	eax, 4
	mov 	DWORD PTR [ebp-312], eax
	; offset := (int)t67
	mov 	eax, DWORD PTR [ebp-312]
	mov 	DWORD PTR [ebp-24], eax
	; goto label11
	jmp	_call_Us0025AE60$
	; label28:
_call_Us0025AFB0$:
	; t68 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-340], eax
	; t69 := (void **)t68
	mov 	eax, DWORD PTR [ebp-340]
	mov 	DWORD PTR [ebp-344], eax
	; t70 := *p
	mov 	eax, DWORD PTR [ebp-68]
	mov	eax, [eax]
	mov 	DWORD PTR [ebp-348], eax
	; *t69 := t70
	mov 	ecx, DWORD PTR [ebp-344]
	mov 	eax, DWORD PTR [ebp-348]
	mov	[ecx], eax
	; t71 := (unsigned int)offset
	mov 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-352], eax
	; t72 := t71 + .integer44
	mov 	eax, DWORD PTR [ebp-352]
	add 	eax, 4
	mov 	DWORD PTR [ebp-356], eax
	; offset := (int)t72
	mov 	eax, DWORD PTR [ebp-356]
	mov 	DWORD PTR [ebp-24], eax
	; goto label11
	jmp	_call_Us0025AE60$
	; label29:
_call_Us0025B4F0$:
	; t73 := p + 12
	mov 	eax, DWORD PTR [ebp-68]
	add 	eax, 12
	mov 	DWORD PTR [ebp-364], eax
	; size := *t73
	mov 	eax, DWORD PTR [ebp-364]
	mov	eax, [eax]
	mov 	DWORD PTR [ebp-360], eax
	; t74 := esp + offset
	mov 	eax, DWORD PTR [ebp-12]
	add 	eax, DWORD PTR [ebp-24]
	mov 	DWORD PTR [ebp-368], eax
	; t75 := (void *)t74
	mov 	eax, DWORD PTR [ebp-368]
	mov 	DWORD PTR [ebp-372], eax
	; t76 := *p
	mov 	eax, DWORD PTR [ebp-68]
	mov	eax, [eax]
	mov 	DWORD PTR [ebp-376], eax
	; t77 := (unsigned int)size
	mov 	eax, DWORD PTR [ebp-360]
	mov 	DWORD PTR [ebp-380], eax
	; param t75
	mov 	eax, DWORD PTR [ebp-372]
	mov	DWORD PTR 0[esp], eax
	; param t76
	mov 	eax, DWORD PTR [ebp-376]
	mov	DWORD PTR 4[esp], eax
	; param t77
	mov 	eax, DWORD PTR [ebp-380]
	mov	DWORD PTR 8[esp], eax
	; call memcpy
	call	_memcpy
	; offset := offset + size
	mov 	eax, DWORD PTR [ebp-24]
	add 	eax, DWORD PTR [ebp-360]
	mov 	DWORD PTR [ebp-24], eax
	; goto label11
	jmp	_call_Us0025AE60$
	; goto label11
	jmp	_call_Us0025AE60$
	; label9:
_call_Us0025B790$:
	; if kind == 1 goto label10
	mov 	eax, DWORD PTR [ebp-72]
	cmp	eax, 1
	je	_call_Us00242840$
	; if kind == 2 goto label12
	mov 	eax, DWORD PTR [ebp-72]
	cmp	eax, 2
	je	_call_Us002428B0$
	; if kind == 3 goto label13
	mov 	eax, DWORD PTR [ebp-72]
	cmp	eax, 3
	je	_call_Us00242AE0$
	; if kind == 4 goto label16
	mov 	eax, DWORD PTR [ebp-72]
	cmp	eax, 4
	je	_call_Us00242D10$
	; if kind == 5 goto label17
	mov 	eax, DWORD PTR [ebp-72]
	cmp	eax, 5
	je	_call_Us00242A00$
	; if kind == 6 goto label18
	mov 	eax, DWORD PTR [ebp-72]
	cmp	eax, 6
	je	_call_Us00242C30$
	; if kind == 7 goto label19
	mov 	eax, DWORD PTR [ebp-72]
	cmp	eax, 7
	je	_call_Us00242CA0$
	; if kind == 8 goto label20
	mov 	eax, DWORD PTR [ebp-72]
	cmp	eax, 8
	je	_call_Us00242D80$
	; if kind == 9 goto label21
	mov 	eax, DWORD PTR [ebp-72]
	cmp	eax, 9
	je	_call_Us00242ED0$
	; if kind == 10 goto label24
	mov 	eax, DWORD PTR [ebp-72]
	cmp	eax, 10
	je	_call_Us0025BA30$
	; if kind == 11 goto label25
	mov 	eax, DWORD PTR [ebp-72]
	cmp	eax, 11
	je	_call_Us0025B950$
	; if kind == 12 goto label28
	mov 	eax, DWORD PTR [ebp-72]
	cmp	eax, 12
	je	_call_Us0025AFB0$
	; if kind == 13 goto label29
	mov 	eax, DWORD PTR [ebp-72]
	cmp	eax, 13
	je	_call_Us0025B4F0$
	; label11:
_call_Us0025AE60$:
	; p := p + 16
	mov 	eax, DWORD PTR [ebp-68]
	add 	eax, 16
	mov 	DWORD PTR [ebp-68], eax
	; narg := narg + 1
	mov 	eax, DWORD PTR [ebp-20]
	add 	eax, 1
	mov 	DWORD PTR [ebp-20], eax
	; goto label7
	jmp	_call_Us00242A70$
	; label8:
_call_Us00242BC0$:
	; goto label30
	jmp	_call_Us0025ABC0$
	; label31:
_call_Us0025B090$:
	; label32:
_call_Us0025B480$:
	; t78 := (void (*)(void))pf
	mov 	eax, DWORD PTR [ebp+16]
	mov 	DWORD PTR [ebp-384], eax
	; call t78
	mov 	eax, DWORD PTR [ebp-384]
	call	eax
	; goto label33
	jmp	_call_Us0025AC30$
	; label34:
_call_Us0025B5D0$:
	; t79 := r
	mov 	eax, DWORD PTR [ebp+12]
	mov 	DWORD PTR [ebp-388], eax
	; t80 := (long double (*)(void))pf
	mov 	eax, DWORD PTR [ebp+16]
	mov 	DWORD PTR [ebp-392], eax
	; t81 := call t80
	mov 	eax, DWORD PTR [ebp-392]
	call	eax
	fstp 	QWORD PTR [ebp-400]
	; *t79 := t81
	mov 	ebx, DWORD PTR [ebp-388]
	mov	eax, DWORD PTR [ebp-400]
	mov	edx, DWORD PTR [ebp-396]
	mov 	[ebx  ], eax
	mov 	[ebx+4], edx
	; goto label33
	jmp	_call_Us0025AC30$
	; label35:
_call_Us0025B870$:
	; t82 := r
	mov 	eax, DWORD PTR [ebp+12]
	mov 	DWORD PTR [ebp-404], eax
	; t83 := (double (*)(void))pf
	mov 	eax, DWORD PTR [ebp+16]
	mov 	DWORD PTR [ebp-408], eax
	; t84 := call t83
	mov 	eax, DWORD PTR [ebp-408]
	call	eax
	fstp 	QWORD PTR [ebp-416]
	; *t82 := t84
	mov 	ebx, DWORD PTR [ebp-404]
	mov	eax, DWORD PTR [ebp-416]
	mov	edx, DWORD PTR [ebp-412]
	mov 	[ebx  ], eax
	mov 	[ebx+4], edx
	; goto label33
	jmp	_call_Us0025AC30$
	; label36:
_call_Us0025B560$:
	; t85 := r
	mov 	eax, DWORD PTR [ebp+12]
	mov 	DWORD PTR [ebp-420], eax
	; t86 := (float (*)(void))pf
	mov 	eax, DWORD PTR [ebp+16]
	mov 	DWORD PTR [ebp-424], eax
	; t87 := call t86
	mov 	eax, DWORD PTR [ebp-424]
	call	eax
	fstp 	DWORD PTR [ebp-428]
	; *t85 := t87
	mov 	ecx, DWORD PTR [ebp-420]
	mov 	eax, DWORD PTR [ebp-428]
	mov	[ecx], eax
	; goto label33
	jmp	_call_Us0025AC30$
	; label37:
_call_Us0025B6B0$:
	; t88 := r
	mov 	eax, DWORD PTR [ebp+12]
	mov 	DWORD PTR [ebp-432], eax
	; t89 := (unsigned long long int (*)(void))pf
	mov 	eax, DWORD PTR [ebp+16]
	mov 	DWORD PTR [ebp-436], eax
	; t90 := call t89
	mov 	eax, DWORD PTR [ebp-436]
	call	eax
	mov	DWORD PTR [ebp-448], eax
	mov	DWORD PTR [ebp-444], edx
	; *t88 := t90
	mov 	ebx, DWORD PTR [ebp-432]
	mov	eax, DWORD PTR [ebp-448]
	mov	edx, DWORD PTR [ebp-444]
	mov 	[ebx  ], eax
	mov 	[ebx+4], edx
	; goto label33
	jmp	_call_Us0025AC30$
	; goto label33
	jmp	_call_Us0025AC30$
	; label30:
_call_Us0025ABC0$:
	; if rk == 0 goto label31
	mov 	eax, DWORD PTR [ebp+32]
	cmp	eax, 0
	je	_call_Us0025B090$
	; if rk == 13 goto label32
	mov 	eax, DWORD PTR [ebp+32]
	cmp	eax, 13
	je	_call_Us0025B480$
	; if rk == 1 goto label34
	mov 	eax, DWORD PTR [ebp+32]
	cmp	eax, 1
	je	_call_Us0025B5D0$
	; if rk == 2 goto label35
	mov 	eax, DWORD PTR [ebp+32]
	cmp	eax, 2
	je	_call_Us0025B870$
	; if rk == 3 goto label36
	mov 	eax, DWORD PTR [ebp+32]
	cmp	eax, 3
	je	_call_Us0025B560$
	; goto label37
	jmp	_call_Us0025B6B0$
	; label33:
_call_Us0025AC30$:
	; leave
	mov 	esp, ebp
	pop	ebx
	pop	ebp
	ret
_call_Us	ENDP
_TEXT ENDS
EXTERN _memcpy:PROC
END
