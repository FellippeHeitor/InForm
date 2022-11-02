'$INCLUDE:'InFormVersion.bas'

PRINT "InForm - GUI system for QB64 - "; __UI_Version
PRINT "VBDOS to InForm form conversion utility"
PRINT "-------------------------------------------------"

DIM lf AS STRING * 1, q AS STRING * 1
lf = CHR$(10)
q = CHR$(34)
IF LEN(COMMAND$) > 0 THEN
    IF _FILEEXISTS(COMMAND$) = 0 THEN PRINT "File not found.": END
    theFile$ = COMMAND$
ELSE
    DO
        INPUT "File to convert (.frm):", theFile$
        IF LEN(theFile$) = 0 THEN END
        IF UCASE$(RIGHT$(theFile$, 4)) <> ".FRM" THEN theFile$ = theFile$ + ".FRM"
        IF _FILEEXISTS(theFile$) = 0 THEN PRINT "File "; theFile$; " not found." ELSE EXIT DO
    LOOP
END IF
OPEN theFile$ FOR BINARY AS #1

LINE INPUT #1, a$
IF a$ <> "Version 1.00" THEN
    PRINT "Expected VBDOS text form file. Exiting."
    END
END IF

LINE INPUT #1, a$
IF LEFT$(a$, 11) <> "BEGIN Form " THEN
    PRINT "Invalid VBDOS text form file. Exiting."
    END
END IF

FormName$ = MID$(a$, 12)

o$ = "'InForm - GUI system for QB64 - " + __UI_Version
o$ = o$ + lf + "'Fellippe Heitor, " + __UI_CopyrightSpan + " - fellippe@qb64.org - @FellippeHeitor"
o$ = o$ + lf + "'-----------------------------------------------------------"
o$ = o$ + lf + "SUB __UI_LoadForm"
o$ = o$ + lf
o$ = o$ + lf + "    DIM __UI_NewID AS LONG"
o$ = o$ + lf
o$ = o$ + lf + "    __UI_NewID = __UI_NewControl(__UI_Type_Form, " + q + FormName$ + q + ", "

row = CSRLIN

DO
    IF EOF(1) THEN EXIT DO
    LINE INPUT #1, a$
    DO WHILE LEFT$(a$, 1) = CHR$(9)
        a$ = MID$(a$, 2)
    LOOP
    percentage% = (SEEK(1) / LOF(1)) * 100
    LOCATE row, 1: COLOR 7: PRINT STRING$(80, 176);
    LOCATE row, 1: COLOR 11: PRINT STRING$((80 * percentage%) / 100, 219);
    COLOR 8
    LOCATE row + 1, 1: PRINT SPACE$(80);
    LOCATE row + 1, 1: PRINT a$;
    COLOR 7
    eq = INSTR(a$, "=")
    IF eq THEN
        property$ = RTRIM$(LEFT$(a$, eq - 1))
        value$ = LTRIM$(RTRIM$(MID$(a$, eq + 1)))
        SELECT CASE property$
            CASE "Width"
                IF LEFT$(value$, 5) = "Char(" THEN width$ = STR$(VAL(MID$(value$, 6)) * _FONTWIDTH + 5)
            CASE "Height"
                IF LEFT$(value$, 5) = "Char(" THEN height$ = STR$(VAL(MID$(value$, 6)) * _FONTHEIGHT + 15)
            CASE "BackColor"
                IF LEFT$(value$, 8) = "QBColor(" THEN backColor$ = QBColor2QB64$(VAL(MID$(value$, 9)))
            CASE "ForeColor"
                IF LEFT$(value$, 8) = "QBColor(" THEN foreColor$ = QBColor2QB64$(VAL(MID$(value$, 9)))
            CASE "Caption"
                caption$ = value$
            CASE "Text"
                text$ = value$
            CASE "Left"
                IF LEFT$(value$, 5) = "Char(" THEN leftSide$ = STR$(VAL(MID$(value$, 6)) * _FONTWIDTH + 5)
            CASE "Top"
                IF LEFT$(value$, 5) = "Char(" THEN top$ = STR$(VAL(MID$(value$, 6)) * _FONTHEIGHT + 15)
            CASE "Enabled"
                IF value$ = "0" THEN disabled$ = "True"
            CASE "Visible"
                IF value$ = "0" THEN hidden$ = "True"
        END SELECT
    ELSE
        COLOR 15
        IF LEFT$(a$, 6) = "BEGIN " THEN
            IF LEN(FormName$) THEN
                FormName$ = ""
                o$ = o$ + width$ + "," + height$ + ", 0, 0, 0)"
                o$ = o$ + lf + "    Control(__UI_NewID).Font = SetFont(" + q + q + ", 16, " + q + q + ")"
                GOSUB AddProperties
            ELSEIF controlType$ = "__UI_Type_Frame" THEN
                GOSUB FinishFrame
            END IF
            control$ = MID$(a$, 7)
            controlType$ = LEFT$(control$, INSTR(control$, " ") - 1)
            controlName$ = MID$(control$, INSTR(control$, " ") + 1)
            i = 1: i$ = ""
            DO WHILE INSTR(controlList$, "$" + controlName$ + i$ + "$") > 0
                i = i + 1: i$ = LTRIM$(STR$(i))
            LOOP
            controlName$ = controlName$ + i$
            controlList$ = controlList$ + "$" + controlName$ + "$"
            caseAll$ = caseAll$ + "        CASE " + controlName$ + lf + lf
            SELECT CASE controlType$
                CASE "Label"
                    controlType$ = "__UI_Type_Label"
                CASE "ComboBox", "DriveListBox"
                    controlType$ = "__UI_Type_DropdownList"
                    caseFocus$ = caseFocus$ + "        CASE " + controlName$ + lf + lf
                CASE "CommandButton"
                    controlType$ = "__UI_Type_Button"
                    caseFocus$ = caseFocus$ + "        CASE " + controlName$ + lf + lf
                CASE "ListBox", "DirListBox", "FileListBox"
                    controlType$ = "__UI_Type_ListBox"
                    caseFocus$ = caseFocus$ + "        CASE " + controlName$ + lf + lf
                    caseList$ = caseList$ + "        CASE " + controlName$ + lf + lf
                CASE "Frame"
                    controlType$ = "__UI_Type_Frame"
                CASE "CheckBox"
                    controlType$ = "__UI_Type_CheckBox"
                    caseFocus$ = caseFocus$ + "        CASE " + controlName$ + lf + lf
                CASE "OptionButton"
                    controlType$ = "__UI_Type_RadioButton"
                    caseFocus$ = caseFocus$ + "        CASE " + controlName$ + lf + lf
                CASE "PictureBox"
                    controlType$ = "__UI_Type_PictureBox"
                CASE "TextBox"
                    controlType$ = "__UI_Type_TextBox"
                    caseFocus$ = caseFocus$ + "        CASE " + controlName$ + lf + lf
                    caseTextBox$ = caseTextBox$ + "        CASE " + controlName$ + lf + lf
                CASE ELSE
                    controlType$ = "__UI_Type_PictureBox"
            END SELECT
            assignIDs$ = assignIDs$ + lf + "    " + controlName$ + " = __UI_GetID(" + q + controlName$ + q + ")"
            controlIDsDIM$ = controlIDsDIM$ + lf + "DIM SHARED " + controlName$ + " AS LONG"
            IF controlType$ = "__UI_Type_Frame" THEN
                Frame$ = controlName$
                control$ = ""
            END IF
        ELSEIF a$ = "END" THEN
            IF LEN(control$) > 0 THEN
                FinishFrame:
                o$ = o$ + lf + "    __UI_NewID = __UI_NewControl(" + controlType$ + ", " + q + controlName$ + q + ", "
                o$ = o$ + width$ + "," + height$ + ", " + leftSide$ + ", " + top$ + ", "
                IF LEN(Frame$) > 0 AND controlType$ <> "__UI_Type_Frame" THEN
                    o$ = o$ + "__UI_GetID(" + q + Frame$ + q + "))"
                ELSE
                    o$ = o$ + "0)"
                END IF
                GOSUB AddProperties
                control$ = ""
                IF controlType$ = "__UI_Type_Frame" THEN RETURN
            ELSE
                IF LEN(Frame$) THEN
                    Frame$ = ""
                ELSE
                    EXIT DO
                END IF
            END IF
        END IF
    END IF
    _LIMIT 500
LOOP
o$ = o$ + lf + "END SUB"
o$ = o$ + lf
o$ = o$ + lf + "SUB __UI_AssignIDs"
o$ = o$ + assignIDs$
o$ = o$ + lf + "END SUB"

newFile$ = LEFT$(theFile$, INSTR(theFile$, ".") - 1) + "_InForm.frm"
CLOSE
OPEN newFile$ FOR BINARY AS #1
PUT #1, , o$
CLOSE
TextFileNum = FREEFILE
newTextFile$ = LEFT$(theFile$, INSTR(theFile$, ".") - 1) + "_InForm.bas"
OPEN newTextFile$ FOR OUTPUT AS #TextFileNum
PRINT #TextFileNum, "': This program was generated by"
PRINT #TextFileNum, "': InForm - GUI system for QB64 - "; __UI_Version
PRINT #TextFileNum, "': Fellippe Heitor, " + __UI_CopyrightSpan + " - fellippe@qb64.org - @fellippeheitor"
PRINT #TextFileNum, "'-----------------------------------------------------------"
PRINT #TextFileNum,
PRINT #TextFileNum, "': Controls' IDs: ------------------------------------------------------------------";
PRINT #TextFileNum, controlIDsDIM$
PRINT #TextFileNum,
PRINT #TextFileNum, "': External modules: ---------------------------------------------------------------"
PRINT #TextFileNum, "'$INCLUDE:'InForm\InForm.ui'"
PRINT #TextFileNum, "'$INCLUDE:'InForm\xp.uitheme'"
PRINT #TextFileNum, "'$INCLUDE:'" + newFile$ + "'"
PRINT #TextFileNum,
PRINT #TextFileNum, "': Event procedures: ---------------------------------------------------------------"
FOR i = 0 TO 14
    SELECT EVERYCASE i
        CASE 0: PRINT #TextFileNum, "SUB __UI_BeforeInit"
        CASE 1: PRINT #TextFileNum, "SUB __UI_OnLoad"
        CASE 2: PRINT #TextFileNum, "SUB __UI_BeforeUpdateDisplay"
        CASE 3: PRINT #TextFileNum, "SUB __UI_BeforeUnload"
        CASE 4: PRINT #TextFileNum, "SUB __UI_Click (id AS LONG)"
        CASE 5: PRINT #TextFileNum, "SUB __UI_MouseEnter (id AS LONG)"
        CASE 6: PRINT #TextFileNum, "SUB __UI_MouseLeave (id AS LONG)"
        CASE 7: PRINT #TextFileNum, "SUB __UI_FocusIn (id AS LONG)"
        CASE 8: PRINT #TextFileNum, "SUB __UI_FocusOut (id AS LONG)"
        CASE 9: PRINT #TextFileNum, "SUB __UI_MouseDown (id AS LONG)"
        CASE 10: PRINT #TextFileNum, "SUB __UI_MouseUp (id AS LONG)"
        CASE 11: PRINT #TextFileNum, "SUB __UI_KeyPress (id AS LONG)"
        CASE 12: PRINT #TextFileNum, "SUB __UI_TextChanged (id AS LONG)"
        CASE 13: PRINT #TextFileNum, "SUB __UI_ValueChanged (id AS LONG)"
        CASE 14: PRINT #TextFileNum, "SUB __UI_FormResized"

        CASE 0 TO 3, 14
            PRINT #TextFileNum,

        CASE 4 TO 6, 9, 10 'All controls except for Menu panels, and internal context menus
            PRINT #TextFileNum, "    SELECT CASE id"
            PRINT #TextFileNum, caseAll$;
            PRINT #TextFileNum, "    END SELECT"

        CASE 7, 8, 11 'Controls that can have focus only
            PRINT #TextFileNum, "    SELECT CASE id"
            PRINT #TextFileNum, caseFocus$;
            PRINT #TextFileNum, "    END SELECT"

        CASE 12 'Text boxes
            PRINT #TextFileNum, "    SELECT CASE id"
            PRINT #TextFileNum, caseTextBox$;
            PRINT #TextFileNum, "    END SELECT"

        CASE 13 'Dropdown list, List box and Track bar
            PRINT #TextFileNum, "    SELECT CASE id"
            PRINT #TextFileNum, caseList$;
            PRINT #TextFileNum, "    END SELECT"
    END SELECT
    PRINT #TextFileNum, "END SUB"
    PRINT #TextFileNum,
NEXT
CLOSE #TextFileNum
LOCATE row, 1: COLOR 11: PRINT STRING$(80, 219);
COLOR 15
PRINT
PRINT "Conversion finished. Files output:"
PRINT "    "; newFile$
PRINT "    "; newTextFile$
END

AddProperties:
IF LEN(caption$) THEN o$ = o$ + lf + "    SetCaption __UI_NewID, " + caption$: caption$ = ""
IF LEN(FormName$) = 0 THEN
    IF backColor$ = formBackColor$ THEN backColor$ = ""
    IF foreColor$ = formForeColor$ THEN foreColor$ = ""
END IF
IF LEN(backColor$) THEN o$ = o$ + lf + "    Control(__UI_NewID).BackColor = " + backColor$: IF control$ = "" THEN formBackColor$ = backColor$: backColor$ = ""
IF LEN(foreColor$) THEN o$ = o$ + lf + "    Control(__UI_NewID).ForeColor = " + foreColor$: IF control$ = "" THEN formForeColor$ = foreColor$: foreColor$ = ""
IF LEN(text$) THEN o$ = o$ + lf + "    Text(__UI_NewID) = " + text$: text$ = ""
IF LEN(disabled$) THEN o$ = o$ + lf + "    Control(__UI_NewID).Disabled = True": disabled$ = ""
IF LEN(hidden$) THEN o$ = o$ + lf + "    Control(__UI_NewID).Hidden = True": hidden$ = ""
o$ = o$ + lf
RETURN

FUNCTION QBColor2QB64$ (index AS _BYTE)
    QBColor2QB64$ = "_RGB32(" + LTRIM$(STR$(_RED(index))) + ", " + LTRIM$(STR$(_GREEN(index))) + ", " + LTRIM$(STR$(_BLUE(index))) + ")"
END FUNCTION
