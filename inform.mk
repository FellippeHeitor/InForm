# Makefile for InForm-PE

ifeq ($(OS),)
	ifeq ($(shell uname -s),Linux)
		OS := Linux
	endif
	ifeq ($(shell uname -s),Darwin)
		OS := macOS
	endif
endif

ifeq ($(OS),)
	OS := Windows_NT
endif

ifeq ($(filter $(OS),Linux macOS Windows_NT),)
	$(error OS must be set to 'Linux', 'macOS', or 'Windows_NT'.)
endif

$(info OS: $(OS))

ifeq ($(OS),Windows_NT)
	RM := del /Q
	EXTENSION := .exe
	FIXPATH = $(subst /,\,$1)
else
	RM := rm -fr
	EXTENSION :=
	FIXPATH = $1
endif

SEARCH_PATHS := $(QB64PE_PATH) . ../qb64pe ../QB64pe ../QB64PE

QB64PE_PATH_FOUND = $(firstword $(foreach dir,$(SEARCH_PATHS),$(if $(wildcard $(dir)/qb64pe$(EXTENSION)),$(dir),)))

ifeq ($(QB64PE_PATH_FOUND),)
	$(error QB64-PE executable not found in default search paths. Please provide the path using QB64PE_PATH.)
endif

QB64PE := $(QB64PE_PATH_FOUND)/qb64pe$(EXTENSION)

$(info Using QB64PE from: $(QB64PE))

QB64PE_FLAGS := -x -w -e

TEST_EXECUTABLE := tests/test_main$(EXTENSION)

.PHONY: all release test clean

all: UiEditor$(EXTENSION) InForm/UiEditorPreview$(EXTENSION) InForm/vbdos2inform$(EXTENSION) ThemeEditor$(EXTENSION)

UiEditor$(EXTENSION) : InForm/UiEditor.bas
	$(QB64PE) $(QB64PE_FLAGS) $< -o $@

InForm/UiEditorPreview$(EXTENSION) : InForm/UiEditorPreview.bas
	$(QB64PE) $(QB64PE_FLAGS) $< -o $@

InForm/vbdos2inform$(EXTENSION) : InForm/vbdos2inform.bas
	$(QB64PE) $(QB64PE_FLAGS) $< -o $@

ThemeEditor$(EXTENSION) : InForm/ThemeEditor.bas InForm/ThemeEditor.frm
	$(QB64PE) $(QB64PE_FLAGS) $< -o $@

$(TEST_EXECUTABLE): tests/test_main.bas
	$(QB64PE) $(QB64PE_FLAGS) $< -o $@

release: clean
	$(MAKE) -f inform.mk all QB64PE_FLAGS="$(QB64PE_FLAGS) -f:OptimizeCppProgram=true"

test: $(TEST_EXECUTABLE)
	@echo "Running tests..."
	$(call FIXPATH,./$(TEST_EXECUTABLE))

clean:
	-$(RM) $(call FIXPATH,UiEditor$(EXTENSION)) $(call FIXPATH,InForm/UiEditorPreview$(EXTENSION)) $(call FIXPATH,InForm/vbdos2inform$(EXTENSION)) $(call FIXPATH,ThemeEditor$(EXTENSION)) $(call FIXPATH,$(TEST_EXECUTABLE))