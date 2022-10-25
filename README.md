# InForm

![InForm logo](InForm/resources/Application-icon-128.png)

A GUI engine and WYSIWYG interface designer for QB64-PE

Wiki: <https://github.com/a740g/InForm/wiki>

## Event-driven QB64 programs

InForm's main goal is to generate event-driven QB64 applications. This means that you design a graphical user interface with interactive controls and then write the code to respond to such controls once they are manipulated.

## Workflow

After your form looks the way you want it to, click File -> Save to export its contents and generate a .bas source file. Two files are output:

* **.frm**
the generated form in QB64 code. This can be loaded back into InForm's designer or manually edited in QB64 or any text editor later, if you want to adjust fine details.

* **.bas**
the actual program you will add your code to.

### You add code to respond to events

* *Click*
* *MouseEnter/MouseLeave* (hover)
* *FocusIn/FocusOut*
* *MouseDown/MouseUp* (events preceding a Click)
* *KeyPress*
* *TextChanged* (for text box controls)
* *ValueChanged* (for track bars, lists and dropdown lists)

### There are also events that occur in specific moments, to which you can respond/add code

* *BeforeInit*, triggered just before the form is shown.
* *OnLoad*, triggered right after the form is first shown.
* *BeforeUpdateDisplay*, triggered everytime the form is about to be repainted.
* *BeforeUnload*, triggered when the user tries to close the program, either via clicking the window's X button, right click in the task bar -> Close or with Alt+F4 (Windows only).
* *FormResized*, triggered when a form with the CanResize property is resized at runtime.

## Developer Goals

* Decouple QB64-PE internal features from the library (e.g. falcon.h)
* Ensure library continues to work even if QB64-PE font library changes 😉
* Make the library standalone and work from any directory
* Remove all gimmicky features like the defunct auto-update & installer
* Ensure the library does not write anything to disk and runs completely from memory
