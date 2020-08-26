#ifndef _TACSIM_H_
#define _TACSIM_H_

#ifdef CXX_GENERATOR
#define COMPILER cxx_compiler
#define param_scope scope
#else // CXX_GENERATOR
#define COMPILER c_compiler
#endif // CXX_GENERATOR

namespace tacsim {
  using namespace std;
  using namespace COMPILER;
  typedef map<var*, void*> address_table_t;
  extern vector<address_table_t> g_stack;
#ifdef __CYGWIN__
  extern vector<address_table_t> g_passed_addr;
#endif // __CYGWIN__
  namespace allocate {
    void register_funcs();
    void memory(const scope* ptr);
    extern vector<pair<void*, addrof*> > after_addrof;
    void set_addrof(const pair<void*, addrof*>& x);
    void entrance(const param_scope* ptr);
    void exit(const param_scope* ptr);
  }  // end of namespace allocate
  struct not_found {
    usr* m_usr;
    not_found(usr* u) : m_usr(u) {}
  };
  void* getaddr(var* v, bool prev = false);
  namespace external {
    struct table_t : map<string, void*> {
      table_t();
    };
    extern table_t table;
    void* get(usr*) throw (not_found);
  } // end of namespace external
  typedef vector<tac*>::const_iterator pc_t;
  bool call_direct(string name, pc_t ret);
  bool call_usr(usr* u, pc_t ret);
  extern int main_ret;
  extern const vector<pair<const fundef*, vector<tac*> > >* current_funcs;
  struct cmp_name {
    string m_name;
    cmp_name(string name) : m_name(name) {}
    bool operator()(const pair<const fundef*, vector<tac*> >& x)
    {
      using namespace std;
      using namespace COMPILER;
      const fundef* fun = x.first;
      const usr* u = fun->m_usr;
      return u->m_name == m_name;
    }
  };
  template<class K, class V> struct destroy {
    void operator()(std::pair<K,V> x) const
    {
      delete x.first;
    }
  };
  extern vector<const vector<tac*>*> current_code;
  extern vector<pair<void*, const type*> > parameters;
  inline uint64_t align(uint64_t offset, uint64_t al)
  {
    if (uint64_t n = offset & (al - 1))
      offset += al - n;
    return offset;
  }
#ifdef CXX_GENERATOR
  void call_initialize(const pair<const fundef*, vector<tac*> >&);
  void call_terminate(const pair<const fundef*, vector<tac*> >&);
  namespace except {
    extern const type* T;
  } // end of namespace except
#endif // CXX_GENERATOR
}  // end of namespace tacsim

#endif  // _TACSIM_H_
