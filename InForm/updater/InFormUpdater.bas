': This program uses
': InForm - GUI library for QB64 - Beta version 7
': Fellippe Heitor, 2016-2018 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED InFormUpdater AS LONG
DIM SHARED PictureBox2 AS LONG
DIM SHARED InFormresourcesApplicationicon128PX AS LONG
DIM SHARED InFormLB AS LONG
DIM SHARED forQB64LB AS LONG
DIM SHARED ListBox1 AS LONG
DIM SHARED RetryBT AS LONG
DIM SHARED CancelBT AS LONG
DIM SHARED ActivityIndicator AS LONG

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../InForm.ui'
'$INCLUDE:'../xp.uitheme'
'$INCLUDE:'InFormUpdater.frm'
'$INCLUDE:'../ini.bm'

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit

END SUB

SUB __UI_OnLoad
    Report "Contacting server"
    CHDIR ".."
    IF _FILEEXISTS("InFormUpdate.ini") THEN KILL "InFormUpdate.ini"
END SUB

SUB __UI_BeforeUpdateDisplay STATIC
    DIM NextEvent AS LONG
    SHARED ThisStep AS INTEGER

    IF ThisStep = 0 THEN ThisStep = 1

    SELECT EVERYCASE ThisStep
        CASE 1 'check availability
            Result$ = Download$("www.qb64.org/inform/update/latest.ini", "InFormUpdate.ini", 30)
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
            localVersion$ = ReadSetting("InFormVersion.bas", "", "CONST __UI_Version")
            localVersionNumber! = VAL(ReadSetting("InFormVersion.bas", "", "CONST __UI_VersionNumber"))
            localVersionisBeta%% = ReadSetting("InFormVersion.bas", "", "CONST __UI_VersionIsBeta") = "True"
            IF localVersionisBeta%% THEN localBeta$ = " Beta version " ELSE localBeta$ = " "
            Report "Local version:" + localBeta$ + LTRIM$(STR$(localVersionNumber!))

            serverVersion$ = ReadSetting("InFormUpdate.ini", "", "version")
            isBeta$ = ReadSetting("InFormUpdate.ini", "", "beta")
            serverBeta%% = True
            IF isBeta$ = "true" THEN isBeta$ = " Beta version " ELSE isBeta$ = " "
            Report "Remote version:" + isBeta$ + serverVersion$

            IF localVersionisBeta%% THEN
                IF serverBeta%% AND VAL(serverVersion$) <= localVersionNumber! THEN
                    NextEvent = True: ThisStep = 7: EXIT SUB
                END IF
            ELSE
                IF VAL(serverVersion$) <= localVersionNumber! THEN
                    NextEvent = True: ThisStep = 7: EXIT SUB
                END IF
            END IF

            thisFile% = 0

            NextEvent = True: ThisStep = 3
        CASE 3 'download new content
            IF NextEvent THEN NextEvent = False: Report "Downloading content..."

            IF url$ = "" THEN
                thisFile% = thisFile% + 1

                url$ = ReadSetting("InFormUpdate.ini", LTRIM$(STR$(thisFile%)), "url")
                IF url$ = "" THEN
                    NextEvent = True: ThisStep = 4: EXIT SUB
                END IF
                target$ = ReadSetting("InFormUpdate.ini", LTRIM$(STR$(thisFile%)), "target")
                IF _DIREXISTS(target$) = 0 THEN MKDIR LEFT$(target$, LEN(target$) - 1)
                outputFileName$ = target$ + ReadSetting("InFormUpdate.ini", LTRIM$(STR$(thisFile%)), "filename")
                checksum$ = ReadSetting("InFormUpdate.ini", LTRIM$(STR$(thisFile%)), "checksum")

                Report "Downloading " + outputFileName$ + "..."

                IF _FILEEXISTS(outputFileName$) THEN
                    IF ADLER32$(outputFileName$) = checksum$ THEN
                        Report "Already downloaded, skipping."
                        url$ = ""
                    END IF
                END IF
            END IF

            IF LEN(url$) THEN
                Result$ = Download$(url$, outputFileName$, 30)
            ELSE
                Result$ = MKI$(0)
            END IF

            SELECT CASE CVI(LEFT$(Result$, 2))
                CASE 1 'Success
                    'Checksum:
                    IF ADLER32(outputFileName$) <> checksum$ THEN
                        Report "Failed."
                        ThisStep = -1
                        NextEvent = True
                        EXIT SUB
                    END IF
                    Report "Done:" + STR$(CVL(MID$(Result$, 3))) + " bytes."
                    url$ = ""
                CASE 2 'Can't reach server
                    Report "Can't reach server."
                    ThisStep = -1
                    NextEvent = True
                CASE 3 'Timeout :-(
                    Report "Failed to download update files from server."
                    ThisStep = -1
                    NextEvent = True
            END SELECT
        CASE 4 'compile UiEditor.bas
            IF NextEvent THEN NextEvent = False: Report "Compiling UiEditor.bas...": EXIT SUB
            CHDIR ".."
            Result% = SHELL("qb64.exe -x InForm/UiEditor.bas")
            IF Result% THEN
                Report "Compilation failed."
                ThisStep = -1
                NextEvent = True
            ELSE
                ThisStep = 5
                NextEvent = True
            END IF
        CASE 5 'compile UiEditorPreview.bas
            IF NextEvent THEN NextEvent = False: Report "Compiling UiEditorPreview.bas...": EXIT SUB
            Result% = SHELL("qb64.exe -x InForm/UiEditorPreview.bas -o InForm/UiEditorPreview.exe")
            IF Result% THEN
                Report "Compilation failed."
                ThisStep = -1
                NextEvent = True
            ELSE
                ThisStep = 6
                NextEvent = True
            END IF
        CASE 6 'clean up
            IF NextEvent THEN NextEvent = False: Report "Cleaning up..."
        CASE 7 'already up-to-date
            Answer = MessageBox("You already have the latest version.", "", MsgBox_OkOnly + MsgBox_Information)
            SYSTEM
        CASE 1 TO 6
            BeginDraw ActivityIndicator
            CLS , __UI_DefaultColor(__UI_Type_Form, 2)
            angle = angle + .05
            'IF indicatorIncrement = 0 THEN indicatorIncrement = .05: indicatorSize = 1
            'indicatorSize = indicatorSize + indicatorIncrement
            'IF indicatorSize >= 5 THEN indicatorIncrement = indicatorIncrement * -1
            'IF indicatorSize <= 1 THEN indicatorIncrement = indicatorIncrement * -1
            indicatorSize = 2
            IF angle > _PI(2) THEN angle = _PI(2) - angle
            FOR i = 0 TO 360 STEP 90
                CircleFill _WIDTH / 2 + COS(angle + _D2R(i)) * (_WIDTH * .2), _HEIGHT / 2, indicatorSize, _RGBA32(0, 0, 0, map(i, 0, 360, 20, 255))
            NEXT
            EndDraw ActivityIndicator
        CASE ELSE
            IF NextEvent THEN NextEvent = False: Report "Updated failed."
            Control(RetryBT).Hidden = False
            Control(ActivityIndicator).Hidden = True
    END SELECT

END SUB

SUB Report (text$)
    AddItem ListBox1, TIME$ + ": " + text$
END SUB

FUNCTION ADLER32$ (File$)
    'This function comes from Videogamer555. Read the original topic below:
    'http://www.qb64.net/forum/index.php?topic=2804.msg24245#msg24245
    DIM A32$, fileHandle AS LONG
    DIM Astr AS STRING * 4
    DIM Bstr AS STRING * 4
    A = 1
    B = 0

    IF _FILEEXISTS(File$) = 0 THEN EXIT SUB

    fileHandle = FREEFILE
    OPEN File$ FOR BINARY AS fileHandle
    DataArray$ = SPACE$(LOF(fileHandle))
    GET #fileHandle, 1, DataArray$
    CLOSE #fileHandle

    FOR i = 1 TO LEN(DataArray$)
        A = (A + ASC(MID$(DataArray$, i, 1))) MOD 65521
        B = (B + A) MOD 65521
    NEXT i
    RSET Astr = HEX$(A)
    RSET Bstr = HEX$(B)

    A32$ = Bstr + Astr
    FOR i = 1 TO 8
        IF MID$(A32$, i, 1) = " " THEN MID$(A32$, i, 1) = "0"
    NEXT i

    ADLER32$ = A32$
END FUNCTION

FUNCTION Download$ (url$, file$, timelimit) STATIC
    'as seen on http://www.qb64.org/wiki/Downloading_Files
    'adapted for use with InForm

    DIM client AS LONG, l AS LONG

    IF url$ <> prevUrl$ THEN
        prevUrl$ = url$
        url2$ = url$
        x = INSTR(url2$, "/")
        IF x THEN url2$ = LEFT$(url$, x - 1)
        IF url2$ <> prevUrl2$ THEN
            prevUrl2$ = url2$
            IF client THEN CLOSE client: client = 0
            client = _OPENCLIENT("TCP/IP:80:" + url2$)
            IF client = 0 THEN Download = MKI$(2): prevUrl$ = "": EXIT FUNCTION
        END IF
        e$ = CHR$(13) + CHR$(10) ' end of line characters
        url3$ = RIGHT$(url$, LEN(url$) - x + 1)
        x$ = "GET " + url3$ + " HTTP/1.1" + e$
        x$ = x$ + "Host: " + url2$ + e$ + e$
        PUT #client, , x$
        t! = TIMER ' start time
    END IF

    GET #client, , a2$
    a$ = a$ + a2$
    i = INSTR(a$, "Content-Length:")
    IF i THEN
        i2 = INSTR(i, a$, e$)
        IF i2 THEN
            l = VAL(MID$(a$, i + 15, i2 - i - 14))
            i3 = INSTR(i2, a$, e$ + e$)
            IF i3 THEN
                i3 = i3 + 4 'move i3 to start of data
                IF (LEN(a$) - i3 + 1) = l THEN
                    d$ = MID$(a$, i3, l)
                    fh = FREEFILE
                    OPEN file$ FOR OUTPUT AS #fh: CLOSE #fh 'Warning! Clears data from existing file
                    OPEN file$ FOR BINARY AS #fh
                    PUT #fh, , d$
                    CLOSE #fh
                    Download = MKI$(1) + MKL$(l) 'indicates download was successful
                    prevUrl$ = ""
                    a$ = ""
                    EXIT FUNCTION
                END IF ' availabledata = l
            END IF ' i3
        END IF ' i2
    END IF ' i
    IF TIMER > t! + timelimit THEN CLOSE client: client = 0: Download = MKI$(3): prevUrl$ = "": EXIT FUNCTION
    Download = MKI$(0) 'still working
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
