# build options:
#   FBC            name of the fbc compiler
#   CMD_MKDIR      command for making directories
#   CMD_RM         command for removing files and directories
#   CMD_ECHO       command for printing text
#   FBCFLAGS       for options passed to fbc compiler
#   DEBUG=1        generate debug information
#   TARGET=win32   build for win32 x86
#   TARGET=win64   build for win32 x86_64
#   TARGET=win32   build for linux x86
#   TARGET=win64   build for linux x86_64
#   SHARED=1       build as shared libraries
#

FBC       = fbc
CMD_MKDIR = mkdir.exe
CMD_RM    = rm.exe
CMD_ECHO  = @printf.exe "%s\r\n"

FBCFLAGS += -w pedantic -mt -gen gcc -asm intel

-include config.mk

ifdef DEBUG
	FBCFLAGS += -g
endif

ifeq ($(TARGET),win32)
	FBCFLAGS += -target win32 -arch 686
	# FBCFLAGS += -gen gas
	TARGET_OS := win32
	TARGET_CPU := x86
	BITS := 32
else ifeq ($(TARGET),win64)
	FBCFLAGS += -target win64 -arch x86_64
	# FBCFLAGS += -gen gcc
	TARGET_OS := win32
	TARGET_CPU := x86_64
	BITS := 64
else ifeq ($(TARGET),lin32)
	FBCFLAGS += -target linux -arch 686
	# FBCFLAGS += -gen gas
	TARGET_OS := linux
	TARGET_CPU := x86
	BITS := 32
else ifeq ($(TARGET),lin64)
	FBCFLAGS += -target linux -arch x86_64 -pic
	# FBCFLAGS += -gen gcc
	TARGET_OS := linux
	TARGET_CPU := x86_64
	BITS := 64
else
	$(error need TARGET=win32|win64)
endif

FBCFLAGS += -i $(INCDIR)

SRCDIR := ./src
LIBDIR := ./lib/$(TARGET)
BINDIR := ./bin/$(TARGET)
INCDIR := ./inc
TSTDIR := ./tests

INC_HDRS := $(wildcard $(INCDIR)/*.bi)
INC_HDRS += $(wildcard $(INCDIR)/fbsound/*.bi)
SRC_HDRS := $(wildcard $(SRCDIR)/*.bi)
TST_HDRS := $(wildcard $(TSTDIR)/*.bi)

TARGETS :=

ifeq ($(TARGET_OS),win32)
	ifdef SHARED
		TARGETS += \
			$(LIBDIR)/libfbscpu.a \
			$(LIBDIR)/libfbsdsp.a  \
			$(BINDIR)/fbsound-$(BITS).dll \
			$(BINDIR)/fbsound-ds-$(BITS).dll \
			$(BINDIR)/fbsound-mm-$(BITS).dll \
			buildlib-$(BITS).bat
	else
		TARGETS += \
			$(LIBDIR)/libfbscpu.a \
			$(LIBDIR)/libfbsdsp.a  \
			$(LIBDIR)/libfbsound.a
		SRC_SRCS := \
			$(SRCDIR)/fbsound.bas \
			$(SRCDIR)/plug-static.bas \
			$(SRCDIR)/plug-mm.bas \
			$(SRCDIR)/plug-ds.bas
	endif
else ifeq ($(TARGET_OS),linux)
	TARGETS += \
		buildlib-$(BITS).sh
endif

TEST_SRCS := $(wildcard tests/*.bas)
TEST_EXES := $(patsubst %.bas,%.exe,$(TEST_SRCS))

.phony : build
build : $(TARGETS)

.phony : tests
tests : build $(TEST_EXES)

$(LIBDIR) $(BINDIR) :
	$(CMD_MKDIR) -p $@

$(LIBDIR)/libfbscpu.a : src/fbscpu.bas $(INC_HDRS) $(SRC_HDRS) | $(LIBDIR)
	$(FBC) $(FBCFLAGS) -lib $< -x $@

$(LIBDIR)/libfbsdsp.a : src/fbsdsp.bas $(INC_HDRS) $(SRC_HDRS) | $(LIBDIR)
	$(FBC) $(FBCFLAGS) -lib $< -x $@

$(LIBDIR)/libfbsound.a : $(SRC_SRCS) $(INC_HDRS) $(SRC_HDRS) | $(LIBDIR)
	$(FBC) $(FBCFLAGS) -lib $(SRC_SRCS) -x $@
 
$(BINDIR)/fbsound-$(BITS).dll : src/fbsound.bas $(INC_HDRS) $(SRC_HDRS) | $(BINDIR)
	$(FBC) $(FBCFLAGS) -dll $< -p $(LIBDIR) -x $@

$(BINDIR)/fbsound-ds-$(BITS).dll : src/plug-ds.bas | $(BINDIR)
	$(FBC) $(FBCFLAGS) -dll $< -p $(LIBDIR) -x $@

$(BINDIR)/fbsound-mm-$(BITS).dll : src/plug-mm.bas | $(BINDIR)
	$(FBC) $(FBCFLAGS) -dll $< -p $(LIBDIR) -x $@

$(TSTDIR)/%.exe:$(TSTDIR)/%.bas $(TST_HDRS)
	$(FBC) $(FBCFLAGS) $< -x $@

buildlib-$(BITS).bat: makefile
	$(CMD_ECHO) "@echo \"build FBSound 1.2 for Windows $(TARGET_CPU):\"" > $@
	$(CMD_ECHO) "@REM Set the right path to your $(BITS)-bit FreeBASIC compiler !" >> $@
	$(CMD_ECHO) "$(FBC) $(FBCFLAGS) -lib src/fbscpu.bas -x $(LIBDIR)/libfbscpu.a" >> $@
	$(CMD_ECHO) "$(FBC) $(FBCFLAGS) -lib src/fbsdsp.bas -x $(LIBDIR)/libfbsdsp.a" >> $@
	$(CMD_ECHO) "$(FBC) $(FBCFLAGS) -p $(LIBDIR)/ -dll src/fbsound.bas -x $(BINDIR)/fbsound-$(BITS).dll" >> $@
	$(CMD_ECHO) "$(FBC) $(FBCFLAGS) -dll src/plug-ds.bas -x $(BINDIR)/fbsound-ds-$(BITS).dll" >> $@
	$(CMD_ECHO) "$(FBC) $(FBCFLAGS) -dll src/plug-mm.bas -x $(BINDIR)/fbsound-mm-$(BITS).dll" >> $@
	$(CMD_ECHO) "del $(subst /,\\,$(BINDIR))\\libfbsound-$(BITS).dll.a" >> $@
	$(CMD_ECHO) "del $(subst /,\\,$(BINDIR))\\libfbsound-ds-$(BITS).dll.a" >> $@
	$(CMD_ECHO) "del $(subst /,\\,$(BINDIR))\\libfbsound-mm-$(BITS).dll.a" >> $@
	$(CMD_ECHO) "@echo \"ready!\"" >> $@
	$(CMD_ECHO) "@pause" >> $@
	$(CMD_ECHO) "" >> $@

buildlib-$(BITS).sh: makefile
	$(CMD_ECHO) "#!/bin/sh" > $@
	$(CMD_ECHO) "echo \"build FBSound 1.2 for Linux $(TARGET_CPU):\"" >> $@
	$(CMD_ECHO) "echo \"build Linux $(TARGET_CPU) $(LIBDIR)/libfbscpu.a\"" >> $@
	$(CMD_ECHO) "fbc -g -w pedantic $(FBCFLAGS) -lib src/fbscpu.bas -x $(LIBDIR)/libfbscpu.a" >> $@
	$(CMD_ECHO) "echo \"build Linux $(TARGET_CPU) $(LIBDIR)/libfbsdsp.a\"" >> $@
	$(CMD_ECHO) "fbc -g -w pedantic $(FBCFLAGS) -lib src/fbsdsp.bas -x $(LIBDIR)/libfbsdsp.a" >> $@
	$(CMD_ECHO) "echo \"build Linux $(TARGET_CPU) $(BINDIR)/libfbsound-$(BITS).so\"" >> $@
	$(CMD_ECHO) "fbc -g -w pedantic $(FBCFLAGS) -p $(LIBDIR)/ -dylib src/fbsound.bas -x $(BINDIR)/libfbsound-$(BITS).so" >> $@
	$(CMD_ECHO) "echo \"build Linux $(TARGET_CPU) $(BINDIR)/libfbsound-alsa-$(BITS).so\"" >> $@
	$(CMD_ECHO) "fbc -g -w pedantic $(FBCFLAGS) -dylib src/plug-alsa.bas -x $(BINDIR)/libfbsound-alsa-$(BITS).so" >> $@
	$(CMD_ECHO) "echo \"ready!\"" >> $@
	$(CMD_ECHO) "echo \"\"" >> $@
	$(CMD_ECHO) "echo \"have fun with FreeBASIC and FBSound\"" >> $@
	$(CMD_ECHO) "echo \"\"" >> $@
	$(CMD_ECHO) "" >> $@

.phony : clean
clean : clean-build clean-tests

.phony : clean-build
clean-build :
	$(CMD_RM) -f $(TARGETS)

.phony : clean-tests
clean-tests :
	$(CMD_RM) -f $(TEST_EXES)
