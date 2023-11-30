' ebacCalculator.bas    Version 2.0  10/14/2021
'-----------------------------------------------------------------------------------
'       PROGRAM: ebacCalculator.bas
'        AUTHOR: George McGinn
'
'  DATE WRITTEN: 04/01/2021
'       VERSION: 2.0
'       PROJECT: Estimated Blood-Alcohol Content Calculator
'
'   DESCRIPTION: Program shows many of the functions of using InForm while using
'                most of the original code from the Zenity project. This can now
'                run on all systems (Linux, MAC and Windows).
'
' Written by George McGinn
' Copyright (C)2021 by George McGinn - All Rights Reserved
' Version 1.0 - Created 04/01/2021
' Version 2.0 - Created 10/14/2021
'
' CHANGE LOG
'-----------------------------------------------------------------------------------
' 04/01/2021 v1.0  GJM - New Program (TechBASIC and C++ Versions).
' 06/19/2021 v1.5  GJM - Updated to use Zenity and SHELL commands to run on Linux with
'                        a simple GUI.
' 10/14/2021 v2.0  GJM - Updated to use InForm GUI in place of Zenity an SHELL commands.
'                        Can now run on any OS
'-----------------------------------------------------------------------------------
'  Copyright (C)2021 by George McGinn.  All Rights Reserved.
'
' untitled.bas by George McGinn is licensed under a Creative Commons
' Attribution-NonCommercial 4.0 International. (CC BY-NC 4.0)
'
' Full License Link: https://creativecommons.org/licenses/by-nc/4.0/legalcode
'
'-----------------------------------------------------------------------------------
' PROGRAM NOTES
'
': This program uses
': InForm - GUI library for QB64 - v1.3
': Fellippe Heitor, 2016-2021 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------------------------------

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED maleRB AS LONG
DIM SHARED femaleRB AS LONG
DIM SHARED AgreeCB AS LONG
DIM SHARED AGREEBT AS LONG
DIM SHARED ebacFRM AS LONG
DIM SHARED SexLB AS LONG
DIM SHARED weightLB AS LONG
DIM SHARED nbrdrinksLB AS LONG
DIM SHARED timeLB AS LONG
DIM SHARED EnterInformationLB AS LONG
DIM SHARED WeightTB AS LONG
DIM SHARED nbrDrinksTB AS LONG
DIM SHARED TimeTB AS LONG
DIM SHARED CancelBT AS LONG
DIM SHARED OKBT AS LONG
DIM SHARED HELPBT AS LONG
DIM SHARED QUITBT AS LONG
DIM SHARED displayResults AS LONG
DIM SHARED informationLB AS LONG

': User-defined Variables: ---------------------------------------------------------
DIM SHARED AS STRING HELPFile
DIM SHARED AS INTEGER SOBER, legalToDrive
DIM SHARED AS STRING Sex
DIM SHARED AS DOUBLE A, T
DIM SHARED AS SINGLE B, OZ, Wt, EBAC

DIM SHARED AS STRING helpcontents, prt_text


': External modules: ---------------------------------------------------------------
'$INCLUDE:'../../InForm/extensions/MessageBox.bi'
'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'ebacCalculator.frm'
'$INCLUDE:'../../InForm/xp.uitheme'
'$INCLUDE:'../../InForm/InForm.ui'
'$INCLUDE:'../../InForm/extensions/MessageBox.bas'

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit

END SUB

SUB __UI_OnLoad

    ' *** Initialize Variables
    A = 0
    Wt = 0
    B = .0
    T = 0: St = 0
    I = 0
    Bdl = 1.055
    OZ = .5
    SOBER = FALSE: legalToDrive = FALSE
    HELPFile = "EBACHelp.txt"
    displayDisclaimer

END SUB

SUB __UI_BeforeUpdateDisplay
    'This event occurs at approximately 60 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%

END SUB

SUB __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.

END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE ebacFRM

        CASE SexLB

        CASE weightLB

        CASE nbrdrinksLB

        CASE timeLB

        CASE EnterInformationLB

        CASE WeightTB

        CASE nbrDrinksTB

        CASE TimeTB

        CASE informationLB

        CASE displayResults

        CASE AgreeCB

        CASE maleRB
            Sex = "M"

        CASE femaleRB
            Sex = "F"

        CASE AGREEBT
            Answer = MessageBox("Do you want to perform another calculation?             ", "", MsgBox_YesNo + MsgBox_Question)
            IF Answer = MsgBox_Yes THEN
                Control(AgreeCB).Value = FALSE
                Control(AGREEBT).Disabled = TRUE
            ELSE
                Answer = MessageBox("Thank You for using EBAC Calculator. Please Don't Drink and Drive.", "", MsgBox_Ok + MsgBox_Information)
                SYSTEM
            END IF

        CASE CancelBT
            ResetForm

        CASE OKBT
            IF Control(maleRB).Value = FALSE AND Control(femaleRB).Value = FALSE THEN
                Answer = MessageBox("Invalid: You must select either M (male) or F (female). Please Correct.", "", MsgBox_Ok + MsgBox_Information)
                EXIT SUB
            END IF
            A = Control(nbrDrinksTB).Value
            Wt = Control(WeightTB).Value
            T = Control(TimeTB).Value
            calcEBAC
            Control(QUITBT).Disabled = TRUE
            ResetList displayResults
            Text(displayResults) = prt_text

        CASE HELPBT
            ResetList displayResults
            IF _FILEEXISTS(HELPFile) THEN
                DIM fh AS LONG
                fh = FREEFILE
                OPEN HELPFile FOR INPUT AS #fh
                DO UNTIL EOF(fh)
                    LINE INPUT #fh, helpcontents
                    AddItem displayResults, helpcontents
                LOOP
                CLOSE #fh
                Control(displayResults).LastVisibleItem = 0
            ELSE
                Answer = MessageBox("HELP File " + HELPFile$ + " Not Found                             ", "", MsgBox_Ok + MsgBox_Question)
                SYSTEM 1
            END IF

        CASE QUITBT
            Answer = MessageBox("Are you sure you want to QUIT?                     ", "", MsgBox_YesNo + MsgBox_Question)
            IF Answer = MsgBox_Yes THEN
                Answer = MessageBox("Thank You for using EBAC Calculator. Please Don't Drink and Drive.", "", MsgBox_Ok + MsgBox_Information)
                SYSTEM
            END IF

    END SELECT
END SUB

SUB __UI_MouseEnter (id AS LONG)
END SUB

SUB __UI_MouseLeave (id AS LONG)
END SUB

SUB __UI_FocusIn (id AS LONG)
END SUB

SUB __UI_FocusOut (id AS LONG)
    'This event occurs right before a control loses focus.
    'To prevent a control from losing focus, set __UI_KeepFocus = True below.
END SUB

SUB __UI_MouseDown (id AS LONG)
END SUB

SUB __UI_MouseUp (id AS LONG)
END SUB

SUB __UI_KeyPress (id AS LONG)
    'When this event is fired, __UI_KeyHit will contain the code of the key hit.
    'You can change it and even cancel it by making it = 0
END SUB

SUB __UI_TextChanged (id AS LONG)
    SELECT CASE id

        CASE WeightTB
            Control(AgreeCB).Value = FALSE
            Control(AGREEBT).Disabled = TRUE

        CASE nbrDrinksTB
            Control(AgreeCB).Value = FALSE
            Control(AGREEBT).Disabled = TRUE

        CASE TimeTB
            Control(AgreeCB).Value = FALSE
            Control(AGREEBT).Disabled = TRUE

    END SELECT
END SUB

SUB __UI_ValueChanged (id AS LONG)
    SELECT CASE id

        CASE displayResults

        CASE maleRB
            Control(AgreeCB).Value = FALSE
            Control(AGREEBT).Disabled = TRUE

        CASE femaleRB
            Control(AgreeCB).Value = FALSE
            Control(AGREEBT).Disabled = TRUE

        CASE AgreeCB
            IF Control(AgreeCB).Value = TRUE THEN
                Control(AGREEBT).Disabled = FALSE
                Control(QUITBT).Disabled = FALSE
            ELSE
                Control(AGREEBT).Disabled = TRUE
                Control(QUITBT).Disabled = TRUE
            END IF

    END SELECT
END SUB

SUB __UI_FormResized
END SUB


': User FUNCTIONS/SUBROUTINES: ---------------------------------------------------------------

SUB displayDisclaimer

    '    prt_text = "*** DISCLAIMER ***" + CHR$(10)
    prt_text = "Unless otherwise separately undertaken by the Licensor, to the extent" + CHR$(10)
    prt_text = prt_text + "possible, the Licensor offers the Licensed Material as-is and" + CHR$(10)
    prt_text = prt_text + "as-available, and makes no representations or warranties of any kind" + CHR$(10)
    prt_text = prt_text + "concerning the Licensed Material, whether express, implied, statutory," + CHR$(10)
    prt_text = prt_text + "or other. This includes, without limitation, warranties of title," + CHR$(10)
    prt_text = prt_text + "merchantability, fitness for a particular purpose, non-infringement," + CHR$(10)
    prt_text = prt_text + "absence of latent or other defects, accuracy, or the presence or absence" + CHR$(10)
    prt_text = prt_text + "of errors, whether or not known or discoverable. Where disclaimers of" + CHR$(10)
    prt_text = prt_text + "warranties are not allowed in full or in part, this disclaimer may not" + CHR$(10)
    prt_text = prt_text + "apply to You." + CHR$(10) + CHR$(10)

    prt_text = prt_text + "To the extent possible, in no event will the Licensor be liable to You" + CHR$(10)
    prt_text = prt_text + "on any legal theory (including, without limitation, negligence) or" + CHR$(10)
    prt_text = prt_text + "otherwise for any direct, special, indirect, incidental, consequential," + CHR$(10)
    prt_text = prt_text + "punitive, exemplary, or other losses, costs, expenses, or damages" + CHR$(10)
    prt_text = prt_text + "arising out of this Public License or use of the Licensed Material, even" + CHR$(10)
    prt_text = prt_text + "if the Licensor has been advised of the possibility of such losses," + CHR$(10)
    prt_text = prt_text + "costs, expenses, or damages. Where a limitation of liability is not" + CHR$(10)
    prt_text = prt_text + "allowed in full or in part, this limitation may not apply to You." + CHR$(10) + CHR$(10)

    prt_text = prt_text + "The disclaimer of warranties and limitation of liability provided above" + CHR$(10)
    prt_text = prt_text + "shall be interpreted in a manner that, to the extent possible, most" + CHR$(10)
    prt_text = prt_text + "closely approximates an absolute disclaimer and waiver of all liability." + CHR$(10)

    Answer = MessageBox(prt_text, "*** DISCLAIMER ***", MsgBox_YesNo + MsgBox_Question)
    IF Answer = MsgBox_No THEN
        Answer = MessageBox("Sorry you don't agree. Please Don't Drink and Drive.", "", MsgBox_Ok + MsgBox_Information)
        SYSTEM
    END IF

END SUB


SUB ResetForm
    Control(nbrDrinksTB).Value = 0
    Control(WeightTB).Value = 0
    Control(TimeTB).Value = 0
    Control(AgreeCB).Value = FALSE
    Control(AGREEBT).Disabled = TRUE
    Control(maleRB).Value = FALSE
    Control(femaleRB).Value = FALSE
    ResetList displayResults
    Sex = ""
END SUB


SUB calcEBAC
    '-------------------------------------------------------------
    ' *** Convert Drinks into Fluid Ounces of EtOH (Pure Alcohol).
    ' *** A is number of drinks. 1 drink is about .6 FLoz of alcohol
    FLoz = A * OZ
    legalToDrive = FALSE

    '-----------------------------------------------------
    ' *** Set/calculate EBAC values based on Sex
    SELECT CASE Sex
        CASE "M"
            B = .017
            EBAC = 7.97 * FLoz / Wt - B * T
        CASE "F"
            B = .019
            EBAC = 9.86 * FLoz / Wt - B * T
    END SELECT

    IF EBAC < 0 THEN EBAC = 0

    '----------------------------------------------------------------------------------------------
    ' *** Populate the EBAC string with the EBAC value formatted to 3 decimal places for FORM output
    prt_text = "ESTIMATED BLOOD ALCOHOL CONTENT (EBAC) in g/dL = " + strFormat$(STR$(EBAC), "###.###") + CHR$(10) + CHR$(10)


    '-----------------------------------------------------------------------------------------
    ' *** Based on EBAC range values, populate the FORM output string with the approriate text
    SELECT CASE EBAC
        CASE .500 TO 100.9999
            prt_text = prt_text + "*** ALERT: CALL AN AMBULANCE, DEATH LIKELY" + CHR$(10)
            prt_text = prt_text + "Unconsious/coma, unresponsive, high likelihood of death. It is illegal" + CHR$(10) + _
                                  "to operate a motor vehicle at this level of intoxication in all states." + CHR$(10)
        CASE .400 TO .4999
            prt_text = prt_text + "*** ALERT: CALL AN AMBULANCE, DEATH POSSIBLE" + CHR$(10)
            prt_text = prt_text + "Onset of coma, and possible death due to respiratory arrest. It is illegal" + CHR$(10) + _
                                  "to operate a motor vehicle at this level of intoxication in all states." + CHR$(10)
        CASE .350 TO .3999
            prt_text = prt_text + "*** ALERT: CALL AN AMBULANCE, SEVERE ALCOHOL POISONING" + CHR$(10)
            prt_text = prt_text + " Coma is possible. This is the level of surgical anesthesia. It is illegal" + CHR$(10) + _
                                  "to operate a motor vehicle at this level of intoxication in all states." + CHR$(10)
        CASE .300 TO .3499
            prt_text = prt_text + "*** ALERT: YOU ARE IN A DRUNKEN STUP0R, AT RISK TO PASSING OUT" + CHR$(10)
            prt_text = prt_text + "STUPOR. You have little comprehension of where you are. You may pass out" + CHR$(10) + _
                                  "suddenly and be difficult to awaken. It is illegal to operate a motor" + CHR$(10) + _
                                  "vehicle at this level of intoxication in all states." + CHR$(10)
        CASE .250 TO .2999
            prt_text = prt_text + "*** ALERT: SEVERLY IMPAIRED - DRUNK ENOUGH TO CAUSE SEVERE INJURY/DEATH TO SELF" + CHR$(10)
            prt_text = prt_text + "All mental, physical and sensory functions are severely impaired." + CHR$(10) + _
                                  "Increased risk of asphyxiation from choking on vomit and of seriously injuring" + CHR$(10) + _
                                  "yourself by falls or other accidents. It is illegal to operate a motor" + CHR$(10) + _
                                  "vehicle at this level of intoxication in all states." + CHR$(10)
        CASE .200 TO .2499
            prt_text = prt_text + "YOU ARE EXTREMELY DRUNK" + CHR$(10)
            prt_text = prt_text + "Feeling dazed/confused or otherwise disoriented. May need help to" + CHR$(10) + _
                                  "stand/walk. If you injure yourself you may not feel the pain. Some" + CHR$(10) + _
                                  "people have nausea and vomiting at this level. The gag reflex" + CHR$(10) + _
                                  "is impaired and you can choke if you do vomit. Blackouts are likely" + CHR$(10) + _
                                  "at this level so you may not remember what has happened. It is illegal" + CHR$(10) + _
                                  "to operate a motor vehicle at this level of intoxication in all states." + CHR$(10)
        CASE .160 TO .1999
            prt_text = prt_text + "YOUR ARE SEVERLY DRUNK - ENOUGH TO BECOME VERY SICK" + CHR$(10)
            prt_text = prt_text + "Dysphoria* predominates, nausea may appear. The drinker has the appearance" + CHR$(10) + _
                                  "of a 'sloppy drunk.' It is illegal to operate a motor vehicle at this level" + CHR$(10) + _
                                  "of intoxication in all states." + CHR$(10) + CHR$(10) + _
                                  "* Dysphoria: An emotional state of anxiety, depression, or unease." + CHR$(10)
        CASE .130 TO .1599
            prt_text = prt_text + "YOU ARE VERY DRUNK - ENOUGH TO LOSE PHYSICAL & MENTAL CONTROL" + CHR$(10)
            prt_text = prt_text + "Gross motor impairment and lack of physical control. Blurred vision and major" + CHR$(10) + _
                                  "loss of balance. Euphoria is reduced and dysphoria* is beginning to appear." + CHR$(10) + _
                                  "Judgment and perception are severely impaired. It is illegal to operate a " + CHR$(10) + _
                                  "motor vehicle at this level of intoxication in all states." + CHR$(10) + CHR$(10)
            prt_text = prt_text + "* Dysphoria: An emotional state of anxiety, depression, or unease." + CHR$(10)
        CASE .100 TO .1299
            prt_text = prt_text + "YOU ARE LEGALLY DRUNK" + CHR$(10)
            prt_text = prt_text + "Significant impairment of motor coordination and loss of good judgment." + CHR$(10) + _
                                  "Speech may be slurred; balance, vision, reaction time and hearing will be" + CHR$(10) + _
                                  "impaired. Euphoria. It is illegal to operate a motor vehicle at this level" + CHR$(10) + _
                                  "of intoxication in all states." + CHR$(10)
        CASE .070 TO .0999
            prt_text = prt_text + "YOU MAY BE LEGALLY DRUNK" + CHR$(10)
            prt_text = prt_text + "Slight impairment of balance, speech, vision, reaction time, and hearing." + CHR$(10) + _
                                  "Euphoria. Judgment and self-control are reduced, and caution, reason and" + CHR$(10) + _
                                  "memory are impaired (in some* states .08 is legally impaired and it is illegal" + CHR$(10) + _
                                  "to drive at this level). You will probably believe that you are functioning" + CHR$(10) + _
                                  "better than you really are." + CHR$(10) + CHR$(10)
            prt_text = prt_text + "(*** As of July, 2004 ALL states had passed .08 BAC Per Se Laws. The final" + CHR$(10) + _
                                  "one took effect in August of 2005.)" + CHR$(10)
        CASE .040 TO .0699
            prt_text = prt_text + "YOU MAY BE LEGALLY BUZZED" + CHR$(10)
            prt_text = prt_text + "Feeling of well-being, relaxation, lower inhibitions, sensation of warmth." + CHR$(10) + _
                                  "Euphoria. Some minor impairment of reasoning and memory, lowering of caution." + CHR$(10) + _
                                  "Your behavior may become exaggerated and emotions intensified (Good emotions" + CHR$(10) + _
                                  "are better, bad emotions are worse)" + CHR$(10)
        CASE .020 TO .0399
            prt_text = prt_text + "YOU MAY BE OK TO DRIVE, BUT IMPAIRMENT BEGINS" + CHR$(10)
            prt_text = prt_text + "No loss of coordination, slight euphoria and loss of shyness. Depressant effects" + CHR$(10) + _
                                  "are not apparent. Mildly relaxed and maybe a little lightheaded." + CHR$(10)
        CASE .000 TO .0199
            prt_text = prt_text + "YOU ARE OK TO DRIVE" + CHR$(10)
    END SELECT

    '-----------------------------------------------------------
    '*** Determine if Drunk (>.08 EBAC) and calculate:
    '***    - When user will be less than .08
    '***    - How long it will take to become completely sober
    IF EBAC > .08 THEN
        SOBER = FALSE
        CEBAC = EBAC
        st = T
        DO UNTIL SOBER = TRUE
            T = T + 1
            IF CEBAC > .0799 THEN I = I + 1

            SELECT CASE Sex
                CASE "M"
                    B = .017
                    CEBAC = 7.97 * FLoz / Wt - B * T
                CASE "F"
                    B = .019
                    CEBAC = 9.86 * FLoz / Wt - B * T
            END SELECT

            IF legalToDrive = FALSE THEN
                IF CEBAC < .08 THEN
                    prt_text = prt_text + CHR$(10) + CHR$(10) + "It will take about " + strFormat$(STR$(I), "##") + " hours from your last drink to be able to drive." + CHR$(10)
                    legalToDrive = TRUE
                END IF
            END IF

            IF CEBAC <= 0 THEN
                prt_text = prt_text + "It will take about " + strFormat$(STR$(T - st), "##") + " hours from your last drink to be completely sober."
                SOBER = TRUE
            END IF
        LOOP
    END IF

END SUB


FUNCTION strFormat$ (text AS STRING, template AS STRING)
    '-----------------------------------------------------------------------------
    ' *** Return a formatted string to a variable
    '
    d = _DEST: s = _SOURCE
    n = _NEWIMAGE(80, 80, 0)
    _DEST n: _SOURCE n
    PRINT USING template; VAL(text)
    FOR i = 1 TO 79
        t$ = t$ + CHR$(SCREEN(1, i))
    NEXT
    IF LEFT$(t$, 1) = "%" THEN t$ = MID$(t$, 2)
    strFormat$ = _TRIM$(t$)
    _DEST d: _SOURCE s
    _FREEIMAGE n
END FUNCTION
