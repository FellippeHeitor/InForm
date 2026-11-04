# Anchors

Anchors let controls move and stretch on their own when a form is resized, so a resizable form doesn't need layout code in `__UI_FormResized`.

## In the designer

1. Select the form and tick **Resizable** in Control toggles.
2. Select a control. Under Control toggles, the **Anchor** picker shows the control as a box inside its parent, with a bar from each side to the parent's edge. Click a side to anchor the control to that edge (the bar turns solid) or to release it (the bar turns dotted). The line under the picker says what the control will do, e.g. "Sticks to the bottom-right corner of the form."

| Anchored to | When the form gets wider, the control... |
|-------------|------------------------------------------|
| Left (default) | stays where it is |
| Right | moves right with the edge |
| Left + right | gets wider |

Top and bottom work the same way for the height. A control always follows at least one side in each direction, so to release the left side, anchor the right one first. With several controls selected, a click changes only that edge on each of them.

In the preview, a selected control with anchors other than the default shows a small blue pin on each edge it follows. The pins are part of **View > Show invisible elements on the preview**.

## How it works

- `Control(id).Anchor` holds a combination of `__UI_Anchor_Left`, `__UI_Anchor_Top`, `__UI_Anchor_Right` and `__UI_Anchor_Bottom`. `0` (the default) means left + top.
- Controls on the form follow the form. Controls inside a **Frame** or **TabControl** follow that container, so a container can stretch and its own anchored children follow it.
- Anchors apply whenever the form's size changes: when the user resizes the window, and when your code sets `Control(form).Width` or `.Height`.
- Controls are laid out before `__UI_FormResized` runs, so your code there sees the new layout and can still change it.
- Widths and heights never go below 1 pixel. The size a control would have had is remembered, so after shrinking a form past what fits, growing it back restores the original layout exactly. Setting a minimum form size in `__UI_FormResized` keeps controls from getting squashed in the first place.
- Anchors don't move anything in the designer's preview.
- For users to be able to resize the window, the form needs `CanResize = True` and a `$RESIZE:ON` line in `__UI_LoadForm`. The designer writes both when **Resizable** is ticked; add them yourself if you write the .frm by hand.

## Example

```vb
SUB __UI_OnLoad
    Control(OkBT).Anchor = __UI_Anchor_Right OR __UI_Anchor_Bottom
    Control(CancelBT).Anchor = __UI_Anchor_Right OR __UI_Anchor_Bottom
    Control(NotesTB).Anchor = __UI_Anchor_Left OR __UI_Anchor_Top OR __UI_Anchor_Right OR __UI_Anchor_Bottom
END SUB

SUB __UI_FormResized
    'Keep the form from getting too small; this resizes it again, and the anchors follow
    IF Control(MainForm).Width < 400 THEN Control(MainForm).Width = 400
    IF Control(MainForm).Height < 260 THEN Control(MainForm).Height = 260
END SUB
```

See `examples/AnchorsDemo` for a complete program.
