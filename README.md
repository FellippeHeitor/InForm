# INFORM-PE

![InForm logo](InForm/resources/Application-icon-128.png)

[InForm-PE](https://github.com/QB64-Phoenix-Edition/InForm-PE) is a GUI engine and WYSIWYG interface designer for [QB64-PE](https://www.qb64phoenix.com/). It is a fork of [InForm](https://github.com/FellippeHeitor/InForm), authored by [Fellippe Heitor](https://github.com/FellippeHeitor).

InForm-PE's main goal is to generate *event-driven* QB64-PE applications. This means that you design a graphical user interface with interactive controls and then write the code to respond to such controls once they are manipulated.

## FEATURES

- WYSIWYG interface designer
- Event-driven application design
- Works on Windows, Linux & macOS
- Everything is statically linked (no shared library dependencies)
- Themes: classic XP, flat light and flat dark built in, or your own theme files ([Themes](docs/Themes.md))
- Tab control for multi-page forms ([TabControl](docs/TabControl.md))

## DOCUMENTATION

- [Wiki](https://github.com/QB64-Phoenix-Edition/InForm-PE/wiki)
- [Tutorial](https://raw.githack.com/QB64-Phoenix-Edition/InForm-PE/refs/heads/master/docs/tutorial/index.html)
- [Extensions](docs/Extensions.md)
- [Themes](docs/Themes.md)
- [TabControl](docs/TabControl.md)

## USAGE

Install InForm-PE and QB64-PE side-by-side in their own directories. There is no need to copy InForm-PE files to the QB64-PE directory.

> The following directory setup is recommended

```text
<some-drive-or-directory/>
        ├────<InForm-PE/>
        │       └───<UiEditor[.exe]>
        └────<QB64pe/>
                └───<qb64pe[.exe]>
```

Assuming your setup is like the above, do the following:

- Open Terminal and change to the InForm-PE directory using an appropriate OS command
- Run `setup_inform_lnx.sh`, `setup_inform_mac.command` or `setup_inform_win.cmd` depending on the OS you are on. This will run make with the correct parameters. If the build fails, ensure QB64-PE is installed in the **QB64pe** directory (next to the InForm-PE directory). If QB64-PE is installed elsewhere, then edit the setup scripts to change the location
- Once InForm-PE is compiled, you will find the UiEditor[.exe] and ThemeEditor[.exe] executables in the InForm-PE directory
- Run UiEditor[.exe] to start designing your forms
- Run ThemeEditor[.exe] to create your own themes (see [Themes](docs/Themes.md))
- After your form looks the way you want it to, click **File > Save** to export its contents and generate a **.bas** source file. Two files are exported:
  - **.frm** - the generated form in QB64-PE code. This can be loaded back into InForm-PE's designer or manually edited in QB64-PE or any text editor later, if you want to adjust fine details
  - **.bas** - the actual program you will add your code to

***You add code to respond to events.***

- *Click*
- *MouseEnter/MouseLeave* (hover)
- *FocusIn/FocusOut*
- *MouseDown/MouseUp* (events preceding a Click)
- *KeyPress*
- *TextChanged* (for text box controls)
- *ValueChanged* (for track bars, lists and dropdown lists)

***There are also events that occur in specific moments, to which you can respond/add code.***

- *BeforeInit*, triggered just before the form is shown.
- *OnLoad*, triggered right after the form is first shown.
- *BeforeUpdateDisplay*, triggered every time the form is about to be repainted.
- *BeforeUnload*, triggered when the user tries to close the program, either via clicking the window's X button, right click in the task bar -> Close or with Alt+F4 (Windows only).
- *FormResized*, triggered when a form with the CanResize property is resized at runtime.

***IMPORTANT: The following files must be copied to your project directory for it to compile.***

```text
InForm/InForm.bi
InForm/InForm.ui
InForm/InFormCommon.bi
InForm/InFormVersion.bi
InForm/InFormTheme.bm
InForm/InFormTabControl.bm
InForm/xp.uitheme
InForm/themes/*.*
InForm/extensions/*.*
```

## EXAMPLES

| Name | Author |
|------|-------------|
| 21-game | TempodiBasic |
| Bin2Include | Zachary Spriggs |
| Bubble-Universe | Samuel Gomes |
| Calculator | Terry Ritchie |
| ClickTheVoid | Fellippe Heitor |
| ClockPatience | Richard Notley |
| DuckShoot | Richard Notley |
| ebacCalculator | George McGinn |
| EncryptDecrypt | TempodiBasic |
| Fahrenheit-Celsius | Richard Notley |
| Fireworks2 | Fellippe Heitor |
| GIFPlaySample | Fellippe Heitor |
| GravitationSimulation | Richard Notley |
| GX-Map-Maker | boxgaming |
| InFormPaint | Fellippe Heitor |
| InsideOutsideTriangle |  Richard Notley |
| Lander1 | B+ |
| Lander2 | B+ |
| Mahjong | Richard Notley |
| MasterMindGuessTheSequence | TempodiBasic |
| Pelmanism | Richard Notley |
| PictureGrid | Richard Notley |
| PlayFX | Samuel Gomes |
| R2P | bobalooie |
| RockPaperScissorsSpockLizard | TempodiBasic |
| Stopwatch | Fellippe Heitor |
| TabDemo | Fellippe Heitor |
| TextFetch | B+ |
| ThemeGallery | Fellippe Heitor |
| ThemePreview | Fellippe Heitor |
| TicTacToe | Fellippe Heitor |
| TicTacToe2 | Fellippe Heitor |
| Trackword | Richard Notley |
| VDrops | bobalooie |
| WordClock | Fellippe Heitor |
| wordSearch | George McGinn |

## NOTES

- This requires the latest version of [QB64-PE](https://github.com/QB64-Phoenix-Edition/QB64pe/releases/latest). QB64, or other forks of QB64 will not work!
