#include "stdafx.h"

#include "c_core.h"

#define COMPILER c_compiler

#ifndef _MSC_VER
#include <dirent.h>
#else // _MSC_VER
#include <io.h>
#include <stdarg.h>
#endif // _MSC_VER

#ifdef linux
extern "C" {
extern int __isoc99_fscanf (FILE * __stream,
			    const char * __format, ...);
extern int __isoc99_scanf (const char * __format, ...);
extern int __isoc99_sscanf (const char * __s,
			    const char * __format, ...);
}
#endif // linux

#include "tacsim.h"

tacsim::external::table_t tacsim::external::table;

#define REGISTER_MACRO(name) \
{ \
  void* tmp = (void*)&name; \
  insert(make_pair( #name ,tmp )); \
}

#ifdef _MSC_VER
namespace tacsim {
	char* unsafe_strcpy(char* dst, const char* src)
	{
		strcpy_s(dst, -1, src);
		return dst;
	}
	char* sbrk(int sz)
	{
		char* p = (char*)malloc(sz);
		return p ? p : (char*)-1;
	}
	extern int opendir(){ return 0; }
  extern int readdir(){ return 0; }
  extern void closedir(){}
}  // end of namespace tacsim
#endif // _MSC_VER

tacsim::external::table_t::table_t()
{
	using namespace std;
	REGISTER_MACRO(errno);
	REGISTER_MACRO(printf);
	REGISTER_MACRO(strlen);
	REGISTER_MACRO(getchar);
	REGISTER_MACRO(rand);
	REGISTER_MACRO(putchar);
	REGISTER_MACRO(atof);
	REGISTER_MACRO(getc);
	REGISTER_MACRO(putc);
	REGISTER_MACRO(fclose);
	REGISTER_MACRO(malloc);
	REGISTER_MACRO(free);
	REGISTER_MACRO(strcmp);
	REGISTER_MACRO(fprintf);
	REGISTER_MACRO(vfprintf);
	REGISTER_MACRO(exit);
	REGISTER_MACRO(fgets);
	REGISTER_MACRO(atoi);
	REGISTER_MACRO(stat);
	REGISTER_MACRO(ferror);
	REGISTER_MACRO(vprintf);
#ifndef _MSC_VER
	REGISTER_MACRO(strcpy);
	REGISTER_MACRO(scanf);
	REGISTER_MACRO(sscanf);
	REGISTER_MACRO(strcat);
	REGISTER_MACRO(sprintf);
	REGISTER_MACRO(fopen);
	REGISTER_MACRO(open);
	REGISTER_MACRO(creat);
#else // _MSC_VER
	{
		typedef errno_t FUNC(char*, size_t, const char*);
		FUNC* p = strcpy_s;
		insert(make_pair("strcpy_s", p));
		insert(make_pair("strcpy", unsafe_strcpy));
	}
	REGISTER_MACRO(scanf_s);
	REGISTER_MACRO(sscanf_s);
	{
		typedef errno_t FUNC(char*, size_t, const char*);
		FUNC* p = strcat_s;
		insert(make_pair("strcat_s", p));
	}
	{
		typedef errno_t FUNC(char*, size_t, const char*, ...);
		FUNC* p = sprintf_s;
		insert(make_pair("sprintf_s", p));
	}
	REGISTER_MACRO(fopen_s);
	_S_IREAD;
	REGISTER_MACRO(_sopen_s);
#endif // _MSC_VER
#ifndef __GNUC__
	REGISTER_MACRO(tolower);
	REGISTER_MACRO(isalpha);
	REGISTER_MACRO(isalnum);
	REGISTER_MACRO(isspace);
	REGISTER_MACRO(isdigit);
#else // __GNUC__
	{
		void* tmp = (void*)::tolower;
		insert(make_pair("tolower", tmp));
	}
	{
		void* tmp = (void*)::isalpha;
		insert(make_pair("isalpha", tmp));
	}
	{
		void* tmp = (void*)::isalnum;
		insert(make_pair("isalnum", tmp));
	}
	{
		void* tmp = (void*)::isspace;
		insert(make_pair("isspace", tmp));
	}
	{
		void* tmp = (void*)::isdigit;
		insert(make_pair("isdigit", tmp));
	}
#endif // __GNUC__
	{
#ifdef __CYGWIN__	  
		typedef char* FUNC(const char *, const char *);
#else  //  __CYGWIN__
		typedef const char* FUNC(const char *, const char *);		
#endif  //  __CYGWIN__
		FUNC* tmp = ::strstr;
		insert(make_pair("strstr", (void*)tmp));
	}
#ifdef _MSC_VER
	{
		typedef double FUNC(double);
		FUNC* tmp = ::sqrt;
		insert(make_pair("sqrt", (void*)tmp));
	}
#else // _MSC_VER
	{
		void* tmp = (void*)::sqrt;
		insert(make_pair("sqrt", tmp));
	}
#endif // _MSC_VER
#ifndef _MSC_VER
	REGISTER_MACRO(strdup);
	REGISTER_MACRO(read);
	REGISTER_MACRO(write);
	REGISTER_MACRO(lseek);
#else // _MSC_VER
	REGISTER_MACRO(_strdup);
	REGISTER_MACRO(_read);
	REGISTER_MACRO(_write);
	REGISTER_MACRO(_lseek);
#endif // _MSC_VER

	REGISTER_MACRO(opendir);
	REGISTER_MACRO(readdir);
	REGISTER_MACRO(closedir);
	REGISTER_MACRO(sbrk);

#ifdef __CYGWIN__
	REGISTER_MACRO(__locale_ctype_ptr);
	REGISTER_MACRO(__getreent);
#endif  // __CYGWIN__
#ifdef _MSC_VER
	REGISTER_MACRO(__acrt_iob_func);
	REGISTER_MACRO(__stdio_common_vfprintf);
	REGISTER_MACRO(_stat64i32);
#endif // _MSC_VER
#ifdef linux
	REGISTER_MACRO(__ctype_b_loc);
	REGISTER_MACRO(__isoc99_scanf);
	REGISTER_MACRO(__isoc99_fscanf);
	REGISTER_MACRO(__isoc99_sscanf);
	REGISTER_MACRO(stdin);
	REGISTER_MACRO(stdout);
	REGISTER_MACRO(stderr);
	REGISTER_MACRO(_IO_getc);
	REGISTER_MACRO(_IO_putc);
#endif // linux
}
