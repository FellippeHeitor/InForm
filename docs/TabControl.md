# TabControl

A **TabControl** is a container with a row of tabs at the top. Each tab shows its own set of controls, so you can fit several pages of options in one form.

## In the designer

1. Click **New tab control** in the toolbox (the last button). It starts with two tabs.
2. Edit the **Tabs** property to rename, add or remove tabs, one per line.
3. Click a tab in the preview to show its page, then add or drop controls on it. A control belongs to the tab that was active when it was added.
4. **Active tab** sets which tab is shown when the program starts.

Like frames, tab controls can't be placed inside another container.

## How it works

- The tab captions are stored in `Text(id)`, one per line, the same way list box items are.
- `Control(id).Value` is the active tab (starting at 1) and `Control(id).Max` is the number of tabs.
- Every child control has a `TabPage` property: the tab it belongs to. `0` means the control is shown on every tab.
- Switching tabs fires `__UI_ValueChanged` for the tab control.

Users can switch tabs with the mouse, with the Left/Right/Home/End keys when the tab strip has focus, and with Ctrl+Tab / Ctrl+Shift+Tab from any control inside the tab control.

## Example

```vb
SUB __UI_ValueChanged (id AS LONG)
    SELECT CASE id
        CASE MainTabs
            SetCaption StatusLB, "Active tab: " + GetTabCaption(MainTabs, Control(MainTabs).Value)
    END SELECT
END SUB
```

The `TabDemo` example shows a complete form with three tabs and theme switching.

## API reference

```vb
SUB AddTab (id AS LONG, tabCaption AS STRING)
```

Adds a tab at the end. The first tab added becomes the active one.

```vb
SUB RemoveTab (id AS LONG, index AS LONG)
```

Removes a tab. Controls on that tab are hidden, and controls on later tabs move back one tab.

```vb
SUB SetTabCaption (id AS LONG, index AS LONG, tabCaption AS STRING)
FUNCTION GetTabCaption$ (id AS LONG, index AS LONG)
FUNCTION GetTabCount& (id AS LONG)
```

Change or read tab captions, and count the tabs.

```vb
SUB SetActiveTab (id AS LONG, index AS LONG)
```

Shows a tab, the same as clicking it (fires `__UI_ValueChanged`).

```vb
SUB SetControlTab (controlId AS LONG, page AS LONG)
```

Moves a child control to another tab (`0` = every tab).
