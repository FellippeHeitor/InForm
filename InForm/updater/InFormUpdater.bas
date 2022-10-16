': This program uses
': InForm - GUI library for QB64 - Beta version 9
': Fellippe Heitor, 2016-2019 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

': Controls' IDs: ------------------------------------------------------------------
Dim Shared InFormUpdater As Long
Dim Shared PictureBox2 As Long
Dim Shared InFormresourcesApplicationicon128PX As Long
Dim Shared InFormLB As Long
Dim Shared forQB64LB As Long
Dim Shared ListBox1 As Long
Dim Shared RetryBT As Long
Dim Shared CancelBT As Long
Dim Shared ActivityIndicator As Long

Dim Shared binaryExtension$, pathAppend$
Dim Shared CheckDevUpdates As _Byte

$If WIN Then
    binaryExtension$ = ".exe"
    pathAppend$ = ""
$Else
        binaryExtension$ = ""
        pathAppend$ = "./"
$End If

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../InForm.bi'
'$INCLUDE:'../xp.uitheme'
'$INCLUDE:'InFormUpdater.frm'
'$INCLUDE:'../ini.bm'
'$include:'../extensions/download.bas'

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit

END SUB

SUB __UI_OnLoad
    Report "Contacting server..."
    CHDIR "../.."
    IF _FILEEXISTS("InFormUpdate.ini") THEN KILL "InFormUpdate.ini"

    DIM value$
    value$ = ReadSetting("InForm/InForm.ini", "InForm Settings", "Receive development updates")
    IF LEN(value$) THEN
        CheckDevUpdates = (value$ = "True")
    ELSE
        WriteSetting "InForm/InForm.ini", "InForm Settings", "Receive development updates", "False"
        CheckDevUpdates = False
    END IF
END SUB

SUB __UI_BeforeUpdateDisplay STATIC
    DIM NextEvent AS LONG, remoteFile$
    SHARED ThisStep AS INTEGER

    IF ThisStep = 0 THEN ThisStep = 1

    SELECT EVERYCASE ThisStep
        CASE 1 'check availability
            IF CheckDevUpdates THEN
                remoteFile$ = "www.qb64.org/inform/update/latestdev.ini"
            ELSE
                remoteFile$ = "www.qb64.org/inform/update/latest.ini"
            END IF
            Result$ = Download$(remoteFile$, "InFormUpdate.ini", 30)
            SELECT CASE CVI(LEFT$(Result$, 2))
                CASE 1 'Success
                    Report "Script downloaded:" + STR$(CVL(MID$(Result$, 3))) + " bytes."
                    ThisStep = 2
                    NextEvent = True
                CASE 2 'Can't reach server
                    Report "Can't reach server."
                    ThisStep = -1
                    NextEvent = True
                CASE 3 'Timeout :-(
                    Report "Failed to download update script."
                    ThisStep = -1
                    NextEvent = True
            END SELECT
        CASE 2 'compare with current version
            IF NextEvent THEN NextEvent = False: Report "Parsing update script..."
            localVersion$ = ReadSetting("InForm/InFormVersion.bas", "", "CONST __UI_Version")
            localVersionNumber! = VAL(ReadSetting("InForm/InFormVersion.bas", "", "CONST __UI_VersionNumber"))
            localVersionisBeta%% = VAL(ReadSetting("InForm/InFormVersion.bas", "", "CONST __UI_VersionIsBeta"))
            IF localVersionisBeta%% THEN localBeta$ = " Beta Version" ELSE localBeta$ = ""
            Report "Local build:" + STR$(localVersionNumber!) + localBeta$

            serverVersion$ = ReadSetting("InFormUpdate.ini", "", "version")
            serverBeta$ = ReadSetting("InFormUpdate.ini", "", "beta")
            serverBeta%% = (serverBeta$ = "true")
            IF serverBeta%% THEN serverBeta$ = " Beta Version" ELSE serverBeta$ = ""
            Report "Remote build: " + serverVersion$ + serverBeta$

            IF VAL(serverVersion$) <= localVersionNumber! THEN
                NextEvent = True: ThisStep = 7: EXIT SUB
            END IF

            thisFile% = 0
            baseUrl$ = ReadSetting("InFormUpdate.ini", "", "baseurl")

            NextEvent = True: ThisStep = 3
        CASE 3 'download new content
            IF NextEvent THEN NextEvent = False: Report "Downloading content..."

            IF url$ = "" THEN
                thisFile% = thisFile% + 1

                url$ = ReadSetting("InFormUpdate.ini", LTRIM$(STR$(thisFile%)), "filename")
                IF url$ = "" THEN
                    NextEvent = True: ThisStep = 4: EXIT SUB
                END IF
                IF INSTR(url$, "/") > 0 THEN
                    FOR i = LEN(url$) TO 1 STEP -1
                        IF ASC(url$, i) = 47 THEN '/
                            target$ = LEFT$(url$, i)
                            EXIT FOR
                        END IF
                    NEXT

                    IF _DIREXISTS(target$) = 0 THEN MKDIR target$
                ELSE
                    target$ = ""
                END IF
                outputFileName$ = url$
                checksum$ = ReadSetting("InFormUpdate.ini", LTRIM$(STR$(thisFile%)), "checksum")

                IF _FILEEXISTS(outputFileName$) THEN
                    IF getChecksum$(outputFileName$) = checksum$ THEN
                        url$ = ""
                    END IF
                END IF

                IF LEN(url$) THEN Report "Downloading " + outputFileName$ + "...;"
            END IF

            IF LEN(url$) THEN
                IF INSTR(url$, "updater") > 0 THEN
                    WriteSetting "InForm/InForm.ini", "InForm Settings", "Recompile updater", "True"
                END IF
                Result$ = Download$(baseUrl$ + url$, outputFileName$, 30)
            ELSE
                Result$ = MKI$(0)
            END IF

            SELECT CASE CVI(LEFT$(Result$, 2))
                CASE 1 'Success
                    'Checksum:
                    IF getChecksum(outputFileName$) <> checksum$ THEN
                        Report "Failed."
                        ThisStep = -1
                        NextEvent = True
                        EXIT SUB
                    END IF
                    Report " done (" + LTRIM$(STR$(CVL(MID$(Result$, 3)))) + " bytes)"
                    url$ = ""
                CASE 2 'Can't reach server
                    Report "failed."
                    Report "Can't reach server."
                    ThisStep = -1
                    NextEvent = True
                CASE 3 'Timeout :-(
                    Report "failed."
                    Report "Failed to download update files from server."
                    ThisStep = -1
                    NextEvent = True
            END SELECT
        CASE 4 'compile UiEditor.bas
            IF NextEvent THEN NextEvent = False: Report "Compiling UiEditor.bas...": EXIT SUB
            SHELL _HIDE pathAppend$ + "qb64" + binaryExtension$ + " -s:exewithsource=false"
            Result% = SHELL(pathAppend$ + "qb64" + binaryExtension$ + " -x InForm/UiEditor.bas")
            IF Result% > 0 OR _FILEEXISTS(pathAppend$ + "qb64" + binaryExtension$) = 0 THEN
                Report "Compilation failed."
                ThisStep = -1
                NextEvent = True
            ELSE
                ThisStep = 5
                NextEvent = True
            END IF
        CASE 5 'compile UiEditorPreview.bas
            IF NextEvent THEN NextEvent = False: Report "Compiling UiEditorPreview.bas...": EXIT SUB
            Result% = SHELL(pathAppend$ + "qb64" + binaryExtension$ + " -x InForm/UiEditorPreview.bas -o InForm/UiEditorPreview.exe")
            IF Result% THEN
                Report "Compilation failed."
                ThisStep = -1
                NextEvent = True
            ELSE
                ThisStep = 6
                NextEvent = True
            END IF
        CASE 6 'clean up
            IF NextEvent THEN NextEvent = False: Report "Cleaning up...": EXIT SUB
            KILL "InFormUpdate.ini"
            ThisStep = 8
            NextEvent = True
        CASE 7 'already up-to-date
            DIM b$
            b$ = ""
            IF CheckDevUpdates THEN b$ = "\n(You are currently in the development channel; you can\nchange that in InForm Designer, Options menu -> Auto-update)"
            Answer = MessageBox("You already have the latest version." + b$, "", MsgBox_OkOnly + MsgBox_Information)
            KILL "InFormUpdate.ini"
            SYSTEM
        CASE 8 'done
            IF NextEvent THEN NextEvent = False: Report "Update complete.": EXIT SUB
            Result$ = Download$("", "", 30) 'close client
            Control(ActivityIndicator).Hidden = True
            Caption(CancelBT) = "Finish"
            SetFocus CancelBT
        CASE 1 TO 6
            BeginDraw ActivityIndicator
            CLS , __UI_DefaultColor(__UI_Type_Form, 2)
            angle = angle + .05
            indicatorSize = 2
            IF angle > _PI(2) THEN angle = _PI(2) - angle
            FOR i = 0 TO 360 STEP 90
                CircleFill _WIDTH / 2 + COS(angle + _D2R(i)) * (_WIDTH * .2), _HEIGHT / 2, indicatorSize, _RGBA32(0, 0, 0, map(i, 0, 360, 20, 255))
            NEXT
            EndDraw ActivityIndicator
        CASE ELSE
            IF NextEvent THEN NextEvent = False: Report "Updated failed.": AddItem ListBox1, ""
            Result$ = Download$("", "", 30)
            KILL "InFormUpdate.ini"
            Control(RetryBT).Hidden = False
            Control(ActivityIndicator).Hidden = True
    END SELECT

END SUB

SUB Report (__text$)
    STATIC Continue%%
    DIM text$

    text$ = __text$

    IF text$ = "" THEN
        Continue%% = False
        EXIT SUB
    END IF

    IF RIGHT$(text$, 1) = ";" THEN
        text$ = LEFT$(text$, LEN(text$) - 1)
        GOSUB AddThisItem
        Continue%% = True
    ELSE
        GOSUB AddThisItem
        Continue%% = False
    END IF
    EXIT SUB

    AddThisItem:
    IF Continue%% THEN
        text$ = GetItem(ListBox1, Control(ListBox1).Max) + text$
        ReplaceItem ListBox1, Control(ListBox1).Max, text$
    ELSE
        AddItem ListBox1, TIME$ + ": " + text$
    END IF
    RETURN
END SUB

FUNCTION getChecksum$ (File$)
    DIM fileHandle AS LONG

    IF _FILEEXISTS(File$) = 0 THEN EXIT SUB

    fileHandle = FREEFILE
    OPEN File$ FOR BINARY AS fileHandle
    DataArray$ = SPACE$(LOF(fileHandle))
    GET #fileHandle, 1, DataArray$
    CLOSE #fileHandle

    getChecksum$ = HEX$(crc32~&(DataArray$))
END FUNCTION

FUNCTION crc32~& (buf AS STRING)
    'adapted from https://rosettacode.org/wiki/CRC-32
    STATIC table(255) AS _UNSIGNED LONG
    STATIC have_table AS _BYTE
    DIM crc AS _UNSIGNED LONG, k AS _UNSIGNED LONG
    DIM i AS LONG, j AS LONG

    IF have_table = 0 THEN
        FOR i = 0 TO 255
            k = i
            FOR j = 0 TO 7
                IF (k AND 1) THEN
                    k = _SHR(k, 1)
                    k = k XOR &HEDB88320
                ELSE
                    k = _SHR(k, 1)
                END IF
                table(i) = k
            NEXT
        NEXT
        have_table = -1
    END IF

    crc = NOT crc ' crc = &Hffffffff

    FOR i = 1 TO LEN(buf)
        crc = (_SHR(crc, 8)) XOR table((crc AND &HFF) XOR ASC(buf, i))
    NEXT

    crc32~& = NOT crc
END FUNCTION

SUB CircleFill (x AS LONG, y AS LONG, R AS LONG, C AS _UNSIGNED LONG)
    DIM x0 AS SINGLE, y0 AS SINGLE
    DIM e AS SINGLE

    x0 = R
    y0 = 0
    e = 0
    DO WHILE y0 < x0
        IF e <= 0 THEN
            y0 = y0 + 1
            LINE (x - x0, y + y0)-(x + x0, y + y0), C, BF
            LINE (x - x0, y - y0)-(x + x0, y - y0), C, BF
            e = e + 2 * y0
        ELSE
            LINE (x - y0, y - x0)-(x + y0, y - x0), C, BF
            LINE (x - y0, y + x0)-(x + y0, y + x0), C, BF
            x0 = x0 - 1
            e = e - 2 * x0
        END IF
    LOOP
    LINE (x - R, y)-(x + R, y), C, BF
END SUB

FUNCTION map! (value!, minRange!, maxRange!, newMinRange!, newMaxRange!)
    map! = ((value! - minRange!) / (maxRange! - minRange!)) * (newMaxRange! - newMinRange!) + newMinRange!
END FUNCTION

SUB __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.

END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE InFormUpdater

        CASE RetryBT
            SHARED ThisStep AS INTEGER
            ThisStep = 1
            Control(RetryBT).Hidden = True
            Control(ActivityIndicator).Hidden = False
            Report "Contacting server"
            IF _FILEEXISTS("InFormUpdate.ini") THEN KILL "InFormUpdate.ini"
        CASE CancelBT
            IF Caption(CancelBT) = "Finish" THEN
                DIM Answer AS _BYTE
                IF _FILEEXISTS("UiEditor" + binaryExtension$) THEN
                    Answer = MessageBox("Launch InForm Designer?", "", MsgBox_YesNo + MsgBox_Question)
                    IF Answer = MsgBox_Yes THEN
                        SHELL _DONTWAIT pathAppend$ + "UiEditor" + binaryExtension$
                    END IF
                END IF
            END IF
            SYSTEM
    END SELECT
END SUB

SUB __UI_MouseEnter (id AS LONG)
    SELECT CASE id
    END SELECT
END SUB

SUB __UI_MouseLeave (id AS LONG)
    SELECT CASE id
    END SELECT
END SUB

SUB __UI_FocusIn (id AS LONG)
    SELECT CASE id
    END SELECT
END SUB

SUB __UI_FocusOut (id AS LONG)
    'This event occurs right before a control loses focus.
    'To prevent a control from losing focus, set __UI_KeepFocus = True below.
    SELECT CASE id
    END SELECT
END SUB

SUB __UI_MouseDown (id AS LONG)
    SELECT CASE id
    END SELECT
END SUB

SUB __UI_MouseUp (id AS LONG)
    SELECT CASE id
    END SELECT
END SUB

SUB __UI_KeyPress (id AS LONG)
    'When this event is fired, __UI_KeyHit will contain the code of the key hit.
    'You can change it and even cancel it by making it = 0
    SELECT CASE id
    END SELECT
END SUB

SUB __UI_TextChanged (id AS LONG)
    SELECT CASE id
    END SELECT
END SUB

SUB __UI_ValueChanged (id AS LONG)
    SELECT CASE id
    END SELECT
END SUB

SUB __UI_FormResized

END SUB

'$INCLUDE:'../InForm.ui'

