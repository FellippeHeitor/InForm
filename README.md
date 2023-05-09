# InForm-PE

![InForm logo](InForm/resources/Application-icon-128.png)

A GUI engine and WYSIWYG interface designer for QB64-PE

Wiki: <https://github.com/a740g/InForm-PE/wiki>

## Event-driven QB64-PE programs

InForm-PE's main goal is to generate event-driven QB64-PE applications. This means that you design a graphical user interface with interactive controls and then write the code to respond to such controls once they are manipulated.

## Workflow

After your form looks the way you want it to, click **File > Save** to export its contents and generate a **.bas** source file. Two files are output:

* **.frm**
the generated form in QB64-PE code. This can be loaded back into InForm-PE's designer or manually edited in QB64-PE or any text editor later, if you want to adjust fine details.

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

## Setup

Install Inform-PE and QB64-PE side-by-side in their own directories. There is no need to copy InForm-PE files to the QB64-PE directory. The following directory setup is recommended.

```text
<some-drive-or-directory>
    |
    |-------<InForm-PE>
    |
    |-------<QB64pe>
```
