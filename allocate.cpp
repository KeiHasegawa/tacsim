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
  address_table_t g_static;
  vector<address_table_t> g_stack;
#ifdef __CYGWIN__
  vector<address_table_t> g_passed_addr;
#endif // __CYGWIN__
  namespace allocate {
    pair<var*, void*> conv(const pair<const fundef*, vector<tac*> >&);
    void usr1(const pair<string, vector<usr*> >& x);
    void usr2(usr* u);
    void constant_(usr* u);
    bool loc_mode;
    void set_value(pair<int, var*> x, void* dest);
    void for_var(var*);
    bool enter_mode;
#ifdef __CYGWIN__
    vector<vector<auto_ptr<char> > > copied;
#endif // __CYGWIN__
  }  // end of namespace allocate
}  // end of namespace tacsim

void tacsim::allocate::register_funcs()
{
  using namespace std;
  using namespace COMPILER;
  const vector < pair<const fundef*, vector<tac*> > >& funcs = *current_funcs;
  transform(funcs.begin(),funcs.end(),inserter(g_static, g_static.begin()), conv);
}

std::pair<COMPILER::var*, void*> tacsim::allocate::conv(const std::pair<const COMPILER::fundef*, std::vector<COMPILER::tac*> >& x)
{
  using namespace std;
  using namespace COMPILER;
  const fundef* func = x.first;
  var* v = func->m_usr;
  return make_pair(v, (void*)v);
}

#ifdef CXX_GENERATOR
namespace tacsim {
  const COMPILER::instantiated_tag::SEED* get_seed(const COMPILER::tag* ptr)
  {
    using namespace COMPILER;
    tag::flag_t flag = ptr->m_flag;
    if (flag & tag::INSTANTIATE) {
      typedef const instantiated_tag IT;
      IT* it = static_cast<IT*>(ptr);
      return &it->m_seed;
    }
    if (flag & tag::SPECIAL_VER) {
      typedef const special_ver_tag SV;
      SV* sv = static_cast<SV*>(ptr);
      return &sv->m_key;
    }
    return 0;
  }
  const COMPILER::type* reduce(const COMPILER::type* T)
  {
    using namespace COMPILER;
    T = T->unqualified();
    if (T->m_id == type::POINTER) {
      typedef const pointer_type PT;
      PT* pt = static_cast<PT*>(T);
      T = pt->referenced_type();
      return reduce(T);
    }
    if (T->m_id == type::REFERENCE) {
      typedef const reference_type RT;
      RT* rt = static_cast<RT*>(T);
      T = rt->referenced_type();
      return reduce(T);
    }
    if (T->m_id == type::ARRAY) {
      typedef const array_type AT;
      AT* at = static_cast<AT*>(T);
      T = at->element_type();
      return reduce(T);
    }
    return T;
  }
  bool incomplete(const std::pair<const COMPILER::type*, COMPILER::var*>& x)
  {
    using namespace std;
    using namespace COMPILER;
    const type* T = x.first;
    if (!T) {
      var* v = x.second;
      if (!v)
	return false;
      if (v->addrof_cast())
        return false;
      assert(v->usr_cast());
      usr* u = static_cast<usr*>(v);
      return u->m_flag2 & usr::TEMPL_PARAM;
    }
    T = reduce(T);
    if (T->m_id == type::TEMPLATE_PARAM)
      return true;
    if (T->m_id == type::VARRAY)
      return true;
    if (T->m_id == type::POINTER_MEMBER) {
      typedef const pointer_member_type PM;
      auto pm = static_cast<PM*>(T);
      T = pm->referenced_type();
      if (incomplete(make_pair(T, (var*)0)))
	return true;
      const tag* ptr = pm->ctag();
      T = ptr->m_types.first;
      return incomplete(make_pair(T, (var*)0));
    }
    if (tag* ptr = T->get_tag()) {
      if (ptr->m_flag & tag::TYPENAMED) {
        if (T->m_id == type::INCOMPLETE_TAGGED)
          return true;
      }
      if (const instantiated_tag::SEED* seed = get_seed(ptr)) {
        typedef instantiated_tag::SEED::const_iterator IT;
        IT p = find_if(begin(*seed), end(*seed), incomplete);
        return p != end(*seed);
      }
    }
    return false;
  }
} // end of namespace tacsim
#endif // CXX_GENERATOR

void tacsim::allocate::memory(const COMPILER::scope* ps)
{
  using namespace std;
  using namespace COMPILER;
#ifdef CXX_GENERATOR
  if (ps->m_id == scope::TAG) {
    const tag* ptr = static_cast<const tag*>(ps);
    tag::flag_t flag = ptr->m_flag;
    if (flag & tag::TEMPLATE)
      return;
    if (auto seed = get_seed(ptr)) {
      auto p = find_if(begin(*seed), end(*seed), incomplete);
      if (p != end(*seed))
	return;
    }
  }
#endif // CXX_GENERATOR
  const map<string, vector<usr*> >& usrs = ps->m_usrs;
  for_each(usrs.begin(), usrs.end(), usr1);
  const vector<scope*>& children = ps->m_children;
  for_each(children.begin(), children.end(), memory);
}

void tacsim::allocate::
usr1(const std::pair<std::string, std::vector<COMPILER::usr*> >& x)
{
  using namespace std;
  using namespace COMPILER;
  const vector<usr*>& vec = x.second;
  for_each(vec.begin(), vec.end(), usr2);
}

namespace tacsim {
  using namespace std;
  using namespace COMPILER;
  bool definition_of(pair<var*, void*> x, usr* u);
  namespace allocate {
    inline bool is_static(usr* u)
    {
      usr::flag_t flag = u->m_flag;
#ifdef CXX_GENERATOR
      if (flag & usr::STATIC_DEF)
        return true;
      scope::id_t id = u->m_scope->m_id;
      return (flag & usr::STATIC) && id != scope::TAG;
#else // CXX_GENERATOR
      return flag & usr::STATIC;
#endif // CXX_GENERATOR
    }
  } // end of namespace allocate
} // end of namespace tacsim

// This function is called when
// . allocate static memory       ( !loc_mode )
// . allocate non-static memory   ( loc_mode && enter_mode )
// . deallocate non-static memory ( loc_mode && !enter_mode )
void tacsim::allocate::usr2(COMPILER::usr* u)
{
  using namespace std;
  using namespace COMPILER;

  usr::flag_t flag = u->m_flag;

  if (flag & usr::TYPEDEF)
    return;

#ifdef CXX_GENERATOR
  if (flag & usr::NAMESPACE)
    return;
#endif // CXX_GENERATOR

  usr::flag_t mask = usr::flag_t(usr::EXTERN | usr::FUNCTION);
  if (flag & mask){
    if (loc_mode) {
      if (enter_mode)
        g_static[u] = 0;
      else {
        if (!is_external_declaration(u))
          g_static.erase(u);
      }
    }
    return;
  }

  if (is_static(u)) {
    if (loc_mode)
      return;
#ifdef CXX_GENERATOR
    if (flag & usr::STATIC_DEF) {
      address_table_t::const_iterator p =
        find_if(g_static.begin(), g_static.end(),
                bind2nd(ptr_fun(definition_of), u));
      if (p != g_static.end())
        return;
    }
#endif // CXX_GENERATOR
    const type* T = u->m_type;
    T = T->complete_type();
    int size = T->size();
    assert(size);
    void* p = g_static[u] = new char[size];
    memset(p, 0, size);
  }

  if (flag & usr::WITH_INI) {
    if (loc_mode)
      return;
    with_initial* wi = static_cast<with_initial*>(u);
    map<int, var*>& value = wi->m_value;
    if (!g_static[u]) {
      int size = u->m_type->size();
      assert(size);
      memset(g_static[u] = new char[size], 0, size);
    }
    for_each(value.begin(), value.end(),
             bind2nd(ptr_fun(set_value),g_static[u]));
    return;
  }

  if (flag & usr::STATIC)
    return;

#ifdef CXX_GENERATOR
  if (flag & usr::OVERLOAD)
    return;

  usr::flag2_t flag2 = u->m_flag2;
  if (flag2 & usr::PARTIAL_ORDERING)
    return;
#endif // CXX_GENERATOR

  if (u->isconstant())
    return constant_(u);

  if (is_external_declaration(u)) {
    if (loc_mode)
      return;
    address_table_t::const_iterator p =
      find_if(g_static.begin(), g_static.end(),
              bind2nd(ptr_fun(definition_of), u));
    if (p != g_static.end())
      return;
#ifdef CXX_GENERATOR
    if (flag2 & usr::ALIAS)
      return;
#endif // CXX_GENERATOR
    const type* T = u->m_type;
    int size = T->size();
    assert(size);
    memset(g_static[u] = new char[size], 0, size);
    return;
  }

  if (loc_mode)
    for_var(u);
}

void tacsim::allocate::constant_(COMPILER::usr* u)
{
  using namespace std;
  using namespace COMPILER;

  usr::flag_t flag = u->m_flag;
  if (loc_mode)
    return;

  const type* T = u->m_type;
  int size = T->size();
  void* p = g_static[u] = new char[size];
  if (T->real()) {
    if (size == sizeof(float)) {
      typedef float T;
      constant<T>* c = static_cast<constant<T>*>(u);
      *(T*)p = c->m_value;
    }
    else if (size == sizeof(double)) {
      typedef double T;
      constant<T>* c = static_cast<constant<T>*>(u);
      *(T*)p = c->m_value;
    }
    else {
      typedef long double T;
      assert(size == sizeof(T));
      constant<T>* c = static_cast<constant<T>*>(u);
      *(T*)p = c->m_value;
    }
  }
  else if (T->integer()) {
    if (size == sizeof(char)) {
      typedef char T;
      constant<T>* c = static_cast<constant<T>*>(u);
      *(T*)p = c->m_value;
    }
    else if (size == sizeof(short)) {
      typedef short T;
      constant<T>* c = static_cast<constant<T>*>(u);
      *(T*)p = c->m_value;
    }
    else if (size == sizeof(int)) {
      typedef int T;
      constant<T>* c = static_cast<constant<T>*>(u);
      *(T*)p = c->m_value;
    }
    else if (size == sizeof(long)) {
      typedef long T;
      constant<T>* c = static_cast<constant<T>*>(u);
      *(T*)p = c->m_value;
    }
    else {
      typedef long long T;
      assert(size == sizeof(T));
      constant<T>* c = static_cast<constant<T>*>(u);
      *(T*)p = c->m_value;
    }
  }
  else {
    assert(flag & usr::CONST_PTR);
    typedef void* T;
    constant<T>* c = static_cast<constant<T>*>(u);
    *(T*)p = c->m_value;
  }
}

namespace tacsim {
  namespace allocate {
    using namespace std;
    using namespace COMPILER;
    template<class T> void set_value2(void* dest, int offset, constant<T>* c)
    {
      char* pc = static_cast<char*>(dest) + offset;
      T* ptr = reinterpret_cast<T*>(pc);
      *ptr = c->m_value;
    }
  }
}  // end of namespace allocate, tacsim

void tacsim::allocate::set_value(std::pair<int, COMPILER::var*> x, void* dest)
{
  using namespace std;
  using namespace COMPILER;

  int offset = x.first;
  var* v = x.second;
  if (usr* u = v->usr_cast()) {
    assert(u->isconstant());
    const type* T = u->m_type;
    int size = T->size();
    if (T->real()) {
      if (size == sizeof(float))
        set_value2(dest, offset, static_cast<constant<float>*>(u));
      else if (size == sizeof(double))
        set_value2(dest, offset, static_cast<constant<double>*>(u));
      else {
        assert(size == sizeof(long double));
        set_value2(dest, offset, static_cast<constant<long double>*>(u));
      }
    }
    else if (T->integer()) {
      if (size == sizeof(char))
        set_value2(dest, offset, static_cast<constant<char>*>(u));
      else if (size == sizeof(short int))
        set_value2(dest, offset, static_cast<constant<short int>*>(u));
      else if (size == sizeof(int))
        set_value2(dest, offset, static_cast<constant<int>*>(u));
      else if (size == sizeof(long int))
        set_value2(dest, offset, static_cast<constant<long int>*>(u));
      else {
        assert(size == sizeof(long long int));
        set_value2(dest, offset, static_cast<constant<long long int>*>(u));
      }
    }
    else {
      assert(u->m_flag & usr::CONST_PTR);
      set_value2(dest, offset, static_cast<constant<void*>*>(u));
    }
  }
  else {
    addrof* addr = v->addrof_cast();
    assert(addr);
    dest = (char*)dest + offset;
    after_addrof.push_back(make_pair(dest, addr));
  }
}

void tacsim::allocate::for_var(COMPILER::var* v)
{
  using namespace std;
  using namespace COMPILER;

  if (enter_mode) {
    const type* T = v->m_type;
    int size = T->size();
    address_table_t& curr = g_stack.back();
    memset(curr[v] = new char[size], 0xcc, size);
  }
  else {
    address_table_t& curr = g_stack.back();
    address_table_t::iterator p = curr.find(v);
    if (p != curr.end()) {
      delete[] p->second;
      curr.erase(p);
    }
  }
}

namespace tacsim {
  using namespace std;
  vector<pair<void*, COMPILER::addrof*> > allocate::after_addrof;
} // end of namespace tacsim

void tacsim::allocate::set_addrof(const std::pair<void*, COMPILER::addrof*>& x)
{
  using namespace std;
  using namespace COMPILER;
  void* ptr = x.first;
  void** dest = (void**)ptr;
  addrof* addr = x.second;
  var* v = addr->m_ref;
  int offset = addr->m_offset;
  *dest = (void*)((char*)getaddr(v)+offset);
}

void* tacsim::getaddr(COMPILER::var* v, bool prev)
{
  using namespace std;
  using namespace COMPILER;
  int size = g_stack.size();
  assert(!prev || size >= 2);
  if (!g_stack.empty()){
    const address_table_t& ref = g_stack[prev ? size-2 : size-1];
    address_table_t::const_iterator p = ref.find(v);
    if (p != ref.end())
      return p->second;
  }

  address_table_t::const_iterator p = g_static.find(v);
  if (p != g_static.end()) {
    if (void* r = p->second)
      return r;
  }
#ifdef CXX_GENERATOR
  usr* u = v->usr_cast();
  if (!u) {
    auto ti = static_cast<type_information*>(v);
    const type* T = ti->m_T;
    return reinterpret_cast<void*>(const_cast<type*>(T));
  }
#else  // CXX_GENERATOR
  usr* u = v->usr_cast();
  assert(u);
#endif  // CXX_GENERATOR
  p = find_if(g_static.begin(), g_static.end(),
	      bind2nd(ptr_fun(definition_of), u));
  if (p != g_static.end()) {
    assert(p->second);
    return p->second;
  }

  return external::get(u);
}

void* tacsim::external::get(COMPILER::usr* u) throw (not_found)
{
  string name = u->m_name;
  map<string, void*>::const_iterator q = external::table.find(name);
  if (q != external::table.end())
    return q->second;
  throw not_found(u);
}

bool
tacsim::definition_of(std::pair<COMPILER::var*, void*> x, COMPILER::usr* uy)
{
  using namespace std;
  using namespace COMPILER;
  var* v = x.first;
  usr* ux = v->usr_cast();
  if (!ux)
    return false;
  if (ux->m_name != uy->m_name)
    return false;
  if (!is_external_declaration(ux))
    return false;
  if ((ux->m_flag & usr::EXTERN) && !(ux->m_flag & usr::FUNCTION))
    return false;
  if (ux->m_scope != uy->m_scope) {
    if (uy->m_scope->m_id != scope::BLOCK)
      return false;
  }
  return true;
}

namespace tacsim {
  using namespace std;
  using namespace COMPILER;
  namespace allocate {
    int add_size(int offset, const pair<void*, const type*>& x);
    char* save_param(char* p, const pair<void*, const type*>& x);
    char* decide_address(char* p, usr* u);
    void loc_var(scope*);
    stack<void*> param_area;
  }  // end of namespace allocate
}  // end of namespace tacsim

void tacsim::allocate::entrance(const COMPILER::param_scope* ptr)
{
  using namespace std;
  using namespace COMPILER;

  g_stack.push_back(address_table_t());
#ifdef __CYGWIN__
  g_passed_addr.push_back(address_table_t());
  copied.push_back(vector<auto_ptr<char> >());
#endif // __CYGWIN__
  int n = accumulate(parameters.begin(), parameters.end(), 0, add_size);
  char* p = n ? new char[n+16] : 0;
  param_area.push(p);
  (void)accumulate(parameters.begin(), parameters.end(), p, save_param);
  const vector<usr*>& order = ptr->m_order;
  (void)accumulate(order.begin(), order.end(), p, decide_address);
  for_each(parameters.begin(), parameters.end(), destroy<void*, const type*>()); parameters.clear();

  loc_mode = true;
  enter_mode = true;
  const vector<scope*>& children = ptr->m_children;
  for_each(children.begin(), children.end(), loc_var);
}

int tacsim::allocate::add_size(int offset, const std::pair<void*, const COMPILER::type*>& x)
{
  using namespace std;
  using namespace COMPILER;
  const type* T = x.second;
  T = T->promotion();

  // Workaround for calling function which takes va_list
  // and bellow just works in intel partially.
  // This is not complete even if limited intel.
  if (sizeof(void*) == 8) {
#ifdef __CYGWIN__
    if (T->real() && T->size() == sizeof(long double)) {
      offset = tacsim::align(offset, 8);
      return offset + 8;
    }
#endif // __CYGWIN__          
    int al = T->align();
    al = max(al, 8);
    offset = tacsim::align(offset, al);
  }
  return offset + T->size();
}

#ifdef __CYGWIN__
namespace tacsim {
  namespace allocate {
    using namespace std;
    using namespace COMPILER;
    char* create_copy_pass_addr(char* p, void* src, const type* T)
    {
      p = (char*)tacsim::align((uint64_t)p, 8);
      int size = T->size();
      char* dst = new char[size];
      vector<auto_ptr<char> >& v = copied.back();
      v.push_back(auto_ptr<char>(dst));
      memcpy(dst, src, size);
      *(char**)p = dst;
      return p + 8;
    }
    char* decide_addr_created_copy(char* p, usr* u)
    {
      p = (char*)tacsim::align((uint64_t)p, 8);
      address_table_t& curr = g_stack.back();
      curr[u] = *(void**)p;
      address_table_t& curr2 = g_passed_addr.back(); 
      curr2[u] = p;
      return p + 8;
    }
  } // end of namespace allocate
} // end of namespace tacsim
#endif // __CYGWIN__

namespace tacsim {
  namespace allocate {
    using namespace std;
    using namespace COMPILER;
    char* save_param(char* p, const pair<void*, const type*>& x)
    {
      using namespace COMPILER;
      void* src = x.first;
      const type* T = x.second;
      T = T->promotion();

      // Workaround for calling function which takes va_list.
      // See also add_size comment.
      if (sizeof(void*) == 8) {
#ifdef __CYGWIN__
        if (T->real() && T->size() == sizeof(long double))
          return create_copy_pass_addr(p, src, T);
#endif // __CYGWIN__
        int al = T->align();
        al = max(al, 8);
        p = (char*)tacsim::align((uint64_t)p, al);
      }

      memcpy(p, src, T->size());
      return p + T->size();
    }
  } // end of namespace allocate
} // end of namespace tacsim

char* tacsim::allocate::decide_address(char* p, COMPILER::usr* u)
{
  using namespace COMPILER;
  const type* T = u->m_type;
  T = T->promotion();

  // Workaroudn for calling function which takes va_list.
  // See also add_size and save_param comment.
  if (sizeof(void*) == 8) {
#ifdef __CYGWIN__
    if (T->real() && T->size() == sizeof(long double))
      return decide_addr_created_copy(p, u);
#endif // __CYGWIN__          
    int al = T->align();
    al = max(al, 8);
    p = (char*)tacsim::align((uint64_t)p, al);
  }
        
  address_table_t& curr = g_stack.back();
  curr[u] = p;
  return p + T->size();
}

void tacsim::allocate::loc_var(COMPILER::scope* ptr)
{
  using namespace std;
  using namespace COMPILER;
        
  if (ptr->m_id != scope::BLOCK)
    return;
  block* b = static_cast<block*>(ptr);
  const map<string, vector<usr*> >& usrs = b->m_usrs;
  for_each(usrs.begin(), usrs.end(), usr1);
  const vector<var*>& vars = b->m_vars;
  for_each(vars.begin(), vars.end(), for_var);
  const vector<scope*>& children = b->m_children;
  for_each(children.begin(), children.end(), loc_var);
}

void tacsim::allocate::exit(const COMPILER::param_scope* ptr)
{
  using namespace std;
  using namespace COMPILER;

  void* p = param_area.top();
  delete[] p;
  param_area.pop();

  enter_mode = false;
  const vector<scope*>& children = ptr->m_children;
  for_each(children.begin(), children.end(), loc_var);
  g_stack.pop_back();
#ifdef __CYGWIN__
  g_passed_addr.pop_back();
  copied.pop_back();
#endif // __CYGWIN__
}
