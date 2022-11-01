Option _Explicit
Option _ExplicitArray

Dim Shared UiEditorPID As Long, ExeIcon As Long
Dim Shared AutoNameControls As _Byte
Dim Shared UndoPointer As Integer, TotalUndoImages As Integer, MidUndo As _Byte
ReDim Shared UndoImage(100) As String
Dim Shared IsCreating As _Byte
Dim Shared Host As Long, HostPort As String
Dim Shared Stream$, RestoreCrashData$
Dim Shared LastPreviewDataSent$
Dim Shared ContextMenuIcon As Long
ReDim Shared LockedControls(0) As Long, TotalLockedControls As Long
ReDim Shared AutoPlayGif(0) As _Byte

ReDim Shared QB64KEYWORDS(0) As String
READ_KEYWORDS

ChDir ".."

Const EmptyForm$ = "9iVA_9GK1P<000`ooO7000@00D006mVL]53;1`B000000000noO100006mVL]5cno760cEfI_EFMYi2MdIf?Q9GJQaV;dAWIol2CY9VLQ9GN_HdK^AgL_4TLY56K^@7MVmCB^IdKbef;bEfL_EWLSEfL_hdKdmFC_ifK]8EIWE7KQ9W;dAWIo<fKe9W;dAWIZXB<b00o%%%0"

'Signals sent from Editor to Preview:
'   201 = Align Left
'   202 = Align Right
'   203 = Align Tops
'   204 = Align Bottoms
'   205 = Align Centers Vertically
'   206 = Align Centers Horizontally
'   207 = Align Center Vertically (to form)
'   208 = Align Center Horizontally (to form)
'   209 = Align Distribute Vertically
'   210 = Align Distribute Horizontally
'   211 = Move control up (z-ordering)
'   212 = Move control down (z-ordering)
'   213 = Select specific control
'   214 = Undo
'   215 = Redo
'   216 = Save state for undo
'   217 = Copy selected controls to clipboard
'   218 = Paste selected controls from clipboard
'   219 = Cut to clipboard
'   220 = Delete selected controls
'   221 = Select all controls
'   222 = Add new textbox with the .NumericOnly property set to true
'   223 = Switch .NumericOnly between True/__UI_NumericWithBounds
'   224 = Add new MenuBar control
'   225 = Convert control type to alternative type
'   226 = Add new ContextMenu control
'   227 = Toggle __UI_ShowInvisibleControls
'   228 = Bind/Unbind selected controls

'SavePreview parameters:
Const InDisk = 1
Const InClipboard = 2
Const ToEditor = 3
Const ToUndoBuffer = 4
Const FromEditor = 5

Dim i As Long
Dim Shared AlphaNumeric(255)
For i = 48 To 57: AlphaNumeric(i) = -1: Next
For i = 65 To 90: AlphaNumeric(i) = -1: Next
For i = 97 To 122: AlphaNumeric(i) = -1: Next
AlphaNumeric(95) = -1

Dim Shared Alpha(255)
For i = 65 To 90: Alpha(i) = -1: Next
For i = 97 To 122: Alpha(i) = -1: Next
Alpha(95) = -1

Dim Shared Numeric(255)
For i = 48 To 57: Numeric(i) = -1: Next

$If WIN Then
    Declare Dynamic Library "kernel32"
        Function OpenProcess& (ByVal dwDesiredAccess As Long, Byval bInheritHandle As Long, Byval dwProcessId As Long)
        Function CloseHandle& (ByVal hObject As Long)
        Function GetExitCodeProcess& (ByVal hProcess As Long, lpExitCode As Long)
    End Declare
    Const PathSep$ = "\"
$Else
    DECLARE LIBRARY
        FUNCTION PROCESS_CLOSED& ALIAS kill (BYVAL pid AS INTEGER, BYVAL signal AS INTEGER)
    END DECLARE
    CONST PathSep$ = "/"
$End If

'Load context menu icon image:
ContextMenuIcon = LoadEditorImage("contextmenu.bmp")
__UI_ClearColor ContextMenuIcon, 0, 0

'$include:'extensions/gifplay.bi'
'$include:'InForm.bi'
'$include:'xp.uitheme'
'$include:'UiEditorPreview.frm'
'$include:'extensions/gifplay.bm'

'Event procedures: ---------------------------------------------------------------
Sub __UI_Click (id As Long)
End Sub

Sub __UI_MouseEnter (id As Long)
End Sub

Sub __UI_MouseLeave (id As Long)
End Sub

Sub __UI_FocusIn (id As Long)
End Sub

Sub __UI_FocusOut (id As Long)
End Sub

Sub __UI_MouseDown (id As Long)
End Sub

Sub __UI_MouseUp (id As Long)
End Sub

Function AddNewMenuBarControl&
    Dim i As Long, TempValue As Long

    'Before adding a menu bar item, reset all other menu bar items' alignment
    For i = 1 To UBound(Control)
        If Control(i).Type = __UI_Type_MenuBar Then
            Control(i).Align = __UI_Left
        End If
    Next
    TempValue = __UI_NewControl(__UI_Type_MenuBar, "", 0, 0, 0, 0, 0)
    SetCaption TempValue, RTrim$(Control(TempValue).Name)
    __UI_RefreshMenuBar
    __UI_ActivateMenu Control(TempValue), False
    AddNewMenuBarControl& = TempValue
End Function

Sub SelectNewControl (id As Long)
    Dim i As Long
    For i = 1 To UBound(Control)
        Control(i).ControlIsSelected = False
    Next
    Control(id).ControlIsSelected = True
    __UI_TotalSelectedControls = 1
    __UI_FirstSelectedID = id
    __UI_ForceRedraw = True
End Sub

Sub __UI_BeforeUpdateDisplay
    Dim a$, b$, TempValue As Long, i As Long, j As Long
    Dim NewControl As Integer, FileNameToLoad$
    Static UiEditorFile As Integer, EditorWasActive As _Byte
    Static WasDragging As _Byte, WasResizing As _Byte
    Static NewWindowTop As Integer, NewWindowLeft As Integer

    If __UI_TotalSelectedControls < 0 Then __UI_TotalSelectedControls = 0

    SavePreview ToEditor

    If UBound(LockedControls) <> UBound(Control) Then
        ReDim _Preserve LockedControls(UBound(Control)) As Long
    End If

    If UBound(AutoPlayGif) <> UBound(Control) Then
        ReDim _Preserve AutoPlayGif(UBound(Control)) As _Byte
    End If

    For i = 1 To UBound(AutoPlayGif)
        If AutoPlayGif(i) Then UpdateGif i
    Next

    Static prevDefaultButton As Long, prevMenuPanelActive As Integer
    Static prevSelectionRectangle As Integer, prevUndoPointer As Integer
    Static prevTotalUndoImages As Integer, prevShowInvisibleControls As _Byte

    If __UI_DefaultButtonID <> prevDefaultButton Then
        prevDefaultButton = __UI_DefaultButtonID
        b$ = MKL$(__UI_DefaultButtonID)
        SendData b$, "DEFAULTBUTTONID"
    End If

    If prevShowInvisibleControls <> __UI_ShowInvisibleControls Then
        prevShowInvisibleControls = __UI_ShowInvisibleControls
        b$ = MKI$(__UI_ShowInvisibleControls)
        SendData b$, "SHOWINVISIBLECONTROLS"
    End If

    If prevMenuPanelActive <> (__UI_TotalActiveMenus > 0 And Left$(Control(__UI_ParentMenu(__UI_TotalActiveMenus)).Name, 5) <> "__UI_") Then
        prevMenuPanelActive = (__UI_TotalActiveMenus > 0 And Left$(Control(__UI_ParentMenu(__UI_TotalActiveMenus)).Name, 5) <> "__UI_")
        b$ = MKI$(prevMenuPanelActive)
        SendData b$, "MENUPANELACTIVE"
    End If

    If prevSelectionRectangle <> (__UI_SelectionRectangle) Then
        prevSelectionRectangle = (__UI_SelectionRectangle)
        b$ = MKI$(prevSelectionRectangle)
        SendData b$, "SELECTIONRECTANGLE"
    End If

    If prevUndoPointer <> UndoPointer Then
        prevUndoPointer = UndoPointer
        b$ = MKI$(UndoPointer)
        SendData b$, "UNDOPOINTER"
    End If

    If prevTotalUndoImages <> TotalUndoImages Then
        prevTotalUndoImages = TotalUndoImages
        b$ = MKI$(TotalUndoImages)
        SendData b$, "TOTALUNDOIMAGES"
    End If

    Dim incomingData$, Signal$, Property$

    Get #Host, , incomingData$
    Stream$ = Stream$ + incomingData$

    Dim ThisContainer As Long, TempWidth As Integer, TempHeight As Integer
    Dim TempTop As Integer
    If Control(Control(__UI_FirstSelectedID).ParentID).Type = __UI_Type_Frame Then
        ThisContainer = Control(__UI_FirstSelectedID).ParentID
        TempWidth = Control(Control(__UI_FirstSelectedID).ParentID).Width
        TempHeight = Control(Control(__UI_FirstSelectedID).ParentID).Height
        TempTop = TempHeight \ 2
    ElseIf Control(__UI_FirstSelectedID).Type = __UI_Type_Frame Then
        ThisContainer = Control(__UI_FirstSelectedID).ID
        TempWidth = Control(__UI_FirstSelectedID).Width
        TempHeight = Control(__UI_FirstSelectedID).Height
        TempTop = TempHeight \ 2
    Else
        TempWidth = Control(__UI_FormID).Width
        TempHeight = Control(__UI_FormID).Height
        TempTop = (TempHeight - __UI_MenuBarOffsetV) \ 2 + __UI_MenuBarOffsetV
    End If

    Dim thisData$, thisCommand$
    Do While InStr(Stream$, "<END>") > 0
        thisData$ = Left$(Stream$, InStr(Stream$, "<END>") - 1)
        Stream$ = Mid$(Stream$, InStr(Stream$, "<END>") + 5)
        thisCommand$ = Left$(thisData$, InStr(thisData$, ">") - 1)
        thisData$ = Mid$(thisData$, Len(thisCommand$) + 2)
        Select Case UCase$(thisCommand$)
            Case "RESTORECRASH"
                RestoreCrashData$ = thisData$
                LoadPreview FromEditor
                Exit Sub
            Case "WINDOWPOSITION"
                NewWindowLeft = CVI(Left$(thisData$, 2))
                NewWindowTop = CVI(Mid$(thisData$, 3, 2))
            Case "AUTONAME"
                AutoNameControls = CVI(thisData$)
            Case "MOUSESWAP"
                __UI_MouseButtonsSwap = CVI(thisData$)
            Case "SHOWPOSSIZE"
                __UI_ShowPositionAndSize = CVI(thisData$)
            Case "SHOWINVISIBLECONTROLS"
                __UI_ShowInvisibleControls = CVI(thisData$)
            Case "SNAPLINES"
                __UI_SnapLines = CVI(thisData$)
            Case "SIGNAL"
                Signal$ = Signal$ + thisData$
            Case "PROPERTY"
                Property$ = Property$ + thisData$
            Case "OPENFILE"
                FileNameToLoad$ = thisData$
            Case "NEWCONTROL"
                TempValue = CVI(thisData$)

                If TempValue > 0 Then
                    Dim defW As Integer, defH As Integer
                    Dim tempType As Long
                    defW = __UI_Type(TempValue).DefaultWidth
                    defH = __UI_Type(TempValue).DefaultHeight
                    tempType = TempValue
                    SaveUndoImage

                    'Enforce no frame inside frame:
                    If tempType = __UI_Type_Frame Then
                        ThisContainer = 0
                        TempWidth = Control(__UI_FormID).Width
                        TempHeight = Control(__UI_FormID).Height
                        TempTop = (TempHeight - __UI_MenuBarOffsetV) \ 2 + __UI_MenuBarOffsetV
                    End If

                    If tempType = __UI_Type_MenuBar Then
                        TempValue = AddNewMenuBarControl
                    ElseIf tempType = __UI_Type_MenuItem Then
                        If __UI_TotalActiveMenus > 0 And Left$(Control(__UI_ParentMenu(__UI_TotalActiveMenus)).Name, 5) <> "__UI_" Then
                            TempValue = __UI_NewControl(tempType, "", 0, 0, 0, 0, __UI_ParentMenu(__UI_TotalActiveMenus))
                            SetCaption TempValue, RTrim$(Control(TempValue).Name)
                            ThisContainer = __UI_ParentMenu(__UI_TotalActiveMenus)
                            __UI_CloseAllMenus
                            __UI_ActivateMenu Control(ThisContainer), False
                        End If
                    Else
                        TempValue = __UI_NewControl(TempValue, "", defW, defH, TempWidth \ 2 - defW \ 2, TempTop - defH \ 2, ThisContainer)
                        SetCaption TempValue, RTrim$(Control(TempValue).Name)
                    End If

                    Select Case tempType
                        Case __UI_Type_ProgressBar
                            SetCaption TempValue, "\#"
                        Case __UI_Type_ContextMenu
                            Control(TempValue).HelperCanvas = _CopyImage(ContextMenuIcon, 32)
                            RefreshContextMenus
                            __UI_ActivateMenu Control(TempValue), False
                    End Select

                    If __UI_TotalActiveMenus > 0 And (Control(TempValue).Type <> __UI_Type_ContextMenu And Control(TempValue).Type <> __UI_Type_MenuBar And Control(TempValue).Type <> __UI_Type_MenuItem) Then
                        __UI_CloseAllMenus
                    End If
                    SelectNewControl TempValue
                End If
            Case "LOCKCONTROLS"
                'When the user starts editing a property in UiEditor,
                'a list of the currently selected controls is built so
                'that the property can be applied to the same controls
                'later; allows for"
                '    "click control, change property, click another control"
                TotalLockedControls = 0
                For i = 1 To UBound(Control)
                    If Control(i).ControlIsSelected Then
                        TotalLockedControls = TotalLockedControls + 1
                        LockedControls(TotalLockedControls) = i
                    End If
                Next
            Case "PAUSEALLGIF"
                For i = 1 To UBound(Control)
                    If AutoPlayGif(i) Then
                        AutoPlayGif(i) = False
                        StopGif i
                    End If
                Next
            Case "BINDCONTROLS"
                Dim BindInfo$(1 To 4)

                For i = 1 To 4
                    TempValue = CVL(Left$(thisData$, 4))
                    thisData$ = Mid$(thisData$, 5)
                    BindInfo$(i) = Left$(thisData$, TempValue)
                    thisData$ = Mid$(thisData$, TempValue + 1)
                Next

                __UI_Bind __UI_GetID(BindInfo$(1)), __UI_GetID(BindInfo$(2)), BindInfo$(3), BindInfo$(4)
            Case "UNBINDCONTROLS"
                __UI_UnBind __UI_GetID(thisData$)
        End Select
    Loop

    For i = 1 To _TotalDroppedFiles
        Dim tempImage&
        tempImage& = _LoadImage(_DroppedFile(i), 32)
        If tempImage& < -1 Then
            defW = _Width(tempImage&)
            defH = _Height(tempImage&)
            _FreeImage tempImage&
            tempType = __UI_Type_PictureBox

            SaveUndoImage

            TempValue = __UI_NewControl(tempType, "", defW, defH, _MouseX - defW \ 2, _MouseY - defH \ 2, ThisContainer)
            If ThisContainer > 0 Then
                Control(TempValue).Left = 0
                Control(TempValue).Top = 0
            End If

            If __UI_TotalActiveMenus > 0 Then
                __UI_CloseAllMenus
            End If
            SelectNewControl TempValue

            PreviewLoadImage Control(TempValue), _DroppedFile(i)

            b$ = Mid$(_DroppedFile(i), _InStrRev(_DroppedFile(i), PathSep$) + 1)
            Swap i, TempValue
            GoSub AutoName
            Swap i, TempValue
        End If
        If i = _TotalDroppedFiles Then _FinishDrop
    Next

    $If WIN Then
        If NewWindowLeft <> -32001 And NewWindowTop <> -32001 And (NewWindowLeft <> _ScreenX Or NewWindowTop <> _ScreenY) Then
            _ScreenMove NewWindowLeft + 612, NewWindowTop
        End If
    $End If

    'Check if the editor is still alive
    $If WIN Then
        Dim hnd&, b&, ExitCode&
        hnd& = OpenProcess(&H400, 0, UiEditorPID)
        b& = GetExitCodeProcess(hnd&, ExitCode&)
        If b& = 1 And ExitCode& = 259 Then
            'Editor is active.
            EditorWasActive = True
        Else
            'Editor was closed.
            If EditorWasActive = False Then
                'Preview was launched by user
                Dim Answer As Long
                _ScreenHide
                Answer = MessageBox("InForm Designer is not running. Please run the main program.", "InForm Preview", 0)
            End If
			If _FileExists("..\UiEditorPreview.frmbin") Then Kill "..\UiEditorPreview.frmbin"
            System
        End If
        b& = CloseHandle(hnd&)
    $Else
        IF PROCESS_CLOSED(UiEditorPID, 0) THEN 
			If _FileExists("UiEditorPreview.frmbin") Then Kill "UiEditorPreview.frmbin"
			SYSTEM
		END IF
    $End If

    If __UI_IsDragging Then
        If Not WasDragging Then
            WasDragging = True
        End If
    Else
        If WasDragging Then
            SaveUndoImage
            WasDragging = False
        End If
    End If

    If __UI_IsResizing Then
        If Not WasResizing Then
            WasResizing = True
        End If
    Else
        If WasResizing Then
            SaveUndoImage
            WasResizing = False
        End If
    End If

    Static prevImgWidthSent As Integer, prevImgHeightSent As Integer
    Static prevTurnsInto As Integer
    If __UI_FirstSelectedID > 0 Then
        If Control(__UI_FirstSelectedID).Type = __UI_Type_PictureBox And Len(Text(__UI_FirstSelectedID)) > 0 Then
            IF prevImgWidthSent <> _WIDTH(Control(__UI_FirstSelectedID).HelperCanvas) OR _
               prevImgHeightSent <> _HEIGHT(Control(__UI_FirstSelectedID).HelperCanvas) THEN
                prevImgWidthSent = _Width(Control(__UI_FirstSelectedID).HelperCanvas)
                prevImgHeightSent = _Height(Control(__UI_FirstSelectedID).HelperCanvas)
                b$ = MKI$(_Width(Control(__UI_FirstSelectedID).HelperCanvas))
                SendData b$, "ORIGINALIMAGEWIDTH"

                b$ = MKI$(_Height(Control(__UI_FirstSelectedID).HelperCanvas))
                SendData b$, "ORIGINALIMAGEHEIGHT"
            End If
        Else
            IF prevImgWidthSent <> 0 OR _
               prevImgHeightSent <> 0 THEN
                prevImgWidthSent = 0
                prevImgHeightSent = 0
                b$ = MKI$(0)
                SendData b$, "ORIGINALIMAGEWIDTH"
                SendData b$, "ORIGINALIMAGEHEIGHT"
            End If
        End If

        If __UI_TotalSelectedControls = 1 Then
            If prevTurnsInto <> __UI_Type(Control(__UI_FirstSelectedID).Type).TurnsInto Or Control(__UI_FirstSelectedID).Type = __UI_Type_TextBox Then
                prevTurnsInto = __UI_Type(Control(__UI_FirstSelectedID).Type).TurnsInto
                If Control(__UI_FirstSelectedID).Type = __UI_Type_TextBox Then
                    'Offer to turn text to numeric-only TextBox and vice-versa
                    If Control(__UI_FirstSelectedID).NumericOnly = False Then
                        prevTurnsInto = -1
                    Else
                        prevTurnsInto = -2
                    End If
                End If
                b$ = MKI$(prevTurnsInto)
                SendData b$, "TURNSINTO"
            End If

            If __UI_DesignMode = True And __UI_ShowInvisibleControls = True Then
                'Check if this control has a ContextMenu attached to it
                'and indicate that
                If Control(__UI_FirstSelectedID).Type = __UI_Type_ContextMenu Then
                    For i = 1 To UBound(Control)
                        If Control(i).Type = __UI_Type_ContextMenu Then
                            If __UI_FirstSelectedID = Control(i).ID Then
                                Control(i).ControlState = 2
                            Else
                                Control(i).ControlState = 1
                            End If
                            Control(i).Redraw = True
                        End If
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).Type = __UI_Type_ContextMenu Then
                            If Control(__UI_FirstSelectedID).ContextMenuID = Control(i).ID Then
                                Control(i).ControlState = 2
                            Else
                                Control(i).ControlState = 1
                            End If
                            Control(i).Redraw = True
                        End If
                    Next
                End If
            End If
        ElseIf __UI_TotalSelectedControls > 1 Then
            Dim SearchType As Integer, AllControlsTurnInto As _Byte
            SearchType = Control(__UI_FirstSelectedID).Type
            AllControlsTurnInto = True
            For i = 1 To UBound(Control)
                If Control(i).ControlIsSelected Then
                    If SearchType = __UI_Type_TextBox Then
                        If Control(i).NumericOnly <> Control(__UI_FirstSelectedID).NumericOnly Then
                            AllControlsTurnInto = False
                            Exit For
                        End If
                    Else
                        If Control(i).Type <> SearchType Then
                            AllControlsTurnInto = False
                            Exit For
                        End If
                    End If
                End If
            Next
            SearchType = __UI_Type(SearchType).TurnsInto
            If SearchType = 0 And Control(__UI_FirstSelectedID).Type = __UI_Type_TextBox Then
                If Control(__UI_FirstSelectedID).NumericOnly = False Then
                    SearchType = -1
                Else
                    SearchType = -2
                End If
            End If
            If Not AllControlsTurnInto Then SearchType = 0
            If prevTurnsInto <> SearchType Then
                prevTurnsInto = SearchType
                b$ = MKI$(prevTurnsInto)
                SendData b$, "TURNSINTO"
            End If

            If __UI_DesignMode = True And __UI_ShowInvisibleControls = True Then
                'Check if all selected controls have the same ContextMenu
                'attached to them and indicate that
                Dim SelectionContextMenu As Long, AllControlsHaveTheSameContextMenu As _Byte
                AllControlsHaveTheSameContextMenu = True
                SelectionContextMenu = Control(__UI_FirstSelectedID).ContextMenuID
                If SelectionContextMenu > 0 Then
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            If Control(i).ContextMenuID <> SelectionContextMenu Then
                                AllControlsHaveTheSameContextMenu = False
                                Exit For
                            End If
                        End If
                    Next
                Else
                    AllControlsHaveTheSameContextMenu = False
                End If

                If AllControlsHaveTheSameContextMenu Then
                    For i = 1 To UBound(Control)
                        If Control(i).Type = __UI_Type_ContextMenu Then
                            If SelectionContextMenu = Control(i).ID Then
                                Control(i).ControlState = 2
                            Else
                                Control(i).ControlState = 1
                            End If
                            Control(i).Redraw = True
                        End If
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).Type = __UI_Type_ContextMenu Then
                            Control(i).ControlState = 1
                            Control(i).Redraw = True
                        End If
                    Next
                End If
            End If
        End If
    Else
        For i = 1 To UBound(Control)
            If Control(i).Type = __UI_Type_ContextMenu Then
                Control(i).ControlState = 1 'normal state
                Control(i).Redraw = True
            End If
        Next
    End If

    Do While Len(Signal$)
        b$ = Left$(Signal$, 2)
        Signal$ = Mid$(Signal$, 3)
        TempValue = CVI(b$)
        If TempValue = -2 Then
            'Hide the preview
            _ScreenHide
        ElseIf TempValue = -3 Then
            'Show the preview
            _ScreenShow
        ElseIf TempValue = -4 Then
            'Load an existing file
            IsCreating = True
            Dim FileToLoad As Integer
            FileToLoad = FreeFile
            Open FileNameToLoad$ For Binary As #FileToLoad
            a$ = Space$(LOF(FileToLoad))
            Get #FileToLoad, 1, a$
            Close #FileToLoad

            FileToLoad = FreeFile
            Open "UiEditorPreview.frmbin" For Binary As #FileToLoad
            Put #FileToLoad, 1, a$
            Close #FileToLoad

            __UI_DefaultButtonID = 0
            _ScreenShow
            If InStr(a$, "SUB __UI_LoadForm") > 0 Then
                LoadPreviewText
            Else
                LoadPreview InDisk
            End If
            UndoPointer = 0
            TotalUndoImages = 0
            SendSignal -7 'Form just loaded
        ElseIf TempValue = -5 Then
            'Reset request (new form)
            IsCreating = True
            a$ = Unpack$(EmptyForm$)

            FileToLoad = FreeFile
            Open "UiEditorPreview.frmbin" For Binary As #FileToLoad
            Put #FileToLoad, 1, a$
            Close #FileToLoad

            LoadPreview InDisk
            LoadDefaultFonts

            LastPreviewDataSent$ = ""
            UndoPointer = 0
            TotalUndoImages = 0
            __UI_DefaultButtonID = 0
            _Icon
            SendSignal -7 'New form created
        ElseIf TempValue = -6 Then
            'Set current button as default
            If __UI_DefaultButtonID = __UI_FirstSelectedID Then
                __UI_DefaultButtonID = 0
            Else
                __UI_DefaultButtonID = __UI_FirstSelectedID
            End If
        ElseIf TempValue = -7 Then
            __UI_RestoreImageOriginalSize
        ElseIf TempValue = -8 Then
            'Editor is manipulated, preview menus must be closed.
            If __UI_TotalActiveMenus > 0 And Left$(Control(__UI_ParentMenu(__UI_TotalActiveMenus)).Name, 5) = "__UI_" Then
                __UI_CloseAllMenus
            End If
        ElseIf TempValue = 214 Then
            RestoreUndoImage
        ElseIf TempValue = 215 Then
            RestoreRedoImage
        End If
    Loop

    Dim PropertyApplied As _Byte, LockedControlsGOSUB As _Byte
    PropertyApplied = False
    If TotalLockedControls Then LockedControlsGOSUB = True Else LockedControlsGOSUB = False
    Do While Len(Property$)
        Dim FloatValue As _Float, temp$, temp2$
        'Editor sent property value
        b$ = ReadSequential$(Property$, 2)
        TempValue = CVI(b$)
        SaveUndoImage
        PropertyApplied = True
        Select Case TempValue
            Case 1 'Name
                b$ = ReadSequential$(Property$, 4)
                b$ = ReadSequential$(Property$, CVL(b$))
                If TotalLockedControls = 1 Then
                    temp$ = AdaptName$(b$, LockedControls(1))
                    temp2$ = RTrim$(Control(LockedControls(1)).Name) + Chr$(10) + temp$
                    SendData temp2$, "CONTROLRENAMED"
                    Control(LockedControls(1)).Name = temp$
                Else
                    If __UI_TotalSelectedControls = 1 Then
                        temp$ = AdaptName$(b$, __UI_FirstSelectedID)
                        temp2$ = RTrim$(Control(__UI_FirstSelectedID).Name) + Chr$(10) + temp$
                        SendData temp2$, "CONTROLRENAMED"
                        Control(__UI_FirstSelectedID).Name = temp$
                    ElseIf __UI_TotalSelectedControls = 0 Then
                        temp$ = AdaptName$(b$, __UI_FormID)
                        temp2$ = RTrim$(Control(__UI_FormID).Name) + Chr$(10) + temp$
                        SendData temp2$, "CONTROLRENAMED"
                        Control(__UI_FormID).Name = temp$
                    End If
                End If
            Case 2 'Caption
                b$ = ReadSequential$(Property$, 4)
                b$ = ReadSequential$(Property$, CVL(b$))
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        i = LockedControls(j)
                        GoSub ChangeCaption
                    Next
                Else
                    If __UI_TotalSelectedControls > 0 Then
                        For i = 1 To UBound(Control)
                            If Control(i).ControlIsSelected Then
                                ChangeCaption:
                                If Control(i).Type = __UI_Type_Label Then
                                    Dim TotalReplacements As Long
                                    b$ = Replace(b$, "\n", Chr$(10), False, TotalReplacements)
                                End If
                                SetCaption i, b$
                                If Control(i).Type = __UI_Type_Label Then AutoSizeLabel Control(i)
                                If Len(b$) > 0 And b$ <> "&" Then GoSub AutoName
                                If Control(i).Type = __UI_Type_MenuItem Then
                                    __UI_ActivateMenu Control(Control(i).ParentID), False
                                End If
                                If LockedControlsGOSUB Then Return
                            End If
                        Next
                    Else
                        Caption(__UI_FormID) = b$
                        i = __UI_FormID
                        If Len(b$) > 0 And b$ <> "&" Then GoSub AutoName
                    End If
                End If

                GoTo SkipAutoName

                AutoName:
                If AutoNameControls Then
                    Dim NewName$

                    NewName$ = RTrim$(b$)

                    If Control(i).Type = __UI_Type_MenuBar Then
                        If Len(NewName$) > 36 Then NewName$ = Left$(NewName$, 36)
                    ElseIf Control(i).Type <> __UI_Type_Form And Control(i).Type <> __UI_Type_MenuItem And Control(i).Type <> __UI_Type_ListBox And Control(i).Type <> __UI_Type_TrackBar And Control(i).Type <> __UI_Type_DropdownList Then
                        If Len(NewName$) > 38 Then NewName$ = Left$(NewName$, 38)
                    End If
                    Select Case Control(i).Type
                        Case __UI_Type_Button: NewName$ = NewName$ + "BT"
                        Case __UI_Type_Label: NewName$ = NewName$ + "LB"
                        Case __UI_Type_CheckBox: NewName$ = NewName$ + "CB"
                        Case __UI_Type_RadioButton: NewName$ = NewName$ + "RB"
                        Case __UI_Type_TextBox: NewName$ = NewName$ + "TB"
                        Case __UI_Type_ProgressBar: NewName$ = NewName$ + "PB"
                        Case __UI_Type_MenuBar: NewName$ = NewName$ + "Menu"
                        Case __UI_Type_MenuItem
                            NewName$ = RTrim$(Control(Control(i).ParentID).Name) + NewName$
                        Case __UI_Type_PictureBox: NewName$ = NewName$ + "PX"
                    End Select

                    temp$ = AdaptName$(NewName$, i)
                    temp2$ = RTrim$(Control(i).Name) + Chr$(10) + temp$
                    SendData temp2$, "CONTROLRENAMED"
                    Control(i).Name = temp$
                End If
                Return

                SkipAutoName:
            Case 3 'Text
                b$ = ReadSequential$(Property$, 4)
                b$ = ReadSequential$(Property$, CVL(b$))
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        i = LockedControls(j)
                        GoSub ChangeText
                    Next
                Else
                    If __UI_TotalSelectedControls > 0 Then
                        For i = 1 To UBound(Control)
                            If Control(i).ControlIsSelected Then
                                ChangeText:
                                Text(i) = b$
                                If Control(i).Type = __UI_Type_TextBox And Control(i).NumericOnly Then
                                    Text(i) = b$
                                    Control(i).Value = Val(b$)
                                ElseIf Control(i).Type = __UI_Type_TextBox And Control(i).Max > 0 Then
                                    Text(i) = Left$(b$, Control(i).Max)
                                End If
                                If Control(i).Type = __UI_Type_Button Or Control(i).Type = __UI_Type_MenuItem Then
                                    LoadImage Control(i), b$
                                ElseIf Control(i).Type = __UI_Type_PictureBox Then
                                    PreviewLoadImage Control(i), b$
                                    If Len(Text(i)) > 0 Then 'Load successful
                                        'Keep aspect ratio at load
                                        Control(i).Height = (_Height(Control(i).HelperCanvas) / _Width(Control(i).HelperCanvas)) * Control(i).Width
                                        If Len(b$) > 0 And b$ <> "&" Then GoSub AutoName
                                    End If
                                ElseIf Control(i).Type = __UI_Type_ListBox Or Control(i).Type = __UI_Type_DropdownList Then
                                    Text(i) = Replace(b$, "\n", Chr$(10), False, TotalReplacements)
                                    If Control(i).Max < TotalReplacements + 1 Then Control(i).Max = TotalReplacements + 1
                                    Control(i).LastVisibleItem = 0 'Reset it so it's recalculated
                                End If
                                If LockedControlsGOSUB Then Return
                            End If
                        Next
                    Else
                        If ExeIcon <> 0 Then _FreeImage ExeIcon: ExeIcon = 0
                        ExeIcon = IconPreview&(b$)
                        If ExeIcon < -1 Then
                            _Icon ExeIcon
                            Text(__UI_FormID) = b$
                        Else
                            _Icon
                            If _FileExists(b$) Then
                                If LCase$(Right$(b$, 4)) <> ".ico" Then
                                    SendSignal -6
                                    Text(__UI_FormID) = ""
                                Else
                                    SendSignal -4
                                    Text(__UI_FormID) = b$
                                End If
                            Else
                                Text(__UI_FormID) = ""
                            End If
                        End If
                    End If
                End If
            Case 4 'Top
                b$ = ReadSequential$(Property$, 2)
                TempValue = CVI(b$)
                If TotalLockedControls > 0 Then
                    For i = 1 To TotalLockedControls
                        Control(LockedControls(i)).Top = TempValue
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            Control(i).Top = TempValue
                        End If
                    Next
                End If
            Case 5 'Left
                b$ = ReadSequential$(Property$, 2)
                TempValue = CVI(b$)
                If TotalLockedControls > 0 Then
                    For i = 1 To TotalLockedControls
                        Control(LockedControls(i)).Left = TempValue
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            Control(i).Left = TempValue
                        End If
                    Next
                End If
            Case 6 'Width
                b$ = ReadSequential$(Property$, 2)
                TempValue = CVI(b$)
                If TempValue < 1 Then TempValue = 1
                If TotalLockedControls > 0 Then
                    For i = 1 To TotalLockedControls
                        IF __UI_Type(Control(LockedControls(i)).Type).RestrictResize <> __UI_CantResizeH AND _
                           __UI_Type(Control(LockedControls(i)).Type).RestrictResize <> __UI_CantResize THEN
                            Control(LockedControls(i)).Width = TempValue
                        End If
                    Next
                Else
                    If __UI_TotalSelectedControls > 0 Then
                        For i = 1 To UBound(Control)
                            If Control(i).ControlIsSelected Then
                                IF __UI_Type(Control(i).Type).RestrictResize <> __UI_CantResizeH AND _
                                   __UI_Type(Control(i).Type).RestrictResize <> __UI_CantResize THEN
                                    Control(i).Width = TempValue
                                End If
                            End If
                        Next
                    Else
                        If TempValue < 20 Then TempValue = 20
                        Control(__UI_FormID).Width = TempValue
                    End If
                End If
            Case 7 'Height
                b$ = ReadSequential$(Property$, 2)
                TempValue = CVI(b$)
                If TempValue < 1 Then TempValue = 1
                If TotalLockedControls > 0 Then
                    For i = 1 To TotalLockedControls
                        IF __UI_Type(Control(LockedControls(i)).Type).RestrictResize <> __UI_CantResizeV AND _
                           __UI_Type(Control(LockedControls(i)).Type).RestrictResize <> __UI_CantResize THEN
                            Control(LockedControls(i)).Height = TempValue
                        End If
                    Next
                Else
                    If __UI_TotalSelectedControls > 0 Then
                        For i = 1 To UBound(Control)
                            If Control(i).ControlIsSelected Then
                                IF __UI_Type(Control(i).Type).RestrictResize <> __UI_CantResizeV AND _
                                   __UI_Type(Control(i).Type).RestrictResize <> __UI_CantResize THEN
                                    Control(i).Height = TempValue
                                End If
                            End If
                        Next
                    Else
                        If TempValue < 20 Then TempValue = 20
                        Control(__UI_FormID).Height = TempValue
                    End If
                End If
            Case 8 'Font
                b$ = ReadSequential$(Property$, 4)
                b$ = ReadSequential$(Property$, CVL(b$))
                Dim NewFontFile As String
                Dim NewFontSize As Integer
                Dim FindSep As Integer, TotalSep As Integer

                'Parse b$ into Font data
                FindSep = InStr(b$, ",")
                If FindSep Then TotalSep = TotalSep + 1
                NewFontFile = Left$(b$, FindSep - 1)
                b$ = Mid$(b$, FindSep + 1)

                NewFontSize = Val(b$)

                If TotalSep = 1 And NewFontSize > 0 Then
                    If TotalLockedControls Then
                        For j = 1 To TotalLockedControls
                            i = LockedControls(j)
                            GoSub ChangeFont
                        Next
                    Else
                        If __UI_TotalSelectedControls > 0 Then
                            For i = 1 To UBound(Control)
                                If Control(i).ControlIsSelected Then
                                    ChangeFont:
                                    Control(i).Font = SetFont(NewFontFile, NewFontSize)
                                    Dim tempFont As Long
                                    tempFont = _Font
                                    _Font Control(i).Font
                                    Select Case Control(i).Type
                                        Case __UI_Type_Label
                                            If Control(i).WordWrap = False Then
                                                Control(i).Height = uspacing + 6 + (Abs(Control(i).HasBorder) * Control(i).BorderSize)
                                                AutoSizeLabel Control(i)
                                            End If
                                        Case __UI_Type_TextBox
                                            If Control(i).Multiline = False Then
                                                Control(i).Height = uspacing + 6 + (Abs(Control(i).HasBorder) * Control(i).BorderSize)
                                            End If
                                        Case __UI_Type_CheckBox, __UI_Type_RadioButton
                                            Control(i).Height = uspacing + 6
                                        Case __UI_Type_ProgressBar
                                            If InStr(Caption(i), Chr$(10)) = 0 Then
                                                Control(i).Height = uspacing + 6
                                            End If
                                    End Select
                                    If Control(i).HotKey > 0 Then
                                        If Control(i).HotKeyPosition = 1 Then
                                            Control(i).HotKeyOffset = 0
                                        Else
                                            Control(i).HotKeyOffset = __UI_PrintWidth(Left$(Caption(i), Control(i).HotKeyPosition - 1))
                                        End If
                                    End If
                                    _Font tempFont
                                    If LockedControlsGOSUB Then Return
                                End If
                            Next
                        Else
                            Control(__UI_FormID).Font = SetFont(NewFontFile, NewFontSize)
                            Dim MustRedrawMenus As _Byte
                            For i = 1 To UBound(Control)
                                If Control(i).Type = __UI_Type_MenuBar Or Control(i).Type = __UI_Type_MenuItem Or Control(i).Type = __UI_Type_MenuPanel Or Control(i).Type = __UI_Type_ContextMenu Then
                                    Control(i).Font = SetFont(NewFontFile, NewFontSize)
                                    MustRedrawMenus = True
                                End If
                            Next
                            If MustRedrawMenus Then __UI_RefreshMenuBar
                        End If
                    End If
                End If
            Case 9 'Tooltip
                b$ = ReadSequential$(Property$, 4)
                b$ = ReadSequential$(Property$, CVL(b$))

                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        i = LockedControls(j)
                        GoSub ChangeTooltip
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            ChangeTooltip:
                            ToolTip(i) = Replace(b$, "\n", Chr$(10), False, 0)
                            If LockedControlsGOSUB Then Return
                        End If
                    Next
                End If
            Case 10 'Value
                b$ = ReadSequential$(Property$, Len(FloatValue))
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        i = LockedControls(j)
                        GoSub ChangeValue
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            ChangeValue:
                            If Control(i).Type = __UI_Type_CheckBox Or (Control(i).Type = __UI_Type_MenuItem And Control(i).BulletStyle = __UI_CheckMark) Or Control(i).Type = __UI_Type_ToggleSwitch Then
                                If _CV(_Float, b$) <> 0 Then
                                    Control(i).Value = True
                                Else
                                    Control(i).Value = False
                                End If
                            ElseIf Control(i).Type = __UI_Type_RadioButton Or (Control(i).Type = __UI_Type_MenuItem And Control(i).BulletStyle = __UI_Bullet) Then
                                If _CV(_Float, b$) <> 0 Then
                                    SetRadioButtonValue i
                                Else
                                    Control(i).Value = False
                                End If
                            Else
                                Control(i).Value = _CV(_Float, b$)
                            End If
                            If LockedControlsGOSUB Then Return
                        End If
                    Next
                End If
            Case 11 'Min
                b$ = ReadSequential$(Property$, Len(FloatValue))
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        Control(LockedControls(j)).Min = _CV(_Float, b$)
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            Control(i).Min = _CV(_Float, b$)
                        End If
                    Next
                End If
            Case 12 'Max
                b$ = ReadSequential$(Property$, Len(FloatValue))
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        i = LockedControls(j)
                        GoSub ChangeMax
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            ChangeMax:
                            Control(i).Max = _CV(_Float, b$)
                            If Control(i).Type = __UI_Type_TextBox Then
                                Text(i) = Left$(Text(i), Int(Control(i).Max))
                                If Len(Mask(i)) > 0 Then Mask(i) = ""
                            End If
                            If LockedControlsGOSUB Then Return
                        End If
                    Next
                End If
            Case 13 'Interval
                b$ = ReadSequential$(Property$, Len(FloatValue))
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        Control(LockedControls(j)).Interval = _CV(_Float, b$)
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            Control(i).Interval = _CV(_Float, b$)
                        End If
                    Next
                End If
            Case 14 'Stretch
                b$ = ReadSequential$(Property$, 2)
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        Control(LockedControls(j)).Stretch = CVI(b$)
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            Control(i).Stretch = CVI(b$)
                        End If
                    Next
                End If
            Case 15 'Has border
                b$ = ReadSequential$(Property$, 2)
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        Control(LockedControls(j)).HasBorder = CVI(b$)
                        If CVI(b$) Then
                            If Control(LockedControls(j)).BorderSize = 0 Then
                                Control(LockedControls(j)).BorderSize = 1
                            End If
                        End If
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            Control(i).HasBorder = CVI(b$)
                            If CVI(b$) Then
                                If Control(i).BorderSize = 0 Then
                                    Control(i).BorderSize = 1
                                End If
                            End If
                        End If
                    Next
                End If
            Case 16 'Show percentage
                b$ = ReadSequential$(Property$, 2)
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        Control(LockedControls(j)).ShowPercentage = CVI(b$)
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            Control(i).ShowPercentage = CVI(b$)
                        End If
                    Next
                End If
            Case 17 'Word wrap
                b$ = ReadSequential$(Property$, 2)
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        Control(LockedControls(j)).WordWrap = CVI(b$)
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            Control(i).WordWrap = CVI(b$)
                        End If
                    Next
                End If
            Case 18 'Can have focus
                b$ = ReadSequential$(Property$, 2)
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        Control(LockedControls(j)).CanHaveFocus = CVI(b$)
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            Control(i).CanHaveFocus = CVI(b$)
                        End If
                    Next
                End If
            Case 19 'Disabled
                b$ = ReadSequential$(Property$, 2)
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        Control(LockedControls(j)).Disabled = CVI(b$)
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            Control(i).Disabled = CVI(b$)
                        End If
                    Next
                End If
            Case 20 'Hidden
                b$ = ReadSequential$(Property$, 2)
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        i = LockedControls(j)
                        GoSub ChangeHidden
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            ChangeHidden:
                            Control(i).Hidden = CVI(b$)
                            If Control(i).Type = __UI_Type_MenuItem And __UI_ParentMenu(__UI_TotalActiveMenus) = Control(i).ParentID Then
                                __UI_ActivateMenu Control(Control(i).ParentID), False
                            End If
                            If LockedControlsGOSUB Then Return
                        End If
                    Next
                End If
            Case 21 'CenteredWindow - Form only
                b$ = ReadSequential$(Property$, 2)
                TempValue = CVI(b$)
                If TotalLockedControls = 0 And __UI_TotalSelectedControls = 0 Then
                    Control(__UI_FormID).CenteredWindow = TempValue
                End If
            Case 22 'Alignment
                b$ = ReadSequential$(Property$, 2)
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        i = LockedControls(j)
                        GoSub ChangeAlignment
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            ChangeAlignment:
                            Control(i).Align = CVI(b$)
                            If Control(i).Type = __UI_Type_MenuBar Then
                                If Control(i).Align <> __UI_Left Then Control(i).Align = __UI_Right
                                If __UI_TotalActiveMenus > 0 Then __UI_CloseAllMenus
                                __UI_RefreshMenuBar
                            End If
                            If LockedControlsGOSUB Then Return
                        End If
                    Next
                End If
            Case 23 'ForeColor
                b$ = ReadSequential$(Property$, 4)
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        Control(LockedControls(j)).ForeColor = _CV(_Unsigned Long, b$)
                    Next
                Else
                    If __UI_TotalSelectedControls > 0 Then
                        For i = 1 To UBound(Control)
                            If Control(i).ControlIsSelected Then
                                Control(i).ForeColor = _CV(_Unsigned Long, b$)
                            End If
                        Next
                    Else
                        Control(__UI_FormID).ForeColor = _CV(_Unsigned Long, b$)
                        For i = 1 To UBound(Control)
                            If Control(i).Type = __UI_Type_MenuBar Then
                                Control(i).ForeColor = _CV(_Unsigned Long, b$)
                            End If
                        Next
                    End If
                End If
            Case 24 'BackColor
                b$ = ReadSequential$(Property$, 4)
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        Control(LockedControls(j)).BackColor = _CV(_Unsigned Long, b$)
                    Next
                Else
                    If __UI_TotalSelectedControls > 0 Then
                        For i = 1 To UBound(Control)
                            If Control(i).ControlIsSelected Then
                                Control(i).BackColor = _CV(_Unsigned Long, b$)
                            End If
                        Next
                    Else
                        Control(__UI_FormID).BackColor = _CV(_Unsigned Long, b$)
                        For i = 1 To UBound(Control)
                            If Control(i).Type = __UI_Type_MenuBar Then
                                Control(i).BackColor = _CV(_Unsigned Long, b$)
                            End If
                        Next
                    End If
                End If
            Case 25 'SelectedForeColor
                b$ = ReadSequential$(Property$, 4)
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        Control(LockedControls(j)).SelectedForeColor = _CV(_Unsigned Long, b$)
                    Next
                Else
                    If __UI_TotalSelectedControls > 0 Then
                        For i = 1 To UBound(Control)
                            If Control(i).ControlIsSelected Then
                                Control(i).SelectedForeColor = _CV(_Unsigned Long, b$)
                            End If
                        Next
                    Else
                        Control(__UI_FormID).SelectedForeColor = _CV(_Unsigned Long, b$)
                        For i = 1 To UBound(Control)
                            If Control(i).Type = __UI_Type_MenuBar Or Control(i).Type = __UI_Type_MenuItem Or Control(i).Type = __UI_Type_MenuPanel Or Control(i).Type = __UI_Type_ContextMenu Then
                                Control(i).SelectedForeColor = _CV(_Unsigned Long, b$)
                            End If
                        Next
                    End If
                End If
            Case 26 'SelectedBackColor
                b$ = ReadSequential$(Property$, 4)
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        Control(LockedControls(j)).SelectedBackColor = _CV(_Unsigned Long, b$)
                    Next
                Else
                    If __UI_TotalSelectedControls > 0 Then
                        For i = 1 To UBound(Control)
                            If Control(i).ControlIsSelected Then
                                Control(i).SelectedBackColor = _CV(_Unsigned Long, b$)
                            End If
                        Next
                    Else
                        Control(__UI_FormID).SelectedBackColor = _CV(_Unsigned Long, b$)
                        For i = 1 To UBound(Control)
                            If Control(i).Type = __UI_Type_MenuBar Or Control(i).Type = __UI_Type_MenuItem Or Control(i).Type = __UI_Type_MenuPanel Or Control(i).Type = __UI_Type_ContextMenu Then
                                Control(i).SelectedBackColor = _CV(_Unsigned Long, b$)
                            End If
                        Next
                    End If
                End If
            Case 27 'BorderColor
                b$ = ReadSequential$(Property$, 4)
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        Control(LockedControls(j)).BorderColor = _CV(_Unsigned Long, b$)
                    Next
                Else
                    If __UI_TotalSelectedControls > 0 Then
                        For i = 1 To UBound(Control)
                            If Control(i).ControlIsSelected Then
                                Control(i).BorderColor = _CV(_Unsigned Long, b$)
                            End If
                        Next
                    Else
                        Control(__UI_FormID).BorderColor = _CV(_Unsigned Long, b$)
                    End If
                End If
            Case 28 'BackStyle
                b$ = ReadSequential$(Property$, 2)
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        Control(LockedControls(j)).BackStyle = CVI(b$)
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            Control(i).BackStyle = CVI(b$)
                        End If
                    Next
                End If
            Case 29 'CanResize - Form only
                b$ = ReadSequential$(Property$, 2)
                TempValue = CVI(b$)
                If TotalLockedControls = 0 And __UI_TotalSelectedControls = 0 Then
                    Control(__UI_FormID).CanResize = TempValue
                End If
            Case 31 'Padding
                b$ = ReadSequential$(Property$, 2)
                TempValue = CVI(b$)
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        Control(LockedControls(j)).Padding = TempValue
                    Next
                ElseIf __UI_TotalSelectedControls > 0 Then
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            Control(i).Padding = TempValue
                        End If
                    Next
                End If
            Case 32 'Vertical Alignment
                b$ = ReadSequential$(Property$, 2)
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        Control(LockedControls(j)).VAlign = CVI(b$)
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            Control(i).VAlign = CVI(b$)
                        End If
                    Next
                End If
            Case 33 'Password field
                b$ = ReadSequential$(Property$, 2)
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        Control(LockedControls(j)).PasswordField = CVI(b$)
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            Control(i).PasswordField = CVI(b$)
                        End If
                    Next
                End If
            Case 34 'Encoding - Form only
                b$ = ReadSequential$(Property$, 4)
                Control(__UI_FormID).Encoding = CVL(b$)
            Case 35 'Mask
                b$ = ReadSequential$(Property$, 4)
                b$ = ReadSequential$(Property$, CVL(b$))
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        i = LockedControls(j)
                        GoSub ChangeMask
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            ChangeMask:
                            Mask(i) = b$
                            Text(i) = ""
                            If Len(Mask(i)) Then Control(i).Max = 0
                            If LockedControlsGOSUB Then Return
                        End If
                    Next
                End If
            Case 36 'MinInterval
                b$ = ReadSequential$(Property$, Len(FloatValue))
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        Control(LockedControls(j)).MinInterval = _CV(_Float, b$)
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            Control(i).MinInterval = _CV(_Float, b$)
                        End If
                    Next
                End If
            Case 37 'BulletStyle
                b$ = ReadSequential$(Property$, 2)
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        Control(LockedControls(j)).BulletStyle = CVI(b$)
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            Control(i).BulletStyle = CVI(b$)
                        End If
                    Next
                End If
            Case 38 'AutoScroll
                b$ = ReadSequential$(Property$, 2)
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        Control(LockedControls(j)).AutoScroll = CVI(b$)
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            Control(i).AutoScroll = CVI(b$)
                        End If
                    Next
                End If
            Case 39 'AutoSize
                b$ = ReadSequential$(Property$, 2)
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        Control(LockedControls(j)).AutoSize = CVI(b$)
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            Control(i).AutoSize = CVI(b$)
                        End If
                    Next
                End If
            Case 40 'BorderSize
                b$ = ReadSequential$(Property$, 2)
                TempValue = CVI(b$)
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        If Control(LockedControls(j)).Type <> __UI_Type_Frame Then
                            Control(LockedControls(j)).BorderSize = TempValue
                            If Control(LockedControls(j)).Type = __UI_Type_TextBox Then
                                tempFont = _Font
                                _Font Control(LockedControls(j)).Font
                                If Control(LockedControls(j)).Multiline = False Then Control(LockedControls(j)).Height = uspacing + 6 + (Abs(Control(LockedControls(j)).HasBorder) * Control(LockedControls(j)).BorderSize)
                                _Font tempFont
                            End If
                        End If
                    Next
                ElseIf __UI_TotalSelectedControls > 0 Then
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            If Control(i).Type <> __UI_Type_Frame Then
                                Control(i).BorderSize = TempValue
                                If Control(i).Type = __UI_Type_TextBox Then
                                    tempFont = _Font
                                    _Font Control(i).Font
                                    If Control(i).Multiline = False Then Control(i).Height = uspacing + 6 + (Abs(Control(i).HasBorder) * Control(i).BorderSize)
                                    _Font tempFont
                                End If
                            End If
                        End If
                    Next
                End If
            Case 41 'ContextMenuID
                b$ = ReadSequential$(Property$, 2)
                b$ = ReadSequential$(Property$, CVI(b$))
                Control(__UI_GetID(b$)).ControlState = 2 'highlight ContextMenu handle
                Control(__UI_GetID(b$)).Redraw = True 'highlight ContextMenu handle
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        i = LockedControls(j)
                        Control(i).ContextMenuID = __UI_GetID(b$)
                    Next
                Else
                    If __UI_TotalSelectedControls > 0 Then
                        For i = 1 To UBound(Control)
                            If Control(i).ControlIsSelected Then
                                Control(i).ContextMenuID = __UI_GetID(b$)
                            End If
                        Next
                    Else
                        Control(__UI_FormID).ContextMenuID = __UI_GetID(b$)
                    End If
                End If
            Case 42 'HideTicks
                b$ = ReadSequential$(Property$, 2)
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        If CVI(b$) Then
                            Control(LockedControls(j)).Height = __UI_Type(__UI_Type_TrackBar).MinimumHeight
                        Else
                            Control(LockedControls(j)).Height = __UI_Type(__UI_Type_TrackBar).DefaultHeight
                        End If
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            If CVI(b$) Then
                                Control(i).Height = __UI_Type(__UI_Type_TrackBar).MinimumHeight
                            Else
                                Control(i).Height = __UI_Type(__UI_Type_TrackBar).DefaultHeight
                            End If
                        End If
                    Next
                End If
            Case 43 'Key combo
                b$ = ReadSequential$(Property$, 2)
                b$ = ReadSequential$(Property$, CVI(b$))
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        i = RegisterKeyCombo(b$, LockedControls(j))
                        If Control(LockedControls(j)).Type = __UI_Type_MenuItem Then
                            __UI_ActivateMenu Control(Control(LockedControls(j)).ParentID), False
                            Exit For
                        End If
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            j = RegisterKeyCombo(b$, Control(i).ID)
                            If Control(i).Type = __UI_Type_MenuItem Then
                                __UI_ActivateMenu Control(Control(i).ParentID), False
                                Exit For
                            End If
                        End If
                    Next
                End If
            Case 44 'Auto-play (GIF extension)
                b$ = ReadSequential$(Property$, 2)
                If TotalLockedControls Then
                    For j = 1 To TotalLockedControls
                        AutoPlayGif(LockedControls(j)) = CVI(b$)
                        If AutoPlayGif(LockedControls(j)) Then PlayGif LockedControls(j) Else StopGif LockedControls(j)
                    Next
                Else
                    For i = 1 To UBound(Control)
                        If Control(i).ControlIsSelected Then
                            AutoPlayGif(i) = CVI(b$)
                            If AutoPlayGif(i) Then PlayGif i Else StopGif i
                        End If
                    Next
                End If
            Case 201 To 210
                'Alignment commands
                b$ = ReadSequential$(Property$, 2)
                DoAlign TempValue
            Case 211, 212 'Z-Ordering -> Move up/down
                Dim tID1 As Long, tID2 As Long
                a$ = ReadSequential$(Property$, 4)
                b$ = ReadSequential$(Property$, 4)
                tID1 = Control(CVL(a$)).ID
                tID2 = Control(CVL(b$)).ID
                Swap Control(CVL(b$)), Control(CVL(a$))
                Swap Caption(CVL(b$)), Caption(CVL(a$))
                Swap Text(CVL(b$)), Text(CVL(a$))
                Swap ToolTip(CVL(b$)), ToolTip(CVL(a$))
                Control(CVL(a$)).ID = tID1
                Control(CVL(b$)).ID = tID2

                'Restore ParentIDs based on ParentName
                For i = 1 To UBound(Control)
                    Control(i).ParentID = __UI_GetID(Control(i).ParentName)
                Next

                If __UI_TotalActiveMenus > 0 And Left$(Control(__UI_ParentMenu(__UI_TotalActiveMenus)).Name, 5) <> "__UI_" Then
                    If Control(CVL(a$)).Type = __UI_Type_MenuItem Then
                        __UI_ActivateMenu Control(Control(CVL(a$)).ParentID), False
                    ElseIf Control(CVL(b$)).Type = __UI_Type_MenuItem Then
                        __UI_ActivateMenu Control(Control(CVL(b$)).ParentID), False
                    Else
                        __UI_CloseAllMenus
                    End If
                End If
            Case 213
                'Select control
                b$ = ReadSequential$(Property$, 4)

                'Desselect all first:
                For i = 1 To UBound(Control)
                    Control(i).ControlIsSelected = False
                Next

                If CVL(b$) > 0 Then Control(CVL(b$)).ControlIsSelected = True
            Case 216 To 221
                __UI_KeyPress TempValue
            Case 222 'New textbox control with the NumericOnly property set to true
                b$ = ReadSequential$(Property$, 2)
                TempValue = __UI_NewControl(__UI_Type_TextBox, "", 120, 23, TempWidth \ 2 - 60, TempTop - 12, ThisContainer)
                Control(TempValue).Name = "Numeric" + Control(TempValue).Name
                SetCaption TempValue, RTrim$(Control(TempValue).Name)
                Control(TempValue).NumericOnly = __UI_NumericWithBounds
                Control(TempValue).Min = -32768
                Control(TempValue).Max = 32767

                If __UI_TotalActiveMenus > 0 Then
                    __UI_CloseAllMenus
                End If

                For i = 1 To UBound(Control)
                    Control(i).ControlIsSelected = False
                Next
                Control(TempValue).ControlIsSelected = True
                __UI_TotalSelectedControls = 1
                __UI_FirstSelectedID = TempValue
                __UI_ForceRedraw = True
            Case 223
                b$ = ReadSequential$(Property$, 2)
                AlternateNumericOnlyProperty
            Case 225
                ConvertControlToAlternativeType
        End Select
        __UI_ForceRedraw = True
    Loop
    If PropertyApplied Then TotalLockedControls = 0

    If __UI_TotalActiveMenus > 0 And Left$(Control(__UI_ParentMenu(__UI_TotalActiveMenus)).Name, 5) = "__UI_" And __UI_CantShowContextMenu Then
        __UI_CloseAllMenus
        b$ = "SIGNAL>" + MKI$(-2) + "<END>" 'Signal to the editor that the preview can't show the context menu
        Put #Host, , b$
    ElseIf __UI_TotalActiveMenus > 0 And Left$(Control(__UI_ParentMenu(__UI_TotalActiveMenus)).Name, 5) = "__UI_" Then
        Static LocalMenuShown As _Byte, LocalMenuShownSignalSent As _Byte
        LocalMenuShown = True
    Else
        LocalMenuShown = False
        LocalMenuShownSignalSent = False
    End If

    If LocalMenuShown And Not LocalMenuShownSignalSent Then
        b$ = "SIGNAL>" + MKI$(-5) + "<END>" 'Signal to the editor that a context menu is successfully shown
        Put #Host, , b$
        LocalMenuShownSignalSent = True
    End If

    Static prevTotalSelected As Long, prevFirstSelected As Long
    Static prevFormID As Long

    If __UI_TotalSelectedControls <> prevTotalSelected Then
        prevTotalSelected = __UI_TotalSelectedControls
        b$ = "TOTALSELECTEDCONTROLS>" + MKL$(__UI_TotalSelectedControls) + "<END>"
        Put #Host, , b$
    End If

    If Control(__UI_FirstSelectedID).ID = 0 Then __UI_FirstSelectedID = 0
    If __UI_FirstSelectedID <> prevFirstSelected Then
        prevFirstSelected = __UI_FirstSelectedID
        b$ = "FIRSTSELECTED>" + MKL$(__UI_FirstSelectedID) + "<END>"
        Put #Host, , b$
    End If

    If __UI_FormID <> prevFormID Then
        prevFormID = __UI_FormID
        b$ = "FORMID>" + MKL$(__UI_FormID) + "<END>"
        Put #Host, , b$
    End If
End Sub

Sub __UI_BeforeUnload
    __UI_UnloadSignal = False
    SendSignal -9
End Sub

Sub __UI_BeforeInit
    __UI_DesignMode = True

    If _FileExists("UiEditorPreview.frmbin") Then
        Dim FileToLoad As Integer, a$
        FileToLoad = FreeFile
        Open "UiEditorPreview.frmbin" For Binary As #FileToLoad
        a$ = Space$(LOF(FileToLoad))
        Get #FileToLoad, 1, a$
        Close #FileToLoad

        If InStr(a$, "SUB __UI_LoadForm") > 0 Then
            LoadPreviewText
        Else
            LoadPreview InDisk
        End If
    End If
End Sub

Sub __UI_FormResized
    Static TimesResized As Integer

    If IsCreating Then TimesResized = 0: IsCreating = False

    TimesResized = TimesResized + 1

    If TimesResized > 5 Then
        'Manually resizing a form triggers this event a few times;
        'Loading a form triggers it 2 or three times usually.
        TimesResized = 0
        SendSignal -8
    End If
End Sub

Sub __UI_OnLoad
    Dim b$, Answer As Integer, start!
    LoadDefaultFonts

    b$ = "Connecting to InForm Designer..."
    GoSub ShowMessage

    HostPort = Command$(1)
    If Val(HostPort) < 60000 Then
        ForceQuit:
        _ScreenHide
        Answer = MessageBox("InForm Designer is not running. Please run the main program.", "InForm Preview", 0)
        System
    End If

    $If WIN Then
        Const TIMEOUT = 10
    $Else
            CONST TIMEOUT = 120
    $End If

    start! = Timer
    Do
        Host = _OpenClient("TCP/IP:" + HostPort + ":localhost")
        _Display
    Loop Until Host < 0 Or Timer - start! > TIMEOUT

    If Host = 0 Then GoTo ForceQuit

    b$ = "Connected! Handshaking..."
    GoSub ShowMessage

    'Handshake: each module sends the other their PID:
    Dim incomingData$, thisData$
    start! = Timer
    Do
        incomingData$ = ""
        Get #Host, , incomingData$
        Stream$ = Stream$ + incomingData$
        If InStr(Stream$, "<END>") Then
            thisData$ = Left$(Stream$, InStr(Stream$, "<END>") - 1)
            Stream$ = Mid$(Stream$, Len(thisData$) + 6)
            If Left$(thisData$, 10) = "EDITORPID>" Then
                UiEditorPID = CVL(Mid$(thisData$, 11))
            End If
            Exit Do
        End If
    Loop Until Timer - start! > TIMEOUT

    If UiEditorPID = 0 Then GoTo ForceQuit

    b$ = "PREVIEWPID>" + MKL$(__UI_GetPID) + "<END>"
    Put #Host, , b$

    _AcceptFileDrop

    Exit Sub
    ShowMessage:
    Dim PreserveDestMessage As Long
    PreserveDestMessage = _Dest
    _Dest 0
    _Font Control(__UI_FormID).Font
    Cls , __UI_DefaultColor(__UI_Type_Form, 2)
    Color __UI_DefaultColor(__UI_Type_Form, 1), _RGBA32(0, 0, 0, 0)
    __UI_PrintString _Width \ 2 - _PrintWidth(b$) \ 2, _Height \ 2 - _FontHeight \ 2, b$
    _Display
    _Dest PreserveDestMessage
    Return
End Sub

Sub __UI_KeyPress (id As Long)
    Select Case id
        Case 201 To 210
            DoAlign id
        Case 214
            RestoreUndoImage
        Case 215
            RestoreRedoImage
        Case 216
            SaveUndoImage
        Case 217 'Copy selected controls to clipboard
            SavePreview InClipboard
        Case 218 'Restore selected controls from clipboard
            LoadPreview InClipboard
        Case 219 'Cut selected controls to clipboard
            SavePreview InClipboard
            DeleteSelectedControls
        Case 220 'Delete selected controls
            DeleteSelectedControls
        Case 221 'Select all controls
            SelectAllControls
        Case 223
            AlternateNumericOnlyProperty
        Case 224
            Dim TempValue As Long
            TempValue = AddNewMenuBarControl
            SelectNewControl TempValue
        Case 225
            ConvertControlToAlternativeType
        Case 226 'Add new ContextMenu control
            TempValue = __UI_NewControl(__UI_Type_ContextMenu, "", 22, 22, 0, 0, 0)
            Control(TempValue).HelperCanvas = _CopyImage(ContextMenuIcon, 32)
            RefreshContextMenus
            __UI_ActivateMenu Control(TempValue), False
            SelectNewControl TempValue
        Case 227 'Toggle __UI_ShowInvisibleControls
            __UI_ShowInvisibleControls = Not __UI_ShowInvisibleControls
        Case 228 'Bind/unbind controls
            'DIM a$, b$, c$, found AS _BYTE
            'DIM i AS LONG, j AS LONG
            'FOR i = 1 TO UBOUND(Control)
            '    IF Control(i).ControlIsSelected THEN
            '        j = j + 1
            '        IF j = 1 THEN
            '            found = __UI_PropertyEnum(a$, Control(i).BoundProperty)
            '            IF __UI_TotalSelectedControls = 1 THEN EXIT FOR
            '        ELSEIF j = 2 THEN
            '            found = __UI_PropertyEnum(b$, Control(i).BoundProperty)
            '            EXIT FOR
            '        END IF
            '    END IF
            'NEXT
            'c$ = MKL$(LEN(a$)) + a$ + MKL$(LEN(b$)) + b$
            SendData "", "SHOWBINDCONTROLDIALOG"
    End Select
End Sub

Sub AlternateNumericOnlyProperty
    If Control(__UI_FirstSelectedID).NumericOnly = True Then
        Control(__UI_FirstSelectedID).NumericOnly = __UI_NumericWithBounds
        If Val(Text(__UI_FirstSelectedID)) > Control(__UI_FirstSelectedID).Max Then
            Text(__UI_FirstSelectedID) = LTrim$(Str$(Control(__UI_FirstSelectedID).Max))
        ElseIf Val(Text(__UI_FirstSelectedID)) < Control(__UI_FirstSelectedID).Min Then
            Text(__UI_FirstSelectedID) = LTrim$(Str$(Control(__UI_FirstSelectedID).Min))
        End If
    ElseIf Control(__UI_FirstSelectedID).NumericOnly = __UI_NumericWithBounds Then
        Control(__UI_FirstSelectedID).NumericOnly = True
    End If
End Sub

Sub DoAlign (AlignMode As Integer)
    Dim i As Long
    Dim LeftMost As Integer
    Dim RightMost As Integer
    Dim TopMost As Integer, BottomMost As Integer, SelectionHeight As Integer
    Dim TopDifference As Integer, NewTopMost As Integer
    Dim SelectionWidth As Integer
    Dim LeftDifference As Integer, NewLeftMost As Integer
    Dim FindTops As Integer
    Dim FindLefts As Integer, NextControlToDistribute As Long
    Dim TotalSpace As Integer, BinSize As Integer

    Select Case AlignMode
        Case 201 'Lefts
            If __UI_TotalSelectedControls > 1 Then
                LeftMost = Control(__UI_FormID).Width
                For i = 1 To UBound(Control)
                    If Control(i).ControlIsSelected Then
                        If Control(i).Left < LeftMost Then LeftMost = Control(i).Left
                    End If
                Next
                For i = 1 To UBound(Control)
                    If Control(i).ControlIsSelected Then
                        Control(i).Left = LeftMost
                    End If
                Next
            End If
        Case 202 'Rights
            If __UI_TotalSelectedControls > 1 Then
                RightMost = 0
                For i = 1 To UBound(Control)
                    If Control(i).ControlIsSelected Then
                        If Control(i).Left + Control(i).Width - 1 > RightMost Then RightMost = Control(i).Left + Control(i).Width - 1
                    End If
                Next
                For i = 1 To UBound(Control)
                    If Control(i).ControlIsSelected Then
                        Control(i).Left = RightMost - (Control(i).Width - 1)
                    End If
                Next
            End If
        Case 203 'Tops
            If __UI_TotalSelectedControls > 1 Then
                TopMost = Control(__UI_FormID).Height
                For i = 1 To UBound(Control)
                    If Control(i).ControlIsSelected Then
                        If Control(i).Top < TopMost Then TopMost = Control(i).Top
                    End If
                Next
                For i = 1 To UBound(Control)
                    If Control(i).ControlIsSelected Then
                        Control(i).Top = TopMost
                    End If
                Next
            End If
        Case 204 'Bottoms
            If __UI_TotalSelectedControls > 1 Then
                BottomMost = 0
                For i = 1 To UBound(Control)
                    If Control(i).ControlIsSelected Then
                        If Control(i).Top + Control(i).Height - 1 > BottomMost Then BottomMost = Control(i).Top + Control(i).Height - 1
                    End If
                Next
                For i = 1 To UBound(Control)
                    If Control(i).ControlIsSelected Then
                        Control(i).Top = BottomMost - (Control(i).Height - 1)
                    End If
                Next
            End If
        Case 205 'Centers vertically
            If __UI_TotalSelectedControls > 1 Then
                If Control(__UI_FirstSelectedID).ParentID = 0 Then
                    TopMost = Control(__UI_FormID).Height
                Else
                    TopMost = Control(Control(__UI_FirstSelectedID).ParentID).Height
                End If
                BottomMost = 0
                For i = 1 To UBound(Control)
                    If Control(i).ControlIsSelected Then
                        If Control(i).Top < TopMost Then TopMost = Control(i).Top
                        If Control(i).Top + Control(i).Height - 1 > BottomMost Then BottomMost = Control(i).Top + Control(i).Height - 1
                    End If
                Next
                SelectionHeight = BottomMost - TopMost
                NewTopMost = TopMost + SelectionHeight / 2
                For i = 1 To UBound(Control)
                    If Control(i).ControlIsSelected Then
                        Control(i).Top = NewTopMost - Control(i).Height / 2
                    End If
                Next
            End If
        Case 206 'Centers horizontally
            If __UI_TotalSelectedControls > 1 Then
                If Control(__UI_FirstSelectedID).ParentID = 0 Then
                    LeftMost = Control(__UI_FormID).Width
                Else
                    LeftMost = Control(Control(__UI_FirstSelectedID).ParentID).Width
                End If
                RightMost = 0
                For i = 1 To UBound(Control)
                    If Control(i).ControlIsSelected Then
                        If Control(i).Left < LeftMost Then LeftMost = Control(i).Left
                        If Control(i).Left + Control(i).Width - 1 > RightMost Then RightMost = Control(i).Left + Control(i).Width - 1
                    End If
                Next
                SelectionWidth = RightMost - LeftMost
                NewLeftMost = LeftMost + SelectionWidth / 2
                For i = 1 To UBound(Control)
                    If Control(i).ControlIsSelected Then
                        Control(i).Left = NewLeftMost - Control(i).Width / 2
                    End If
                Next
            End If
        Case 207 'Center vertically to form
            If __UI_TotalSelectedControls = 1 Then
                If Control(__UI_FirstSelectedID).ParentID = 0 Then
                    Control(__UI_FirstSelectedID).Top = (Control(__UI_FormID).Height - __UI_MenuBarOffsetV) / 2 - Control(__UI_FirstSelectedID).Height / 2 + __UI_MenuBarOffsetV
                Else
                    Control(__UI_FirstSelectedID).Top = Control(Control(__UI_FirstSelectedID).ParentID).Height / 2 - Control(__UI_FirstSelectedID).Height / 2
                End If
            ElseIf __UI_TotalSelectedControls > 1 Then
                If Control(__UI_FirstSelectedID).ParentID = 0 Then
                    TopMost = Control(__UI_FormID).Height
                Else
                    TopMost = Control(Control(__UI_FirstSelectedID).ParentID).Height
                End If
                BottomMost = 0
                For i = 1 To UBound(Control)
                    If Control(i).ControlIsSelected Then
                        If Control(i).Top < TopMost Then TopMost = Control(i).Top
                        If Control(i).Top + Control(i).Height - 1 > BottomMost Then BottomMost = Control(i).Top + Control(i).Height - 1
                    End If
                Next
                SelectionHeight = BottomMost - TopMost
                If Control(__UI_FirstSelectedID).ParentID = 0 Then
                    NewTopMost = (Control(__UI_FormID).Height - __UI_MenuBarOffsetV) / 2 - SelectionHeight / 2
                Else
                    NewTopMost = Control(Control(__UI_FirstSelectedID).ParentID).Height / 2 - SelectionHeight / 2
                End If
                TopDifference = TopMost - NewTopMost
                For i = 1 To UBound(Control)
                    If Control(i).ControlIsSelected Then
                        Control(i).Top = Control(i).Top - TopDifference + __UI_MenuBarOffsetV
                    End If
                Next
            End If
        Case 208 'Center horizontally to form
            If __UI_TotalSelectedControls = 1 Then
                If Control(__UI_FirstSelectedID).ParentID = 0 Then
                    Control(__UI_FirstSelectedID).Left = Control(__UI_FormID).Width / 2 - Control(__UI_FirstSelectedID).Width / 2
                Else
                    Control(__UI_FirstSelectedID).Left = Control(Control(__UI_FirstSelectedID).ParentID).Width / 2 - Control(__UI_FirstSelectedID).Width / 2
                End If
            ElseIf __UI_TotalSelectedControls > 1 Then
                If Control(__UI_FirstSelectedID).ParentID = 0 Then
                    LeftMost = Control(__UI_FormID).Width
                Else
                    LeftMost = Control(Control(__UI_FirstSelectedID).ParentID).Width
                End If
                RightMost = 0
                For i = 1 To UBound(Control)
                    If Control(i).ControlIsSelected Then
                        If Control(i).Left < LeftMost Then LeftMost = Control(i).Left
                        If Control(i).Left + Control(i).Width - 1 > RightMost Then RightMost = Control(i).Left + Control(i).Width - 1
                    End If
                Next
                SelectionWidth = RightMost - LeftMost
                If Control(__UI_FirstSelectedID).ParentID = 0 Then
                    NewLeftMost = Control(__UI_FormID).Width / 2 - SelectionWidth / 2
                Else
                    NewLeftMost = Control(Control(__UI_FirstSelectedID).ParentID).Width / 2 - SelectionWidth / 2
                End If
                LeftDifference = LeftMost - NewLeftMost
                For i = 1 To UBound(Control)
                    If Control(i).ControlIsSelected Then
                        Control(i).Left = Control(i).Left - LeftDifference
                    End If
                Next
            End If
        Case 209 'Distribute vertically
            'Build a sublist containing the selected controls in the order they
            'are currently placed vertically:

            ReDim SubList(1 To __UI_TotalSelectedControls) As Long
            __UI_AutoRefresh = False
            For FindTops = 0 To Control(__UI_FormID).Height - 1
                For i = 1 To UBound(Control)
                    If Control(i).ControlIsSelected And Control(i).Top = FindTops Then
                        If NextControlToDistribute > 0 Then
                            If SubList(NextControlToDistribute) <> i Then
                                NextControlToDistribute = NextControlToDistribute + 1
                                SubList(NextControlToDistribute) = i
                                Exit For
                            End If
                        Else
                            NextControlToDistribute = NextControlToDistribute + 1
                            SubList(NextControlToDistribute) = i
                            Exit For
                        End If
                    End If
                Next
                If NextControlToDistribute = __UI_TotalSelectedControls Then Exit For
            Next

            TotalSpace = (Control(SubList(__UI_TotalSelectedControls)).Top + Control(SubList(__UI_TotalSelectedControls)).Height) - Control(SubList(1)).Top
            For i = 1 To __UI_TotalSelectedControls
                TotalSpace = TotalSpace - Control(SubList(i)).Height
            Next

            BinSize = TotalSpace \ (__UI_TotalSelectedControls - 1)
            FindTops = Control(SubList(1)).Top - BinSize
            For i = 1 To __UI_TotalSelectedControls
                FindTops = FindTops + BinSize
                Control(SubList(i)).Top = FindTops
                FindTops = FindTops + Control(SubList(i)).Height
            Next

            __UI_AutoRefresh = True
            __UI_ForceRedraw = True
        Case 210 'Distribute horizontally
            'Build a sublist containing the selected controls in the order they
            'are currently placed horizontally:

            ReDim SubList(1 To __UI_TotalSelectedControls) As Long
            __UI_AutoRefresh = False
            For FindLefts = 0 To Control(__UI_FormID).Width - 1
                For i = 1 To UBound(Control)
                    If Control(i).ControlIsSelected And Control(i).Left = FindLefts Then
                        If NextControlToDistribute > 0 Then
                            If SubList(NextControlToDistribute) <> i Then
                                NextControlToDistribute = NextControlToDistribute + 1
                                SubList(NextControlToDistribute) = i
                                Exit For
                            End If
                        Else
                            NextControlToDistribute = NextControlToDistribute + 1
                            SubList(NextControlToDistribute) = i
                            Exit For
                        End If
                    End If
                Next
                If NextControlToDistribute = __UI_TotalSelectedControls Then Exit For
            Next

            TotalSpace = (Control(SubList(__UI_TotalSelectedControls)).Left + Control(SubList(__UI_TotalSelectedControls)).Width) - Control(SubList(1)).Left
            For i = 1 To __UI_TotalSelectedControls
                TotalSpace = TotalSpace - Control(SubList(i)).Width
            Next

            BinSize = TotalSpace \ (__UI_TotalSelectedControls - 1)
            FindLefts = Control(SubList(1)).Left - BinSize
            For i = 1 To __UI_TotalSelectedControls
                FindLefts = FindLefts + BinSize
                Control(SubList(i)).Left = FindLefts
                FindLefts = FindLefts + Control(SubList(i)).Width
            Next

            __UI_AutoRefresh = True
            __UI_ForceRedraw = True
    End Select
End Sub

Sub ConvertControlToAlternativeType
    Dim i As Long
    Dim NewType As Integer

    NewType = __UI_Type(Control(__UI_FirstSelectedID).Type).TurnsInto
    If NewType = 0 Then NewType = __UI_Type_TextBox

    For i = 1 To UBound(Control)
        If Control(i).ControlIsSelected Then

            Control(i).Type = NewType
            Control(i).Width = __UI_Type(NewType).DefaultWidth
            Control(i).Height = __UI_Type(NewType).DefaultHeight

            If NewType = __UI_Type_MenuBar Then
                Caption(i) = RTrim$(Control(i).Name)
                __UI_AdjustNewMenuBarTopHeight i
            ElseIf NewType = __UI_Type_ContextMenu Then
                If Control(i).HelperCanvas = 0 Then
                    Control(i).HelperCanvas = _CopyImage(ContextMenuIcon, 32)
                End If
            ElseIf NewType = __UI_Type_TextBox Then
                If Control(i).NumericOnly = False Then
                    Control(i).NumericOnly = __UI_NumericWithBounds
                    If Control(i).Min = 0 And Control(i).Max = 0 Then
                        Control(i).Min = -32768
                        Control(i).Max = 32767
                    End If
                Else
                    Control(i).NumericOnly = False
                    If Control(i).Min = -32768 And Control(i).Max = 32767 Then
                        Control(i).Min = 0
                        Control(i).Max = 0
                    End If
                End If
            End If
        End If
    Next

    If NewType = __UI_Type_MenuBar Or NewType = __UI_Type_ContextMenu Then
        __UI_RefreshMenuBar
        __UI_HasMenuBar = (__UI_FirstMenuBarControl > 0)
        RefreshContextMenus
        __UI_ActivateMenu Control(__UI_FirstSelectedID), False
    End If

    __UI_ForceRedraw = True
End Sub

Sub SelectAllControls
    Dim i As Long
    If __UI_TotalSelectedControls = 1 And Control(__UI_FirstSelectedID).Type = __UI_Type_Frame Then
        Dim ThisContainer As Long
        ThisContainer = Control(__UI_FirstSelectedID).ID
        Control(__UI_FirstSelectedID).ControlIsSelected = False
        __UI_TotalSelectedControls = 0
        For i = 1 To UBound(Control)
            If Control(i).Type <> __UI_Type_Frame And Control(i).Type <> __UI_Type_Form And Control(i).Type <> __UI_Type_Font And Control(i).Type <> __UI_Type_MenuBar And Control(i).Type <> __UI_Type_MenuItem And Control(i).Type <> __UI_Type_MenuPanel And Control(i).Type <> __UI_Type_ContextMenu And Control(i).Type <> __UI_Type_MenuItem Then
                If Control(i).ID > 0 And Control(i).ParentID = ThisContainer Then
                    Control(i).ControlIsSelected = True
                    __UI_TotalSelectedControls = __UI_TotalSelectedControls + 1
                    If __UI_TotalSelectedControls = 1 Then __UI_FirstSelectedID = Control(i).ID
                End If
            End If
        Next
    Else
        __UI_TotalSelectedControls = 0
        For i = 1 To UBound(Control)
            If Control(i).Type <> __UI_Type_Frame And Control(i).Type <> __UI_Type_Form And Control(i).Type <> __UI_Type_Font And Control(i).Type <> __UI_Type_MenuBar And Control(i).Type <> __UI_Type_MenuItem And Control(i).Type <> __UI_Type_MenuPanel And Control(i).Type <> __UI_Type_ContextMenu And Control(i).Type <> __UI_Type_MenuItem Then
                If Control(i).ID > 0 And Control(i).ParentID = 0 Then
                    Control(i).ControlIsSelected = True
                    __UI_TotalSelectedControls = __UI_TotalSelectedControls + 1
                    If __UI_TotalSelectedControls = 1 Then __UI_FirstSelectedID = Control(i).ID
                End If
            End If
        Next
    End If
End Sub

Sub SelectChildrenControls (id As Long)
    Dim i As Long
    For i = 1 To UBound(Control)
        If Control(i).ParentID = id Then
            If Control(i).ControlIsSelected = False Then
                Control(i).ControlIsSelected = True
                __UI_TotalSelectedControls = __UI_TotalSelectedControls + 1
                If Control(i).Type = __UI_Type_MenuItem Then
                    'Recursively select children's children too:
                    SelectChildrenControls Control(i).ID
                End If
            End If
        End If
    Next
End Sub

Sub DeleteSelectedControls
    Dim i As Long, j As Long, didDelete As _Byte

    'A container's contents will be deleted with it if it's
    'the only selected control.
    IF __UI_TotalSelectedControls = 1 AND _
       (Control(__UI_FirstSelectedID).Type = __UI_Type_Frame OR _
        Control(__UI_FirstSelectedID).Type = __UI_Type_MenuBar OR _
        Control(__UI_FirstSelectedID).Type = __UI_Type_MenuItem OR _
        Control(__UI_FirstSelectedID).Type = __UI_Type_ContextMenu) THEN
        SelectChildrenControls __UI_FirstSelectedID
    End If

    'Iterate over control list and delete selected controls.
    For i = UBound(Control) To 1 Step -1
        If Control(i).Type = __UI_Type_Form Then _Continue
        If Control(i).ControlIsSelected Then
            If Control(i).Type = __UI_Type_MenuBar Or Control(i).Type = __UI_Type_ContextMenu Then
                Dim MustRefreshMenuBar As _Byte, MustRefreshContextMenus As _Byte
                If Control(i).Type = __UI_Type_MenuBar Then
                    MustRefreshMenuBar = True
                Else
                    MustRefreshContextMenus = True
                End If
            End If
            If __UI_TotalActiveMenus > 0 And __UI_ParentMenu(__UI_TotalActiveMenus) = Control(i).ID Then
                __UI_CloseAllMenus
            End If
            CloseGif i
            __UI_DestroyControl Control(i)
            If MustRefreshMenuBar Then __UI_RefreshMenuBar
            If MustRefreshContextMenus Then RefreshContextMenus
            __UI_ForceRedraw = True
            didDelete = True
        End If
    Next
    If didDelete Then __UI_TotalSelectedControls = 0
End Sub

Sub RefreshContextMenus
    Dim i As Long
    Dim ctxMenuCount As Long

    For i = 1 To UBound(Control)
        If Control(i).Type = __UI_Type_ContextMenu And Left$(Control(i).Name, 5) <> "__UI_" Then
            ctxMenuCount = ctxMenuCount + 1
            Control(i).Left = __UI_SnapDistanceFromForm + ((ctxMenuCount - 1) * Control(i).Width)
            Control(i).Left = Control(i).Left + ((ctxMenuCount - 1) * __UI_SnapDistance)
            Control(i).Top = Control(__UI_FormID).Height - Control(i).Height - __UI_SnapDistanceFromForm
        End If
    Next
End Sub

Sub __UI_TextChanged (id As Long)
End Sub

Sub __UI_ValueChanged (id As Long)
End Sub

Function Pack$ (__DataIn$)
    'Adapted from:
    '==================
    ' BASFILE.BAS v0.10
    '==================
    'Coded by Dav for QB64 (c) 2009
    'http://www.qbasicnews.com/dav/qb64.php
    Dim DataIn$, OriginalLength As Long
    Dim a$, BC&, LL&, DataOut$
    Dim T%, B&, c$, g$
    Dim B$

    DataIn$ = __DataIn$
    OriginalLength = Len(DataIn$)
    Do
        a$ = ReadSequential(DataIn$, 3)
        BC& = BC& + 3: LL& = LL& + 4
        GoSub Encode
        DataOut$ = DataOut$ + a$
        If OriginalLength - BC& < 3 Then
            a$ = ReadSequential(DataIn$, OriginalLength - BC&)
            GoSub Encode
            B$ = a$
            Select Case Len(B$)
                Case 1: a$ = "%%%" + B$
                Case 2: a$ = "%%" + B$
                Case 3: a$ = "%" + B$
            End Select
            DataOut$ = DataOut$ + a$
            Exit Do
        End If
    Loop

    Pack$ = DataOut$
    Exit Function

    Encode:
    For T% = Len(a$) To 1 Step -1
        B& = B& * 256 + Asc(Mid$(a$, T%))
    Next

    c$ = ""
    For T% = 1 To Len(a$) + 1
        g$ = Chr$(48 + (B& And 63)): B& = B& \ 64
        'If < and > are here, replace them with # and *
        'Just so there's no HTML tag problems with forums.
        'They'll be restored during the decoding process..
        'IF g$ = "<" THEN g$ = "#"
        'IF g$ = ">" THEN g$ = "*"
        c$ = c$ + g$
    Next
    a$ = c$
    Return
End Function

Function Unpack$ (PackedData$)
    'Adapted from:
    '==================
    ' BASFILE.BAS v0.10
    '==================
    'Coded by Dav for QB64 (c) 2009
    'http://www.qbasicnews.com/dav/qb64.php
    Dim A$, i&, B$, C%, F$, C$, t%, B&, X$, btemp$, BASFILE$

    A$ = PackedData$

    For i& = 1 To Len(A$) Step 4: B$ = Mid$(A$, i&, 4)
        If InStr(1, B$, "%") Then
            For C% = 1 To Len(B$): F$ = Mid$(B$, C%, 1)
                If F$ <> "%" Then C$ = C$ + F$
            Next: B$ = C$
            End If: For t% = Len(B$) To 1 Step -1
            B& = B& * 64 + Asc(Mid$(B$, t%)) - 48
            Next: X$ = "": For t% = 1 To Len(B$) - 1
            X$ = X$ + Chr$(B& And 255): B& = B& \ 256
    Next: btemp$ = btemp$ + X$: Next

    Unpack$ = btemp$
End Function

Function ReadSequential$ (Txt$, Bytes%)
    ReadSequential$ = Left$(Txt$, Bytes%)
    Txt$ = Mid$(Txt$, Bytes% + 1)
End Function

Sub LoadPreview (Destination As _Byte)
    Dim a$, b$, i As Long, __UI_EOF As _Byte, Answer As _Byte
    Dim NewType As Integer, NewWidth As Integer, NewHeight As Integer
    Dim NewLeft As Integer, NewTop As Integer, NewName As String
    Dim NewParentID As String, FloatValue As _Float, TempValue As Long
    Dim Dummy As Long, Disk As _Byte, Clip$, FirstToBeSelected As Long
    Dim BinaryFileNum As Integer, LogFileNum As Integer
    Dim CorruptedData As _Byte, UndoBuffer As _Byte

    Const LogFileLoad = False

    If _FileExists("UiEditorPreview.frmbin") = 0 And Destination = InDisk Then
        Exit Sub
    End If

    If Destination = InDisk Then
        Disk = True
        BinaryFileNum = FreeFile
        Open "UiEditorPreview.frmbin" For Binary As #BinaryFileNum
    ElseIf Destination = ToUndoBuffer Then
        UndoBuffer = True
    End If

    LogFileNum = FreeFile
    If LogFileLoad Then Open "ui_log.txt" For Output As #LogFileNum

    If Disk Then
        b$ = Space$(7): Get #BinaryFileNum, 1, b$
        If b$ <> "InForm" + Chr$(1) Then
            GoTo LoadError
            Exit Sub
        End If
    ElseIf UndoBuffer Then
        If UndoPointer = TotalUndoImages Then Exit Sub
        Clip$ = UndoImage$(UndoPointer)
    ElseIf Destination = FromEditor Then
        Clip$ = RestoreCrashData$
        UndoBuffer = True
    Else
        Clip$ = _Clipboard$
        b$ = ReadSequential$(Clip$, Len(__UI_ClipboardCheck$))
        If b$ <> __UI_ClipboardCheck$ Then
            GoTo LoadError
            Exit Sub
        End If
    End If

    If LogFileLoad Then Print #LogFileNum, "FOUND INFORM+1"

    __UI_AutoRefresh = False

    If Disk Then
        For i = UBound(Control) To 1 Step -1
            If Left$(Control(i).Name, 5) <> "__UI_" Then
                CloseGif i
                __UI_DestroyControl Control(i)
            End If
        Next
        If LogFileLoad Then Print #LogFileNum, "DESTROYED CONTROLS"

        b$ = Space$(4): Get #BinaryFileNum, , b$
        If LogFileLoad Then Print #LogFileNum, "READ NEW ARRAYS:" + Str$(CVL(b$))

        ReDim _Preserve Caption(1 To CVL(b$)) As String
        ReDim __UI_TempCaptions(1 To CVL(b$)) As String
        ReDim Text(1 To CVL(b$)) As String
        ReDim __UI_TempTexts(1 To CVL(b$)) As String
        ReDim ToolTip(1 To CVL(b$)) As String
        ReDim __UI_TempTips(1 To CVL(b$)) As String
        ReDim _Preserve Control(0 To CVL(b$)) As __UI_ControlTYPE
    ElseIf UndoBuffer Then
        For i = UBound(Control) To 1 Step -1
            If Left$(Control(i).Name, 5) <> "__UI_" Then
                CloseGif i
                __UI_DestroyControl Control(i)
            End If
        Next
        If LogFileLoad Then Print #LogFileNum, "DESTROYED CONTROLS"

        b$ = ReadSequential$(Clip$, 4)
        If LogFileLoad Then Print #LogFileNum, "READ NEW ARRAYS:" + Str$(CVL(b$))

        ReDim _Preserve Caption(1 To CVL(b$)) As String
        ReDim __UI_TempCaptions(1 To CVL(b$)) As String
        ReDim Text(1 To CVL(b$)) As String
        ReDim __UI_TempTexts(1 To CVL(b$)) As String
        ReDim ToolTip(1 To CVL(b$)) As String
        ReDim __UI_TempTips(1 To CVL(b$)) As String
        ReDim _Preserve Control(0 To CVL(b$)) As __UI_ControlTYPE
    Else
        Dim ShiftPosition As _Byte
        For i = 1 To UBound(Control)
            If Control(i).ControlIsSelected Then ShiftPosition = True
            Control(i).ControlIsSelected = False
        Next

        __UI_TotalSelectedControls = 0

        'Clip$ = "InForm" + CHR$(10) + CHR$(10)
        'Clip$ = Clip$ + "BEGIN CONTROL DATA" + CHR$(10)
        'Clip$ = Clip$ + STRING$(60, "-") + CHR$(10)
        'Clip$ = Clip$ + HEX$(LEN(b$)) + CHR$(10)
        'Clip$ = Clip$ + b$ + CHR$(10)
        'Clip$ = Clip$ + STRING$(60, "-") + CHR$(10)
        'Clip$ = Clip$ + "END CONTROL DATA"

        Dim ClipLen$
        Do
            a$ = ReadSequential$(Clip$, 1)
            If a$ = Chr$(10) Then Exit Do
            If a$ = "" Then GoTo LoadError
            ClipLen$ = ClipLen$ + a$
        Loop

        b$ = ReadSequential$(Clip$, Val("&H" + ClipLen$))
        b$ = Replace$(b$, Chr$(10), "", False, 0)
        Clip$ = Unpack$(b$)
    End If

    If Not Disk Then b$ = ReadSequential$(Clip$, 2) Else b$ = Space$(2): Get #BinaryFileNum, , b$
    If LogFileLoad Then Print #LogFileNum, "READ NEW CONTROL:" + Str$(CVI(b$))
    If CVI(b$) <> -1 Then GoTo LoadError
    Do
        If Not Disk Then b$ = ReadSequential$(Clip$, 4) Else b$ = Space$(4): Get #BinaryFileNum, , b$
        Dummy = CVL(b$)
        If Not Disk Then b$ = ReadSequential$(Clip$, 2) Else b$ = Space$(2): Get #BinaryFileNum, , b$
        NewType = CVI(b$)
        If LogFileLoad Then Print #LogFileNum, "TYPE:" + Str$(CVI(b$))
        If Not Disk Then b$ = ReadSequential$(Clip$, 2) Else b$ = Space$(2): Get #BinaryFileNum, , b$
        If Not Disk Then b$ = ReadSequential$(Clip$, CVI(b$)) Else b$ = Space$(CVI(b$)): Get #BinaryFileNum, , b$
        NewName = b$
        If LogFileLoad Then Print #LogFileNum, "NAME:" + NewName
        If Not Disk Then b$ = ReadSequential$(Clip$, 2) Else b$ = Space$(2): Get #BinaryFileNum, , b$
        NewWidth = CVI(b$)
        If LogFileLoad Then Print #LogFileNum, "WIDTH:" + Str$(CVI(b$))
        If Not Disk Then b$ = ReadSequential$(Clip$, 2) Else b$ = Space$(2): Get #BinaryFileNum, , b$
        NewHeight = CVI(b$)
        If LogFileLoad Then Print #LogFileNum, "HEIGHT:" + Str$(CVI(b$))
        If Not Disk Then b$ = ReadSequential$(Clip$, 2) Else b$ = Space$(2): Get #BinaryFileNum, , b$
        NewLeft = CVI(b$)
        If LogFileLoad Then Print #LogFileNum, "LEFT:" + Str$(CVI(b$))
        If Not Disk Then b$ = ReadSequential$(Clip$, 2) Else b$ = Space$(2): Get #BinaryFileNum, , b$
        NewTop = CVI(b$)
        If Not Disk Then
            If ShiftPosition Then
                NewLeft = NewLeft + 20
                NewTop = NewTop + 20
            End If
        End If
        If LogFileLoad Then Print #LogFileNum, "TOP:" + Str$(CVI(b$))
        If Not Disk Then b$ = ReadSequential$(Clip$, 2) Else b$ = Space$(2): Get #BinaryFileNum, , b$
        If CVI(b$) > 0 Then
            If Not Disk Then NewParentID = ReadSequential$(Clip$, CVI(b$)) Else NewParentID = Space$(CVI(b$)): Get #BinaryFileNum, , NewParentID
            If LogFileLoad Then Print #LogFileNum, "PARENT:" + NewParentID
        Else
            NewParentID = ""
            If LogFileLoad Then Print #LogFileNum, "PARENT: ORPHAN/CONTAINER"
        End If

        If Not Disk Then
            'Change control's name in case this form already has one with the same name
            Dim TempName$, c$, OriginalIndex$, NameChanges$
            Dim OriginalName$, DidRename As _Byte

            OriginalName$ = RTrim$(NewName)
            DidRename = False
            Do While __UI_GetID(NewName) > 0
                DidRename = True
                If InStr(NameChanges$, OriginalName$ + "=") = 0 Then
                    NameChanges$ = NameChanges$ + OriginalName$ + "="
                End If
                TempName$ = RTrim$(NewName)
                c$ = Right$(TempName$, 1)
                If Asc(c$) >= 48 And Asc(c$) <= 57 Then
                    'Update this control's name by the ID # assigned to it, if any
                    OriginalIndex$ = c$
                    TempName$ = Left$(TempName$, Len(TempName$) - 1)
                    Do
                        c$ = Right$(TempName$, 1)
                        If Asc(c$) >= 48 And Asc(c$) <= 57 Then
                            OriginalIndex$ = c$ + OriginalIndex$
                            TempName$ = Left$(TempName$, Len(TempName$) - 1)
                            If Len(TempName$) = 0 Then Exit Do
                        Else
                            Exit Do
                        End If
                    Loop
                Else
                    OriginalIndex$ = "1"
                End If
                NewName = TempName$ + LTrim$(Str$(Val(OriginalIndex$) + 1))
            Loop
            If DidRename Then
                NameChanges$ = NameChanges$ + NewName + ";"
            End If
        End If

        If Len(NewParentID) > 0 And InStr(NameChanges$, NewParentID + "=") Then
            'This control's container had a name change when it was
            'pasted, so we'll reassign it to its new cloned parent:
            Dim NewID As Long, EndNewID As Long
            NewID = InStr(NameChanges$, NewParentID + "=") + Len(NewParentID + "=")
            EndNewID = InStr(NewID, NameChanges$, ";")
            NewParentID = Mid$(NameChanges$, NewID, EndNewID - NewID)
        End If

        TempValue = __UI_NewControl(NewType, NewName, NewWidth, NewHeight, NewLeft, NewTop, __UI_GetID(NewParentID))

        If Not Disk And Not UndoBuffer Then
            Control(TempValue).ControlIsSelected = True
            __UI_TotalSelectedControls = __UI_TotalSelectedControls + 1
            If __UI_TotalSelectedControls = 1 Then FirstToBeSelected = TempValue
        End If
        If NewType = __UI_Type_PictureBox Then
            Control(TempValue).HasBorder = False
            Control(TempValue).Stretch = False
        ElseIf NewType = __UI_Type_ContextMenu Then
            Control(TempValue).HelperCanvas = _CopyImage(ContextMenuIcon, 32)
            Control(TempValue).Width = 22
            Control(TempValue).Height = 22
            RefreshContextMenus
        End If

        Do 'read properties
            If Not Disk Then b$ = ReadSequential$(Clip$, 2) Else b$ = Space$(2): Get #BinaryFileNum, , b$
            If LogFileLoad Then Print #LogFileNum, "PROPERTY:" + Str$(CVI(b$)) + " :";
            Select Case CVI(b$)
                Case -2 'Caption
                    If Not Disk Then b$ = ReadSequential$(Clip$, 4) Else b$ = Space$(4): Get #BinaryFileNum, , b$
                    If Not Disk Then b$ = ReadSequential$(Clip$, CVL(b$)) Else b$ = Space$(CVL(b$)): Get #BinaryFileNum, , b$
                    SetCaption TempValue, b$
                    If LogFileLoad Then Print #LogFileNum, "CAPTION:" + Caption(TempValue)
                Case -3 'Text
                    If Not Disk Then b$ = ReadSequential$(Clip$, 4) Else b$ = Space$(4): Get #BinaryFileNum, , b$
                    If Not Disk Then b$ = ReadSequential$(Clip$, CVL(b$)) Else b$ = Space$(CVL(b$)): Get #BinaryFileNum, , b$
                    Text(TempValue) = b$
                    If Control(TempValue).Type = __UI_Type_PictureBox Then
                        PreviewLoadImage Control(TempValue), Text(TempValue)
                    ElseIf Control(TempValue).Type = __UI_Type_Button Or Control(TempValue).Type = __UI_Type_MenuItem Then
                        LoadImage Control(TempValue), Text(TempValue)
                    ElseIf Control(TempValue).Type = __UI_Type_Form Then
                        If ExeIcon <> 0 Then _FreeImage ExeIcon: ExeIcon = 0
                        ExeIcon = IconPreview&(Text(TempValue))
                        If ExeIcon < -1 Then
                            _Icon ExeIcon
                        End If
                    End If
                    If LogFileLoad Then Print #LogFileNum, "TEXT:" + Text(TempValue)
                Case -4 'Stretch
                    Control(TempValue).Stretch = True
                    If LogFileLoad Then Print #LogFileNum, "STRETCH"
                Case -5 'Font
                    If LogFileLoad Then Print #LogFileNum, "FONT:";
                    Dim FontSetup$, FindSep As Integer
                    Dim NewFontName As String, NewFontFile As String
                    Dim NewFontSize As Integer
                    If Not Disk Then b$ = ReadSequential$(Clip$, 2) Else b$ = Space$(2): Get #BinaryFileNum, , b$
                    If Not Disk Then FontSetup$ = ReadSequential$(Clip$, CVI(b$)) Else FontSetup$ = Space$(CVI(b$)): Get #BinaryFileNum, , FontSetup$
                    If LogFileLoad Then Print #LogFileNum, FontSetup$

                    FindSep = InStr(FontSetup$, ",")
                    NewFontFile = Left$(FontSetup$, FindSep - 1)
                    FontSetup$ = Mid$(FontSetup$, FindSep + 1)

                    NewFontSize = Val(FontSetup$)

                    Control(TempValue).Font = SetFont(NewFontFile, NewFontSize)

                    If Not Disk Then b$ = ReadSequential$(Clip$, 2) Else b$ = Space$(2): Get #BinaryFileNum, , b$
                    If Not Disk Then FontSetup$ = ReadSequential$(Clip$, CVI(b$)) Else FontSetup$ = Space$(CVI(b$)): Get #BinaryFileNum, , FontSetup$
                Case -6 'ForeColor
                    If Not Disk Then b$ = ReadSequential$(Clip$, 4) Else b$ = Space$(4): Get #BinaryFileNum, , b$
                    Control(TempValue).ForeColor = _CV(_Unsigned Long, b$)
                    If LogFileLoad Then Print #LogFileNum, "FORECOLOR"
                Case -7 'BackColor
                    If Not Disk Then b$ = ReadSequential$(Clip$, 4) Else b$ = Space$(4): Get #BinaryFileNum, , b$
                    Control(TempValue).BackColor = _CV(_Unsigned Long, b$)
                    If LogFileLoad Then Print #LogFileNum, "BACKCOLOR"
                Case -8 'SelectedForeColor
                    If Not Disk Then b$ = ReadSequential$(Clip$, 4) Else b$ = Space$(4): Get #BinaryFileNum, , b$
                    Control(TempValue).SelectedForeColor = _CV(_Unsigned Long, b$)
                    If LogFileLoad Then Print #LogFileNum, "SELECTEDFORECOLOR"
                Case -9 'SelectedBackColor
                    If Not Disk Then b$ = ReadSequential$(Clip$, 4) Else b$ = Space$(4): Get #BinaryFileNum, , b$
                    Control(TempValue).SelectedBackColor = _CV(_Unsigned Long, b$)
                    If LogFileLoad Then Print #LogFileNum, "SELECTEDBACKCOLOR"
                Case -10 'BorderColor
                    If Not Disk Then b$ = ReadSequential$(Clip$, 4) Else b$ = Space$(4): Get #BinaryFileNum, , b$
                    Control(TempValue).BorderColor = _CV(_Unsigned Long, b$)
                    If LogFileLoad Then Print #LogFileNum, "BORDERCOLOR"
                Case -11
                    Control(TempValue).BackStyle = __UI_Transparent
                    If LogFileLoad Then Print #LogFileNum, "BACKSTYLE:TRANSPARENT"
                Case -12
                    Control(TempValue).HasBorder = True
                    If Control(TempValue).BorderSize = 0 Then
                        Control(TempValue).BorderSize = 1
                    End If
                    If LogFileLoad Then Print #LogFileNum, "HASBORDER"
                Case -13
                    If Not Disk Then b$ = ReadSequential$(Clip$, 1) Else b$ = Space$(1): Get #BinaryFileNum, , b$
                    Control(TempValue).Align = _CV(_Byte, b$)
                    If LogFileLoad Then Print #LogFileNum, "ALIGN="; Control(TempValue).Align
                Case -14
                    If Not Disk Then b$ = ReadSequential$(Clip$, Len(FloatValue)) Else b$ = Space$(Len(FloatValue)): Get #BinaryFileNum, , b$
                    Control(TempValue).Value = _CV(_Float, b$)
                    If LogFileLoad Then Print #LogFileNum, "VALUE="; Control(TempValue).Value
                Case -15
                    If Not Disk Then b$ = ReadSequential$(Clip$, Len(FloatValue)) Else b$ = Space$(Len(FloatValue)): Get #BinaryFileNum, , b$
                    Control(TempValue).Min = _CV(_Float, b$)
                    If LogFileLoad Then Print #LogFileNum, "MIN="; Control(TempValue).Min
                Case -16
                    If Not Disk Then b$ = ReadSequential$(Clip$, Len(FloatValue)) Else b$ = Space$(Len(FloatValue)): Get #BinaryFileNum, , b$
                    Control(TempValue).Max = _CV(_Float, b$)
                    If LogFileLoad Then Print #LogFileNum, "MAX="; Control(TempValue).Max
                Case -19
                    Control(TempValue).ShowPercentage = True
                    If LogFileLoad Then Print #LogFileNum, "SHOWPERCENTAGE"
                Case -20
                    Control(TempValue).CanHaveFocus = True
                    If LogFileLoad Then Print #LogFileNum, "CANHAVEFOCUS"
                Case -21
                    Control(TempValue).Disabled = True
                    If LogFileLoad Then Print #LogFileNum, "DISABLED"
                Case -22
                    Control(TempValue).Hidden = True
                    If LogFileLoad Then Print #LogFileNum, "HIDDEN"
                Case -23
                    Control(TempValue).CenteredWindow = True
                    If LogFileLoad Then Print #LogFileNum, "CENTEREDWINDOW"
                Case -24 'Tips
                    If Not Disk Then b$ = ReadSequential$(Clip$, 4) Else b$ = Space$(4): Get #BinaryFileNum, , b$
                    If Not Disk Then b$ = ReadSequential$(Clip$, CVL(b$)) Else b$ = Space$(CVL(b$)): Get #BinaryFileNum, , b$
                    ToolTip(TempValue) = b$
                    If LogFileLoad Then Print #LogFileNum, "TIP: "; ToolTip(TempValue)
                Case -25
                    Dim ContextMenuName As String
                    If Not Disk Then b$ = ReadSequential$(Clip$, 2) Else b$ = Space$(2): Get #BinaryFileNum, , b$
                    If Not Disk Then ContextMenuName = ReadSequential$(Clip$, CVI(b$)) Else ContextMenuName = Space$(CVI(b$)): Get #BinaryFileNum, , ContextMenuName
                    Control(TempValue).ContextMenuID = __UI_GetID(ContextMenuName)
                    If LogFileLoad Then Print #LogFileNum, "CONTEXTMENU:"; ContextMenuName
                Case -26
                    If Not Disk Then b$ = ReadSequential$(Clip$, Len(FloatValue)) Else b$ = Space$(Len(FloatValue)): Get #BinaryFileNum, , b$
                    Control(TempValue).Interval = _CV(_Float, b$)
                    If LogFileLoad Then Print #LogFileNum, "INTERVAL="; Control(TempValue).Interval
                Case -27
                    Control(TempValue).WordWrap = True
                    If LogFileLoad Then Print #LogFileNum, "WORDWRAP"
                Case -28
                    If Not Disk Then b$ = ReadSequential$(Clip$, 4) Else b$ = Space$(4): Get #BinaryFileNum, , b$
                    Control(TempValue).TransparentColor = _CV(_Unsigned Long, b$)
                    If LogFileLoad Then Print #LogFileNum, "TRANSPARENTCOLOR"
                    __UI_ClearColor Control(TempValue).HelperCanvas, Control(TempValue).TransparentColor, -1
                Case -29
                    Control(TempValue).CanResize = True
                    If LogFileLoad Then Print #LogFileNum, "CANRESIZE"
                Case -31
                    If Not Disk Then b$ = ReadSequential$(Clip$, 2) Else b$ = Space$(2): Get #BinaryFileNum, , b$
                    Control(TempValue).Padding = CVI(b$)
                    If LogFileLoad Then Print #LogFileNum, "PADDING" + Str$(CVI(b$))
                Case -32
                    If Not Disk Then b$ = ReadSequential$(Clip$, 1) Else b$ = Space$(1): Get #BinaryFileNum, , b$
                    Control(TempValue).VAlign = _CV(_Byte, b$)
                    If LogFileLoad Then Print #LogFileNum, "VALIGN="; Control(TempValue).VAlign
                Case -33
                    Control(TempValue).PasswordField = True
                    If LogFileLoad Then Print #LogFileNum, "PASSWORDFIELD"
                Case -34
                    If Not Disk Then b$ = ReadSequential$(Clip$, 4) Else b$ = Space$(4): Get #BinaryFileNum, , b$
                    Control(TempValue).Encoding = CVL(b$)
                    If LogFileLoad Then Print #LogFileNum, "ENCODING="; Control(TempValue).Encoding
                Case -35
                    __UI_DefaultButtonID = TempValue
                    If LogFileLoad Then Print #LogFileNum, "DEFAULT BUTTON"
                Case -36
                    If Not Disk Then b$ = ReadSequential$(Clip$, 4) Else b$ = Space$(4): Get #BinaryFileNum, , b$
                    If Not Disk Then b$ = ReadSequential$(Clip$, CVL(b$)) Else b$ = Space$(CVL(b$)): Get #BinaryFileNum, , b$
                    Mask(TempValue) = b$
                    If LogFileLoad Then Print #LogFileNum, "MASK:" + Mask(TempValue)
                Case -37
                    If Not Disk Then b$ = ReadSequential$(Clip$, Len(FloatValue)) Else b$ = Space$(Len(FloatValue)): Get #BinaryFileNum, , b$
                    Control(TempValue).MinInterval = _CV(_Float, b$)
                    If LogFileLoad Then Print #LogFileNum, "MININTERVAL="; Control(TempValue).MinInterval
                Case -38
                    Control(TempValue).NumericOnly = True
                Case -39
                    Control(TempValue).NumericOnly = __UI_NumericWithBounds
                Case -40
                    Control(TempValue).BulletStyle = __UI_Bullet
                Case -41
                    Control(TempValue).AutoScroll = True
                Case -42
                    Control(TempValue).AutoSize = True
                Case -43
                    If Not Disk Then b$ = ReadSequential$(Clip$, 2) Else b$ = Space$(2): Get #BinaryFileNum, , b$
                    Control(TempValue).BorderSize = CVI(b$)
                    If LogFileLoad Then Print #LogFileNum, "BORDER SIZE" + Str$(CVI(b$))
                Case -44
                    Dim RegisterResult As _Byte, Combo As String
                    If Not Disk Then b$ = ReadSequential$(Clip$, 2) Else b$ = Space$(2): Get #BinaryFileNum, , b$
                    If Not Disk Then Combo = ReadSequential$(Clip$, CVI(b$)) Else Combo = Space$(CVI(b$)): Get #BinaryFileNum, , ContextMenuName
                    RegisterResult = RegisterKeyCombo(Combo, TempValue)
                    If LogFileLoad Then Print #LogFileNum, "KEY COMBO:"; Combo
                Case -46
                    If TempValue <= UBound(AutoPlayGif) Then
                        AutoPlayGif(i) = True
                    End If
                Case -47
                    Control(TempValue).ControlIsSelected = True
                Case -1 'new control
                    If LogFileLoad Then Print #LogFileNum, "READ NEW CONTROL: -1"
                    Exit Do
                Case -1024
                    If LogFileLoad Then Print #LogFileNum, "READ END OF FILE: -1024"
                    __UI_EOF = True
                    Exit Do
                Case Else
                    If LogFileLoad Then Print #LogFileNum, "UNKNOWN PROPERTY ="; CVI(b$)
                    __UI_EOF = True 'Stop reading if corrupted data is found
                    CorruptedData = True
                    Exit Do
            End Select
        Loop
    Loop Until __UI_EOF
    If Disk Then Close #BinaryFileNum
    If LogFileLoad Then Close #LogFileNum
    If Not Disk And Not UndoBuffer Then
        If Not CorruptedData Then
            __UI_FirstSelectedID = FirstToBeSelected
        Else
            CloseGif TempValue
            __UI_DestroyControl Control(TempValue)
            __UI_TotalSelectedControls = __UI_TotalSelectedControls - 1
        End If
        __UI_ForceRedraw = True
    End If
    __UI_AutoRefresh = True
    Exit Sub

    LoadError:
    If Disk Then
        Close #BinaryFileNum
        Kill "UiEditorPreview.frmbin"
    End If
    If LogFileLoad Then Close #LogFileNum
    __UI_AutoRefresh = True
End Sub

Sub LoadPreviewText
    Dim b$, i As Long, __UI_EOF As _Byte, Answer As _Byte
    Dim NewType As Integer, NewWidth As Integer, NewHeight As Integer
    Dim NewLeft As Integer, NewTop As Integer, NewName As String
    Dim NewParentID As String, FloatValue As _Float, TempValue As Long
    Dim Dummy As Long, DummyText$, TotalNewControls As Long
    Dim BinaryFileNum As Integer, LogFileNum As Integer
    Dim NewRed As _Unsigned _Byte, NewGreen As _Unsigned _Byte, NewBlue As _Unsigned _Byte

    Const LogFileLoad = False

    If _FileExists("UiEditorPreview.frmbin") = 0 Then
        Exit Sub
    Else
        BinaryFileNum = FreeFile
        Open "UiEditorPreview.frmbin" For Binary As #BinaryFileNum

        LogFileNum = FreeFile
        If LogFileLoad Then Open "ui_log.txt" For Output As #LogFileNum
        Do
            If EOF(BinaryFileNum) Then GoTo LoadError
            Line Input #BinaryFileNum, b$
        Loop Until b$ = "SUB __UI_LoadForm"
        If LogFileLoad Then Print #LogFileNum, "FOUND SUB __UI_LOADFORM"

        __UI_AutoRefresh = False
        For i = UBound(Control) To 1 Step -1
            If Left$(Control(i).Name, 5) <> "__UI_" Then
                CloseGif i
                __UI_DestroyControl Control(i)
            End If
        Next
        If LogFileLoad Then Print #LogFileNum, "DESTROYED CONTROLS"

        Do
            Line Input #BinaryFileNum, b$
        Loop Until InStr(b$, "__UI_NewControl") > 0
        If LogFileLoad Then Print #LogFileNum, "READ NEW CONTROL"
        Do
            DummyText$ = nextParameter(b$)
            Select Case DummyText$
                Case "__UI_Type_Form": NewType = 1
                Case "__UI_Type_Frame": NewType = 2
                Case "__UI_Type_Button": NewType = 3
                Case "__UI_Type_Label": NewType = 4
                Case "__UI_Type_CheckBox": NewType = 5
                Case "__UI_Type_RadioButton": NewType = 6
                Case "__UI_Type_TextBox": NewType = 7
                Case "__UI_Type_ProgressBar": NewType = 8
                Case "__UI_Type_ListBox": NewType = 9
                Case "__UI_Type_DropdownList": NewType = 10
                Case "__UI_Type_MenuBar": NewType = 11
                Case "__UI_Type_MenuItem": NewType = 12
                Case "__UI_Type_MenuPanel": NewType = 13
                Case "__UI_Type_PictureBox": NewType = 14
                Case "__UI_Type_TrackBar": NewType = 15
                Case "__UI_Type_ContextMenu": NewType = 16
                Case "__UI_Type_Font": NewType = 17
                Case "__UI_Type_ToggleSwitch": NewType = 18
            End Select
            If LogFileLoad Then Print #LogFileNum, "TYPE:" + DummyText$

            NewName = nextParameter(b$)
            If LogFileLoad Then Print #LogFileNum, "NAME:" + NewName

            NewWidth = Val(nextParameter(b$))
            If LogFileLoad Then Print #LogFileNum, "WIDTH:" + Str$(NewWidth)

            NewHeight = Val(nextParameter(b$))
            If LogFileLoad Then Print #LogFileNum, "HEIGHT:" + Str$(NewHeight)

            NewLeft = Val(nextParameter(b$))
            If LogFileLoad Then Print #LogFileNum, "LEFT:" + Str$(NewLeft)

            NewTop = Val(nextParameter(b$))
            If LogFileLoad Then Print #LogFileNum, "TOP:" + Str$(NewTop)

            DummyText$ = nextParameter(b$)
            If DummyText$ = "0" Then
                NewParentID = ""
                If LogFileLoad Then Print #LogFileNum, "PARENT: ORPHAN/CONTAINER"
            Else
                NewParentID = DummyText$
                If LogFileLoad Then Print #LogFileNum, "PARENT:" + NewParentID
            End If

            TempValue = __UI_NewControl(NewType, NewName, NewWidth, NewHeight, NewLeft, NewTop, __UI_GetID(NewParentID))

            If UBound(AutoPlayGif) <> UBound(Control) Then
                ReDim _Preserve AutoPlayGif(UBound(Control)) As _Byte
            End If

            If NewType = __UI_Type_PictureBox Then
                Control(TempValue).HasBorder = False
                Control(TempValue).Stretch = False
            ElseIf NewType = __UI_Type_ContextMenu Then
                Control(TempValue).HelperCanvas = _CopyImage(ContextMenuIcon, 32)
                Control(TempValue).Width = 22
                Control(TempValue).Height = 22
                RefreshContextMenus
            End If
            If NewType = __UI_Type_Label Then Control(TempValue).VAlign = __UI_Top

            Do 'read properties
                Do
                    Line Input #BinaryFileNum, b$
                    b$ = LTrim$(RTrim$(b$))
                    If Len(b$) > 0 Then Exit Do
                Loop
                If Left$(b$, 20) = "Control(__UI_NewID)." Then
                    'Property
                    DummyText$ = Mid$(b$, InStr(21, b$, " = ") + 3)
                    If LogFileLoad Then Print #LogFileNum, "PROPERTY: "; Mid$(b$, 21, InStr(21, b$, " =") - 21)
                    Select Case Mid$(b$, 21, InStr(21, b$, " =") - 21)
                        Case "Stretch"
                            Control(TempValue).Stretch = (DummyText$ = "True")
                        Case "Font"
                            Dim NewFontFile As String
                            Dim NewFontSize As Integer

                            If Left$(DummyText$, 8) = "SetFont(" Then
                                NewFontFile = nextParameter(DummyText$)
                                NewFontSize = Val(nextParameter(DummyText$))
                                Control(TempValue).Font = SetFont(NewFontFile, NewFontSize)
                            End If
                        Case "ForeColor"
                            If Left$(DummyText$, 6) = "_RGB32" Then
                                NewRed = Val(nextParameter(DummyText$))
                                NewGreen = Val(nextParameter(DummyText$))
                                NewBlue = Val(nextParameter(DummyText$))
                                Control(TempValue).ForeColor = _RGB32(NewRed, NewGreen, NewBlue)
                            ElseIf Left$(DummyText$, 2) = "&H" Then
                                Control(TempValue).ForeColor = Val(DummyText$)
                            End If
                        Case "BackColor"
                            If Left$(DummyText$, 6) = "_RGB32" Then
                                NewRed = Val(nextParameter(DummyText$))
                                NewGreen = Val(nextParameter(DummyText$))
                                NewBlue = Val(nextParameter(DummyText$))
                                Control(TempValue).BackColor = _RGB32(NewRed, NewGreen, NewBlue)
                            ElseIf Left$(DummyText$, 2) = "&H" Then
                                Control(TempValue).BackColor = Val(DummyText$)
                            End If
                        Case "SelectedForeColor"
                            If Left$(DummyText$, 6) = "_RGB32" Then
                                NewRed = Val(nextParameter(DummyText$))
                                NewGreen = Val(nextParameter(DummyText$))
                                NewBlue = Val(nextParameter(DummyText$))
                                Control(TempValue).SelectedForeColor = _RGB32(NewRed, NewGreen, NewBlue)
                            ElseIf Left$(DummyText$, 2) = "&H" Then
                                Control(TempValue).SelectedForeColor = Val(DummyText$)
                            End If
                        Case "SelectedBackColor"
                            If Left$(DummyText$, 6) = "_RGB32" Then
                                NewRed = Val(nextParameter(DummyText$))
                                NewGreen = Val(nextParameter(DummyText$))
                                NewBlue = Val(nextParameter(DummyText$))
                                Control(TempValue).SelectedBackColor = _RGB32(NewRed, NewGreen, NewBlue)
                            ElseIf Left$(DummyText$, 2) = "&H" Then
                                Control(TempValue).SelectedBackColor = Val(DummyText$)
                            End If
                        Case "BorderColor"
                            If Left$(DummyText$, 6) = "_RGB32" Then
                                NewRed = Val(nextParameter(DummyText$))
                                NewGreen = Val(nextParameter(DummyText$))
                                NewBlue = Val(nextParameter(DummyText$))
                                Control(TempValue).BorderColor = _RGB32(NewRed, NewGreen, NewBlue)
                            ElseIf Left$(DummyText$, 2) = "&H" Then
                                Control(TempValue).BorderColor = Val(DummyText$)
                            End If
                        Case "BackStyle"
                            If DummyText$ = "__UI_Transparent" Then
                                Control(TempValue).BackStyle = __UI_Transparent
                            End If
                        Case "HasBorder"
                            If DummyText$ = "True" Then
                                Control(TempValue).HasBorder = True
                                If Control(TempValue).BorderSize = 0 Then
                                    Control(TempValue).BorderSize = 1
                                End If
                            End If
                        Case "Align"
                            Select Case DummyText$
                                Case "__UI_Center": Control(TempValue).Align = __UI_Center
                                Case "__UI_Right": Control(TempValue).Align = __UI_Right
                            End Select
                        Case "Value"
                            Control(TempValue).Value = Val(DummyText$)
                        Case "Min"
                            Control(TempValue).Min = Val(DummyText$)
                        Case "Max"
                            Control(TempValue).Max = Val(DummyText$)
                        Case "ShowPercentage"
                            Control(TempValue).ShowPercentage = (DummyText$ = "True")
                        Case "CanHaveFocus"
                            Control(TempValue).CanHaveFocus = (DummyText$ = "True")
                        Case "Disabled"
                            Control(TempValue).Disabled = (DummyText$ = "True")
                        Case "Hidden"
                            Control(TempValue).Hidden = (DummyText$ = "True")
                        Case "CenteredWindow"
                            Control(TempValue).CenteredWindow = (DummyText$ = "True")
                        Case "ContextMenuID"
                            Control(TempValue).ContextMenuID = __UI_GetID(nextParameter(DummyText$))
                        Case "Interval"
                            Control(TempValue).Interval = Val(DummyText$)
                        Case "MinInterval"
                            Control(TempValue).MinInterval = Val(DummyText$)
                        Case "WordWrap"
                            Control(TempValue).WordWrap = (DummyText$ = "True")
                        Case "TransparentColor"
                            If Left$(DummyText$, 6) = "_RGB32" Then
                                NewRed = Val(nextParameter(DummyText$))
                                NewGreen = Val(nextParameter(DummyText$))
                                NewBlue = Val(nextParameter(DummyText$))
                                Control(TempValue).TransparentColor = _RGB32(NewRed, NewGreen, NewBlue)
                                __UI_ClearColor Control(TempValue).HelperCanvas, Control(TempValue).TransparentColor, -1
                            ElseIf Left$(DummyText$, 2) = "&H" Then
                                Control(TempValue).TransparentColor = Val(DummyText$)
                                __UI_ClearColor Control(TempValue).HelperCanvas, Control(TempValue).TransparentColor, -1
                            End If
                        Case "CanResize"
                            Control(TempValue).CanResize = (DummyText$ = "True")
                        Case "Padding"
                            Control(TempValue).Padding = Val(DummyText$)
                        Case "BorderSize"
                            Control(TempValue).BorderSize = Val(DummyText$)
                        Case "VAlign"
                            Select Case DummyText$
                                Case "__UI_Middle": Control(TempValue).VAlign = __UI_Middle
                                Case "__UI_Bottom": Control(TempValue).VAlign = __UI_Bottom
                            End Select
                        Case "PasswordField"
                            Control(TempValue).PasswordField = (DummyText$ = "True")
                        Case "Encoding"
                            Control(TempValue).Encoding = Val(DummyText$)
                        Case "NumericOnly"
                            If DummyText$ = "True" Then
                                Control(TempValue).NumericOnly = True
                            ElseIf DummyText$ = "__UI_NumericWithBounds" Then
                                Control(TempValue).NumericOnly = __UI_NumericWithBounds
                            End If
                        Case "BulletStyle"
                            If DummyText$ = "__UI_CheckMark" Then
                                Control(TempValue).BulletStyle = __UI_CheckMark
                            ElseIf DummyText$ = "__UI_Bullet" Then
                                Control(TempValue).BulletStyle = __UI_Bullet
                            End If
                        Case "AutoScroll"
                            Control(TempValue).AutoScroll = (DummyText$ = "True")
                        Case "AutoSize"
                            Control(TempValue).AutoSize = (DummyText$ = "True")
                    End Select
                ElseIf b$ = "__UI_DefaultButtonID = __UI_NewID" Then
                    If LogFileLoad Then Print #LogFileNum, "DEFAULT BUTTON"
                    __UI_DefaultButtonID = TempValue
                ElseIf Left$(b$, 11) = "SetCaption " Then
                    If LogFileLoad Then Print #LogFileNum, "SETCAPTION"
                    'Caption
                    DummyText$ = nextParameter(b$) 'discard first parameter
                    DummyText$ = nextParameter(b$)
                    SetCaption TempValue, DummyText$
                ElseIf Left$(b$, 8) = "AddItem " Then
                    If LogFileLoad Then Print #LogFileNum, "ADD ITEM"
                    'Caption
                    DummyText$ = nextParameter(b$) 'discard first parameter
                    DummyText$ = nextParameter(b$)
                    AddItem TempValue, DummyText$
                ElseIf Left$(b$, 10) = "LoadImage " Then
                    If LogFileLoad Then Print #LogFileNum, "LOADIMAGE"
                    'Image
                    DummyText$ = nextParameter(b$) 'discard first parameter
                    DummyText$ = nextParameter(b$)
                    LoadImage Control(TempValue), DummyText$
                ElseIf Left$(b$, 30) = "__UI_RegisterResult = OpenGif(" Then
                    If LogFileLoad Then Print #LogFileNum, "OPENGIF"
                    'Gif extension
                    Dim RegisterResult As _Byte
                    DummyText$ = nextParameter(b$) 'discard first parameter
                    DummyText$ = nextParameter(b$)
                    RegisterResult = OpenGif(TempValue, DummyText$)
                    If RegisterResult Then
                        If LogFileLoad Then Print #LogFileNum, "LOAD SUCCESSFUL"
                        Text(TempValue) = DummyText$ 'indicates image loaded successfully
                        If Control(TempValue).HelperCanvas < -1 Then
                            _FreeImage Control(TempValue).HelperCanvas
                        End If
                        Control(TempValue).HelperCanvas = _NewImage(GifWidth(TempValue), GifHeight(TempValue), 32)
                        UpdateGif TempValue
                    End If
                ElseIf b$ = "IF __UI_RegisterResult THEN PlayGif __UI_NewID" Or Left$(b$, 8) = "PlayGif " Then
                    If LogFileLoad Then Print #LogFileNum, "AUTOPLAY GIF"
                    'Auto-play gif
                    AutoPlayGif(TempValue) = True
                    PlayGif TempValue
                ElseIf Left$(b$, 22) = "ToolTip(__UI_NewID) = " Then
                    If LogFileLoad Then Print #LogFileNum, "TOOLTIP"
                    'Tooltip
                    DummyText$ = Mid$(b$, InStr(b$, " = ") + 3)
                    DummyText$ = RestoreCHR$(DummyText$)
                    ToolTip(TempValue) = removeQuotation$(DummyText$)
                ElseIf Left$(b$, 19) = "Text(__UI_NewID) = " Then
                    If LogFileLoad Then Print #LogFileNum, "TEXT"
                    'Text
                    DummyText$ = Mid$(b$, InStr(b$, " = ") + 3)
                    DummyText$ = RestoreCHR$(DummyText$)
                    Text(TempValue) = removeQuotation$(DummyText$)

                    If Control(TempValue).Type = __UI_Type_Form Then
                        If ExeIcon <> 0 Then _FreeImage ExeIcon: ExeIcon = 0
                        ExeIcon = IconPreview&(Text(TempValue))
                        If ExeIcon < -1 Then
                            _Icon ExeIcon
                        End If
                    End If
                ElseIf Left$(b$, 19) = "Mask(__UI_NewID) = " Then
                    If LogFileLoad Then Print #LogFileNum, "MASK"
                    'Mask
                    DummyText$ = Mid$(b$, InStr(b$, " = ") + 3)
                    DummyText$ = RestoreCHR$(DummyText$)
                    Mask(TempValue) = removeQuotation$(DummyText$)
                ElseIf Left$(b$, 38) = "__UI_RegisterResult = RegisterKeyCombo" Then
                    If LogFileLoad Then Print #LogFileNum, "KEYCOMBO"
                    DummyText$ = nextParameter(b$)
                    RegisterResult = RegisterKeyCombo(DummyText$, TempValue)
                ElseIf InStr(b$, "__UI_NewControl") > 0 Then
                    'New Control
                    If LogFileLoad Then Print #LogFileNum, "READ NEW CONTROL"
                    Exit Do
                ElseIf Left$(b$, 10) = "__UI_Bind " Then
                    Asc(b$, 10) = 40 'Changes first space into "(" for parsing
                    Dim SourceControl$, TargetControl$
                    Dim SourceProperty$, TargetProperty$
                    Dim SourceSet As _Byte, TargetSet As _Byte

                    SourceControl$ = nextParameter$(b$)
                    TargetControl$ = nextParameter$(b$)
                    SourceProperty$ = nextParameter$(b$)
                    TargetProperty$ = nextParameter$(b$)

                    SourceSet = False: TargetSet = False
                    For i = 1 To UBound(Control)
                        If RTrim$(Control(i).Name) = SourceControl$ Then
                            Control(i).BoundTo = __UI_GetID(TargetControl$)
                            Control(i).BoundProperty = __UI_PropertyEnum(SourceProperty$, 0)
                            SourceSet = True
                        ElseIf RTrim$(Control(i).Name) = TargetControl$ Then
                            Control(i).BoundTo = __UI_GetID(SourceControl$)
                            Control(i).BoundProperty = __UI_PropertyEnum(TargetProperty$, 0)
                            TargetSet = True
                        End If
                        If SourceSet And TargetSet Then Exit For
                    Next
                ElseIf b$ = "END SUB" Then
                    If LogFileLoad Then Print #LogFileNum, "END OF FILE"
                    __UI_EOF = True
                    Exit Do
                End If
            Loop
        Loop Until __UI_EOF
        Close #BinaryFileNum
        If LogFileLoad Then Close #LogFileNum
        __UI_AutoRefresh = True
        Exit Sub

        LoadError:
        Close #BinaryFileNum
        Kill "UiEditorPreview.frmbin"
        __UI_AutoRefresh = True
        Exit Sub
    End If
    Exit Sub
End Sub

Sub PreviewLoadImage (This As __UI_ControlTYPE, fileName$)
    If LCase$(Right$(fileName$, 4)) = ".gif" Then
        Dim tryGif As _Byte
        CloseGif This.ID
        tryGif = OpenGif(This.ID, fileName$)
        If tryGif Then
            If TotalFrames(This.ID) = 1 Then
                CloseGif This.ID
            Else
                Text(This.ID) = fileName$ 'indicates image loaded successfully
                If This.HelperCanvas < -1 Then
                    _FreeImage This.HelperCanvas
                End If
                This.HelperCanvas = _NewImage(GifWidth(This.ID), GifHeight(This.ID), 32)
                AutoPlayGif(This.ID) = False
                UpdateGif This.ID
                Exit Sub
            End If
        End If
    End If
    CloseGif This.ID
    LoadImage This, fileName$
End Sub

Function nextParameter$ (__text$)
    Static lastText$
    Static position1 As Long, position2 As Long
    Dim text$, thisParameter$

    text$ = LTrim$(RTrim$(__text$))
    If text$ <> lastText$ Then
        lastText$ = text$
        position1 = InStr(text$, "(")
        If position1 > 0 Then
            'check that this bracket is outside quotation marks
            Dim quote As _Byte, i As Long
            For i = 1 To position1
                If Asc(text$, i) = 34 Then quote = Not quote
            Next
            If quote Then position1 = 0
        End If

        If position1 = 0 Then
            'no opening bracket; must be a sub call
            position1 = InStr(text$, " ")
            If position1 = 0 Then Exit Function
            position1 = position1 + 1 'skip space
        Else
            position1 = position1 + 1 'skip bracket
        End If
    End If

    position2 = InStr(position1, text$, ",")
    If position2 = 0 Then position2 = InStr(position1, text$, ")")
    If position2 > 0 Then
        'check that this bracket is outside quotation marks
        quote = False
        For i = 1 To position2
            If Asc(text$, i) = 34 Then quote = Not quote
        Next
        If quote Then position2 = 0
    End If
    If position2 = 0 Then position2 = Len(text$) + 1
    thisParameter$ = LTrim$(RTrim$(Mid$(text$, position1, position2 - position1)))
    nextParameter$ = removeQuotation$(thisParameter$)
    position1 = position2 + 1
End Function

Function removeQuotation$ (__text$)
    Dim text$, firstQ As Long, nextQ As Long
    text$ = __text$

    firstQ = InStr(text$, Chr$(34))
    If firstQ = 0 Then removeQuotation$ = text$: Exit Function

    nextQ = InStr(firstQ + 1, text$, Chr$(34))
    If nextQ = 0 Then removeQuotation$ = Mid$(text$, firstQ + 1): Exit Function

    removeQuotation$ = Mid$(text$, firstQ + 1, nextQ - firstQ - 1)
End Function

Sub SavePreview (Destination As _Byte)
    Dim b$, i As Long, a$, FontSetup$, TempValue As Long
    Dim BinFileNum As Integer, TxtFileNum As Integer
    Dim Clip$, Disk As _Byte, TCP As _Byte, UndoBuffer As _Byte
    Dim PreviewData$, Dummy As Long

    Const Debug = False

    If Destination = InDisk Then
        Disk = True
        BinFileNum = FreeFile
        Open "UiEditorPreview.frmbin" For Binary As #BinFileNum
    ElseIf Destination = ToEditor Then
        TCP = True
    ElseIf Destination = ToUndoBuffer Then
        UndoBuffer = True
    Else
        If __UI_TotalSelectedControls = 0 Then Exit Sub

        Dim SelectedFrames$
        For i = 1 To UBound(Control)
            If Control(i).ControlIsSelected And Control(i).Type = __UI_Type_Frame Then
                SelectedFrames$ = SelectedFrames$ + ";" + RTrim$(Control(i).Name) + ";"
            End If
        Next
    End If

    If Debug Then
        TxtFileNum = FreeFile
        Open "UiEditorPreview.txt" For Output As #TxtFileNum
    End If

    b$ = "InForm" + Chr$(1)
    If Disk Then
        Put #BinFileNum, 1, b$
        b$ = MKL$(UBound(Control))
        Put #BinFileNum, , b$
    ElseIf TCP Then
        PreviewData$ = "FORMDATA>" + MKL$(UBound(Control))
    ElseIf UndoBuffer Then
        Clip$ = MKL$(UBound(Control))
    End If

    Dim ThisPass As _Byte
    For ThisPass = 1 To 2
        For i = 1 To UBound(Control)
            If Destination = InClipboard Then
                If Control(i).Type = __UI_Type_Form Or Control(i).Type = __UI_Type_MenuBar Then _Continue
                If Control(i).ControlIsSelected = False Then
                    If InStr(SelectedFrames$, ";" + RTrim$(Control(Control(i).ParentID).Name) + ";") = 0 Then
                        _Continue
                    End If
                End If
            End If

            If Control(i).ID > 0 And Control(i).Type <> __UI_Type_MenuPanel And Control(i).Type <> __UI_Type_Font And Len(RTrim$(Control(i).Name)) > 0 And Left$(RTrim$(Control(i).Name), 5) <> "__UI_" Then
                If ThisPass = 1 Then
                    IF Control(i).Type <> __UI_Type_Form AND _
                       Control(i).Type <> __UI_Type_Frame AND _
                       Control(i).Type <> __UI_Type_MenuBar THEN
                        _Continue
                    End If
                ElseIf ThisPass = 2 Then
                    IF Control(i).Type = __UI_Type_Form OR _
                       Control(i).Type = __UI_Type_Frame OR _
                       Control(i).Type = __UI_Type_MenuBar THEN
                        _Continue
                    End If
                End If
                If Debug Then
                    Print #TxtFileNum, Control(i).ID,
                    Print #TxtFileNum, RTrim$(Control(i).Name)
                End If
                Dim tempList$
                tempList$ = tempList$ + RTrim$(Control(i).Name) + ";"
                b$ = MKI$(-1) + MKL$(i) + MKI$(Control(i).Type) '-1 indicates a new control
                b$ = b$ + MKI$(Len(RTrim$(Control(i).Name)))
                b$ = b$ + RTrim$(Control(i).Name)
                b$ = b$ + MKI$(Control(i).Width) + MKI$(Control(i).Height) + MKI$(Control(i).Left) + MKI$(Control(i).Top)
                If Control(i).ParentID > 0 Then
                    b$ = b$ + MKI$(Len(RTrim$(Control(Control(i).ParentID).Name))) + RTrim$(Control(Control(i).ParentID).Name)
                Else
                    b$ = b$ + MKI$(0)
                End If

                If Disk Then
                    Put #BinFileNum, , b$
                Else
                    Clip$ = Clip$ + b$
                End If

                If Len(Caption(i)) > 0 Then
                    If Control(i).HotKeyPosition > 0 Then
                        a$ = Left$(Caption(i), Control(i).HotKeyPosition - 1) + "&" + Mid$(Caption(i), Control(i).HotKeyPosition)
                    Else
                        a$ = Caption(i)
                    End If
                    b$ = MKI$(-2) + MKL$(Len(a$)) '-2 indicates a caption
                    If Disk Then
                        Put #BinFileNum, , b$
                        Put #BinFileNum, , a$
                    Else
                        Clip$ = Clip$ + b$ + a$
                    End If
                End If

                If Len(ToolTip(i)) > 0 Then
                    b$ = MKI$(-24) + MKL$(Len(ToolTip(i))) '-24 indicates a tip
                    If Disk Then
                        Put #BinFileNum, , b$
                        Put #BinFileNum, , ToolTip(i)
                    Else
                        Clip$ = Clip$ + b$ + ToolTip(i)
                    End If
                End If

                If Len(Text(i)) > 0 Then
                    b$ = MKI$(-3) + MKL$(Len(Text(i))) '-3 indicates a text
                    If Disk Then
                        Put #BinFileNum, , b$
                        Put #BinFileNum, , Text(i)
                    Else
                        Clip$ = Clip$ + b$ + Text(i)
                    End If
                End If

                If Len(Mask(i)) > 0 Then
                    b$ = MKI$(-36) + MKL$(Len(Mask(i))) '-36 indicates a mask
                    If Disk Then
                        Put #BinFileNum, , b$
                        Put #BinFileNum, , Mask(i)
                    Else
                        Clip$ = Clip$ + b$ + Mask(i)
                    End If
                End If

                If Control(i).TransparentColor > 0 Then
                    b$ = MKI$(-28) + _MK$(_Unsigned Long, Control(i).TransparentColor)
                    If Disk Then
                        Put #BinFileNum, , b$
                    Else
                        Clip$ = Clip$ + b$
                    End If
                End If

                If Control(i).Stretch Then
                    b$ = MKI$(-4)
                    If Disk Then
                        Put #BinFileNum, , b$
                    Else
                        Clip$ = Clip$ + b$
                    End If
                End If
                'Inheritable properties won't be saved if they are the same as the parent's
                If Control(i).Type = __UI_Type_Form Or Destination = InClipboard Then
                    If Control(i).Font = 8 Or Control(i).Font = 16 Then
                        'Internal fonts
                        SaveInternalFont:
                        FontSetup$ = "," + LTrim$(Str$(Control(__UI_GetFontID(Control(i).Font)).Max))
                        b$ = MKI$(-5) + MKI$(Len(FontSetup$)) + FontSetup$ + MKI$(0)
                        If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                    Else
                        SaveExternalFont:
                        FontSetup$ = ToolTip(__UI_GetFontID(Control(i).Font)) + "," + LTrim$(Str$(Control(__UI_GetFontID(Control(i).Font)).Max))
                        b$ = MKI$(-5) + MKI$(Len(FontSetup$)) + FontSetup$
                        b$ = b$ + MKI$(Len(Text(__UI_GetFontID(Control(i).Font)))) + Text(__UI_GetFontID(Control(i).Font))
                        If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                    End If
                Else
                    If Control(i).ParentID > 0 Then
                        If Control(i).Font > 0 And Control(i).Font <> Control(Control(i).ParentID).Font Then
                            If Control(i).Font = 8 Or Control(i).Font = 16 Then
                                GoTo SaveInternalFont
                            Else
                                GoTo SaveExternalFont
                            End If
                        End If
                    Else
                        If Control(i).Font > 0 And Control(i).Font <> Control(__UI_FormID).Font Then
                            If Control(i).Font = 8 Or Control(i).Font = 16 Then
                                GoTo SaveInternalFont
                            Else
                                GoTo SaveExternalFont
                            End If
                        End If
                    End If
                End If
                'Colors are saved only if they differ from the theme's defaults
                If Control(i).ForeColor <> __UI_DefaultColor(Control(i).Type, 1) Then
                    b$ = MKI$(-6) + _MK$(_Unsigned Long, Control(i).ForeColor)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
                If Control(i).BackColor <> __UI_DefaultColor(Control(i).Type, 2) Then
                    b$ = MKI$(-7) + _MK$(_Unsigned Long, Control(i).BackColor)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
                If Control(i).SelectedForeColor <> __UI_DefaultColor(Control(i).Type, 3) Then
                    b$ = MKI$(-8) + _MK$(_Unsigned Long, Control(i).SelectedForeColor)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
                If Control(i).SelectedBackColor <> __UI_DefaultColor(Control(i).Type, 4) Then
                    b$ = MKI$(-9) + _MK$(_Unsigned Long, Control(i).SelectedBackColor)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
                If Control(i).BorderColor <> __UI_DefaultColor(Control(i).Type, 5) Then
                    b$ = MKI$(-10) + _MK$(_Unsigned Long, Control(i).BorderColor)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
                If Control(i).BackStyle = __UI_Transparent Then
                    b$ = MKI$(-11)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
                If Control(i).HasBorder Then
                    b$ = MKI$(-12)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
                If Control(i).Align = __UI_Center Then
                    b$ = MKI$(-13) + _MK$(_Byte, Control(i).Align)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                ElseIf Control(i).Align = __UI_Right Then
                    b$ = MKI$(-13) + _MK$(_Byte, Control(i).Align)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
                If Control(i).VAlign = __UI_Middle Then
                    b$ = MKI$(-32) + _MK$(_Byte, Control(i).VAlign)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                ElseIf Control(i).VAlign = __UI_Bottom Then
                    b$ = MKI$(-32) + _MK$(_Byte, Control(i).VAlign)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
                If Control(i).PasswordField = True Then
                    b$ = MKI$(-33)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
                If Control(i).Encoding > 0 Then
                    b$ = MKI$(-34) + MKL$(Control(i).Encoding)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
                If Control(i).Value <> 0 Then
                    b$ = MKI$(-14) + _MK$(_Float, Control(i).Value)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
                If Control(i).Min <> 0 Then
                    b$ = MKI$(-15) + _MK$(_Float, Control(i).Min)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
                If Control(i).Max <> 0 Then
                    b$ = MKI$(-16) + _MK$(_Float, Control(i).Max)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
                If Control(i).ShowPercentage Then
                    b$ = MKI$(-19)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
                If Control(i).CanHaveFocus Then
                    b$ = MKI$(-20)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
                If Control(i).Disabled Then
                    b$ = MKI$(-21)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
                If Control(i).Hidden Then
                    b$ = MKI$(-22)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
                If Control(i).CenteredWindow Then
                    b$ = MKI$(-23)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
                If Control(i).ContextMenuID Then
                    If Left$(Control(Control(i).ContextMenuID).Name, 9) <> "__UI_Text" And Left$(Control(Control(i).ContextMenuID).Name, 16) <> "__UI_PreviewMenu" Then
                        b$ = MKI$(-25) + MKI$(Len(RTrim$(Control(Control(i).ContextMenuID).Name))) + RTrim$(Control(Control(i).ContextMenuID).Name)
                        If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                    End If
                End If
                If Control(i).Interval Then
                    b$ = MKI$(-26) + _MK$(_Float, Control(i).Interval)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
                If Control(i).MinInterval Then
                    b$ = MKI$(-37) + _MK$(_Float, Control(i).MinInterval)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
                If Control(i).WordWrap Then
                    b$ = MKI$(-27)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
                If Control(i).CanResize And Control(i).Type = __UI_Type_Form Then
                    b$ = MKI$(-29)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
                If Control(i).Padding > 0 Then
                    b$ = MKI$(-31) + MKI$(Control(i).Padding)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
                If Control(i).NumericOnly = True Then
                    b$ = MKI$(-38)
                    If Disk Then
                        Put #BinFileNum, , b$
                    Else
                        Clip$ = Clip$ + b$
                    End If
                End If
                If Control(i).NumericOnly = __UI_NumericWithBounds Then
                    b$ = MKI$(-39)
                    If Disk Then
                        Put #BinFileNum, , b$
                    Else
                        Clip$ = Clip$ + b$
                    End If
                End If
                If Control(i).BulletStyle = __UI_Bullet Then
                    b$ = MKI$(-40)
                    If Disk Then
                        Put #BinFileNum, , b$
                    Else
                        Clip$ = Clip$ + b$
                    End If
                End If
                If Control(i).AutoScroll = True Then
                    b$ = MKI$(-41)
                    If Disk Then
                        Put #BinFileNum, , b$
                    Else
                        Clip$ = Clip$ + b$
                    End If
                End If
                If Control(i).AutoSize = True Then
                    b$ = MKI$(-42)
                    If Disk Then
                        Put #BinFileNum, , b$
                    Else
                        Clip$ = Clip$ + b$
                    End If
                End If
                If Control(i).BorderSize > 0 Then
                    b$ = MKI$(-43) + MKI$(Control(i).BorderSize)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
                If Control(i).KeyCombo > 0 Then
                    b$ = MKI$(-44) + MKI$(Len(RTrim$(__UI_KeyCombo(Control(i).KeyCombo).FriendlyCombo))) + RTrim$(__UI_KeyCombo(Control(i).KeyCombo).FriendlyCombo)
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
                If GetGifIndex&(i) > 0 Then
                    'PictureBox has an animated GIF loaded
                    b$ = MKI$(-45)
                    If Disk Then
                        Put #BinFileNum, , b$
                    Else
                        Clip$ = Clip$ + b$
                    End If
                End If
                If i <= UBound(AutoPlayGif) Then
                    If AutoPlayGif(i) Then
                        b$ = MKI$(-46)
                        If Disk Then
                            Put #BinFileNum, , b$
                        Else
                            Clip$ = Clip$ + b$
                        End If
                    End If
                End If
                If Control(i).ControlIsSelected Then
                    b$ = MKI$(-47)
                    If Disk Then
                        Put #BinFileNum, , b$
                    Else
                        Clip$ = Clip$ + b$
                    End If
                End If
                If Control(i).BoundTo > 0 Then
                    b$ = MKI$(-48) + MKI$(Len(RTrim$(Control(Control(i).BoundTo).Name))) + RTrim$(Control(Control(i).BoundTo).Name)
                    Dummy = __UI_PropertyEnum&(a$, Control(i).BoundProperty)
                    b$ = b$ + MKI$(Len(a$)) + a$
                    If Disk Then Put #BinFileNum, , b$ Else Clip$ = Clip$ + b$
                End If
            End If
        Next
    Next
    b$ = MKI$(-1024) 'end of file
    If Disk Then
        Put #BinFileNum, , b$
        Close #BinFileNum
    ElseIf TCP Then
        PreviewData$ = PreviewData$ + Clip$ + b$ + "<END>"
        If LastPreviewDataSent$ <> PreviewData$ And __UI_IsDragging = False And __UI_IsResizing = False Then
            LastPreviewDataSent$ = PreviewData$
            Put #Host, , PreviewData$
        End If
    ElseIf UndoBuffer Then
        Clip$ = Clip$ + b$
        If UndoPointer > 0 Then
            If UndoImage(UndoPointer - 1) = Clip$ Then Exit Sub
        End If
        UndoImage(UndoPointer) = Clip$
        UndoPointer = UndoPointer + 1
        If UndoPointer > TotalUndoImages Then
            TotalUndoImages = TotalUndoImages + 1
        ElseIf UndoPointer < TotalUndoImages Then
            TotalUndoImages = UndoPointer
        End If
        If TotalUndoImages > UBound(UndoImage) Then
            ReDim _Preserve UndoImage(UBound(UndoImage) + 99) As String
        End If
    Else
        Clip$ = Clip$ + b$
        b$ = Pack$(Clip$)

        If Len(b$) > 60 Then
            a$ = ""
            Do
                a$ = a$ + Left$(b$, 60) + Chr$(10)
                b$ = Mid$(b$, 61)
                If Len(b$) <= 60 Then
                    a$ = a$ + b$
                    b$ = a$
                    Exit Do
                End If
            Loop
        End If

        Clip$ = __UI_ClipboardCheck$
        Clip$ = Clip$ + Hex$(Len(b$)) + Chr$(10)
        Clip$ = Clip$ + b$ + Chr$(10)
        Clip$ = Clip$ + String$(60, "-") + Chr$(10)
        Clip$ = Clip$ + "END CONTROL DATA"
        _Clipboard$ = Clip$ + Chr$(10) + "Controls in this block: " + tempList$
    End If
    If Debug Then Close #TxtFileNum
End Sub

Sub SendData (b$, thisCommand$)
    b$ = UCase$(thisCommand$) + ">" + b$ + "<END>"
    Put #Host, , b$
End Sub

Sub SendSignal (Value As Integer)
    Dim b$
    b$ = "SIGNAL>" + MKI$(Value) + "<END>"
    Put #Host, , b$
End Sub


Function AdaptName$ (tName$, TargetID As Long)
    Dim Name$, NewName$, i As Long, c$, NextIsCapital As _Byte, CheckID As Long
    Name$ = RTrim$(tName$)

    '"__UI_" is reserved:
    If UCase$(Left$(Name$, 5)) = "__UI_" Then Name$ = Mid$(Name$, 6)

    If Len(Name$) > 0 Then
        'First valid character must be a letter or "_":
        Do While Not Alpha(Asc(Name$, 1))
            Name$ = Mid$(Name$, 2)
            If Len(Name$) = 0 Then Name$ = Control(TargetID).Name: GoTo CheckDuplicates
        Loop

        'Single "_" to start a variable name is reserved;
        'Double "_" is valid:
        If Left$(Name$, 1) = "_" And Mid$(Name$, 2, 1) <> "_" Then
            Name$ = "_" + Name$
        End If

        'Other valid characters must be alphanumeric:
        For i = 1 To Len(Name$)
            If AlphaNumeric(Asc(Name$, i)) Then
                If NextIsCapital Then
                    NewName$ = NewName$ + UCase$(Mid$(Name$, i, 1))
                    If Asc(Right$(NewName$, 1)) >= 65 And Asc(Right$(NewName$, 1)) <= 90 Then NextIsCapital = False
                Else
                    NewName$ = NewName$ + Mid$(Name$, i, 1)
                End If
            Else
                If Asc(Name$, i) = 32 Then NextIsCapital = True
            End If
        Next
    Else
        Name$ = Control(TargetID).Name
    End If

    If Len(NewName$) > 40 Then NewName$ = Left$(NewName$, 40)
    Name$ = NewName$

    CheckDuplicates:
    i = 1
    Do
        CheckID = __UI_GetID(NewName$)
        If CheckID = 0 Then Exit Do
        If CheckID = TargetID Then Exit Do
        i = i + 1
        c$ = LTrim$(Str$(i))
        If Len(Name$) + Len(c$) <= 40 Then
            NewName$ = Name$ + c$
        Else
            Name$ = Mid$(Name$, 1, 40 - Len(c$))
            NewName$ = Name$ + c$
        End If
    Loop

    If IS_KEYWORD(NewName$) Then NewName$ = "__" + NewName$

    AdaptName$ = NewName$
End Function

'READ_KEYWORDS and IS_KEYWORD come from vWATCH64:
Sub READ_KEYWORDS
    Dim ThisKeyword$, TotalKeywords As Long

    Restore QB64KeywordsDATA
    'Populate QB64KEYWORDS():
    Do
        Read ThisKeyword$
        If ThisKeyword$ = "**END**" Then
            Exit Do
        End If
        TotalKeywords = TotalKeywords + 1
        ReDim _Preserve QB64KEYWORDS(1 To TotalKeywords) As String
        QB64KEYWORDS(TotalKeywords) = UCase$(ThisKeyword$)
    Loop

    QB64KeywordsDATA:
    Data $CHECKING,$CONSOLE,$DYNAMIC,$ELSE,$ELSEIF,$END,$ENDIF,$EXEICON,$IF,$INCLUDE
    Data $LET,$RESIZE,$SCREENHIDE,$SCREENSHOW,$STATIC,$VERSIONINFO,$VIRTUALKEYBOARD,ABS
    Data ABSOLUTE,ACCESS,ALIAS,AND,APPEND,AS,ASC,ATN,BASE,BEEP,BINARY,BLOAD,BSAVE,BYVAL
    Data CALL,CALLS,CASE,IS,CDBL,CDECL,CHAIN,CHDIR,CHR$,CINT,CIRCLE,CLEAR,CLNG,CLOSE
    Data CLS,COLOR,COM,COMMAND$,COMMON,CONST,COS,CSNG,CSRLIN,CUSTOMTYPE,CVD,CVDMBF,CVI
    Data CVL,CVS,CVSMBF,DATA,DATE$,DECLARE,DEF,DEFDBL,DEFINT,DEFLNG,DEFSNG,DEFSTR,DIM
    Data DO,DOUBLE,DRAW,DYNAMIC,ELSE,ELSEIF,END,ENDIF,ENVIRON,ENVIRON$,EOF,EQV,ERASE
    Data ERDEV,ERDEV$,ERL,ERR,ERROR,EVERYCASE,EXIT,EXP,FIELD,FILEATTR,FILES,FIX,FN,FOR
    Data FRE,FREE,FREEFILE,FUNCTION,GET,GOSUB,GOTO,HEX$,IF,IMP,INKEY$,INP,INPUT,INPUT$
    Data INSTR,INT,INTEGER,INTERRUPT,INTERRUPTX,IOCTL,IOCTL$,KEY,KILL,LBOUND,LCASE$,LEFT$
    Data LEN,LET,LIBRARY,LINE,LIST,LOC,LOCATE,LOCK,LOF,LOG,LONG,LOOP,LPOS,LPRINT,LSET
    Data LTRIM$,MID$,MKD$,MKDIR,MKDMBF$,MKI$,MKL$,MKS$,MKSMBF$,MOD,NAME,NEXT,NOT,OCT$
    Data OFF,ON,OPEN,OPTION,OR,OUT,OUTPUT,PAINT,PALETTE,PCOPY,PEEK,PEN,PLAY,PMAP,POINT
    Data POKE,POS,PRESET,PRINT,PSET,PUT,RANDOM,RANDOMIZE,READ,REDIM,REM,RESET,RESTORE
    Data RESUME,RETURN,RIGHT$,RMDIR,RND,RSET,RTRIM$,RUN,SADD,SCREEN,SEEK,SEG,SELECT,SETMEM
    Data SGN,SHARED,SHELL,SIGNAL,SIN,SINGLE,SLEEP,SOUND,SPACE$,SPC,SQR,STATIC,STEP,STICK
    Data STOP,STR$,STRIG,STRING,STRING$,SUB,SWAP,SYSTEM,TAB,TAN,THEN,TIME$,TIMER,TO,TROFF
    Data TRON,TYPE,UBOUND,UCASE$,UEVENT,UNLOCK,UNTIL,USING,VAL,VARPTR,VARPTR$,VARSEG
    Data VIEW,WAIT,WEND,WHILE,WIDTH,WINDOW,WRITE,XOR,_ACOS,_ACOSH,_ALPHA,_ALPHA32,_ARCCOT
    Data _ARCCSC,_ARCSEC,_ASIN,_ASINH,_ATAN2,_ATANH,_AUTODISPLAY,_AXIS,_BACKGROUNDCOLOR
    Data _BIT,_BLEND,_BLINK,_BLUE,_BLUE32,_BUTTON,_BUTTONCHANGE,_BYTE,_CEIL,_CLEARCOLOR
    Data _CLIP,_CLIPBOARD$,_CLIPBOARDIMAGE,_COMMANDCOUNT,_CONNECTED,_CONNECTIONADDRESS$
    Data _CONSOLE,_CONSOLETITLE,_CONTINUE,_CONTROLCHR,_COPYIMAGE,_COPYPALETTE,_COSH,_COT
    Data _COTH,_CSC,_CSCH,_CV,_CWD$,_D2G,_D2R,_DEFAULTCOLOR,_DEFINE,_DELAY,_DEPTHBUFFER
    Data _DESKTOPHEIGHT,_DESKTOPWIDTH,_DEST,_DEVICE$,_DEVICEINPUT,_DEVICES,_DIR$,_DIREXISTS
    Data _DISPLAY,_DISPLAYORDER,_DONTBLEND,_DONTWAIT,_ERRORLINE,_EXIT,_EXPLICIT,_FILEEXISTS
    Data _FLOAT,_FONT,_FONTHEIGHT,_FONTWIDTH,_FREEFONT,_FREEIMAGE,_FREETIMER,_FULLSCREEN
    Data _G2D,_G2R,_GLRENDER,_GREEN,_GREEN32,_HEIGHT,_HIDE,_HYPOT,_ICON,_INCLERRORFILE$
    Data _INCLERRORLINE,_INTEGER64,_KEYCLEAR,_KEYDOWN,_KEYHIT,_LASTAXIS,_LASTBUTTON,_LASTWHEEL
    Data _LIMIT,_LOADFONT,_LOADIMAGE,_MAPTRIANGLE,_MAPUNICODE,_MEM,_MEMCOPY,_MEMELEMENT
    Data _MEMEXISTS,_MEMFILL,_MEMFREE,_MEMGET,_MEMIMAGE,_MEMNEW,_MEMPUT,_MIDDLE,_MK$
    Data _MOUSEBUTTON,_MOUSEHIDE,_MOUSEINPUT,_MOUSEMOVE,_MOUSEMOVEMENTX,_MOUSEMOVEMENTY
    Data _MOUSEPIPEOPEN,_MOUSESHOW,_MOUSEWHEEL,_MOUSEX,_MOUSEY,_NEWIMAGE,_OFFSET,_OPENCLIENT
    Data _OPENCONNECTION,_OPENHOST,_OS$,_PALETTECOLOR,_PI,_PIXELSIZE,_PRESERVE,_PRINTIMAGE
    Data _PRINTMODE,_PRINTSTRING,_PRINTWIDTH,_PUTIMAGE,_R2D,_R2G,_RED,_RED32,_RESIZE
    Data _RESIZEHEIGHT,_RESIZEWIDTH,_RGB,_RGB32,_RGBA,_RGBA32,_ROUND,_SCREENCLICK,_SCREENEXISTS
    Data _SCREENHIDE,_SCREENICON,_SCREENIMAGE,_SCREENMOVE,_SCREENPRINT,_SCREENSHOW,_SCREENX
    Data _SCREENY,_SEC,_SECH,_SETALPHA,_SHELLHIDE,_SINH,_SNDBAL,_SNDCLOSE,_SNDCOPY,_SNDGETPOS
    Data _SNDLEN,_SNDLIMIT,_SNDLOOP,_SNDOPEN,_SNDOPENRAW,_SNDPAUSE,_SNDPAUSED,_SNDPLAY
    Data _SNDPLAYCOPY,_SNDPLAYFILE,_SNDPLAYING,_SNDRATE,_SNDRAW,_SNDRAWDONE,_SNDRAWLEN
    Data _SNDSETPOS,_SNDSTOP,_SNDVOL,_SOURCE,_STARTDIR$,_STRCMP,_STRICMP,_TANH,_TITLE
    Data _TITLE$,_UNSIGNED,_WHEEL,_WIDTH,_WINDOWHANDLE,_WINDOWHASFOCUS,_GLACCUM,_GLALPHAFUNC
    Data _GLARETEXTURESRESIDENT,_GLARRAYELEMENT,_GLBEGIN,_GLBINDTEXTURE,_GLBITMAP,_GLBLENDFUNC
    Data _GLCALLLIST,_GLCALLLISTS,_GLCLEAR,_GLCLEARACCUM,_GLCLEARCOLOR,_GLCLEARDEPTH
    Data _GLCLEARINDEX,_GLCLEARSTENCIL,_GLCLIPPLANE,_GLCOLOR3B,_GLCOLOR3BV,_GLCOLOR3D
    Data _GLCOLOR3DV,_GLCOLOR3F,_GLCOLOR3FV,_GLCOLOR3I,_GLCOLOR3IV,_GLCOLOR3S,_GLCOLOR3SV
    Data _GLCOLOR3UB,_GLCOLOR3UBV,_GLCOLOR3UI,_GLCOLOR3UIV,_GLCOLOR3US,_GLCOLOR3USV,_GLCOLOR4B
    Data _GLCOLOR4BV,_GLCOLOR4D,_GLCOLOR4DV,_GLCOLOR4F,_GLCOLOR4FV,_GLCOLOR4I,_GLCOLOR4IV
    Data _GLCOLOR4S,_GLCOLOR4SV,_GLCOLOR4UB,_GLCOLOR4UBV,_GLCOLOR4UI,_GLCOLOR4UIV,_GLCOLOR4US
    Data _GLCOLOR4USV,_GLCOLORMASK,_GLCOLORMATERIAL,_GLCOLORPOINTER,_GLCOPYPIXELS,_GLCOPYTEXIMAGE1D
    Data _GLCOPYTEXIMAGE2D,_GLCOPYTEXSUBIMAGE1D,_GLCOPYTEXSUBIMAGE2D,_GLCULLFACE,_GLDELETELISTS
    Data _GLDELETETEXTURES,_GLDEPTHFUNC,_GLDEPTHMASK,_GLDEPTHRANGE,_GLDISABLE,_GLDISABLECLIENTSTATE
    Data _GLDRAWARRAYS,_GLDRAWBUFFER,_GLDRAWELEMENTS,_GLDRAWPIXELS,_GLEDGEFLAG,_GLEDGEFLAGPOINTER
    Data _GLEDGEFLAGV,_GLENABLE,_GLENABLECLIENTSTATE,_GLEND,_GLENDLIST,_GLEVALCOORD1D
    Data _GLEVALCOORD1DV,_GLEVALCOORD1F,_GLEVALCOORD1FV,_GLEVALCOORD2D,_GLEVALCOORD2DV
    Data _GLEVALCOORD2F,_GLEVALCOORD2FV,_GLEVALMESH1,_GLEVALMESH2,_GLEVALPOINT1,_GLEVALPOINT2
    Data _GLFEEDBACKBUFFER,_GLFINISH,_GLFLUSH,_GLFOGF,_GLFOGFV,_GLFOGI,_GLFOGIV,_GLFRONTFACE
    Data _GLFRUSTUM,_GLGENLISTS,_GLGENTEXTURES,_GLGETBOOLEANV,_GLGETCLIPPLANE,_GLGETDOUBLEV
    Data _GLGETERROR,_GLGETFLOATV,_GLGETINTEGERV,_GLGETLIGHTFV,_GLGETLIGHTIV,_GLGETMAPDV
    Data _GLGETMAPFV,_GLGETMAPIV,_GLGETMATERIALFV,_GLGETMATERIALIV,_GLGETPIXELMAPFV,_GLGETPIXELMAPUIV
    Data _GLGETPIXELMAPUSV,_GLGETPOINTERV,_GLGETPOLYGONSTIPPLE,_GLGETSTRING,_GLGETTEXENVFV
    Data _GLGETTEXENVIV,_GLGETTEXGENDV,_GLGETTEXGENFV,_GLGETTEXGENIV,_GLGETTEXIMAGE,_GLGETTEXLEVELPARAMETERFV
    Data _GLGETTEXLEVELPARAMETERIV,_GLGETTEXPARAMETERFV,_GLGETTEXPARAMETERIV,_GLHINT
    Data _GLINDEXMASK,_GLINDEXPOINTER,_GLINDEXD,_GLINDEXDV,_GLINDEXF,_GLINDEXFV,_GLINDEXI
    Data _GLINDEXIV,_GLINDEXS,_GLINDEXSV,_GLINDEXUB,_GLINDEXUBV,_GLINITNAMES,_GLINTERLEAVEDARRAYS
    Data _GLISENABLED,_GLISLIST,_GLISTEXTURE,_GLLIGHTMODELF,_GLLIGHTMODELFV,_GLLIGHTMODELI
    Data _GLLIGHTMODELIV,_GLLIGHTF,_GLLIGHTFV,_GLLIGHTI,_GLLIGHTIV,_GLLINESTIPPLE,_GLLINEWIDTH
    Data _GLLISTBASE,_GLLOADIDENTITY,_GLLOADMATRIXD,_GLLOADMATRIXF,_GLLOADNAME,_GLLOGICOP
    Data _GLMAP1D,_GLMAP1F,_GLMAP2D,_GLMAP2F,_GLMAPGRID1D,_GLMAPGRID1F,_GLMAPGRID2D,_GLMAPGRID2F
    Data _GLMATERIALF,_GLMATERIALFV,_GLMATERIALI,_GLMATERIALIV,_GLMATRIXMODE,_GLMULTMATRIXD
    Data _GLMULTMATRIXF,_GLNEWLIST,_GLNORMAL3B,_GLNORMAL3BV,_GLNORMAL3D,_GLNORMAL3DV
    Data _GLNORMAL3F,_GLNORMAL3FV,_GLNORMAL3I,_GLNORMAL3IV,_GLNORMAL3S,_GLNORMAL3SV,_GLNORMALPOINTER
    Data _GLORTHO,_GLPASSTHROUGH,_GLPIXELMAPFV,_GLPIXELMAPUIV,_GLPIXELMAPUSV,_GLPIXELSTOREF
    Data _GLPIXELSTOREI,_GLPIXELTRANSFERF,_GLPIXELTRANSFERI,_GLPIXELZOOM,_GLPOINTSIZE
    Data _GLPOLYGONMODE,_GLPOLYGONOFFSET,_GLPOLYGONSTIPPLE,_GLPOPATTRIB,_GLPOPCLIENTATTRIB
    Data _GLPOPMATRIX,_GLPOPNAME,_GLPRIORITIZETEXTURES,_GLPUSHATTRIB,_GLPUSHCLIENTATTRIB
    Data _GLPUSHMATRIX,_GLPUSHNAME,_GLRASTERPOS2D,_GLRASTERPOS2DV,_GLRASTERPOS2F,_GLRASTERPOS2FV
    Data _GLRASTERPOS2I,_GLRASTERPOS2IV,_GLRASTERPOS2S,_GLRASTERPOS2SV,_GLRASTERPOS3D
    Data _GLRASTERPOS3DV,_GLRASTERPOS3F,_GLRASTERPOS3FV,_GLRASTERPOS3I,_GLRASTERPOS3IV
    Data _GLRASTERPOS3S,_GLRASTERPOS3SV,_GLRASTERPOS4D,_GLRASTERPOS4DV,_GLRASTERPOS4F
    Data _GLRASTERPOS4FV,_GLRASTERPOS4I,_GLRASTERPOS4IV,_GLRASTERPOS4S,_GLRASTERPOS4SV
    Data _GLREADBUFFER,_GLREADPIXELS,_GLRECTD,_GLRECTDV,_GLRECTF,_GLRECTFV,_GLRECTI,_GLRECTIV
    Data _GLRECTS,_GLRECTSV,_GLRENDERMODE,_GLROTATED,_GLROTATEF,_GLSCALED,_GLSCALEF,_GLSCISSOR
    Data _GLSELECTBUFFER,_GLSHADEMODEL,_GLSTENCILFUNC,_GLSTENCILMASK,_GLSTENCILOP,_GLTEXCOORD1D
    Data _GLTEXCOORD1DV,_GLTEXCOORD1F,_GLTEXCOORD1FV,_GLTEXCOORD1I,_GLTEXCOORD1IV,_GLTEXCOORD1S
    Data _GLTEXCOORD1SV,_GLTEXCOORD2D,_GLTEXCOORD2DV,_GLTEXCOORD2F,_GLTEXCOORD2FV,_GLTEXCOORD2I
    Data _GLTEXCOORD2IV,_GLTEXCOORD2S,_GLTEXCOORD2SV,_GLTEXCOORD3D,_GLTEXCOORD3DV,_GLTEXCOORD3F
    Data _GLTEXCOORD3FV,_GLTEXCOORD3I,_GLTEXCOORD3IV,_GLTEXCOORD3S,_GLTEXCOORD3SV,_GLTEXCOORD4D
    Data _GLTEXCOORD4DV,_GLTEXCOORD4F,_GLTEXCOORD4FV,_GLTEXCOORD4I,_GLTEXCOORD4IV,_GLTEXCOORD4S
    Data _GLTEXCOORD4SV,_GLTEXCOORDPOINTER,_GLTEXENVF,_GLTEXENVFV,_GLTEXENVI,_GLTEXENVIV
    Data _GLTEXGEND,_GLTEXGENDV,_GLTEXGENF,_GLTEXGENFV,_GLTEXGENI,_GLTEXGENIV,_GLTEXIMAGE1D
    Data _GLTEXIMAGE2D,_GLTEXPARAMETERF,_GLTEXPARAMETERFV,_GLTEXPARAMETERI,_GLTEXPARAMETERIV
    Data _GLTEXSUBIMAGE1D,_GLTEXSUBIMAGE2D,_GLTRANSLATED,_GLTRANSLATEF,_GLVERTEX2D,_GLVERTEX2DV
    Data _GLVERTEX2F,_GLVERTEX2FV,_GLVERTEX2I,_GLVERTEX2IV,_GLVERTEX2S,_GLVERTEX2SV,_GLVERTEX3D
    Data _GLVERTEX3DV,_GLVERTEX3F,_GLVERTEX3FV,_GLVERTEX3I,_GLVERTEX3IV,_GLVERTEX3S,_GLVERTEX3SV
    Data _GLVERTEX4D,_GLVERTEX4DV,_GLVERTEX4F,_GLVERTEX4FV,_GLVERTEX4I,_GLVERTEX4IV,_GLVERTEX4S
    Data _GLVERTEX4SV,_GLVERTEXPOINTER,_GLVIEWPORT,_ANTICLOCKWISE,_BEHIND,_CLEAR,_FILLBACKGROUND
    Data _GLUPERSPECTIVE,_HARDWARE,_HARDWARE1,_KEEPBACKGROUND,_NONE,_OFF,_ONLY,_ONLYBACKGROUND
    Data _ONTOP,_SEAMLESS,_SMOOTH,_SMOOTHSHRUNK,_SMOOTHSTRETCHED,_SOFTWARE,_SQUAREPIXELS
    Data _STRETCH
    Data uprint_extra,uprint,uprintwidth,uheight&,uheight,falcon_uspacing&
    Data falcon_uspacing,uascension&,uascension,GetSystemMetrics&
    Data GetSystemMetrics,uspacing&,uspacing,SetFrameRate,SetFocus
    Data AutoSizeLabel,Darken~&,Darken,isNumber%%,isNumber,RawText$,RawText
    Data SetFont&,SetFont,SetCaption,BeginDraw,EndDraw,LoadImage
    Data SetRadioButtonValue,Replace$,Replace,AddItem,RemoveItem,ResetList
    Data ReplaceItem,SelectItem%%,SelectItem,GetItem$,GetItem,MessageBox&
    Data MessageBox,FromCP437$,FromCP437,FromCP1252$,FromCP1252,UTF8$,UTF8
    Data GetControlDrawOrder&,GetControlDrawOrder,IconPreview&,IconPreview
    Data RestoreCHR$,RestoreCHR,MsgBox_OkOnly%%,MsgBox_OkOnly
    Data MsgBox_OkCancel%%,MsgBox_OkCancel,MsgBox_AbortRetryIgnore%%
    Data MsgBox_AbortRetryIgnore,MsgBox_YesNoCancel%%,MsgBox_YesNoCancel
    Data MsgBox_YesNo%%,MsgBox_YesNo,MsgBox_RetryCancel%%,MsgBox_RetryCancel
    Data MsgBox_CancelTryagainContinue%%,MsgBox_CancelTryagainContinue
    Data MsgBox_Critical%,MsgBox_Critical,MsgBox_Question%,MsgBox_Question
    Data MsgBox_Exclamation%,MsgBox_Exclamation,MsgBox_Information%
    Data MsgBox_Information,MsgBox_DefaultButton1%,MsgBox_DefaultButton1
    Data MsgBox_DefaultButton2%,MsgBox_DefaultButton2,MsgBox_DefaultButton3%
    Data MsgBox_DefaultButton3,MsgBox_Defaultbutton4%,MsgBox_Defaultbutton4
    Data MsgBox_AppModal%%,MsgBox_AppModal,MsgBox_SystemModal%
    Data MsgBox_SystemModal,MsgBox_SetForeground&,MsgBox_SetForeground
    Data MsgBox_Ok%%,MsgBox_Ok,MsgBox_Cancel%%,MsgBox_Cancel,MsgBox_Abort%%
    Data MsgBox_Abort,MsgBox_Retry%%,MsgBox_Retry,MsgBox_Ignore%%
    Data MsgBox_Ignore,MsgBox_Yes%%,MsgBox_Yes,MsgBox_No%%,MsgBox_No
    Data MsgBox_Tryagain%%,MsgBox_Tryagain,MsgBox_Continue%%,MsgBox_Continue
    Data **END**
End Sub

Function IS_KEYWORD (Text$)
    Dim uText$, i As Long
    uText$ = UCase$(RTrim$(LTrim$(Text$)))
    For i = 1 To UBound(QB64KEYWORDS)
        If QB64KEYWORDS(i) = uText$ Then IS_KEYWORD = True: Exit Function
    Next i
End Function

Sub SaveUndoImage
    SavePreview ToUndoBuffer
End Sub

Sub RestoreUndoImage
    If UndoPointer = 0 Then Exit Sub
    UndoPointer = UndoPointer - 1
    LoadPreview ToUndoBuffer
End Sub

Sub RestoreRedoImage
    If UndoPointer = TotalUndoImages Then Exit Sub
    UndoPointer = UndoPointer + 1
    LoadPreview ToUndoBuffer
End Sub


Sub LoadDefaultFonts
    If Control(__UI_FormID).Font = 8 Or Control(__UI_FormID).Font = 16 Then
        Control(__UI_FormID).Font = SetFont("segoeui.ttf", 12)
    End If
    If Control(__UI_FormID).Font = 8 Or Control(__UI_FormID).Font = 16 Then
        Control(__UI_FormID).Font = SetFont("arial.ttf", 12)
    End If
    If Control(__UI_FormID).Font = 8 Or Control(__UI_FormID).Font = 16 Then
        Control(__UI_FormID).Font = SetFont("cour.ttf", 12)
    End If
    If Control(__UI_FormID).Font = 8 Or Control(__UI_FormID).Font = 16 Then
        Control(__UI_FormID).Font = SetFont("/Library/Fonts/Arial.ttf", 12)
    End If
    If Control(__UI_FormID).Font = 8 Or Control(__UI_FormID).Font = 16 Then
        Control(__UI_FormID).Font = SetFont("/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf", 12)
    End If
    If Control(__UI_FormID).Font = 8 Or Control(__UI_FormID).Font = 16 Then
        Control(__UI_FormID).Font = SetFont("/usr/share/fonts/TTF/arial.ttf", 12)
    End If
    If Control(__UI_FormID).Font = 8 Or Control(__UI_FormID).Font = 16 Then
        Control(__UI_FormID).Font = SetFont("resources/NotoMono-Regular.ttf", 12)
    End If
End Sub

Function EditorImageData$ (FileName$)
    Dim A$

    Select Case LCase$(FileName$)
        Case "contextmenu.bmp"
            A$ = MKI$(16) + MKI$(16)
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo"
            A$ = A$ + "0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "okXMWm_UVJjoFNj[oKiYWn?XXnjoGR:ZoS9Z`n?VYVjoQVJ\oSIZYnOVZ6ko"
            A$ = A$ + "IZZZoo?0oooo0looo3`ooo?0oooQ^meo0000oK_mfo_mfKoogOomoOomgo?n"
            A$ = A$ + "hSooiWOnoWOnioOniWooj[_noWYZanoo0looo3`ooo?0oooo0loo>JgIoGOm"
            A$ = A$ + "eo?000`o>o[]o3:RgmoSgQfo827HoSGH8m?L@1doiWOno[_njoOVZZjoo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooOXKOmOmeGoofK_mo3000lomgOoogOomoS?nhoOniWoo"
            A$ = A$ + "iWOnoWOnio_nj[ooIZJ\oo?0oooo0looo3`ooo?0oo_SfMfoeGOmoK_mfo_m"
            A$ = A$ + "fKoo0000o3l[Xn?R`QeohQ5Bo37D0mOniWooj[_noWYZZnoo0looo3`ooo?0"
            A$ = A$ + "oooo0loo7jfGoGOmeo_mfKoofK_moOomgo?000`ohS?noWOnioOniWooiWOn"
            A$ = A$ + "o[_njoOVZ6koo3`ooo?0oooo0looo3`ookXMWmOmeGoofK_moK_mfo?000`o"
            A$ = A$ + "0000o3000lO\QRio`15@oWOnio_nj[ooIZZZoo?0oooo0looo3`ooo?0oooQ"
            A$ = A$ + "^meo0000o3000l_mfKoo0000oolc?o?b8SloiWOnoWOnioOniWooj[_noWYZ"
            A$ = A$ + "anoo0looo3`ooo?0oooo0loo>JgIok\c>o_c>klo7n6HoOomgo?000`oHR8P"
            A$ = A$ + "oS7F8m?LH1doiWOno[_njoOVZZjoo3`ooo?0oooo0looo3`ooKgQ7nOmeGoo"
            A$ = A$ + "fK_moohMPmomgOoo0000oS<b8oOniWooiWOnoWOnio_nj[ooIZJ\oo?0oooo"
            A$ = A$ + "0looo3`ooo?0oo_UVjjoeGOmoK_mfo_coJko?N7Jo3000l?V@2hoh56Bo37D"
            A$ = A$ + "0mOniWooj[_noWYZZnoo0looo3`ooo?0oooo0looFJZYoGOmeo_mfKoofK_m"
            A$ = A$ + "oS<b8ooc?olo8S<boWOnioOniWooiWOno[_njoOVZ6koo3`ooo?0oooo0loo"
            A$ = A$ + "o3`oooYY^n_UVJjoFNj[oKiYWn?XXnjoGR:ZoS9Z`n?VYVjoQVJ\oSIZYnOV"
            A$ = A$ + "Z6koIZZZoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`o%%o3"
    End Select
    EditorImageData$ = A$
End Function

Function LoadEditorImage& (FileName$)
    Dim MemoryBlock As _MEM, TempImage As Long, NextSlot As Long
    Dim NewWidth As Integer, NewHeight As Integer, A$, BASFILE$

    A$ = EditorImageData$(FileName$)
    If Len(A$) = 0 Then Exit Function

    NewWidth = CVI(Left$(A$, 2))
    NewHeight = CVI(Mid$(A$, 3, 2))
    A$ = Mid$(A$, 5)

    BASFILE$ = Unpack$(A$)

    TempImage = _NewImage(NewWidth, NewHeight, 32)
    MemoryBlock = _MemImage(TempImage)

    __UI_MemCopy MemoryBlock.OFFSET, _Offset(BASFILE$), Len(BASFILE$)
    _MemFree MemoryBlock

    LoadEditorImage& = TempImage
End Function

'$include:'InForm.ui'

