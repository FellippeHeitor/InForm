
# Makefile for InForm
# Copyright (c) 2022 Samuel Gomes

ifndef OS
$(error "OS must be set to 'lnx', 'win', or 'osx'")
endif

ifeq ($(OS),lnx)
	RM := rm -fr
	EXTENSION :=
endif

ifeq ($(OS),win)
	RM := del /Q
	EXTENSION := .exe
endif

ifeq ($(OS),osx)
	RM := rm -fr
	EXTENSION :=
endif

# This should point to your QB64 installation
QB64PE_PATH := ../QB64pe/
QB64PE := qb64pe
QB64PE_FLAGS := -x -w -e

.PHONY: all clean

all: UiEditor$(EXTENSION) InForm/UiEditorPreview$(EXTENSION) InForm/vbdos2inform$(EXTENSION)

UiEditor$(EXTENSION) : InForm/UiEditor.bas
	$(QB64PE_PATH)$(QB64PE)$(EXTENSION) $(QB64PE_FLAGS) $< -o $@

InForm/UiEditorPreview$(EXTENSION) : InForm/UiEditorPreview.bas
	$(QB64PE_PATH)$(QB64PE)$(EXTENSION) $(QB64PE_FLAGS) $< -o $@

InForm/vbdos2inform$(EXTENSION) : InForm/vbdos2inform.bas
	$(QB64PE_PATH)$(QB64PE)$(EXTENSION) $(QB64PE_FLAGS) $< -o $@

clean:
ifeq ($(OS),win)
	$(RM) UiEditor$(EXTENSION) InForm\UiEditorPreview$(EXTENSION) InForm\vbdos2inform$(EXTENSION)
else
	$(RM) UiEditor$(EXTENSION) InForm/UiEditorPreview$(EXTENSION) InForm/vbdos2inform$(EXTENSION)
endif
