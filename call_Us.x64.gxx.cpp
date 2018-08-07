typedef unsigned long long int uint64_t;
typedef long long int int64_t;
typedef unsigned int uint32_t;
typedef int int32_t;
typedef unsigned short int uint16_t;
typedef short int int16_t;
typedef unsigned char uint8_t;
typedef char int8_t;

union U {
  long double ld; double d; float f;
  uint64_t u64; int64_t s64;
  uint32_t u32; int32_t s32;
  uint16_t u16; int16_t s16;
  uint8_t u8; int8_t s8;
  void* vp;
};

enum kind_t {
  NONE, LD, DOUBLE, FLOAT, U64, S64, U32, S32, U16, S16, U8, S8, VP, REC
};

struct uks {
  union U m_u;
  enum kind_t kind;
  int m_size;
};

static void
call_Us_subr(struct uks* p, int nth, int narg, int big, union U* xmm, int* xmm_flt, union U* gpr1, union U* gpr2, long double* tmp)
{
  enum kind_t kind = p->kind;
  switch (kind) {
  case LD:
    *tmp = p->m_u.ld;
    if (big)
      gpr2->vp = tmp;
    else
      gpr1->vp = tmp;
    break;
  case DOUBLE:
  case FLOAT:
    if (nth <= narg) {
      double d = kind == FLOAT ? (double)p->m_u.f : p->m_u.d;
      xmm->d = d;
      *xmm_flt = 0;
      if (big)
	gpr2->d = d;
      else
	gpr1->d = d;
    }
    else {
      if (kind == FLOAT){
        xmm->f = p->m_u.f;
	*xmm_flt = 1;
      }
      else {
        xmm->d = p->m_u.d;
	*xmm_flt = 0;
      }
    }
    break;
  case U64: case S64:
    if (big)
      gpr2->u64 = p->m_u.u64;
    else
      gpr1->u64 = p->m_u.u64;
    break;
  case U32: case S32:
    if (big)
      gpr2->u32 = p->m_u.u32;
    else
      gpr1->u32 = p->m_u.u32;
    break;
  case U16:
    if (big)
      gpr2->u16 = p->m_u.u16;
    else
      gpr1->u16 = p->m_u.u16;
    break;
  case S16:
    if ( nth <= narg ) {
      if (big)
	gpr2->s32 = p->m_u.s16;
      else
	gpr1->s32 = p->m_u.s16;
    }
    else {
      if (big)
	gpr2->s16 = p->m_u.s16;
      else
	gpr1->s16 = p->m_u.s16;
    }
    break;
  case U8:
    if (big)
      gpr2->u8 = p->m_u.u8;
    else
      gpr1->u8 = p->m_u.u8;
    break;
  case S8:
    if ( nth <= narg ){
      if (big)
	gpr2->s32 = p->m_u.s8;
      else
	gpr1->s32 = p->m_u.s8;
    }
    else {
      if (big)
	gpr2->s8 = p->m_u.s8;
      else
	gpr1->s8 = p->m_u.s8;
    }
    break;
  case VP: case REC:
    if (big)
      gpr2->vp = p->m_u.vp;
    else
      gpr1->vp = p->m_u.vp;
    break;
  }
}


union U RCX_REG, RDX_REG, R8_REG, R9_REG;
union U XMM0_REG, XMM1_REG, XMM2_REG, XMM3_REG;
int     XMM0_FLT, XMM1_FLT, XMM2_FLT, XMM3_FLT;
union U NOTREF;

extern "C" void
call_Us(union U* r, void* pf, struct uks* begin, struct uks* end,
	int nth, enum kind_t rk)
{
  RCX_REG.ld = RDX_REG.ld = R8_REG.ld = R9_REG.ld =
  XMM0_REG.ld = XMM1_REG.ld = XMM2_REG.ld = XMM3_REG.ld = 0;
  XMM0_FLT = XMM1_FLT = XMM2_FLT = XMM3_FLT = 0;
  
  long int N = end - begin;
  long double tmp[N];  
  long int delta = (N&1) ? ((N+1)*8) : (N*8);
  asm("subq	%0, %%rsp" : :"r"(delta));
  void* rvp = r->vp;
  if (rvp)
    RCX_REG.vp = rvp;
  else if (rk == LD)
    RCX_REG.vp = &r->ld;

  struct uks* p = begin;
  int narg = 0;
  int big = rvp || rk == LD;
  if ( p == end ) goto LAST;
  call_Us_subr(p,nth,narg,big,&XMM0_REG,&XMM0_FLT,&RCX_REG,&RDX_REG,&tmp[narg]); 

  if ( (++narg,++p) == end ) goto LAST;
  call_Us_subr(p,nth,narg,big,&XMM1_REG,&XMM1_FLT,&RDX_REG,&R8_REG,&tmp[narg]);

  if ( (++narg,++p) == end ) goto LAST;
  call_Us_subr(p,nth,narg,big,&XMM2_REG,&XMM2_FLT,&R8_REG,&R9_REG,&tmp[narg]);

  if ( (++narg,++p) == end ) goto LAST;
  if ( !big ){
    call_Us_subr(p,nth,narg,big,&XMM3_REG,&XMM3_FLT,&R9_REG,&NOTREF,&tmp[narg]);
    ++narg,++p;
  }

  char* rsp;
  asm("mov	%%rsp, %0": "=r"(rsp));
  for ( uint64_t offset = 32 ; p != end ; ++p, ++narg, offset += 8 ){
    enum kind_t kind = p->kind;
    switch ( kind ){
    case LD:
      tmp[narg] = p->m_u.ld;
      *(long double**)(rsp+offset) = &tmp[narg];
      break;
    case DOUBLE:
      *(double*)(rsp+offset) = p->m_u.d;
      break;
    case FLOAT:
      if ( nth <= narg )
	*(double*)(rsp+offset) = p->m_u.f;
      else
	*(float*)(rsp+offset) = p->m_u.f;
      break;
    case U64: case S64:
      *(uint64_t*)(rsp+offset) = p->m_u.u64;
      break;
    case U32: case S32:
      *(uint32_t*)(rsp+offset) = p->m_u.u32;
      break;
    case U16:
      *(uint16_t*)(rsp+offset) = p->m_u.u16;
      break;
    case S16:
      if ( nth <= narg )
	*(int*)(rsp+offset) = p->m_u.s16;
      else
	*(int16_t*)(rsp+offset) = p->m_u.s16;
      break;
    case U8:
      *(uint8_t*)(rsp+offset) = p->m_u.u8;
      break;
    case S8:
      if ( nth <= narg )
	*(int*)(rsp+offset) = p->m_u.s8;
      else
	*(int8_t*)(rsp+offset) = p->m_u.s8;
      break;
    case VP: case REC:
      *(void**)(rsp+offset) = p->m_u.vp;
      break;
    }
  }
 LAST:

#define SET_REG_MACRO \
  if (XMM0_FLT) \
    asm("movss XMM0_REG(%rip), %xmm0"); \
  else \
    asm("movsd XMM0_REG(%rip), %xmm0"); \
  if (XMM1_FLT) \
    asm("movss XMM1_REG(%rip), %xmm1"); \
  else \
    asm("movsd XMM1_REG(%rip), %xmm1"); \
  if (XMM2_FLT) \
    asm("movss XMM2_REG(%rip), %xmm2"); \
  else \
    asm("movsd XMM2_REG(%rip), %xmm2"); \
  if (XMM3_FLT) \
    asm("movss XMM3_REG(%rip), %xmm3"); \
  else \
    asm("movsd XMM3_REG(%rip), %xmm3"); \
  asm("mov	RCX_REG(%rip), %rcx"); \
  asm("mov	RDX_REG(%rip), %rdx"); \
  asm("mov	R8_REG(%rip), %r8"); \
  asm("mov	R9_REG(%rip), %r9")
  
  switch ( rk ){
  case NONE: case LD: case REC:
    SET_REG_MACRO;
    ((void (*)())pf)();
    break;
  case DOUBLE:
    SET_REG_MACRO;    
    r->d = ((double (*)())pf)();
    break;
  case FLOAT:
    SET_REG_MACRO;    
    r->f = ((float (*)())pf)();
    break;
  default:
    SET_REG_MACRO;    
    r->u64 = ((uint64_t (*)())pf)();
    break;
  }
}
