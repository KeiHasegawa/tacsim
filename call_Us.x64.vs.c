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
call_Us_subr(struct uks* p, int nth, int narg, void* rvp, union U* xmm, int* xmm_flt, union U* gpr1, union U* gpr2)
{
  enum kind_t kind = p->kind;
  switch (kind) {
  case LD: case DOUBLE: case FLOAT:
    if ( nth <= narg ){
      double d = kind == FLOAT ? (double)p->m_u.f : p->m_u.d;
      xmm->d = d;
      *xmm_flt = 0;
      if (rvp)
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
    if ( rvp )
      gpr2->u64 = p->m_u.u64;
    else
      gpr1->u64 = p->m_u.u64;
    break;
  case U32: case S32:
    if ( rvp )
      gpr2->u32 = p->m_u.u32;
    else
      gpr1->u32 = p->m_u.u32;
    break;
  case U16:
    if ( rvp )
      gpr2->u16 = p->m_u.u16;
    else
      gpr1->u16 = p->m_u.u16;
    break;
  case S16:
    if ( nth <= narg ) {
      if ( rvp )
        gpr2->s32 = p->m_u.s16;
      else
        gpr1->s32 = p->m_u.s16;
    }
    else {
      if ( rvp )
        gpr2->s16 = p->m_u.s16;
      else
        gpr1->s16 = p->m_u.s16;
    }
    break;
  case U8:
    if ( rvp )
      gpr2->u8 = p->m_u.u8;
    else
      gpr1->u8 = p->m_u.u8;
    break;
  case S8:
    if ( nth <= narg ){
      if ( rvp )
        gpr2->s32 = p->m_u.s8;
      else
        gpr1->s32 = p->m_u.s8;
    }
    else {
      if ( rvp )
        gpr2->s8 = p->m_u.s8;
      else
        gpr1->s8 = p->m_u.s8;
    }
    break;
  case VP: case REC:
    if ( rvp )
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
char* RSP_REG;

void
call_Us(union U* r, void* pf, struct uks* begin, struct uks* end,
        int nth, enum kind_t rk)
{
  RCX_REG.vp = RDX_REG.vp = R8_REG.vp = R9_REG.vp =
  XMM0_REG.vp = XMM1_REG.vp = XMM2_REG.vp = XMM3_REG.vp = 0;
  XMM0_FLT = XMM1_FLT = XMM2_FLT = XMM3_FLT = 0;
  
  long int N = end - begin;
  long int delta = (N&1) ? ((N+1)*8) : (N*8);
  RSP_REG -= delta;
  void* rvp = r->vp;
  if (rvp)
    RCX_REG.vp = rvp;

  struct uks* p = begin;
  int narg = 0;
  if ( p == end ) goto LAST;
  call_Us_subr(p,nth,narg,rvp,&XMM0_REG,&XMM0_FLT,&RCX_REG,&RDX_REG); 

  if ( (++narg,++p) == end ) goto LAST;
  call_Us_subr(p,nth,narg,rvp,&XMM1_REG,&XMM1_FLT,&RDX_REG,&R8_REG);

  if ( (++narg,++p) == end ) goto LAST;
  call_Us_subr(p,nth,narg,rvp,&XMM2_REG,&XMM2_FLT,&R8_REG,&R9_REG);

  if ( (++narg,++p) == end ) goto LAST;
  if ( !rvp ){
    call_Us_subr(p,nth,narg,rvp,&XMM3_REG,&XMM3_FLT,&R9_REG,&NOTREF);
    ++narg,++p;
  }

  for ( int offset = 32 ; p != end ; ++p, ++narg, offset += 8 ){
    enum kind_t kind = p->kind;
    switch ( kind ){
    case LD: case DOUBLE:
      *(double*)(RSP_REG+offset) = p->m_u.d;
      break;
    case FLOAT:
      {
        float f = p->m_u.f;
        if ( nth <= narg ) {
          double d = f;
          *(double*)(RSP_REG+offset) = d;
        }
        else
          *(float*)(RSP_REG+offset) = f;
      }
      break;
    case U64: case S64:
      *(uint64_t*)(RSP_REG+offset) = p->m_u.u64;
      break;
    case U32: case S32:
      *(uint32_t*)(RSP_REG+offset) = p->m_u.u32;
      break;
    case U16:
      *(uint16_t*)(RSP_REG+offset) = p->m_u.u16;
      break;
    case S16:
      {
        int16_t s16 = p->m_u.s16;
        if ( nth <= narg ) {
          int tmp = s16;
          *(int32_t*)(RSP_REG+offset) = tmp;
        }
        else
          *(int16_t*)(RSP_REG+offset) = s16;
      }
      break;
    case U8:
      *(uint8_t*)(RSP_REG+offset) = p->m_u.u8;
      break;
    case S8:
      {
        int8_t s8 = p->m_u.s8;
        if ( nth <= narg ) {
          int tmp = s8;
          *(int32_t*)(RSP_REG+offset) = tmp;  
        }
        else
          *(int8_t*)(RSP_REG+offset) = s8;  
      }
      break;
    case VP:
    case REC:
          *(void**)(RSP_REG+offset) = p->m_u.vp;
      break;
    }
  }
 LAST:
  asm("mov rcx, QWORD PTR RCX_REG");
  asm("mov rdx, QWORD PTR RDX_REG");
  asm("mov r8,  QWORD PTR R8_REG"); 
  asm("mov r9,  QWORD PTR R9_REG");
  if (XMM0_FLT)
    asm("movss xmm0, DWORD PTR XMM0_REG");
  else
    asm("movsd xmm0, QWORD PTR XMM0_REG");
  if (XMM1_FLT)
    asm("movss xmm1, DWORD PTR XMM1_REG");
  else
    asm("movsd xmm1, QWORD PTR XMM1_REG");
  if (XMM2_FLT)
    asm("movss xmm2, DWORD PTR XMM2_REG");
  else
    asm("movsd xmm2, QWORD PTR XMM2_REG");
  if (XMM3_FLT)
    asm("movss xmm3, DWORD PTR XMM3_REG");
  else
    asm("movsd xmm3, QWORD PTR XMM3_REG");
  
  switch ( rk ){
  case NONE: case REC:
    ((void (*)())pf)();
    break;
  case LD: case DOUBLE:
    r->d = ((double (*)())pf)();
    break;
  case FLOAT:
    r->f = ((float (*)())pf)();
    break;
  default:
    r->u64 = ((uint64_t (*)())pf)();
    break;
  }
}
