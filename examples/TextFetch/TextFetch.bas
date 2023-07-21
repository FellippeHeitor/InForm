' Text Fetch.bas started b+ 2019-11-12 from other work with Dirs and Files loading
' Changes and updates by a740g (24-June-2023). Also simplified direntry.h
'
': This program uses
': InForm - GUI library for QB64 - v1.0
': Fellippe Heitor, 2016-2019 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

OPTION _EXPLICIT

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED frmTextFetch AS LONG
DIM SHARED lbCWD AS LONG
DIM SHARED lbDirs AS LONG
DIM SHARED ListDirs AS LONG
DIM SHARED lbFiles AS LONG
DIM SHARED ListFiles AS LONG
DIM SHARED lbFile AS LONG
DIM SHARED ListFile AS LONG
DIM SHARED lbTxt AS LONG
DIM SHARED ListTxt AS LONG
DIM SHARED BtnStart AS LONG
DIM SHARED BtnEnd AS LONG
DIM SHARED lbStart AS LONG
DIM SHARED lbEnd AS LONG

': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'TextFetch.frm'

' --- DIRENTRY STUFF ---

DECLARE LIBRARY "direntry"
    ' This opens a directly for reading it's contents
    ' IMPORTANT: Call the open_dir() wrapper instead of calling this directly. open_dir() properly null-terminates the directory string
    FUNCTION __open_dir%% (dirName AS STRING)

    ' This reads a single directory entry. You can call this repeatedly
    ' It will return an empty string once all entries have been read
    ' "flags" and "fileSize" are output parameters (i.e. use a variable)
    ' If "flag" is 1 then it is a directory and 2 if it is a file
    FUNCTION read_dir$ (flags AS LONG, fileSize AS LONG)

    ' Close the directory. This must be called before open_dir() or read_dir$() can be used again
    SUB close_dir
END DECLARE

' This properly null-terminates the directory name before passing it to __load_dir()
FUNCTION open_dir%% (dirName AS STRING)
    open_dir = __open_dir(dirName + CHR$(0))
END FUNCTION

' --- DIRENTRY STUFF ---

SUB loadText
    DIM i AS INTEGER, b$, clip$
    ResetList ListTxt
    FOR i = VAL(Caption(lbStart)) TO VAL(Caption(lbEnd))
        b$ = GetItem$(ListFile, i)
        AddItem ListTxt, GetItem$(ListFile, i)
        IF clip$ = "" THEN clip$ = b$ ELSE clip$ = clip$ + CHR$(13) + CHR$(10) + b$
    NEXT
    _CLIPBOARD$ = clip$
    Caption(lbTxt) = "Selected Text (in Clipboard):"
END SUB

SUB loadDirsFilesList
    DIM AS LONG nDirs, i

    Caption(lbCWD) = "Current Directory: " + _CWD$

    REDIM AS STRING Dir(0 TO 0), File(0 TO 0)
    nDirs = GetCurDirLists(Dir(), File())

    IF nDirs > 0 THEN
        ResetList ListDirs
        FOR i = LBOUND(Dir) TO UBOUND(Dir)
            AddItem ListDirs, Dir(i)
        NEXT

        ResetList ListFiles
        FOR i = LBOUND(File) TO UBOUND(File)
            AddItem ListFiles, File(i)
        NEXT
    END IF
END SUB

FUNCTION GetCurDirLists& (DirList() AS STRING, FileList() AS STRING)
    CONST RESIZE_BLOCK_SIZE = 64

    REDIM AS STRING DirList(0 TO RESIZE_BLOCK_SIZE), FileList(0 TO RESIZE_BLOCK_SIZE) ' resize the file and dir list arrays (and toss contents)

    DIM dirName AS STRING: dirName = _CWD$ ' we'll enumerate the current directory contents
    DIM AS LONG dirCount, fileCount, flags, fileSize
    DIM entryName AS STRING

    IF open_dir(dirName) THEN
        DO
            entryName = read_dir(flags, fileSize)
            IF entryName <> "" THEN
                SELECT CASE flags
                    CASE 1
                        IF dirCount > UBOUND(DirList) THEN REDIM _PRESERVE DirList(0 TO UBOUND(DirList) + RESIZE_BLOCK_SIZE) AS STRING
                        DirList(dirCount) = entryName
                        dirCount = dirCount + 1
                    CASE 2
                        IF fileCount > UBOUND(FileList) THEN REDIM _PRESERVE FileList(0 TO UBOUND(FileList) + RESIZE_BLOCK_SIZE) AS STRING
                        FileList(fileCount) = entryName
                        fileCount = fileCount + 1
                END SELECT
            END IF
        LOOP UNTIL entryName = ""
        close_dir
    END IF

    REDIM _PRESERVE DirList(0 TO dirCount) AS STRING
    REDIM _PRESERVE FileList(0 TO fileCount) AS STRING

    GetCurDirLists = dirCount + fileCount ' return total count of items
END FUNCTION

'This SUB will take a given N delimited string, and delimiter$ and create an array of N+1 strings using the LBOUND of the given dynamic array to load.
'notes: the loadMeArray() needs to be dynamic string array and will not change the LBOUND of the array it is given.  rev 2019-08-27
SUB Split (SplitMeString AS STRING, delim AS STRING, loadMeArray() AS STRING)
    DIM curpos AS LONG, arrpos AS LONG, LD AS LONG, dpos AS LONG 'fix use the Lbound the array already has
    curpos = 1: arrpos = LBOUND(loadMeArray): LD = LEN(delim)
    dpos = INSTR(curpos, SplitMeString, delim)
    DO UNTIL dpos = 0
        loadMeArray(arrpos) = MID$(SplitMeString, curpos, dpos - curpos)
        arrpos = arrpos + 1
        IF arrpos > UBOUND(loadMeArray) THEN REDIM _PRESERVE loadMeArray(LBOUND(loadMeArray) TO UBOUND(loadMeArray) + 1000) AS STRING
        curpos = dpos + LD
        dpos = INSTR(curpos, SplitMeString, delim)
    LOOP
    loadMeArray(arrpos) = MID$(SplitMeString, curpos)
    REDIM _PRESERVE loadMeArray(LBOUND(loadMeArray) TO arrpos) AS STRING 'get the ubound correct
END SUB

FUNCTION fileStr$ (txtFile AS STRING)
    IF _FILEEXISTS(txtFile) THEN
        DIM ff AS LONG: ff = FREEFILE
        OPEN txtFile FOR BINARY AS ff
        fileStr$ = INPUT$(LOF(ff), ff)
        CLOSE ff
    END IF
END FUNCTION

FUNCTION rightOf$ (source$, of$)
    IF INSTR(source$, of$) > 0 THEN rightOf$ = MID$(source$, INSTR(source$, of$) + LEN(of$))
END FUNCTION

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit

END SUB

SUB __UI_OnLoad
    loadDirsFilesList
END SUB

SUB __UI_BeforeUpdateDisplay
    'This event occurs at approximately 30 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%

END SUB

SUB __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.

END SUB

SUB __UI_Click (id AS LONG)
    DIM AS LONG value, i
    DIM AS STRING dir, fi, fs, fa(0)

    SELECT CASE id
        CASE frmTextFetch

        CASE lbCWD

        CASE lbDirs

        CASE ListDirs
            dir$ = GetItem$(ListDirs, Control(ListDirs).Value)
            IF _DIREXISTS(dir$) THEN
                CHDIR dir$
                Caption(lbCWD) = "Current Directory: " + _CWD$
                loadDirsFilesList
            END IF

        CASE lbFiles

        CASE ListFiles
            fi$ = GetItem$(ListFiles, Control(ListFiles).Value)
            IF _FILEEXISTS(fi$) THEN
                fs$ = fileStr$(fi$)
                Split fs$, CHR$(13) + CHR$(10), fa()
                ResetList ListFile
                FOR i = LBOUND(fa) TO UBOUND(fa)
                    AddItem ListFile, fa(i)
                NEXT
                'clear
                Caption(lbStart) = "Line Start"
                Caption(lbEnd) = "Line End"
                Caption(lbFile) = "Selected File: Path = " + _CWD$ + ",  Name = " + fi$
            END IF

        CASE lbFile

        CASE ListFile

        CASE lbTxt

        CASE ListTxt

        CASE BtnStart
            value = Control(ListFile).Value
            Caption(lbStart) = STR$(value) + " Start Line"
            IF VAL(Caption(lbStart)) - VAL(Caption(lbEnd)) > 0 THEN loadText

        CASE BtnEnd
            value = Control(ListFile).Value
            Caption(lbEnd) = STR$(value) + " End Line"
            IF VAL(Caption(lbEnd)) - VAL(Caption(lbStart)) > 0 THEN loadText

        CASE lbStart

        CASE lbEnd

    END SELECT
END SUB

SUB __UI_MouseEnter (id AS LONG)
    SELECT CASE id
        CASE frmTextFetch

        CASE lbCWD

        CASE lbDirs

        CASE ListDirs

        CASE lbFiles

        CASE ListFiles

        CASE lbFile

        CASE ListFile

        CASE lbTxt

        CASE ListTxt

        CASE BtnStart

        CASE BtnEnd

        CASE lbStart

        CASE lbEnd

    END SELECT
END SUB

SUB __UI_MouseLeave (id AS LONG)
    SELECT CASE id
        CASE frmTextFetch

        CASE lbCWD

        CASE lbDirs

        CASE ListDirs

        CASE lbFiles

        CASE ListFiles

        CASE lbFile

        CASE ListFile

        CASE lbTxt

        CASE ListTxt

        CASE BtnStart

        CASE BtnEnd

        CASE lbStart

        CASE lbEnd

    END SELECT
END SUB

SUB __UI_FocusIn (id AS LONG)
    SELECT CASE id
        CASE ListDirs

        CASE ListFiles

        CASE ListFile

        CASE ListTxt

        CASE BtnStart

        CASE BtnEnd

    END SELECT
END SUB

SUB __UI_FocusOut (id AS LONG)
    'This event occurs right before a control loses focus.
    'To prevent a control from losing focus, set __UI_KeepFocus = True below.
    SELECT CASE id
        CASE ListDirs

        CASE ListFiles

        CASE ListFile

        CASE ListTxt

        CASE BtnStart

        CASE BtnEnd

    END SELECT
END SUB

SUB __UI_MouseDown (id AS LONG)
    SELECT CASE id
        CASE frmTextFetch

        CASE lbCWD

        CASE lbDirs

        CASE ListDirs

        CASE lbFiles

        CASE ListFiles

        CASE lbFile

        CASE ListFile

        CASE lbTxt

        CASE ListTxt

        CASE BtnStart

        CASE BtnEnd

        CASE lbStart

        CASE lbEnd

    END SELECT
END SUB

SUB __UI_MouseUp (id AS LONG)
    SELECT CASE id
        CASE frmTextFetch

        CASE lbCWD

        CASE lbDirs

        CASE ListDirs

        CASE lbFiles

        CASE ListFiles

        CASE lbFile

        CASE ListFile

        CASE lbTxt

        CASE ListTxt

        CASE BtnStart

        CASE BtnEnd

        CASE lbStart

        CASE lbEnd

    END SELECT
END SUB

SUB __UI_KeyPress (id AS LONG)
    'When this event is fired, __UI_KeyHit will contain the code of the key hit.
    'You can change it and even cancel it by making it = 0
    SELECT CASE id
        CASE ListDirs

        CASE ListFiles

        CASE ListFile

        CASE ListTxt

        CASE BtnStart

        CASE BtnEnd

    END SELECT
END SUB

SUB __UI_TextChanged (id AS LONG)
    SELECT CASE id
    END SELECT
END SUB

SUB __UI_ValueChanged (id AS LONG)

    SELECT CASE id
        CASE ListDirs

        CASE ListFiles

        CASE ListFile

        CASE ListTxt

    END SELECT
END SUB

SUB __UI_FormResized

END SUB

'$INCLUDE:'../../InForm/InForm.ui'
'$INCLUDE:'../../InForm/xp.uitheme'
