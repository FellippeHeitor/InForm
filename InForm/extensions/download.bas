FUNCTION Download$ (url$, file$, timelimit) STATIC
    'as seen on http://www.qb64.org/wiki/Downloading_Files
    'adapted for use with InForm

    DIM theClient AS LONG, l AS LONG
    DIM prevUrl$, prevUrl2$, url2$, x AS LONG
    DIM e$, url3$, x$, t!, a2$, a$, i AS LONG
    DIM i2 AS LONG, i3 AS LONG, d$, fh AS LONG

    IF url$ <> prevUrl$ OR url$ = "" THEN
        prevUrl$ = url$
        IF url$ = "" THEN
            IF theClient THEN CLOSE theClient: theClient = 0
            EXIT FUNCTION
        END IF
        url2$ = url$
        x = INSTR(url2$, "/")
        IF x THEN url2$ = LEFT$(url$, x - 1)
        IF url2$ <> prevUrl2$ THEN
            prevUrl2$ = url2$
            IF theClient THEN CLOSE theClient: theClient = 0
            theClient = _OPENCLIENT("TCP/IP:80:" + url2$)
            IF theClient = 0 THEN Download = MKI$(2): prevUrl$ = "": EXIT FUNCTION
        END IF
        e$ = CHR$(13) + CHR$(10) ' end of line characters
        url3$ = RIGHT$(url$, LEN(url$) - x + 1)
        x$ = "GET " + url3$ + " HTTP/1.1" + e$
        x$ = x$ + "Host: " + url2$ + e$ + e$
        PUT #theClient, , x$
        t! = TIMER ' start time
    END IF

    GET #theClient, , a2$
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
                    prevUrl2$ = ""
                    a$ = ""
                    CLOSE theClient
                    theClient = 0
                    EXIT FUNCTION
                END IF ' availabledata = l
            END IF ' i3
        END IF ' i2
    END IF ' i
    IF TIMER > t! + timelimit THEN CLOSE theClient: theClient = 0: Download = MKI$(3): prevUrl$ = "": EXIT FUNCTION
    Download = MKI$(0) 'still working
END FUNCTION

