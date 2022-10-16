Function Download$ (url$, file$, timelimit) Static
    'as seen on http://www.qb64.org/wiki/Downloading_Files
    'adapted for use with InForm

    Dim theClient As Long, l As Long
    Dim prevUrl$, prevUrl2$, url2$, x As Long
    Dim e$, url3$, x$, t!, a2$, a$, i As Long
    Dim i2 As Long, i3 As Long, d$, fh As Long

    If url$ <> prevUrl$ Or url$ = "" Then
        prevUrl$ = url$
        If url$ = "" Then
            If theClient Then Close theClient: theClient = 0
            Exit Function
        End If
        url2$ = url$
        x = InStr(url2$, "/")
        If x Then url2$ = Left$(url$, x - 1)
        If url2$ <> prevUrl2$ Then
            prevUrl2$ = url2$
            If theClient Then Close theClient: theClient = 0
            theClient = _OpenClient("TCP/IP:80:" + url2$)
            If theClient = 0 Then Download = MKI$(2): prevUrl$ = "": Exit Function
        End If
        e$ = Chr$(13) + Chr$(10) ' end of line characters
        url3$ = Right$(url$, Len(url$) - x + 1)
        x$ = "GET " + url3$ + " HTTP/1.1" + e$
        x$ = x$ + "Host: " + url2$ + e$ + e$
        Put #theClient, , x$
        t! = Timer ' start time
    End If

    Get #theClient, , a2$
    a$ = a$ + a2$
    i = InStr(a$, "Content-Length:")
    If i Then
        i2 = InStr(i, a$, e$)
        If i2 Then
            l = Val(Mid$(a$, i + 15, i2 - i - 14))
            i3 = InStr(i2, a$, e$ + e$)
            If i3 Then
                i3 = i3 + 4 'move i3 to start of data
                If (Len(a$) - i3 + 1) = l Then
                    d$ = Mid$(a$, i3, l)
                    fh = FreeFile
                    Open file$ For Output As #fh: Close #fh 'Warning! Clears data from existing file
                    Open file$ For Binary As #fh
                    Put #fh, , d$
                    Close #fh
                    Download = MKI$(1) + MKL$(l) 'indicates download was successful
                    prevUrl$ = ""
                    prevUrl2$ = ""
                    a$ = ""
                    Close theClient
                    theClient = 0
                    Exit Function
                End If ' availabledata = l
            End If ' i3
        End If ' i2
    End If ' i
    If Timer > t! + timelimit Then Close theClient: theClient = 0: Download = MKI$(3): prevUrl$ = "": Exit Function
    Download = MKI$(0) 'still working
End Function
