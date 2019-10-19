#include "stdafx.h"
#ifdef CXX_GENERATOR
#include "cxx_core.h"
#else // CXX_GENERATOR
#include "c_core.h"
#endif // CXX_GENERATOR

#include "tacsim.h"

namespace tacsim {
  using namespace std;
  using namespace COMPILER;
  const vector<pair<const fundef*, vector<tac*> > >* current_funcs;
  vector<CURRENT_CODE_ELEMENT> current_code;
  namespace exec {
    pc_t select(pc_t pc);
    typedef pc_t FUNC(pc_t);
    struct table_t : map<tac::id_t, FUNC*> {
      table_t();
    } table;
  }  // end of namespace exec
  struct return_address {
    static stack<pc_t> m_stack;
    return_address(pc_t x) { m_stack.push(x); }
    ~return_address() { m_stack.pop(); }
  };
  stack<pc_t> return_address::m_stack;
  bool call_common(const fundef* fun, const vector<tac*>& code, pc_t ra)
  {
    return_address sweeper(ra);
    allocate::entrance(fun->m_param);
    current_code.push_back(&code);
    pc_t pc = code.begin();
    while (pc != code.end()) {
      const tac* ptr = *pc;
      pc = exec::select(pc);
      if (ptr->m_id == tac::RETURN)
	break;
    }
    current_code.pop_back();
    allocate::exit(fun->m_param);
    return true;
  }
} // end of namespace tacsim


bool tacsim::call_direct(std::string name, pc_t ra)
{
  using namespace std;
  using namespace COMPILER;

  const vector<pair<const fundef*, vector<tac*> > >& funcs = *current_funcs;
  vector<pair<const fundef*, vector<tac*> > >::const_iterator p =
    find_if(funcs.begin(), funcs.end(), cmp_name(name));
  if (p == funcs.end())
    return false;
  return call_common(p->first, p->second, ra);
}

#ifdef CXX_GENERATOR
namespace tacsim {
  using namespace std;
  using namespace cxx_compiler;
  inline void initialize_terminate(const pair<const fundef*, vector<tac*> >& x,
				   usr::flag2_t mask)
  {
    const fundef* fdef = x.first;
    usr* u = fdef->m_usr;
    usr::flag2_t flag2 = u->m_flag2;
    if (flag2 & mask) {
      vector<tac*> dummy;
      dummy.push_back(0);
      call_common(x.first, x.second, dummy.end());
    }
  }
  void call_initialize(const pair<const fundef*, vector<tac*> >& x)
  {
    initialize_terminate(x, usr::INITIALIZE_FUNCTION);
  }
  void call_terminate(const pair<const fundef*, vector<tac*> >& x)
  {
    initialize_terminate(x, usr::TERMINATE_FUNCTION);
  }
} // end of namespace tacsim
#endif // CXX_GENERATOR

#ifdef CXX_GENERATOR
namespace tacsim {
  using namespace std;
  using namespace COMPILER;
  string scope_name(scope* p)
  {
    if ( p->m_id == scope::TAG ){
      tag* tg = static_cast<tag*>(p);
      string name = tg->m_name;
      ostringstream os;
      os << name.length() << name;
      return scope_name(tg->m_parent) + os.str();
    }
    if ( p->m_id == scope::NAMESPACE ){
      name_space* ns = static_cast<name_space*>(p);
      string name = ns->m_name;
      ostringstream os;
      os << name.length() << name;
      return scope_name(ns->m_parent) + os.str();
    }
    return "";
  }
  struct match {
    usr* m_uy;
    match(usr* y) : m_uy(y) {}
    bool operator()(const pair<const fundef*, vector<tac*> >& x)
    {
      const fundef* fun = x.first;
      const usr* ux = fun->m_usr;
      if (ux->m_name != m_uy->m_name)
	return false;
      if (ux->m_flag & usr::C_SYMBOL)
	return m_uy->m_flag & usr::C_SYMBOL;
      if (m_uy->m_flag & usr::C_SYMBOL)
	return false;
      if (scope_name(ux->m_scope) != scope_name(m_uy->m_scope))
	return false;
      const type* Tx =   ux->m_type;
      const type* Ty = m_uy->m_type;
      assert(Tx->m_id == type::FUNC);
      assert(Ty->m_id == type::FUNC);
      typedef const func_type FT;
      FT* ftx = static_cast<FT*>(Tx);
      FT* fty = static_cast<FT*>(Ty);
      const vector<const type*>& paramx = ftx->param();
      const vector<const type*>& paramy = fty->param();
      ostringstream osx;
      for (auto T : paramx)
	T->encode(osx);
      ostringstream osy;
      for (auto T : paramy)
	T->encode(osy);
      if (osx.str() != osy.str())
	return false;
      usr::flag2_t flag2x =   ux->m_flag2;
      usr::flag2_t flag2y = m_uy->m_flag2;
      if (!(flag2x & usr::EXPLICIT_INSTANTIATE))
	return !(flag2y & usr::EXPLICIT_INSTANTIATE);
      if (!(flag2y & usr::EXPLICIT_INSTANTIATE))
	return false;
      typedef const instantiated_usr IU;
      IU* iux = static_cast<IU*>(  ux);
      IU* iuy = static_cast<IU*>(m_uy);
      const instantiated_usr::SEED& seedx = iux->m_seed;
      const instantiated_usr::SEED& seedy = iuy->m_seed;
      return seedx == seedy;
    }
  };
} // end of namespace tacsim 
#endif // CXX_GENERATOR

bool tacsim::call_usr(COMPILER::usr* u, pc_t ra)
{
  using namespace std;
  using namespace COMPILER;
#ifdef CXX_GENERATOR
  const vector<pair<const fundef*, vector<tac*> > >& funcs = *current_funcs;
  typedef vector<pair<const fundef*, vector<tac*> > >::const_iterator IT;
  IT p = find_if(funcs.begin(), funcs.end(), match(u));
  if (p == funcs.end())
    return false;
  return call_common(p->first, p->second, ra);
#else // CXX_GENERATOR
  string name = u->m_name;
  return call_direct(name, ra);
#endif // CXX_GENERATOR
}

tacsim::pc_t tacsim::exec::select(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  table_t::const_iterator p = table.find(ptr->m_id);
  assert(p != table.end());
  FUNC* pf = p->second;
  return (*pf)(pc);
}

namespace tacsim {
  pc_t assign(pc_t pc);
  pc_t add(pc_t pc);
  pc_t sub(pc_t pc);
  pc_t mul(pc_t pc);
  pc_t div(pc_t pc);
  pc_t mod(pc_t pc);
  pc_t lsh(pc_t pc);
  pc_t rsh(pc_t pc);
  pc_t and_(pc_t pc);
  pc_t or_(pc_t pc);
  pc_t xor_(pc_t pc);
  pc_t uminus(pc_t pc);
  pc_t tilde(pc_t pc);
  pc_t cast(pc_t pc);
  pc_t param(pc_t pc);
  pc_t call(pc_t pc);
  pc_t return_(pc_t pc);
  pc_t goto_(pc_t pc);
  pc_t to(pc_t pc);
  pc_t addr(pc_t pc);
  pc_t invladdr(pc_t pc);
  pc_t invraddr(pc_t pc);
  pc_t loff(pc_t pc);
  pc_t roff(pc_t pc);
  pc_t alloca_(pc_t pc);
  pc_t asm_(pc_t pc);
  pc_t vastart(pc_t pc);
  pc_t vaarg(pc_t pc);
  pc_t vaend(pc_t pc);
} // end of namespace tacsim

tacsim::exec::table_t::table_t()
{
  using namespace std;
  insert(make_pair(tac::ASSIGN, assign));
  insert(make_pair(tac::ADD, add));
  insert(make_pair(tac::SUB, sub));
  insert(make_pair(tac::MUL, mul));
  insert(make_pair(tac::DIV, div));
  insert(make_pair(tac::MOD, mod));
  insert(make_pair(tac::LSH, lsh));
  insert(make_pair(tac::RSH, rsh));
  insert(make_pair(tac::AND, and_));
  insert(make_pair(tac::OR, or_));
  insert(make_pair(tac::XOR, xor_));
  insert(make_pair(tac::UMINUS, uminus));
  insert(make_pair(tac::TILDE, tilde));
  insert(make_pair(tac::CAST, cast));
  insert(make_pair(tac::PARAM, param));
  insert(make_pair(tac::CALL, call));
  insert(make_pair(tac::RETURN, return_));
  insert(make_pair(tac::GOTO, goto_));
  insert(make_pair(tac::TO, to));
  insert(make_pair(tac::ADDR, addr));
  insert(make_pair(tac::INVLADDR, invladdr));
  insert(make_pair(tac::INVRADDR, invraddr));
  insert(make_pair(tac::LOFF, loff));
  insert(make_pair(tac::ROFF, roff));
  insert(make_pair(tac::ALLOCA, alloca_));
  insert(make_pair(tac::ASM, asm_));
  insert(make_pair(tac::VASTART, vastart));
  insert(make_pair(tac::VAARG, vaarg));
  insert(make_pair(tac::VAEND, vaend));
}

tacsim::pc_t tacsim::assign(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;
  tac* ptr = *pc;
  const type* T = ptr->x->m_type;
  memcpy(getaddr(ptr->x), getaddr(ptr->y), T->size());
  return pc + 1;
}

namespace tacsim {
  using namespace std;
  namespace binary {
    template<class OP, class T> inline void common(OP op, void* x, void* y, void* z)
    {
      *(T*)x = op(*(T*)y, *(T*)z);
    }
  }  // end of namespace binary
  void* add_ptr(void* y, void* z, int sz);
}  // end of namespace tacsim

tacsim::pc_t tacsim::add(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  const type* Tx = ptr->x->m_type;
  int sx = Tx->size();
  void* x = getaddr(ptr->x);
  void* y = getaddr(ptr->y);
  void* z = getaddr(ptr->z);
  if (Tx->real()) {
    if (sx == sizeof(float)) {
      typedef float T;
      binary::common<plus<T>, T>(plus<T>{}, x, y, z);
    }
    else if (sx == sizeof(double)) {
      typedef double T;
      binary::common<plus<T>, T>(plus<T>{}, x, y, z);
    }
    else {
      typedef long double T;
      assert(sx == sizeof(T));
      binary::common<plus<T>, T>(plus<T>{}, x, y, z);
    }
  }
  else if (Tx->integer()) {
    if (sx == sizeof(int)) {
      typedef int T;
      binary::common<plus<T>, T>(plus<T>{}, x, y, z);
    }
    else if (sx == sizeof(long int)) {
      typedef long int T;
      binary::common<plus<T>, T>(plus<T>{}, x, y, z);
    }
    else {
      typedef long long int T;
      assert(sx == sizeof(T));
      binary::common<plus<T>, T>(plus<T>{}, x, y, z);
    }
  }
  else {
    Tx = Tx->unqualified();
#ifdef CXX_GENERATOR
    assert(Tx->m_id == type::POINTER || Tx->m_id == type::REFERENCE);
#else // CXX_GENERATOR
    assert(Tx->m_id == type::POINTER);
#endif // CXX_GENERATOR
    const type* Ty = ptr->y->m_type;
    Ty = Ty->unqualified();
    const type* Tz = ptr->z->m_type;
    Tz = Tz->unqualified();
    int sy = Ty->size();
    int sz = Tz->size();
    if (Tz->integer()) {
      assert(Ty->scalar());
      *(void**)x = add_ptr(y, z, sz);
    }
    else {
      assert(Ty->integer() && Tz->scalar());
      *(void**)x = add_ptr(z, y, sy);
    }
  }
  return pc + 1;
}

void* tacsim::add_ptr(void* y, void* z, int sz)
{
  char* result = *(char**)y;
  if (sz == sizeof(int)) {
    typedef int T;
    result += *(T*)z;
  }
  else if (sz == sizeof(long int)) {
    typedef long int T;
    result += *(T*)z;
  }
  else {
    typedef long long int T;
    assert(sz == sizeof(T));
    result += *(T*)z;
  }
  return (void*)result;
}

tacsim::pc_t tacsim::sub(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  const type* Tx = ptr->x->m_type;
  int sx = Tx->size();
  void* x = getaddr(ptr->x);
  void* y = getaddr(ptr->y);
  void* z = getaddr(ptr->z);
  if (Tx->real()) {
    if (sx == sizeof(float)) {
      typedef float T;
      binary::common<minus<T>, T>(minus<T>{}, x, y, z);
    }
    else if (sx == sizeof(double)) {
      typedef double T;
      binary::common<minus<T>, T>(minus<T>{}, x, y, z);
    }
    else {
      typedef long double T;
      assert(sx == sizeof(T));
      binary::common<minus<T>, T>(minus<T>{}, x, y, z);
    }
  }
  else if (Tx->integer()) {
    const type* Ty = ptr->y->m_type;
    const type* Tz = ptr->z->m_type;
    Ty = Ty->unqualified();
    Tz = Tz->unqualified();
    if (Ty->m_id == type::POINTER && Tz->m_id == type::POINTER) {
      if (sx == sizeof(int))
        *(int*)x = *(char**)y - *(char**)z;
      else if (sx == sizeof(long int))
        *(long int*)x = *(char**)y - *(char**)z;
      else {
        typedef long long int T;
        assert(sx == sizeof(T));
        *(T*)x  = *(char**)y - *(char**)z;
      }
    }
    else if (sx == sizeof(int)) {
      typedef int T;
      binary::common<minus<T>, T>(minus<T>{}, x, y, z);
    }
    else if (sx == sizeof(long int)) {
      typedef long int T;
      binary::common<minus<T>, T>(minus<T>{}, x, y, z);
    }
    else {
      typedef long long int T;
      assert(sx == sizeof(T));
      binary::common<minus<T>, T>(minus<T>{}, x, y, z);
    }
  }
  else {
    Tx = Tx->unqualified();
    assert(Tx->m_id == type::POINTER);
    const type* Ty = ptr->y->m_type;
    Ty = Ty->unqualified();
    assert(Ty->m_id == type::POINTER);
    const type* Tz = ptr->z->m_type;
    int sz = Tz->size();
    char* result = *(char**)y;
    if (sz == sizeof(int))
      result -= *(int*)z;
    else if (sz == sizeof(long int))
      result -= *(long int*)z;
    else {
      assert(sz == sizeof(long long int));
      result -= *(long long int*)z;
    }
    *(char**)x = result;
  }
  return pc + 1;
}

tacsim::pc_t tacsim::mul(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  const type* Tx = ptr->x->m_type;
  int sx = Tx->size();
  void* x = getaddr(ptr->x);
  void* y = getaddr(ptr->y);
  void* z = getaddr(ptr->z);
  if (Tx->real()) {
    if (sx == sizeof(float)) {
      typedef float T;
      binary::common<multiplies<T>, T>(multiplies<T>{}, x, y, z);
    }
    else if (sx == sizeof(double)) {
      typedef double T;
      binary::common<multiplies<T>, T>(multiplies<T>{}, x, y, z);
    }
    else {
      typedef long double T;
      assert(sx == sizeof(T));
      binary::common<multiplies<T>, T>(multiplies<T>{}, x, y, z);
    }
  }
  else {
    assert(Tx->integer());
    if (sx == sizeof(int)) {
      typedef int T;
      binary::common<multiplies<T>, T>(multiplies<T>{}, x, y, z);
    }
    else if (sx == sizeof(long int)) {
      typedef long int T;
      binary::common<multiplies<T>, T>(multiplies<T>{}, x, y, z);
    }
    else {
      typedef long long int T;
      assert(sx == sizeof(T));
      binary::common<multiplies<T>, T>(multiplies<T>{}, x, y, z);
    }
  }
  return pc + 1;
}

tacsim::pc_t tacsim::div(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  const type* Tx = ptr->x->m_type;
  int sx = Tx->size();
  void* x = getaddr(ptr->x);
  void* y = getaddr(ptr->y);
  void* z = getaddr(ptr->z);
  if (Tx->real()) {
    if (sx == sizeof(float)) {
      typedef float T;
      binary::common<divides<T>, T>(divides<T>{}, x, y, z);
    }
    else if (sx == sizeof(double)) {
      typedef double T;
      binary::common<divides<T>, T>(divides<T>{}, x, y, z);
    }
    else {
      typedef long double T;
      assert(sx == sizeof(T));
      binary::common<divides<T>, T>(divides<T>{}, x, y, z);
    }
  }
  else {
    assert(Tx->integer());
    if (sx == sizeof(int)) {
      if (Tx->_signed()) {
        typedef int T;
        binary::common<divides<T>, T>(divides<T>{}, x, y, z);
      }
      else {
        typedef unsigned int T;
        binary::common<divides<T>, T>(divides<T>{}, x, y, z);
      }
    }
    else if (sx == sizeof(long int)) {
      if (Tx->_signed()) {
        typedef long int T;
        binary::common<divides<T>, T>(divides<T>{}, x, y, z);
      }
      else {
        typedef unsigned long int T;
        binary::common<divides<T>, T>(divides<T>{}, x, y, z);
      }
    }
    else {
      assert(sx == sizeof(long long int));
      if (Tx->_signed()) {
        typedef long long int T;
        binary::common<divides<T>, T>(divides<T>{}, x, y, z);
      }
      else {
        typedef unsigned long long int T;
        binary::common<divides<T>, T>(divides<T>{}, x, y, z);
      }
    }
  }
  return pc + 1;
}

tacsim::pc_t tacsim::mod(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  const type* Tx = ptr->x->m_type;
  int sx = Tx->size();
  void* x = getaddr(ptr->x);
  void* y = getaddr(ptr->y);
  void* z = getaddr(ptr->z);
  {
    assert(Tx->integer());
    if (sx == sizeof(int)) {
      if (Tx->_signed()) {
        typedef int T;
        binary::common<modulus<T>, T>(modulus<T>{}, x, y, z);
      }
      else {
        typedef unsigned int T;
        binary::common<modulus<T>, T>(modulus<T>{}, x, y, z);
      }
    }
    else if (sx == sizeof(long int)) {
      if (Tx->_signed()) {
        typedef long int T;
        binary::common<modulus<T>, T>(modulus<T>{}, x, y, z);
      }
      else {
        typedef unsigned long int T;
        binary::common<modulus<T>, T>(modulus<T>{}, x, y, z);
      }
    }
    else {
      assert(sx == sizeof(long long int));
      if (Tx->_signed()) {
        typedef long long int T;
        binary::common<modulus<T>, T>(modulus<T>{}, x, y, z);
      }
      else {
        typedef unsigned long long int T;
        binary::common<modulus<T>, T>(modulus<T>{}, x, y, z);
      }
    }
  }
  return pc + 1;
}

tacsim::pc_t tacsim::lsh(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  void* x = getaddr(ptr->x);
  void* y = getaddr(ptr->y);
  void* z = getaddr(ptr->z);
  const type* Tx = ptr->x->m_type;
  const type* Tz = ptr->z->m_type;
  int sx = Tx->size();
  int sz = Tz->size();
  if (sx == sizeof(int)) {
    if (sz == sizeof(int))
      *(int*)x = *(int*)y << *(int*)z;
    else if (sz == sizeof(long))
      *(int*)x = *(int*)y << *(long*)z;
    else {
      typedef long long int T;
      assert(sz == sizeof(T));
      *(int*)x = *(int*)y << *(T*)z;
    }
  }
  else if (sx == sizeof(long)) {
    if (sz == sizeof(int))
      *(long*)x = *(long*)y << *(int*)z;
    else if (sz == sizeof(long))
      *(long*)x = *(long*)y << *(long*)z;
    else {
      typedef long long int T;
      assert(sz == sizeof(T));
      *(long*)x = *(long*)y << *(T*)z;
    }
  }
  else {
    typedef long long int T;
    assert(sx == sizeof(T));
    if (sz == sizeof(int))
      *(T*)x = *(T*)y << *(int*)z;
    else if (sz == sizeof(long))
      *(T*)x = *(T*)y << *(long*)z;
    else {
      assert(sz == sizeof(T));
      *(T*)x = *(T*)y << *(T*)z;
    }
  }
  return pc + 1;
}

tacsim::pc_t tacsim::rsh(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  void* x = getaddr(ptr->x);
  void* y = getaddr(ptr->y);
  void* z = getaddr(ptr->z);
  const type* Tx = ptr->x->m_type;
  const type* Tz = ptr->z->m_type;
  int sx = Tx->size();
  bool sign = Tx->_signed();
  int sz = Tz->size();
  typedef int Ti;
  typedef unsigned int Tui;
  typedef long Tl;
  typedef unsigned long Tul;
  typedef long long int Tll;
  typedef unsigned long long Tull;
  if (sx == sizeof(Ti)) {
    if (sz == sizeof(Ti)) {
      if (sign)
        *(Ti*)x = *(Ti*)y >> *(Ti*)z;
      else
        *(Tui*)x = *(Tui*)y >> *(Ti*)z;
    }
    else if (sz == sizeof(Tl)) {
      if (sign)
        *(Ti*)x = *(Ti*)y >> *(Tl*)z;
      else
        *(Tui*)x = *(Tui*)y >> *(Tl*)z;
    }
    else {
      assert(sz == sizeof(Tll));
      if (sign)
        *(Ti*)x = *(Ti*)y >> *(Tll*)z;
      else
        *(Tui*)x = *(Tui*)y >> *(Tll*)z;
    }
  }
  else if (sx == sizeof(Tl)) {
    if (sz == sizeof(Ti)) {
      if (sign)
        *(Tl*)x = *(Tl*)y >> *(Ti*)z;
      else
        *(Tul*)x = *(Tul*)y >> *(Ti*)z;
    }
    else if (sz == sizeof(Tl)) {
      if (sign)
        *(Tl*)x = *(Tl*)y >> *(Tl*)z;
      else
        *(Tul*)x = *(Tul*)y >> *(Tl*)z;
    }
    else {
      assert(sz == sizeof(Tll));
      if (sign)
        *(Tl*)x = *(Tl*)y >> *(Tll*)z;
      else
        *(Tul*)x = *(Tul*)y >> *(Tll*)z;
    }
  }
  else {
    assert(sx == sizeof(Tll));
    if (sz == sizeof(Ti)) {
      if (sign)
        *(Tll*)x = *(Tll*)y >> *(Ti*)z;
      else
        *(Tull*)x = *(Tull*)y >> *(Ti*)z;
    }
    else if (sz == sizeof(Tl)) {
      if (sign)
        *(Tll*)x = *(Tll*)y >> *(Tl*)z;
      else
        *(Tull*)x = *(Tull*)y >> *(Tl*)z;
    }
    else {
      assert(sz == sizeof(Tll));
      if (sign)
        *(Tll*)x = *(Tll*)y >> *(Tll*)z;
      else
        *(Tull*)x = *(Tull*)y >> *(Tll*)z;
    }
  }
        
  return pc + 1;
}

tacsim::pc_t tacsim::and_(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  void* x = getaddr(ptr->x);
  void* y = getaddr(ptr->y);
  void* z = getaddr(ptr->z);
  const type* Tx = ptr->x->m_type;
  int sx = Tx->size();
  if (sx == sizeof(int)) {
    typedef int T;
    binary::common<bit_and<T>, T>(bit_and<T>{}, x, y, z);
  }
  else if (sx == sizeof(long int)) {
    typedef long int T;
    binary::common<bit_and<T>, T>(bit_and<T>{}, x, y, z);
  }
  else {
    typedef long long int T;
    assert(sx == sizeof(T));
    binary::common<bit_and<T>, T>(bit_and<T>{}, x, y, z);
  }
  return pc + 1;
}

tacsim::pc_t tacsim::or_(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  void* x = getaddr(ptr->x);
  void* y = getaddr(ptr->y);
  void* z = getaddr(ptr->z);
  const type* Tx = ptr->x->m_type;
  int sx = Tx->size();
  if (sx == sizeof(int)) {
    typedef int T;
    binary::common<bit_or<T>, T>(bit_or<T>{}, x, y, z);
  }
  else if (sx == sizeof(long int)) {
    typedef long int T;
    binary::common<bit_or<T>, T>(bit_or<T>{}, x, y, z);
  }
  else {
    typedef long long int T;
    assert(sx == sizeof(T));
    binary::common<bit_or<T>, T>(bit_or<T>{}, x, y, z);
  }
  return pc + 1;
}

tacsim::pc_t tacsim::xor_(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  void* x = getaddr(ptr->x);
  void* y = getaddr(ptr->y);
  void* z = getaddr(ptr->z);
  const type* Tx = ptr->x->m_type;
  int sx = Tx->size();
  if (sx == sizeof(int)) {
    typedef int T;
    binary::common<bit_xor<T>, T>(bit_xor<T>{}, x, y, z);
  }
  else if (sx == sizeof(long int)) {
    typedef long int T;
    binary::common<bit_xor<T>, T>(bit_xor<T>{}, x, y, z);
  }
  else {
    typedef long long int T;
    assert(sx == sizeof(T));
    binary::common<bit_xor<T>, T>(bit_xor<T>{}, x, y, z);
  }
  return pc + 1;
}

namespace tacsim {
  using namespace std;
  namespace unary {
    template<class OP, class T> inline void common(OP op, void* x, void* y)
    {
      *(T*)x = op(*(T*)y);
    }
  }  // end of namespace binary
}  // end of namespace tacsim

tacsim::pc_t tacsim::uminus(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  void* x = getaddr(ptr->x);
  void* y = getaddr(ptr->y);
  const type* T = ptr->x->m_type;
  int size = T->size();
  if (T->real()) {
    if (size == sizeof(float)) {
      typedef float T;
      unary::common<negate<T>, T>(negate<T>{}, x, y);
    }
    else if (size == sizeof(double)) {
      typedef double T;
      unary::common<negate<T>, T>(negate<T>{}, x, y);
    }
    else {
      typedef long double T;
      assert(size == sizeof(T));
      unary::common<negate<T>, T>(negate<T>{}, x, y);
    }
  }
  else {
    assert(T->integer());
    if (size == sizeof(int)) {
      typedef int T;
      unary::common<negate<T>, T>(negate<T>{}, x, y);
    }
    else if (size == sizeof(long int)) {
      typedef long int T;
      unary::common<negate<T>, T>(negate<T>{}, x, y);
    }
    else {
      typedef long long int T;
      assert(size == sizeof(T));
      unary::common<negate<T>, T>(negate<T>{}, x, y);
    }
  }
  return pc + 1;
}

tacsim::pc_t tacsim::tilde(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  void* x = getaddr(ptr->x);
  void* y = getaddr(ptr->y);
  const type* T = ptr->x->m_type;
  int size = T->size();
  {
    assert(T->integer());
    if (size == sizeof(int)) {
      typedef int T;
      unary::common<bit_not<T>, T>(bit_not<T>{}, x, y);
    }
    else if (size == sizeof(long int)) {
      typedef long int T;
      unary::common<bit_not<T>, T>(bit_not<T>{}, x, y);
    }
    else {
      typedef long long int T;
      assert(size == sizeof(T));
      unary::common<bit_not<T>, T>(bit_not<T>{}, x, y);
    }
  }
  return pc + 1;
}

#define CAST_MACRO(X) \
  {                                                \
    if (Ty->real()) {                                \
      if (sy == sizeof(float)) {                \
        typedef float Y;                        \
        *(X*)x = *(Y*)y;                        \
      }                                                \
      else if (sy == sizeof(double)) {                \
        typedef double Y;                        \
        *(X*)x = *(Y*)y;                        \
      }                                                \
      else {                                        \
        typedef long double Y;                        \
        assert(sy == sizeof(Y));                \
        *(X*)x = *(Y*)y;                        \
      }                                                \
    }                                                \
    else {                                        \
      if (sy == sizeof(char))                        \
        if (signy)                                \
          *(X*)x = *(char*)y;                        \
        else                                        \
          *(X*)x = *(unsigned char*)y;                \
      else if (sy == sizeof(short))                \
        if (signy)                                \
          *(X*)x = *(short*)y;                        \
        else                                        \
          *(X*)x = *(unsigned short*)y;                \
      else if (sy == sizeof(int))                \
        if (signy)                                \
          *(X*)x = *(int*)y;                        \
        else                                        \
          *(X*)x = *(unsigned int*)y;                \
      else if (sy == sizeof(long))                \
        if (signy)                                \
          *(X*)x = *(long*)y;                        \
        else                                        \
          *(X*)x = *(unsigned long*)y;                \
      else {                                        \
        assert(sy == sizeof(long long));        \
        if (signy)                                \
          *(X*)x = *(long long*)y;                \
        else                                        \
          *(X*)x = *(unsigned long long*)y;        \
      }                                                \
    }                                                \
}

tacsim::pc_t tacsim::cast(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  void* x = getaddr(ptr->x);
  void* y = getaddr(ptr->y);
  const type* Tx = ptr->x->m_type;
  const type* Ty = ptr->y->m_type;
  int sx = Tx->size();
  int sy = Ty->size();
  bool signx = Tx->_signed();
  bool signy = Ty->_signed();
  if (Tx->real()) {
    if (sx == sizeof(float)) { CAST_MACRO(float); }
    else if (sx == sizeof(double)) { CAST_MACRO(double); }
    else { assert(sx == sizeof(long double)); CAST_MACRO(long double); }
  }
  else {
    if (sx == sizeof(char)) {
      if (signx) { CAST_MACRO(char); }
      else { CAST_MACRO(unsigned char); }
    }
    else if (sx == sizeof(short)) {
      if (signx) { CAST_MACRO(short); }
      else { CAST_MACRO(unsigned short); }
    }
    else if (sx == sizeof(int)) {
      if (signx) { CAST_MACRO(int); }
      else { CAST_MACRO(unsigned int); }
    }
    else if (sx == sizeof(long)) {
      if (signx) { CAST_MACRO(long); }
      else { CAST_MACRO(unsigned long); }
    }
    else {
      assert(sx == sizeof(long long));
      if (signx) { CAST_MACRO(long long); }
      else { CAST_MACRO(unsigned long long); }
    }
  }
  return pc + 1;
}

namespace tacsim {
  using namespace std;
  using namespace COMPILER;
  vector<pair<void*, const type*> > parameters;
}  // end of namespace tacsim

tacsim::pc_t tacsim::param(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  const type* T = ptr->y->m_type;
  T = T->complete_type();
  int size = T->size();
  void* p = new char[size];
  memcpy(p, getaddr(ptr->y), size);
  parameters.push_back(make_pair(p, T));
  return pc + 1;
}

namespace tacsim {
  using namespace std;
  using namespace COMPILER;
  namespace call_impl {
    pc_t not_pointer(pc_t);
    pc_t via_pointer(pc_t);
    struct cmp_usr {
      void* m_pf;
      cmp_usr(void* pf) : m_pf(pf) {}
      bool operator()(const pair<const fundef*, vector<tac*> >& x)
      {
	const fundef* func = x.first;
	usr* u = func->m_usr;
	return u == (usr*)m_pf;
      }
    };
    void common(COMPILER::var* x, void* pf, const func_type*);
    inline const func_type* get_ft(const type* T)
    {
      T = T->unqualified();
      assert(T->m_id == type::POINTER);
      const pointer_type* pt = static_cast<const pointer_type*>(T);
      T = pt->referenced_type();
      T = T->unqualified();
      assert(T->m_id == type::FUNC);
      return static_cast<const func_type*>(T);
    }
  }
} // end of namespace tacsim

tacsim::pc_t tacsim::call(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  const type* T = ptr->y->m_type;
  return T->scalar() ? call_impl::via_pointer(pc) : call_impl::not_pointer(pc);
}

tacsim::pc_t tacsim::call_impl::not_pointer(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  var* v = ptr->y;
  usr* u = v->usr_cast();
  if (!call_usr(u,pc+1)) {
    // name is not user-defined function like "printf". 
    assert(u);
    void* pf = external::get(u);
    const type* T = u->m_type;  //  T is function_type;
    assert(T->m_id == type::FUNC);
    const func_type* ft = static_cast<const func_type*>(T);
    call_impl::common(ptr->x, pf, ft);
  }
  return pc + 1;
}

tacsim::pc_t tacsim::call_impl::via_pointer(pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  void* pf = *(void**)getaddr(ptr->y);
  typedef const vector < pair<const fundef*, vector<tac*> > > FUNCS;
  FUNCS& funcs = *current_funcs;
  FUNCS::const_iterator p = find_if(funcs.begin(), funcs.end(), cmp_usr(pf));
  if (p != funcs.end()) {
    usr* u = p->first->m_usr;
    bool b = call_usr(u, pc+1);
    assert(b);
    return pc + 1;
  }
  const func_type* ft = call_impl::get_ft(ptr->y->m_type);
  call_impl::common(ptr->x, pf, ft);
  return pc + 1;
}

namespace tacsim {
  using namespace std;
  using namespace COMPILER;
  namespace call_impl {
    enum kind_t {
      NONE, LD, DOUBLE, FLOAT, U64, S64, U32, S32, U16, S16, U8, S8, VP, REC
    };

    union U {
      long double ld; double d; float f;
      uint64_t u64; int64_t s64;
      uint32_t u32; int32_t s32;
      uint16_t u16; int16_t s16;
      uint8_t u8; int8_t s8;
      void* vp;
    };
    struct uks {
      U m_u;
      kind_t m_kind;
      int m_size;
    };
    int calc_nth(const vector<const type*>&);
    uks conv(pair<void*, const type*>);
    kind_t conv_type(const type*);
  }  // end of namespace call_impl
}  // end of namespace tacsim

extern "C" void call_Us(tacsim::call_impl::U* r, void* pf,
        tacsim::call_impl::uks* begin, tacsim::call_impl::uks* end, int nth, tacsim::call_impl::kind_t rk);

void tacsim::call_impl::common(COMPILER::var* x, void* pf, const COMPILER::func_type* ft)
{
  using namespace std;
  using namespace COMPILER;

  const vector<const type*>& param = ft->param();
  int nth = calc_nth(param);
  vector<uks> Us;
  transform(parameters.begin(), parameters.end(), back_inserter(Us), conv);
  for_each(parameters.begin(), parameters.end(), destroy<void*, const type*>());
  parameters.clear();
  const type* T = ft->return_type();
  int size = T->size();
  bool aggr = T->aggregate();
  U r; r.vp = aggr ? new char[size] : 0;
  kind_t rk = conv_type(T);
  uks* begin = Us.data();
  uks* end = begin + Us.size();
  call_Us(&r, pf, begin, end, nth, rk);
  if (x) {
    void* p = aggr ? r.vp : &r;
    memcpy(getaddr(x), p, size);
  }
}

int tacsim::call_impl::calc_nth(const std::vector<const COMPILER::type*>& param)
{
  using namespace std;
  using namespace COMPILER;

  int size = param.size();
  if (!size)
    return numeric_limits<int>::max();
  const type* T = param.back();
  if (T->m_id == type::ELLIPSIS)
    return size - 1;
  return numeric_limits<int>::max();
}

tacsim::call_impl::uks tacsim::call_impl::conv(std::pair<void*, const COMPILER::type*> x)
{
  using namespace std;
  using namespace COMPILER;

  void* p = x.first;
  const type* T = x.second;
  int size = T->size();
  U u;
  if (T->real()) {
    if (size == sizeof(float))
      memcpy(&u.f, p, size);
    else if (size == sizeof(double))
      memcpy(&u.d, p, size);
    else {
      assert(size == sizeof(long double));
      memcpy(&u.ld, p, size);
    }
  }
  else if (T->integer()) {
    if (size == sizeof(char))
      memcpy(&u.u8, p, size);
    else if (size == sizeof(short))
      memcpy(&u.u16, p, size);
    else if (size == sizeof(int))
      memcpy(&u.u32, p, size);
    else {
      assert(size == sizeof(long long));
      memcpy(&u.u64, p, size);
    }
  }
  else if (T->scalar()) {
    assert(size == sizeof(void*));
    memcpy(&u.vp, p, size);
  }
  else {
    assert(T->aggregate());
    u.vp = new char[size];
  }
  uks ret = { u, conv_type(T), size };
  return ret;
}

tacsim::call_impl::kind_t tacsim::call_impl::conv_type(const COMPILER::type* T)
{
  using namespace std;
  using namespace COMPILER;
  int size = T->size();
  bool sign = T->_signed();
  if (T->real()) {
    if (size == sizeof(float))
      return FLOAT;
    else if (size == sizeof(double))
      return DOUBLE;
    else {
      assert(size == sizeof(long double));
      return LD;
    }
  }
  else if (T->integer()) {
    if (size == sizeof(uint8_t))
      return sign ? S8 : U8;
    else if (size == sizeof(uint16_t))
      return sign ? S16 : U16;
    else if (size == sizeof(uint32_t))
      return sign ? S32 : U32;
    else {
      assert(size == sizeof(uint64_t));
      return sign ? S64 : U64;
    }
  }
  else if (T->scalar()) {
    assert(size == sizeof(void*));
    return VP;
  }
  else if (T->aggregate())
    return REC;
  else {
    assert(size == 0);
    return NONE;
  }
}

int tacsim::main_ret;

tacsim::pc_t tacsim::return_(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  pc = return_address::m_stack.top();
  tac* call = *(pc - 1);
  if (ptr->y) {
    const type* T = ptr->y->m_type;
    int size = T->size();
    if (call && call->x)
      memcpy(getaddr(call->x, true), getaddr(ptr->y), size);
    else if (!call)
      main_ret = *(int*)getaddr(ptr->y);
  }
  return pc;
}

namespace tacsim {
  pc_t ifgoto(pc_t pc);
}  // end of namespace tacsim

tacsim::pc_t tacsim::goto_(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;
  tac* tmp = *pc;
  goto3ac* ptr = static_cast<goto3ac*>(tmp);
  if (ptr->m_op)
    return ifgoto(pc);
  const vector<tac*>& code = *current_code.back();
  pc_t p = find(code.begin(), code.end(), ptr->m_to);
  assert(p != code.end());
  return p;
}

tacsim::pc_t tacsim::to(tacsim::pc_t pc){ return pc + 1; }

namespace tacsim {
  namespace ifgoto_impl {
    using namespace std;
    using namespace COMPILER;
    template<class T> bool eq(T y, T z) { return y == z; }
    template<class T> bool ne(T y, T z) { return y != z; }
    template<class T> bool le(T y, T z) { return y <= z; }
    template<class T> bool ge(T y, T z) { return y >= z; }
    template<class T> bool lt(T y, T z) { return y <  z; }
    template<class T> bool gt(T y, T z) { return y >  z; }
    template<class T> struct table_t : map<goto3ac::op, bool (*)(T, T)> {
      table_t()
      {
        map<goto3ac::op, bool(*)(T, T)>::insert(make_pair(goto3ac::EQ, eq<T>));
        map<goto3ac::op, bool(*)(T, T)>::insert(make_pair(goto3ac::NE, ne<T>));
        map<goto3ac::op, bool(*)(T, T)>::insert(make_pair(goto3ac::LE, le<T>));
        map<goto3ac::op, bool(*)(T, T)>::insert(make_pair(goto3ac::GE, ge<T>));
        map<goto3ac::op, bool(*)(T, T)>::insert(make_pair(goto3ac::LT, lt<T>));
        map<goto3ac::op, bool(*)(T, T)>::insert(make_pair(goto3ac::GT, gt<T>));
      }
    };
    template<class T> table_t<T> table;
  }  // end of namespace ifgoto_impl
}  // end of namespace tacsim

#define IFGOTO_REAL_MACRO(T) \
  {                                                                \
    bool(*pred)(T, T) = ifgoto_impl::table<T>[ptr->m_op];        \
    if (pred(*(T*)getaddr(ptr->y), *(T*)getaddr(ptr->z))) {        \
      const vector<tac*>& code = *current_code.back();                \
      return find(code.begin(), code.end(), ptr->m_to);                \
    }                                                                \
}

#define IFGOTO_NOT_REAL_MACRO(T) \
  {                                                                 \
    if (sign) {                                                     \
      bool(*pred)(T, T) = ifgoto_impl::table<T>[ptr->m_op];         \
      if (pred(*(T*)getaddr(ptr->y), *(T*)getaddr(ptr->z))) {       \
        const vector<tac*>& code = *current_code.back();            \
        return find(code.begin(), code.end(), ptr->m_to);           \
      }                                                             \
    }                                                               \
    else {                                                          \
      bool(*pred)(unsigned T, unsigned T) = ifgoto_impl::table<unsigned T>[ptr->m_op]; \
      if (pred(*(unsigned T*)getaddr(ptr->y), *(unsigned T*)getaddr(ptr->z))) { \
        const vector<tac*>& code = *current_code.back();            \
        return find(code.begin(), code.end(), ptr->m_to);           \
      }                                                             \
    }                                                               \
}

tacsim::pc_t tacsim::ifgoto(pc_t pc)
{
  using namespace std;
  using namespace COMPILER;
  tac* tmp = *pc;
  goto3ac* ptr = static_cast<goto3ac*>(tmp);
  const type* T = ptr->y->m_type;
  int size = T->size();
  bool sign = T->_signed();
  if (T->real()) {
    if (size == sizeof(float)) {
      IFGOTO_REAL_MACRO(float);
    }
    else if (size == sizeof(double)) {
      IFGOTO_REAL_MACRO(double);
    }
    else {
      assert(size == sizeof(long double));
      IFGOTO_REAL_MACRO(long double);
    }
  }
  else if (T->integer()) {
    if (size == sizeof(char)) {
      IFGOTO_NOT_REAL_MACRO(char);
    }
    else if (size == sizeof(short)) {
      IFGOTO_NOT_REAL_MACRO(short);
    }
    else if (size == sizeof(int)) {
      IFGOTO_NOT_REAL_MACRO(int);
    }
    else if (size == sizeof(long)) {
      IFGOTO_NOT_REAL_MACRO(long);
    }
    else {
      assert(size == sizeof(long long));
      IFGOTO_NOT_REAL_MACRO(long long);
    }
  }
  else {
    const type* Tz = ptr->z->m_type;
    int size_z = Tz->size();
    if (size == size_z) {
      IFGOTO_NOT_REAL_MACRO(int*);
    }
    else {
      typedef int* T;
      bool(*pred)(T, T) = ifgoto_impl::table<T>[ptr->m_op];
      if (ptr->z->isconstant()) {
        if (ptr->z->m_type->size() == sizeof(int)) {
          constant<int>* c = static_cast<constant<int>*>(ptr->z);
          assert(c->m_value == 0);
        }
        else if (ptr->z->m_type->size() == sizeof(long)) {
          constant<long>* c = static_cast<constant<long>*>(ptr->z);
          assert(c->m_value == 0);
        }
        else {
          assert(ptr->z->m_type->size() == sizeof(long long));
          constant<long long>* c = static_cast<constant<long long>*>(ptr->z);
          assert(c->m_value == 0);
        }
        if (pred(*(T*)getaddr(ptr->y), 0)) {
          const vector<tac*>& code = *current_code.back();
          return find(code.begin(), code.end(), ptr->m_to);
        }
      }
      else {
        assert(ptr->y->isconstant());
        if (ptr->y->m_type->size() == sizeof(int)) {
          constant<int>* c = static_cast<constant<int>*>(ptr->y);
          assert(c->m_value == 0);
        }
        else if (ptr->y->m_type->size() == sizeof(long)) {
          constant<long>* c = static_cast<constant<long>*>(ptr->y);
          assert(c->m_value == 0);
        }
        else {
          assert(ptr->y->m_type->size() == sizeof(long long));
          constant<long long>* c = static_cast<constant<long long>*>(ptr->y);
          assert(c->m_value == 0);
        }
        if (pred(0, *(T*)getaddr(ptr->z))) {
          const vector<tac*>& code = *current_code.back();
          return find(code.begin(), code.end(), ptr->m_to);
        }
      }
    }
  }
  return pc + 1;
}

tacsim::pc_t tacsim::addr(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  *(void**)getaddr(ptr->x) = getaddr(ptr->y);
  return pc + 1;
}

tacsim::pc_t tacsim::invladdr(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  const type* T = ptr->z->m_type;
  memcpy(*(void**)getaddr(ptr->y), getaddr(ptr->z), T->size());
  return pc + 1;
}

tacsim::pc_t tacsim::invraddr(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  const type* T = ptr->x->m_type;
  memcpy(getaddr(ptr->x), *(void**)getaddr(ptr->y), T->size());
  return pc + 1;
}

tacsim::pc_t tacsim::loff(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  const type* Tz = ptr->z->m_type;
  char* dst = (char*)getaddr(ptr->x);
  const type* Ty = ptr->y->m_type;
  int sy = Ty->size();
  int64_t delta = (sy == 4) ? *(int32_t*)getaddr(ptr->y) : *(int64_t*)getaddr(ptr->y);
  memcpy(dst + delta, getaddr(ptr->z), Tz->size());
  return pc + 1;
}

tacsim::pc_t tacsim::roff(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  const type* Tx = ptr->x->m_type;
  char* src = (char*)getaddr(ptr->y);
  const type* Tz = ptr->z->m_type;
  int sz = Tz->size();
  int64_t delta = (sz == 4) ? *(int32_t*)getaddr(ptr->z) : *(int64_t*)getaddr(ptr->z);
  memcpy(getaddr(ptr->x), src + delta, Tx->size());
  return pc + 1;
}

tacsim::pc_t tacsim::alloca_(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  const type* T = ptr->y->m_type;
  uint64_t size;
  if (T->size() == 4)
    size = *(uint32_t*)getaddr(ptr->y);
  else {
    assert(T->size() == 8);
    size = *(uint64_t*)getaddr(ptr->y);
  }
  address_table_t& curr = g_stack.back();
  curr[ptr->x] = new char[size];
  return pc + 1;
}

tacsim::pc_t tacsim::asm_(tacsim::pc_t pc)
{
  tac* ptr = *pc;
  asm3ac* tmp = static_cast<asm3ac*>(ptr);
  throw asm3ac(*tmp);
}

tacsim::pc_t tacsim::vastart(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  const type* T = ptr->y->m_type;
#ifdef __CYGWIN__
  if (sizeof(void*) == 8 && T->real() && T->size() == sizeof(long double)) {
    const address_table_t& curr = g_passed_addr.back();
    address_table_t::const_iterator it = curr.find(ptr->y);
    assert(it != curr.end());
    char* p = (char*)it->second;
    *(char**)getaddr(ptr->x) = p + 8;
    return pc + 1;
  }
#endif // __CYGWIN__

  char* p = (char*)getaddr(ptr->y);
  int size = T->size();
  // Workaround for calling function which takes va_list.
  // See also allocate::add_size comment.
  if (sizeof(void*) == 8)
    size = max(size, 8);
  *(char**)getaddr(ptr->x) = p + size;

  return pc + 1;
}

#ifdef __CYGWIN__
namespace tacsim {
  pc_t ref_substance_from_addr(pc_t pc, char* src, const type* T)
  {
    src = (char*)align((uint64_t)src, 8);
    void* addr = *(void**)src;
    int size = T->size();
    tac* ptr = *pc;
    memcpy(getaddr(ptr->x), addr, size);
    *(char**)getaddr(ptr->y) = src + 8;
    return pc + 1;
  }
} // end of namespace tacsim
#endif // __CYGWIN__

tacsim::pc_t tacsim::vaarg(tacsim::pc_t pc)
{
  using namespace std;
  using namespace COMPILER;

  tac* ptr = *pc;
  char* src = *(char**)getaddr(ptr->y);
  va_arg3ac* varg = static_cast<va_arg3ac*>(ptr);
  const type* T = varg->m_type;
  T = T->promotion();

  // Workaround for calling function which takes va_list.
  // See also allocate::add_size comment.
  if (sizeof(void*) == 8) {
#ifdef __CYGWIN__
    if (T->real() && T->size() == sizeof(long double))
      return ref_substance_from_addr(pc, src, T);
#endif // __CYGWIN__
    int al = T->align();
    al = max(al, 8);
    src = (char*)align((uint64_t)src, al);
  }

  int size = T->size();
  memcpy(getaddr(ptr->x), src, size);
  *(char**)getaddr(ptr->y) = src + size;
  return pc + 1;
}

tacsim::pc_t tacsim::vaend(tacsim::pc_t pc){ return pc + 1; }
