# Edit this to reflect your path to zsound directory
# Or just copy zsound.lib and pcmplayer.inc into the ./zsound folder
ZSOUND_DIR := ../../zsound

TARGET = WOW.PRG
SYMFILE = $(TARGET:.PRG=.sym)

PCMPLAYER_INC := $(ZSOUND_DIR)/inc/pcmplayer.inc
PCMPLAYER_H := $(ZSOUND_DIR)/include/pcmplayer.h
ZSOUND_INC := $(PCMPLAYER_INC) $(PCMPLAYER_H)
ZSOUND_LIB := $(ZSOUND_DIR)/lib/zsound.lib

LIBS := zsound/zsound.lib
INCS := zsound/pcmplayer.inc zsound/pcmplayer.h

SRCDIR = src
CSRC   = $(wildcard $(SRCDIR)/*.c)
ASMSRC = $(wildcard $(SRCDIR)/*.asm)
SRCS   = $(CSRC) $(ASMSRC)

CL65FLAGS = -t cx16 -g -Ln $(SYMFILE) -Izsound --asm-include-dir zsound -O


demo: $(TARGET)

clean:
	rm -f $(TARGET) $(SRCDIR)/*.o

zsound: $(LIBS) $(INCS)
#	mkdir -p zsound
#	cp $(ZSOUND_LIB) $(ZSOUND_INC) zsound/

$(TARGET): $(SRCS) $(LIBS) $(INCS)
	cl65 $(CL65FLAGS) -o $@ $(SRCS) $(LIBS)

zsound/zsound.lib: $(ZSOUND_LIB)
	@mkdir -p zsound
	cp $(ZSOUND_LIB) zsound/

zsound/pcmplayer.inc: $(PCMPLAYER_INC)
	@mkdir -p zsound
	cp $(PCMPLAYER_INC) zsound/

zsound/pcmplayer.h: $(PCMPLAYER_H)
	@mkdir -p zsound
	cp $(PCMPLAYER_H) zsound/

$(ZSOUND_LIB):
	@cd $(ZSOUND_DIR) ; make lib

$(PCMPLAYER_INC):
	@echo ERROR: Cannot find $@

$(PCMPLAYER_LIB):
	@echo ERROR: Cannot find $@
