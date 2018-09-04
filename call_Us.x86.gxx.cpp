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

struct S {
  union U m_u;
  enum kind_t m_kind;
  int m_size;
};

static inline int add_size(int n, struct S* p)
{
  return n + p->m_size;
}

static inline int accumulate(struct S* begin, struct S* end, int n,
                             int (*add)(int, struct S*))
{
  for ( struct S* p = begin ; p != end ; ++p )
    n = add(n, p);
  return n;
}

#ifdef _MSC_VER
static int wa_for_delta(int n){ return n + 3; }
#endif // _MSC_VER

extern "C" void
call_Us(union U* r, void* pf, struct S* begin, struct S* end, int nth, enum kind_t rk)
{
  void* rvp = r->vp;
  int offset = rvp ? 4 : 0;  
  int delta = accumulate(begin, end, offset, add_size);
  int n = delta&15;
  if (n)
    delta += 16 - n;
  char* esp;
#ifdef __GNUC__
  asm("sub        %1, %%esp\n\t"
      "mov        %%esp, %0" : "=r"(esp) : "r"(delta));
#endif // __GNUC__
#ifdef _MSC_VER
#if 0
  asm("sub        esp, %1\n\t"
      "mov        %0, esp" : "=r"(esp) : "r"(delta));
#else
  wa_for_delta(delta);
  asm("mov        eax, DWORD PTR [ebp-8]");  // eax <- delta
  asm("sub        esp, eax");
  asm("mov        DWORD PTR [ebp-12], esp");  // esp(variable) <- esp(reg)
#endif
#endif // _MSC_VER

  if (rvp)
    *(void**)esp = rvp;

  int narg = 0;
  for ( struct S* p = begin ; p != end ; ++p, ++narg ){
    enum kind_t kind = p->m_kind;
    switch ( kind ){
    case LD:
      {
        typedef long double T;
        *(T*)(esp+offset) = p->m_u.ld;
        offset += sizeof(T);
      }
      break;
    case DOUBLE:
      {
        typedef double T;
        *(T*)(esp+offset) = p->m_u.d;
        offset += sizeof(T);
      }
      break;
    case FLOAT:
      {
        if ( nth <= narg ) {
          typedef double T;
          *(T*)(esp+offset) = p->m_u.f;
          offset += sizeof(T);
        }
        else {
          typedef float T;
          *(T*)(esp+offset) = p->m_u.f;
          offset += sizeof(T);
        }
      }
      break;
    case U64: case S64:
      {
        typedef uint64_t T;
        *(T*)(esp+offset) = p->m_u.u64;
        offset += sizeof(T);
      }
      break;
    case U32: case S32:
      {
        typedef uint32_t T;
        *(T*)(esp+offset) = p->m_u.u32;
        offset += sizeof(T);
      }
      break;
    case U16:
      {
        typedef uint16_t T;
        *(T*)(esp+offset) = p->m_u.u16;
        offset += sizeof(int);
      }
      break;
    case S16:
      {
        if ( nth <= narg ) {
          typedef int T;
          *(T*)(esp+offset) = p->m_u.s16;
        }
        else {
          typedef int16_t T;
          *(T*)(esp+offset) = p->m_u.s16;
        }
        offset += sizeof(int);
      }
      break;
    case U8:
      {
        typedef uint8_t T;
        *(T*)(esp+offset) = p->m_u.u8;
        offset += sizeof(int);
      }
      break;
    case S8:
      {
        if ( nth <= narg ) {
          typedef int T;
          *(T*)(esp+offset) = p->m_u.s8;
        }
        else {
          typedef int8_t T;
          *(T*)(esp+offset) = p->m_u.s8;
        }
        offset += sizeof(int);
      }
      break;
    case VP:
      {
        typedef void* T;
        *(T*)(esp+offset) = p->m_u.vp;
        offset += sizeof(T);
      }
      break;
    case REC:
      {
        int size = p->m_size;
        extern void* memcpy(void*, const void*, uint32_t);
        memcpy(esp+offset,p->m_u.vp,size);
        offset += size;
      }
      break;
    }
  }
 LAST:
  switch ( rk ){
  case NONE: case REC:
    ((void (*)(void))pf)();
    break;
  case LD:
    r->ld = ((long double (*)(void))pf)();
    break;
  case DOUBLE:
    r->d = ((double (*)(void))pf)();
    break;
  case FLOAT:
    r->f = ((float (*)(void))pf)();
    break;
  default:
    r->u64 = ((uint64_t (*)(void))pf)();
    break;
  }
}
