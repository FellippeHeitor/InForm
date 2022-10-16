Option _Explicit
Option _ExplicitArray

$Console:Only
_Dest _Console

'$INCLUDE:'InFormVersion.bas'

' Damn!
Dim As Long i, row, percentage, eq, TextFileNum
Dim As String property, value, wdth, hght, caption, text, leftSide, top, disabled, backColorStr, foreColorStr
Dim As String hidden, controlType, control, controlName, iStr, controlList, caseAll, caseFocus, caseList
Dim As String caseTextBox, assignIDs, controlIDsDIM, Frame, newFile, newTextFile, theFile, a, FormName, o
Dim As String formBackColor, formForeColor
Dim As String * 1 lf, q

lf = Chr$(10)
q = Chr$(34)

Print "InForm - GUI system for QB64 - "; __UI_Version
Print "VBDOS to InForm form conversion utility"
Print "-------------------------------------------------"

If Len(Command$) > 0 Then
    If _FileExists(Command$) = 0 Then Print "File not found.": End
    theFile$ = Command$
Else
    Do
        Input "File to convert (.frm):", theFile$
        If Len(theFile$) = 0 Then End
        If UCase$(Right$(theFile$, 4)) <> ".FRM" Then theFile$ = theFile$ + ".FRM"
        If _FileExists(theFile$) = 0 Then Print "File "; theFile$; " not found." Else Exit Do
    Loop
End If

Open theFile$ For Binary As #1

Line Input #1, a$
If a$ <> "Version 1.00" Then
    Print "Expected VBDOS text form file. Exiting."
    End
End If

Line Input #1, a$
If Left$(a$, 11) <> "BEGIN Form " Then
    Print "Invalid VBDOS text form file. Exiting."
    End
End If

FormName$ = Mid$(a$, 12)

o$ = "'InForm - GUI system for QB64 - " + __UI_Version
o$ = o$ + lf + "'Fellippe Heitor, " + __UI_CopyrightSpan + " - fellippe@qb64.org - @FellippeHeitor"
o$ = o$ + lf + "'-----------------------------------------------------------"
o$ = o$ + lf + "SUB __UI_LoadForm"
o$ = o$ + lf
o$ = o$ + lf + "    DIM __UI_NewID AS LONG"
o$ = o$ + lf
o$ = o$ + lf + "    __UI_NewID = __UI_NewControl(__UI_Type_Form, " + q + FormName$ + q + ", "

row = CsrLin

Do
    If EOF(1) Then Exit Do
    Line Input #1, a$
    Do While Left$(a$, 1) = Chr$(9)
        a$ = Mid$(a$, 2)
    Loop
    percentage = (Seek(1) / LOF(1)) * 100
    Locate row, 1: Color 7: Print String$(80, 176);
    Locate row, 1: Color 11: Print String$((80 * percentage) / 100, 219);
    Color 8
    Locate row + 1, 1: Print Space$(80);
    Locate row + 1, 1: Print a$;
    Color 7
    eq = InStr(a$, "=")
    If eq Then
        property$ = RTrim$(Left$(a$, eq - 1))
        value$ = LTrim$(RTrim$(Mid$(a$, eq + 1)))
        Select Case property$
            Case "Width"
                If Left$(value$, 5) = "Char(" Then wdth = Str$(Val(Mid$(value$, 6)) * _FontWidth + 5)
            Case "Height"
                If Left$(value$, 5) = "Char(" Then hght = Str$(Val(Mid$(value$, 6)) * _FontHeight + 15)
            Case "BackColor"
                If Left$(value$, 8) = "QBColor(" Then backColorStr = QBColor2QB64$(Val(Mid$(value$, 9)))
            Case "ForeColor"
                If Left$(value$, 8) = "QBColor(" Then foreColorStr = QBColor2QB64$(Val(Mid$(value$, 9)))
            Case "Caption"
                caption$ = value$
            Case "Text"
                text$ = value$
            Case "Left"
                If Left$(value$, 5) = "Char(" Then leftSide$ = Str$(Val(Mid$(value$, 6)) * _FontWidth + 5)
            Case "Top"
                If Left$(value$, 5) = "Char(" Then top$ = Str$(Val(Mid$(value$, 6)) * _FontHeight + 15)
            Case "Enabled"
                If value$ = "0" Then disabled$ = "True"
            Case "Visible"
                If value$ = "0" Then hidden$ = "True"
        End Select
    Else
        Color 15
        If Left$(a$, 6) = "BEGIN " Then
            If Len(FormName$) Then
                FormName$ = ""
                o$ = o$ + wdth + "," + hght + ", 0, 0, 0)"
                o$ = o$ + lf + "    Control(__UI_NewID).Font = SetFont(" + q + q + ", 16, " + q + q + ")"
                GoSub AddProperties
            ElseIf controlType$ = "__UI_Type_Frame" Then
                GoSub FinishFrame
            End If
            control$ = Mid$(a$, 7)
            controlType$ = Left$(control$, InStr(control$, " ") - 1)
            controlName$ = Mid$(control$, InStr(control$, " ") + 1)
            i = 1: iStr = ""
            Do While InStr(controlList$, "$" + controlName$ + iStr + "$") > 0
                i = i + 1: iStr = LTrim$(Str$(i))
            Loop
            controlName$ = controlName$ + iStr
            controlList$ = controlList$ + "$" + controlName$ + "$"
            caseAll$ = caseAll$ + "        CASE " + controlName$ + lf + lf
            Select Case controlType$
                Case "Label"
                    controlType$ = "__UI_Type_Label"
                Case "ComboBox", "DriveListBox"
                    controlType$ = "__UI_Type_DropdownList"
                    caseFocus$ = caseFocus$ + "        CASE " + controlName$ + lf + lf
                Case "CommandButton"
                    controlType$ = "__UI_Type_Button"
                    caseFocus$ = caseFocus$ + "        CASE " + controlName$ + lf + lf
                Case "ListBox", "DirListBox", "FileListBox"
                    controlType$ = "__UI_Type_ListBox"
                    caseFocus$ = caseFocus$ + "        CASE " + controlName$ + lf + lf
                    caseList$ = caseList$ + "        CASE " + controlName$ + lf + lf
                Case "Frame"
                    controlType$ = "__UI_Type_Frame"
                Case "CheckBox"
                    controlType$ = "__UI_Type_CheckBox"
                    caseFocus$ = caseFocus$ + "        CASE " + controlName$ + lf + lf
                Case "OptionButton"
                    controlType$ = "__UI_Type_RadioButton"
                    caseFocus$ = caseFocus$ + "        CASE " + controlName$ + lf + lf
                Case "PictureBox"
                    controlType$ = "__UI_Type_PictureBox"
                Case "TextBox"
                    controlType$ = "__UI_Type_TextBox"
                    caseFocus$ = caseFocus$ + "        CASE " + controlName$ + lf + lf
                    caseTextBox$ = caseTextBox$ + "        CASE " + controlName$ + lf + lf
                Case Else
                    controlType$ = "__UI_Type_PictureBox"
            End Select
            assignIDs$ = assignIDs$ + lf + "    " + controlName$ + " = __UI_GetID(" + q + controlName$ + q + ")"
            controlIDsDIM$ = controlIDsDIM$ + lf + "DIM SHARED " + controlName$ + " AS LONG"
            If controlType$ = "__UI_Type_Frame" Then
                Frame$ = controlName$
                control$ = ""
            End If
        ElseIf a$ = "END" Then
            If Len(control$) > 0 Then
                FinishFrame:
                o$ = o$ + lf + "    __UI_NewID = __UI_NewControl(" + controlType$ + ", " + q + controlName$ + q + ", "
                o$ = o$ + wdth + "," + hght + ", " + leftSide$ + ", " + top$ + ", "
                If Len(Frame$) > 0 And controlType$ <> "__UI_Type_Frame" Then
                    o$ = o$ + "__UI_GetID(" + q + Frame$ + q + "))"
                Else
                    o$ = o$ + "0)"
                End If
                GoSub AddProperties
                control$ = ""
                If controlType$ = "__UI_Type_Frame" Then Return
            Else
                If Len(Frame$) Then
                    Frame$ = ""
                Else
                    Exit Do
                End If
            End If
        End If
    End If
    _Limit 500
Loop
o$ = o$ + lf + "END SUB"
o$ = o$ + lf
o$ = o$ + lf + "SUB __UI_AssignIDs"
o$ = o$ + assignIDs$
o$ = o$ + lf + "END SUB"

newFile$ = Left$(theFile$, InStr(theFile$, ".") - 1) + "_InForm.frm"
Close
Open newFile$ For Binary As #1
Put #1, , o$
Close
TextFileNum = FreeFile
newTextFile$ = Left$(theFile$, InStr(theFile$, ".") - 1) + "_InForm.bas"
Open newTextFile$ For Output As #TextFileNum
Print #TextFileNum, "': This program was generated by"
Print #TextFileNum, "': InForm - GUI system for QB64 - "; __UI_Version
Print #TextFileNum, "': Fellippe Heitor, " + __UI_CopyrightSpan + " - fellippe@qb64.org - @fellippeheitor"
Print #TextFileNum, "'-----------------------------------------------------------"
Print #TextFileNum,
Print #TextFileNum, "': Controls' IDs: ------------------------------------------------------------------";
Print #TextFileNum, controlIDsDIM$
Print #TextFileNum,
Print #TextFileNum, "': External modules: ---------------------------------------------------------------"
Print #TextFileNum, "'$INCLUDE:'InForm\InForm.ui'"
Print #TextFileNum, "'$INCLUDE:'InForm\xp.uitheme'"
Print #TextFileNum, "'$INCLUDE:'" + newFile$ + "'"
Print #TextFileNum,
Print #TextFileNum, "': Event procedures: ---------------------------------------------------------------"
For i = 0 To 14
    Select EveryCase i
        Case 0: Print #TextFileNum, "SUB __UI_BeforeInit"
        Case 1: Print #TextFileNum, "SUB __UI_OnLoad"
        Case 2: Print #TextFileNum, "SUB __UI_BeforeUpdateDisplay"
        Case 3: Print #TextFileNum, "SUB __UI_BeforeUnload"
        Case 4: Print #TextFileNum, "SUB __UI_Click (id AS LONG)"
        Case 5: Print #TextFileNum, "SUB __UI_MouseEnter (id AS LONG)"
        Case 6: Print #TextFileNum, "SUB __UI_MouseLeave (id AS LONG)"
        Case 7: Print #TextFileNum, "SUB __UI_FocusIn (id AS LONG)"
        Case 8: Print #TextFileNum, "SUB __UI_FocusOut (id AS LONG)"
        Case 9: Print #TextFileNum, "SUB __UI_MouseDown (id AS LONG)"
        Case 10: Print #TextFileNum, "SUB __UI_MouseUp (id AS LONG)"
        Case 11: Print #TextFileNum, "SUB __UI_KeyPress (id AS LONG)"
        Case 12: Print #TextFileNum, "SUB __UI_TextChanged (id AS LONG)"
        Case 13: Print #TextFileNum, "SUB __UI_ValueChanged (id AS LONG)"
        Case 14: Print #TextFileNum, "SUB __UI_FormResized"

        Case 0 To 3, 14
            Print #TextFileNum,

        Case 4 To 6, 9, 10 'All controls except for Menu panels, and internal context menus
            Print #TextFileNum, "    SELECT CASE id"
            Print #TextFileNum, caseAll$;
            Print #TextFileNum, "    END SELECT"

        Case 7, 8, 11 'Controls that can have focus only
            Print #TextFileNum, "    SELECT CASE id"
            Print #TextFileNum, caseFocus$;
            Print #TextFileNum, "    END SELECT"

        Case 12 'Text boxes
            Print #TextFileNum, "    SELECT CASE id"
            Print #TextFileNum, caseTextBox$;
            Print #TextFileNum, "    END SELECT"

        Case 13 'Dropdown list, List box and Track bar
            Print #TextFileNum, "    SELECT CASE id"
            Print #TextFileNum, caseList$;
            Print #TextFileNum, "    END SELECT"
    End Select
    Print #TextFileNum, "END SUB"
    Print #TextFileNum,
Next
Close #TextFileNum
Locate row, 1: Color 11: Print String$(80, 219);
Color 15
Print
Print "Conversion finished. Files output:"
Print "    "; newFile$
Print "    "; newTextFile$
End

AddProperties:
If Len(caption$) Then o$ = o$ + lf + "    SetCaption __UI_NewID, " + caption$: caption$ = ""
If Len(FormName$) = 0 Then
    If backColorStr = formBackColor$ Then backColorStr = ""
    If foreColorStr = formForeColor$ Then foreColorStr = ""
End If
If Len(backColorStr) Then o$ = o$ + lf + "    Control(__UI_NewID).BackColor = " + backColorStr: If control$ = "" Then formBackColor$ = backColorStr: backColorStr = ""
If Len(foreColorStr) Then o$ = o$ + lf + "    Control(__UI_NewID).ForeColor = " + foreColorStr: If control$ = "" Then formForeColor$ = foreColorStr: foreColorStr = ""
If Len(text$) Then o$ = o$ + lf + "    Text(__UI_NewID) = " + text$: text$ = ""
If Len(disabled$) Then o$ = o$ + lf + "    Control(__UI_NewID).Disabled = True": disabled$ = ""
If Len(hidden$) Then o$ = o$ + lf + "    Control(__UI_NewID).Hidden = True": hidden$ = ""
o$ = o$ + lf
Return

Function QBColor2QB64$ (index As _Byte)
    QBColor2QB64$ = "_RGB32(" + LTrim$(Str$(_Red(index))) + ", " + LTrim$(Str$(_Green(index))) + ", " + LTrim$(Str$(_Blue(index))) + ")"
End Function

