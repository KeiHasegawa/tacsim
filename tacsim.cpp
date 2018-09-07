#include "stdafx.h"

#include "c_core.h"

#define COMPILER c_compiler

#include "tacsim.h"

#ifdef _MSC_VER
#define DLL_EXPORT __declspec(dllexport)
#else // _MSC_VER
#define DLL_EXPORT
#endif // _MSC_VER

extern "C" DLL_EXPORT int generator_seed()
{
#ifdef _MSC_VER
  int r = _MSC_VER;
#ifndef CXX_GENERATOR
  r += 10000000;
#else // CXX_GENERATOR
  r += 20000000;
#endif // CXX_GENERATOR
#ifdef WIN32
  r += 100000;
#endif // WIN32
#endif // _MSC_VER
#ifdef __GNUC__
  int r = (__GNUC__ * 10000 + __GNUC_MINOR__ * 100 + __GNUC_PATCHLEVEL__);
#ifndef CXX_GENERATOR
  r += 30000000;
#else // CXX_GENERATOR
  r += 40000000;
#endif // CXX_GENERATOR
#endif // __GNUC__
  return r;
}

namespace tacsim {
  using namespace std;
  string m_generator;
  const char** option_handler(const char** option, int* error);
  const char** arg_option(const char** option, int* error);
  vector<char*> args;
  bool setup();
}

extern "C" DLL_EXPORT void generator_option(int argc, const char** argv, int* error)
{
  using namespace std;
  using namespace tacsim;
  m_generator = *argv;
  ++argv;
  --argc;
  const char** end = argv + argc;
  while (argv != end)
    argv = option_handler(argv, error++);
}

const char** tacsim::option_handler(const char** option, int* error)
{
  using namespace std;
  if (string("--version") == *option) {
    if (!m_generator.empty())
      cerr << m_generator << " : ";
    cerr << "version " << "1.0" << '\n';
    return ++option;
  }
  if (string("--arg") == *option)
    return arg_option(option, error);
        
  if (!m_generator.empty())
    cerr << m_generator << " : ";
  cerr << "unknown option " << *option << '\n';
  *error = 1;
  return ++option;
}

#ifdef _MSC_VER
#define strdup _strdup
#endif // _MSC_VER

const char** tacsim::arg_option(const char** option, int* error)
{
  using namespace std;

  string left = "[";
  if (!*++option || *option != left) {
    cerr << m_generator << " : --arg option requires '['" << '\n';
    *error = 1;
    return ++option;
  }

  string right = "]";
  while (*++option) {
    if (right == *option)
      return ++option;
    args.push_back(strdup(*option));
  }

  cerr << m_generator << " : --arg option requires ']'" << '\n';
  *error = 1;
  return option;
}


extern "C" DLL_EXPORT
void generator_last(const COMPILER::generator::last_interface_t* ptr)
{
  using namespace std;
  using namespace COMPILER;
  using namespace tacsim;
  current_funcs = ptr->m_funcs;
  allocate::register_funcs();
  allocate::memory(ptr->m_root);
  vector<pair<void*, addrof*> >& v = allocate::after_addrof;
  for_each(v.begin(), v.end(), allocate::set_addrof);
  v.clear();
  if (!setup() && !args.empty()) {
    if (!m_generator.empty())
      cerr << m_generator << " : ";
    cerr << "--arg option is specified but `main' function is not declared as";
    cerr << " `int main(int, char**)'" << '\n';
    if (!m_generator.empty())
      cerr << m_generator << " : ";
    cerr << "--arg option is just ignored." << '\n';
  }
  try {
    vector<tac*> dummy;
    dummy.push_back(0);
    if (!call_direct("main", dummy.end())) {
      if (!m_generator.empty())
        cerr << m_generator << " : ";
      cerr << "`main' function is not defined." << '\n';
    }
  }
  catch (not_found nf) {
    const usr* u = nf.m_usr;
    string name = u->m_name;
    file_t file = u->m_file;
    if (!m_generator.empty())
      cerr << m_generator << " : ";
    cerr << '`' << name << "' is declared at ";
    cerr << file.m_name << ':' << file.m_lineno << " but not defined." << '\n';
  }
  catch ( asm3ac asm3 ) {
    file_t file = asm3.m_file;
    string s = asm3.m_inst;
    if (!m_generator.empty())
      cerr << m_generator << " : ";                
    cerr << "asm(" << s << ") is detected";
    cerr << " at " << file.m_name << ':' << file.m_lineno << '\n';
    if (!m_generator.empty())
      cerr << m_generator << " : ";                
    cerr << "cannot simulate" << '\n';
  }
        
  if (main_ret)
    exit(main_ret);
}

bool tacsim::setup()
{
  using namespace std;
  using namespace COMPILER;

  const vector<pair<const fundef*, vector<tac*> > >& funcs = *current_funcs;
  vector<pair<const fundef*, vector<tac*> > >::const_iterator p =
    find_if(funcs.begin(), funcs.end(), bind2nd(ptr_fun(cmp_name), "main"));
  if (p == funcs.end())
    return false;
  const fundef* fun = p->first;
  usr* u = fun->m_usr;
  const type* T = u->m_type;
  const func_type* ft = static_cast<const func_type*>(T);
  const vector<const type*>& param = ft->param();
  if (param.size() < 2)
    return false;
  const type* intt = param[0];
  if (intt->m_id != type::INT)
    return false;
  const type* ptrt = param[1];
  ptrt = ptrt->unqualified();
  if (ptrt->m_id != type::POINTER)
    return false;

  if (args.empty())
    args.push_back(strdup(m_generator.c_str()));

  parameters.push_back(make_pair(new int(args.size()), intt));
  typedef char** PTR;
  PTR ptr = args.data();
  parameters.push_back(make_pair(new PTR(ptr), ptrt));

  return true;
}
