BIT = $(shell sizeoflongx8.exe)
ifeq ($(BIT),32)
  CALL_US_CPP = call_Us.x86.gxx.cpp
else
  CALL_US_CPP = call_Us.x64.gxx.cpp
endif

SRCS =	allocate.cpp \
	exec.cpp \
	ext.cpp \
	stdafx.cpp \
	tacsim.cpp \
	$(CALL_US_CPP)


OBJS = $(SRCS:.cpp=.o)
TACSIM_DLL = tacsim.dll

XX_OBJS = $(SRCS:.cpp=.obj)
TACSIM_XX_DLL = tacsimxx.dll

DEBUG_FLAG = -g
PIC_FLAG = -fPIC
CXXFLAGS = $(DEBUG_FLAG) $(PIC_FLAG) -I$(HCC1_SRCDIR) -w
CXXFLAGS_FOR_XX = $(DEBUG_FLAG) $(PIC_FLAG) -I$(HCXX1_SRCDIR) -w \
-DCXX_GENERATOR

UNAME := $(shell uname)
DLL_FLAG =  -shared
ifneq (,$(findstring Darwin,$(UNAME)))
	DLL_FLAG = -dynamiclib
endif

turbo = $(if $(wildcard /etc/turbolinux-release),1,0)
ifeq ($(turbo),1)
  CXXFLAGS += -DTURBO_LINUX
endif

RM = rm -r -f

all:$(TACSIM_DLL) $(TACSIM_XX_DLL)

$(TACSIM_DLL) : $(OBJS)
	$(CXX) $(DEBUG_FLAG) $(PROF_FLAG) $(DLL_FLAG) -o $@ $(OBJS)

$(TACSIM_XX_DLL) : $(XX_OBJS)
	$(CXX) $(DEBUG_FLAG) $(PROF_FLAG) $(DLL_FLAG) -o $@ $(XX_OBJS)

%.obj : %.cpp
	$(CXX) $(CXXFLAGS_FOR_XX) $< -o $@ -c

clean:
	$(RM) *.o *.obj *~ $(TACSIM_DLL) $(TACSIM_XX_DLL) x64 Debug .vs
	$(RM) call_Us.x64.vs.i call_Us.x64.vs.s
	$(RM) -r .vs x64 Debug Release

call_Us.x86.gxx.o:call_Us.x86.gxx.cpp
	$(CXX) -g $(PIC_FLAG) -I$(HCC1_SRCDIR) -w -c -o $@ $<
