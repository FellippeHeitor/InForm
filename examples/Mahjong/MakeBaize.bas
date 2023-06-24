'Baize Background for Mahjong

SUB MakeBaize (Baize&)
    Baize& = _NEWIMAGE(ScreenX%, ScreenY%, 32)
    _DEST Baize&
    FOR N% = 0 TO ScreenX% - 1
        FOR M% = 0 TO ScreenY% - 1
            PSET (N%, M%), _RGB(0, 35 * RND, 150 + (50 * (1 - RND)))
        NEXT M%
    NEXT N%
    CALL QB64Logo(0, 502)
    CALL QB64Logo(500, 502)
END SUB
