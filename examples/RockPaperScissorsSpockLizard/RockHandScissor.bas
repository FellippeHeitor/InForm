': This program uses
': InForm - GUI library for QB64 - Beta version 7
': Fellippe Heitor, 2016-2018 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

CONST paper = 1, rock = 2, scissor = 3, spok = 4, lizard = 5, draws = 2, looses = 3, wins = 1

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED PlayerChoose AS INTEGER ' flag for user choice
DIM SHARED RockHandScissor AS LONG
DIM SHARED Frame1 AS LONG
DIM SHARED Frame2 AS LONG
DIM SHARED ScoreLB AS LONG
DIM SHARED StartBT AS LONG
DIM SHARED ExitBT AS LONG
DIM SHARED HelpBT AS LONG
DIM SHARED LB AS LONG
DIM SHARED ROCKPAPERSCISSORGAMELB AS LONG
DIM SHARED ChooseYourMoveAndWaitAIsOneLB AS LONG
DIM SHARED assetscartajpegPX AS LONG
DIM SHARED assetssassojpegPX AS LONG
DIM SHARED assetsforbicepngPX AS LONG
DIM SHARED assetsRPSLS_helpjpgPX AS LONG
DIM SHARED assetsspokpngPX AS LONG
DIM SHARED assetslizardpngPX AS LONG

'$INCLUDE:'../../InForm/InForm.bi'
'$INCLUDE:'RockHandScissor.frm'
'$INCLUDE:'../../InForm/InForm.ui'

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit

END SUB

SUB __UI_OnLoad
    _SCREENMOVE _MIDDLE
    Caption(LB) = "0000"
    PlayerChoose = 0
    RANDOMIZE TIMER
    Control(ChooseYourMoveAndWaitAIsOneLB).Hidden = TRUE ' hide help label
    Control(ChooseYourMoveAndWaitAIsOneLB).Disabled = TRUE
    Control(Frame2).Hidden = TRUE ' hide frame2
    Control(Frame2).Disabled = TRUE
END SUB

SUB __UI_BeforeUpdateDisplay
    'This event occurs at approximately 30 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%


    IF PlayerChoose = 20 THEN ' wait 2 sec
        in! = TIMER
        DO WHILE TIMER - in! < 2
        LOOP
        restoreGame
    END IF
    IF PlayerChoose THEN PlayerChoose = PlayerChoose + 1 ' here we pass one time(20 frames) into sub_Display before to reset the game
END SUB

SUB __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.

END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE Frame2

        CASE ROCKPAPERSCISSORGAMELB

        CASE assetsRPSLS_helpjpgPX

        CASE assetscartajpegPX
            ' user chooses to play paper
            Control(assetssassojpegPX).Disabled = TRUE ' hide images of rock and scissor
            Control(assetsforbicepngPX).Disabled = TRUE
            Control(assetsspokpngPX).Disabled = TRUE
            Control(assetslizardpngPX).Disabled = TRUE
            Control(assetssassojpegPX).Hidden = TRUE
            Control(assetsforbicepngPX).Hidden = TRUE
            Control(assetsspokpngPX).Hidden = TRUE
            Control(assetslizardpngPX).Hidden = TRUE
            Control(assetsRPSLS_helpjpgPX).Disabled = TRUE ' hide AI's choice
            Control(assetsRPSLS_helpjpgPX).Hidden = TRUE
            playAI paper
        CASE assetssassojpegPX
            ' user chooses to play rock
            Control(assetscartajpegPX).Disabled = TRUE ' hide paper and scissor
            Control(assetsforbicepngPX).Disabled = TRUE
            Control(assetsspokpngPX).Disabled = TRUE
            Control(assetslizardpngPX).Disabled = TRUE
            Control(assetsspokpngPX).Hidden = TRUE
            Control(assetslizardpngPX).Hidden = TRUE
            Control(assetscartajpegPX).Hidden = TRUE
            Control(assetsforbicepngPX).Hidden = TRUE
            Control(assetsRPSLS_helpjpgPX).Disabled = TRUE ' hide AI's choice
            Control(assetsRPSLS_helpjpgPX).Hidden = TRUE
            playAI rock
        CASE assetsforbicepngPX
            'user chooses to play scissor
            Control(assetssassojpegPX).Disabled = TRUE ' hide  rock and paper
            Control(assetscartajpegPX).Disabled = TRUE
            Control(assetsspokpngPX).Disabled = TRUE
            Control(assetslizardpngPX).Disabled = TRUE
            Control(assetsspokpngPX).Hidden = TRUE
            Control(assetslizardpngPX).Hidden = TRUE
            Control(assetssassojpegPX).Hidden = TRUE
            Control(assetscartajpegPX).Hidden = TRUE
            Control(assetsRPSLS_helpjpgPX).Disabled = TRUE ' hide AI's choice
            Control(assetsRPSLS_helpjpgPX).Hidden = TRUE
            playAI scissor
        CASE assetsspokpngPX
            Control(assetssassojpegPX).Disabled = TRUE ' hide  rock and paper
            Control(assetscartajpegPX).Disabled = TRUE
            Control(assetsforbicepngPX).Disabled = TRUE
            Control(assetslizardpngPX).Disabled = TRUE
            Control(assetsforbicepngPX).Hidden = TRUE
            Control(assetslizardpngPX).Hidden = TRUE
            Control(assetssassojpegPX).Hidden = TRUE
            Control(assetscartajpegPX).Hidden = TRUE
            playAI spok
        CASE assetslizardpngPX
            Control(assetssassojpegPX).Disabled = TRUE ' hide  rock and paper
            Control(assetscartajpegPX).Disabled = TRUE
            Control(assetsspokpngPX).Disabled = TRUE
            Control(assetsforbicepngPX).Disabled = TRUE
            Control(assetsspokpngPX).Hidden = TRUE
            Control(assetsforbicepngPX).Hidden = TRUE
            Control(assetssassojpegPX).Hidden = TRUE
            Control(assetscartajpegPX).Hidden = TRUE
            playAI lizard
        CASE RockHandScissor

        CASE ScoreLB

        CASE Frame1

        CASE StartBT
            Control(HelpBT).Disabled = TRUE
            Control(Frame2).Hidden = FALSE ' show frame2
            Control(Frame2).Disabled = FALSE
            Control(assetssassojpegPX).Disabled = FALSE ' show and activate 3 image buttons for user
            Control(assetsforbicepngPX).Disabled = FALSE
            Control(assetscartajpegPX).Disabled = FALSE
            Control(assetsspokpngPX).Disabled = FALSE
            Control(assetslizardpngPX).Disabled = FALSE
            Control(assetssassojpegPX).Hidden = FALSE
            Control(assetsforbicepngPX).Hidden = FALSE
            Control(assetscartajpegPX).Hidden = FALSE
            Control(assetsspokpngPX).Hidden = FALSE
            Control(assetslizardpngPX).Hidden = FALSE

            Control(assetsRPSLS_helpjpgPX).Hidden = TRUE ' hide help/AI image
            Control(assetsRPSLS_helpjpgPX).Disabled = TRUE
            Control(ChooseYourMoveAndWaitAIsOneLB).Hidden = TRUE ' hide help label
            Control(ChooseYourMoveAndWaitAIsOneLB).Disabled = TRUE

        CASE ExitBT
            SYSTEM ' exit from program
        CASE HelpBT

            IF Control(ChooseYourMoveAndWaitAIsOneLB).Disabled = FALSE THEN
                ' here we reactivate the game
                Control(StartBT).Disabled = FALSE
                Control(ChooseYourMoveAndWaitAIsOneLB).Hidden = TRUE ' hide help label
                Control(ChooseYourMoveAndWaitAIsOneLB).Disabled = TRUE
                Caption(ChooseYourMoveAndWaitAIsOneLB) = "Choose your move and wait AI's one"
                Control(Frame2).Hidden = TRUE ' hide frame2
                Control(Frame2).Disabled = TRUE
                Control(assetssassojpegPX).Disabled = FALSE ' activate 5 image button for user
                Control(assetsforbicepngPX).Disabled = FALSE
                Control(assetscartajpegPX).Disabled = FALSE
                Control(assetsspokpngPX).Disabled = FALSE
                Control(assetslizardpngPX).Disabled = FALSE
                Control(assetssassojpegPX).Hidden = FALSE
                Control(assetsforbicepngPX).Hidden = FALSE
                Control(assetscartajpegPX).Hidden = FALSE
                Control(assetsspokpngPX).Hidden = FALSE
                Control(assetslizardpngPX).Hidden = FALSE

            ELSE
                ' here we show the help
                Control(StartBT).Disabled = TRUE 'disable help button
                Caption(ChooseYourMoveAndWaitAIsOneLB) = "Choose your move and wait AI's one"
                Control(ChooseYourMoveAndWaitAIsOneLB).Hidden = FALSE ' show help label
                Control(ChooseYourMoveAndWaitAIsOneLB).Disabled = FALSE
                Control(assetssassojpegPX).Disabled = TRUE ' hide 5 image button for user
                Control(assetsforbicepngPX).Disabled = TRUE
                Control(assetscartajpegPX).Disabled = TRUE
                Control(assetsspokpngPX).Disabled = TRUE
                Control(assetslizardpngPX).Disabled = TRUE
                Control(assetssassojpegPX).Hidden = TRUE
                Control(assetsforbicepngPX).Hidden = TRUE
                Control(assetscartajpegPX).Hidden = TRUE
                Control(assetsspokpngPX).Hidden = TRUE
                Control(assetslizardpngPX).Hidden = TRUE
                Control(Frame2).Hidden = FALSE 'show frame2
                Control(Frame2).Disabled = FALSE
                LoadImage Control(assetsRPSLS_helpjpgPX), "assets\RPSLS_help.jpg" ' load and show help picture
                Control(assetsRPSLS_helpjpgPX).Redraw = TRUE
            END IF
        CASE LB

        CASE ROCKHANDSCISSORGAMELB

        CASE ChooseYourMoveAndWaitAIsOneLB

    END SELECT
END SUB

SUB restoreGame
    Control(assetssassojpegPX).Disabled = FALSE 'activate 5 image buttons for user
    Control(assetsforbicepngPX).Disabled = FALSE
    Control(assetscartajpegPX).Disabled = FALSE
    Control(assetsspokpngPX).Disabled = FALSE
    Control(assetslizardpngPX).Disabled = FALSE
    Control(assetsspokpngPX).Hidden = FALSE
    Control(assetslizardpngPX).Hidden = FALSE
    Control(assetssassojpegPX).Hidden = FALSE
    Control(assetsforbicepngPX).Hidden = FALSE
    Control(assetscartajpegPX).Hidden = FALSE
    Control(HelpBT).Disabled = FALSE ' activate help button
    Control(assetsRPSLS_helpjpgPX).Redraw = TRUE ' force to show AI's choice
    PlayerChoose = 0 ' reset the chooser game
END SUB

SUB results (result AS INTEGER)
    'here there is the output sound + images for user
    ' and adjourn  score of game
    Control(assetsRPSLS_helpjpgPX).Hidden = FALSE ' show image of ai's choice
    Control(assetsRPSLS_helpjpgPX).Disabled = FALSE
    Control(assetsRPSLS_helpjpgPX).Redraw = TRUE ' force to show image of ai's choice
    SELECT CASE result
        CASE wins
            Caption(LB) = STR$(VAL(Caption(LB)) + 10)
            Caption(ChooseYourMoveAndWaitAIsOneLB) = " YOU WIN!! "
        CASE draws
            Caption(LB) = STR$(VAL(Caption(LB)) + 5)
            Caption(ChooseYourMoveAndWaitAIsOneLB) = " YOU DRAW!! "
        CASE looses
            Caption(LB) = STR$(VAL(Caption(LB)) - 10)
            Caption(ChooseYourMoveAndWaitAIsOneLB) = " YOU LOOSE!! "
    END SELECT
    Control(ChooseYourMoveAndWaitAIsOneLB).Hidden = FALSE 'show result as text in helplabel
    Control(ChooseYourMoveAndWaitAIsOneLB).Disabled = FALSE
END SUB

SUB playAI (choose AS INTEGER)
    PlayerChoose = 1 ' the user has made his choice
    DIM choosen AS INTEGER
    choosen = INT(RND * 5) + 1 ' ai chooses
    Control(ChooseYourMoveAndWaitAIsOneLB).Hidden = TRUE ' hide help label
    Control(ChooseYourMoveAndWaitAIsOneLB).Disabled = TRUE
    LoadImage Control(assetsRPSLS_helpjpgPX), "" ' reset to null image of ai's choice

    SELECT CASE choosen
        CASE paper
            ' AI chooses to play paper
            LoadImage Control(assetsRPSLS_helpjpgPX), "assets\carta.jpg"
            SELECT CASE choose
                CASE paper
                    'draw
                    results draws
                CASE rock
                    ' failure
                    results looses
                CASE scissor
                    ' victory
                    results wins
                CASE spok
                    ' failure
                    results looses
                CASE lizard
                    ' victory
                    results wins
            END SELECT

        CASE rock
            ' AI chooses to play rock
            LoadImage Control(assetsRPSLS_helpjpgPX), "assets\sasso.jpg"
            SELECT CASE choose
                CASE paper
                    'victory
                    results wins
                CASE rock
                    ' draw
                    results draws
                CASE scissor
                    ' loose
                    results looses
                CASE spok
                    'victory
                    results wins
                CASE lizard
                    ' loose
                    results looses
            END SELECT

        CASE scissor
            ' AI chooses to play scissor
            LoadImage Control(assetsRPSLS_helpjpgPX), "assets\forbice.png"
            SELECT CASE choose
                CASE paper
                    'failure
                    results looses
                CASE rock
                    ' victory
                    results wins
                CASE scissor
                    ' draw
                    results draws
                CASE spok
                    ' victory
                    results wins
                CASE lizard
                    'failure
                    results looses
            END SELECT
        CASE spok
            ' AI chooses to play spok
            LoadImage Control(assetsRPSLS_helpjpgPX), "assets\Spok.png"
            SELECT CASE choose
                CASE paper
                    ' victory
                    results wins
                CASE rock
                    'failure
                    results looses
                CASE scissor
                    'failure
                    results looses
                CASE spok
                    ' draw
                    results draws
                CASE lizard
                    ' victory
                    results wins
            END SELECT
        CASE lizard
            'AI chooses to play lizard
            LoadImage Control(assetsRPSLS_helpjpgPX), "assets\lizard.png"
            SELECT CASE choose
                CASE paper
                    'failure
                    results looses
                CASE rock
                    ' victory
                    results wins
                CASE scissor
                    ' victory
                    results wins
                CASE spok
                    'failure
                    results looses
                CASE lizard
                    ' draw
                    results draws
            END SELECT
    END SELECT
END SUB


SUB __UI_MouseEnter (id AS LONG)
    SELECT CASE id
        CASE Frame2

        CASE LB

        CASE ROCKPAPERSCISSORGAMELB

        CASE ChooseYourMoveAndWaitAIsOneLB

        CASE assetscartajpegPX

        CASE assetssassojpegPX

        CASE assetsforbicepngPX

        CASE assetsRPSLS_helpjpgPX

        CASE assetsspokpngPX

        CASE assetslizardpngPX

        CASE RockHandScissor

        CASE ScoreLB

        CASE Frame1

        CASE StartBT

        CASE ExitBT

        CASE HelpBT

        CASE ScoreNLB

        CASE ROCKHANDSCISSORGAMELB



    END SELECT
END SUB

SUB __UI_MouseLeave (id AS LONG)
    SELECT CASE id
        CASE Frame2

        CASE LB

        CASE ROCKPAPERSCISSORGAMELB

        CASE assetscartajpegPX

        CASE assetssassojpegPX

        CASE assetsforbicepngPX

        CASE assetsRPSLS_helpjpgPX

        CASE assetsspokpngPX

        CASE assetslizardpngPX

        CASE RockHandScissor

        CASE ScoreLB

        CASE Frame1

        CASE StartBT

        CASE ExitBT

        CASE HelpBT

        CASE ScoreNLB

        CASE ROCKHANDSCISSORGAMELB

        CASE ChooseYourMoveAndWaitAIsOneLB

    END SELECT
END SUB

SUB __UI_FocusIn (id AS LONG)
    SELECT CASE id
        CASE StartBT

        CASE ExitBT

        CASE HelpBT

    END SELECT
END SUB

SUB __UI_FocusOut (id AS LONG)
    'This event occurs right before a control loses focus.
    'To prevent a control from losing focus, set __UI_KeepFocus = True below.
    SELECT CASE id
        CASE StartBT

        CASE ExitBT

        CASE HelpBT

    END SELECT
END SUB

SUB __UI_MouseDown (id AS LONG)
    SELECT CASE id
        CASE Frame2

        CASE LB

        CASE ROCKPAPERSCISSORGAMELB

        CASE ChooseYourMoveAndWaitAIsOneLB

        CASE assetscartajpegPX

        CASE assetssassojpegPX

        CASE assetsforbicepngPX

        CASE assetsRPSLS_helpjpgPX

        CASE assetsspokpngPX

        CASE assetslizardpngPX

        CASE RockHandScissor

        CASE ScoreLB

        CASE Frame1

        CASE StartBT

        CASE ExitBT

        CASE HelpBT

        CASE ScoreNLB

        CASE ROCKHANDSCISSORGAMELB

        CASE HelpHLB

    END SELECT
END SUB

SUB __UI_MouseUp (id AS LONG)
    SELECT CASE id
        CASE Frame2

        CASE LB

        CASE ROCKPAPERSCISSORGAMELB

        CASE ChooseYourMoveAndWaitAIsOneLB

        CASE assetscartajpegPX

        CASE assetssassojpegPX

        CASE assetsforbicepngPX

        CASE assetsRPSLS_helpjpgPX

        CASE assetsspokpngPX

        CASE assetslizardpngPX

        CASE RockHandScissor

        CASE ScoreLB

        CASE Frame1

        CASE StartBT

        CASE ExitBT

        CASE HelpBT

        CASE ScoreNLB

        CASE ROCKHANDSCISSORGAMELB

        CASE HelpHLB

    END SELECT
END SUB

SUB __UI_KeyPress (id AS LONG)
    'When this event is fired, __UI_KeyHit will contain the code of the key hit.
    'You can change it and even cancel it by making it = 0
    SELECT CASE id
        CASE StartBT

        CASE ExitBT

        CASE HelpBT

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
