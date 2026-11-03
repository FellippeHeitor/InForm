'-----------------------------------------------------------------------------------------------------------------------
' String related stuff
' Copyright (c) 2026 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

CONST __ASC_0~%% = 48~%%, __CHR_0 = CHR$(__ASC_0)
CONST __ASC_1~%% = 49~%%, __CHR_1 = CHR$(__ASC_1)
CONST __ASC_2~%% = 50~%%, __CHR_2 = CHR$(__ASC_2)
CONST __ASC_3~%% = 51~%%, __CHR_3 = CHR$(__ASC_3)
CONST __ASC_4~%% = 52~%%, __CHR_4 = CHR$(__ASC_4)
CONST __ASC_5~%% = 53~%%, __CHR_5 = CHR$(__ASC_5)
CONST __ASC_6~%% = 54~%%, __CHR_6 = CHR$(__ASC_6)
CONST __ASC_7~%% = 55~%%, __CHR_7 = CHR$(__ASC_7)
CONST __ASC_8~%% = 56~%%, __CHR_8 = CHR$(__ASC_8)
CONST __ASC_9~%% = 57~%%, __CHR_9 = CHR$(__ASC_9)
CONST __ASC_UPPER_A~%% = 65~%%, __CHR_UPPER_A = CHR$(__ASC_UPPER_A)
CONST __ASC_UPPER_B~%% = 66~%%, __CHR_UPPER_B = CHR$(__ASC_UPPER_B)
CONST __ASC_UPPER_C~%% = 67~%%, __CHR_UPPER_C = CHR$(__ASC_UPPER_C)
CONST __ASC_UPPER_D~%% = 68~%%, __CHR_UPPER_D = CHR$(__ASC_UPPER_D)
CONST __ASC_UPPER_E~%% = 69~%%, __CHR_UPPER_E = CHR$(__ASC_UPPER_E)
CONST __ASC_UPPER_F~%% = 70~%%, __CHR_UPPER_F = CHR$(__ASC_UPPER_F)
CONST __ASC_UPPER_G~%% = 71~%%, __CHR_UPPER_G = CHR$(__ASC_UPPER_G)
CONST __ASC_UPPER_H~%% = 72~%%, __CHR_UPPER_H = CHR$(__ASC_UPPER_H)
CONST __ASC_UPPER_I~%% = 73~%%, __CHR_UPPER_I = CHR$(__ASC_UPPER_I)
CONST __ASC_UPPER_J~%% = 74~%%, __CHR_UPPER_J = CHR$(__ASC_UPPER_J)
CONST __ASC_UPPER_K~%% = 75~%%, __CHR_UPPER_K = CHR$(__ASC_UPPER_K)
CONST __ASC_UPPER_L~%% = 76~%%, __CHR_UPPER_L = CHR$(__ASC_UPPER_L)
CONST __ASC_UPPER_M~%% = 77~%%, __CHR_UPPER_M = CHR$(__ASC_UPPER_M)
CONST __ASC_UPPER_N~%% = 78~%%, __CHR_UPPER_N = CHR$(__ASC_UPPER_N)
CONST __ASC_UPPER_O~%% = 79~%%, __CHR_UPPER_O = CHR$(__ASC_UPPER_O)
CONST __ASC_UPPER_P~%% = 80~%%, __CHR_UPPER_P = CHR$(__ASC_UPPER_P)
CONST __ASC_UPPER_Q~%% = 81~%%, __CHR_UPPER_Q = CHR$(__ASC_UPPER_Q)
CONST __ASC_UPPER_R~%% = 82~%%, __CHR_UPPER_R = CHR$(__ASC_UPPER_R)
CONST __ASC_UPPER_S~%% = 83~%%, __CHR_UPPER_S = CHR$(__ASC_UPPER_S)
CONST __ASC_UPPER_T~%% = 84~%%, __CHR_UPPER_T = CHR$(__ASC_UPPER_T)
CONST __ASC_UPPER_U~%% = 85~%%, __CHR_UPPER_U = CHR$(__ASC_UPPER_U)
CONST __ASC_UPPER_V~%% = 86~%%, __CHR_UPPER_V = CHR$(__ASC_UPPER_V)
CONST __ASC_UPPER_W~%% = 87~%%, __CHR_UPPER_W = CHR$(__ASC_UPPER_W)
CONST __ASC_UPPER_X~%% = 88~%%, __CHR_UPPER_X = CHR$(__ASC_UPPER_X)
CONST __ASC_UPPER_Y~%% = 89~%%, __CHR_UPPER_Y = CHR$(__ASC_UPPER_Y)
CONST __ASC_UPPER_Z~%% = 90~%%, __CHR_UPPER_Z = CHR$(__ASC_UPPER_Z)
CONST __ASC_LOWER_A~%% = 97~%%, __CHR_LOWER_A = CHR$(__ASC_LOWER_A)
CONST __ASC_LOWER_B~%% = 98~%%, __CHR_LOWER_B = CHR$(__ASC_LOWER_B)
CONST __ASC_LOWER_C~%% = 99~%%, __CHR_LOWER_C = CHR$(__ASC_LOWER_C)
CONST __ASC_LOWER_D~%% = 100~%%, __CHR_LOWER_D = CHR$(__ASC_LOWER_D)
CONST __ASC_LOWER_E~%% = 101~%%, __CHR_LOWER_E = CHR$(__ASC_LOWER_E)
CONST __ASC_LOWER_F~%% = 102~%%, __CHR_LOWER_F = CHR$(__ASC_LOWER_F)
CONST __ASC_LOWER_G~%% = 103~%%, __CHR_LOWER_G = CHR$(__ASC_LOWER_G)
CONST __ASC_LOWER_H~%% = 104~%%, __CHR_LOWER_H = CHR$(__ASC_LOWER_H)
CONST __ASC_LOWER_I~%% = 105~%%, __CHR_LOWER_I = CHR$(__ASC_LOWER_I)
CONST __ASC_LOWER_J~%% = 106~%%, __CHR_LOWER_J = CHR$(__ASC_LOWER_J)
CONST __ASC_LOWER_K~%% = 107~%%, __CHR_LOWER_K = CHR$(__ASC_LOWER_K)
CONST __ASC_LOWER_L~%% = 108~%%, __CHR_LOWER_L = CHR$(__ASC_LOWER_L)
CONST __ASC_LOWER_M~%% = 109~%%, __CHR_LOWER_M = CHR$(__ASC_LOWER_M)
CONST __ASC_LOWER_N~%% = 110~%%, __CHR_LOWER_N = CHR$(__ASC_LOWER_N)
CONST __ASC_LOWER_O~%% = 111~%%, __CHR_LOWER_O = CHR$(__ASC_LOWER_O)
CONST __ASC_LOWER_P~%% = 112~%%, __CHR_LOWER_P = CHR$(__ASC_LOWER_P)
CONST __ASC_LOWER_Q~%% = 113~%%, __CHR_LOWER_Q = CHR$(__ASC_LOWER_Q)
CONST __ASC_LOWER_R~%% = 114~%%, __CHR_LOWER_R = CHR$(__ASC_LOWER_R)
CONST __ASC_LOWER_S~%% = 115~%%, __CHR_LOWER_S = CHR$(__ASC_LOWER_S)
CONST __ASC_LOWER_T~%% = 116~%%, __CHR_LOWER_T = CHR$(__ASC_LOWER_T)
CONST __ASC_LOWER_U~%% = 117~%%, __CHR_LOWER_U = CHR$(__ASC_LOWER_U)
CONST __ASC_LOWER_V~%% = 118~%%, __CHR_LOWER_V = CHR$(__ASC_LOWER_V)
CONST __ASC_LOWER_W~%% = 119~%%, __CHR_LOWER_W = CHR$(__ASC_LOWER_W)
CONST __ASC_LOWER_X~%% = 120~%%, __CHR_LOWER_X = CHR$(__ASC_LOWER_X)
CONST __ASC_LOWER_Y~%% = 121~%%, __CHR_LOWER_Y = CHR$(__ASC_LOWER_Y)
CONST __ASC_LOWER_Z~%% = 122~%%, __CHR_LOWER_Z = CHR$(__ASC_LOWER_Z)

''' @brief Converts a character to lowercase.
''' @param c The ASCII code of the character to convert.
''' @return The ASCII code of the lowercase character.
FUNCTION Asc_ToLowercase~%% (c AS _UNSIGNED _BYTE)
    Asc_ToLowercase = _IIF(c >= __ASC_UPPER_A _ANDALSO c <= __ASC_UPPER_Z, c + 32, c)
END FUNCTION

''' @brief Converts a character to uppercase.
''' @param c The ASCII code of the character to convert.
''' @return The ASCII code of the uppercase character.
FUNCTION Asc_ToUppercase~%% (c AS _UNSIGNED _BYTE)
    Asc_ToUppercase = _IIF(c >= __ASC_LOWER_A _ANDALSO c <= __ASC_LOWER_Z, c - 32, c)
END FUNCTION

''' @brief Checks if a character is alphanumeric.
''' @param c The ASCII code of the character to check.
''' @return _TRUE if the character is alphanumeric, _FALSE otherwise.
FUNCTION Asc_IsAlphanumeric%% (c AS _UNSIGNED _BYTE)
    Asc_IsAlphanumeric = (c >= __ASC_0 _ANDALSO c <= __ASC_9) _ORELSE (c >= __ASC_UPPER_A _ANDALSO c <= __ASC_UPPER_Z) _ORELSE (c >= __ASC_LOWER_A _ANDALSO c <= __ASC_LOWER_Z)
END FUNCTION

''' @brief Checks if a character is alphabetic.
''' @param c The ASCII code of the character to check.
''' @return _TRUE if the character is alphabetic, _FALSE otherwise.
FUNCTION Asc_IsAlphabetic%% (c AS _UNSIGNED _BYTE)
    Asc_IsAlphabetic = (c >= __ASC_UPPER_A _ANDALSO c <= __ASC_UPPER_Z) _ORELSE (c >= __ASC_LOWER_A _ANDALSO c <= __ASC_LOWER_Z)
END FUNCTION

''' @brief Checks if a character is lowercase.
''' @param c The ASCII code of the character to check.
''' @return _TRUE if the character is lowercase, _FALSE otherwise.
FUNCTION Asc_IsLowercase%% (c AS _UNSIGNED _BYTE)
    Asc_IsLowercase = c >= __ASC_LOWER_A _ANDALSO c <= __ASC_LOWER_Z
END FUNCTION

''' @brief Checks if a character is uppercase.
''' @param c The ASCII code of the character to check.
''' @return _TRUE if the character is uppercase, _FALSE otherwise.
FUNCTION Asc_IsUppercase%% (c AS _UNSIGNED _BYTE)
    Asc_IsUppercase = c >= __ASC_UPPER_A _ANDALSO c <= __ASC_UPPER_Z
END FUNCTION

''' @brief Checks if a character is a decimal digit.
''' @param c The ASCII code of the character to check.
''' @return _TRUE if the character is a decimal digit, _FALSE otherwise.
FUNCTION Asc_IsDecimalDigit%% (c AS _UNSIGNED _BYTE)
    Asc_IsDecimalDigit = c >= __ASC_0 _ANDALSO c <= __ASC_9
END FUNCTION

''' @brief Checks if a character is a hexadecimal digit.
''' @param c The ASCII code of the character to check.
''' @return _TRUE if the character is a hexadecimal digit, _FALSE otherwise.
FUNCTION Asc_IsHexadecimalDigit%% (c AS _UNSIGNED _BYTE)
    Asc_IsHexadecimalDigit = (c >= __ASC_0 _ANDALSO c <= __ASC_9) _ORELSE (c >= __ASC_UPPER_A _ANDALSO c <= __ASC_UPPER_F) _ORELSE (c >= __ASC_LOWER_A _ANDALSO c <= __ASC_LOWER_F)
END FUNCTION

''' @brief Checks if a character is an octal digit.
''' @param c The ASCII code of the character to check.
''' @return _TRUE if the character is an octal digit, _FALSE otherwise.
FUNCTION Asc_IsOctalDigit%% (c AS _UNSIGNED _BYTE)
    Asc_IsOctalDigit = c >= __ASC_0 _ANDALSO c <= __ASC_7
END FUNCTION

''' @brief Checks if a character is a binary digit.
''' @param c The ASCII code of the character to check.
''' @return _TRUE if the character is a binary digit, _FALSE otherwise.
FUNCTION Asc_IsBinaryDigit%% (c AS _UNSIGNED _BYTE)
    Asc_IsBinaryDigit = c = __ASC_0 _ORELSE c = __ASC_1
END FUNCTION

''' @brief Checks if a character is a control character.
''' @param c The ASCII code of the character to check.
''' @return _TRUE if the character is a control character, _FALSE otherwise.
FUNCTION Asc_IsControlCharacter%% (c AS _UNSIGNED _BYTE)
    Asc_IsControlCharacter = c < _ASC_SPACE _ORELSE c = _ASC_DEL
END FUNCTION

''' @brief Checks if a character is whitespace.
''' @param c The ASCII code of the character to check.
''' @return _TRUE if the character is whitespace, _FALSE otherwise.
FUNCTION Asc_IsWhitespace%% (c AS _UNSIGNED _BYTE)
    Asc_IsWhitespace = c = _ASC_SPACE _ORELSE c = _ASC_HT _ORELSE c = _ASC_LF _ORELSE c = _ASC_VT _ORELSE c = _ASC_FF _ORELSE c = _ASC_CR
END FUNCTION

''' @brief Checks if a character is blank (space or horizontal tab).
''' @param c The ASCII code of the character to check.
''' @return _TRUE if the character is blank, _FALSE otherwise.
FUNCTION Asc_IsBlank%% (c AS _UNSIGNED _BYTE)
    Asc_IsBlank = c = _ASC_SPACE _ORELSE c = _ASC_HT
END FUNCTION

''' @brief Checks if a character is punctuation.
''' @param c The ASCII code of the character to check.
''' @return _TRUE if the character is punctuation, _FALSE otherwise.
FUNCTION Asc_IsPunctuation%% (c AS _UNSIGNED _BYTE)
    Asc_IsPunctuation = (c >= _ASC_EXCLAMATION _ANDALSO c <= _ASC_FORWARDSLASH) _ORELSE (c >= _ASC_COLON _ANDALSO c <= _ASC_ATSIGN) _ORELSE (c >= _ASC_LEFTSQUAREBRACKET _ANDALSO c <= _ASC_GRAVE) _ORELSE (c >= _ASC_LEFTCURLYBRACKET _ANDALSO c <= _ASC_TILDE)
END FUNCTION

''' @brief Converts a C-style string (null-terminated) to a BASIC string.
''' @param s The C-style string to convert.
''' @return The converted BASIC string.
FUNCTION String_ToBStr$ (s AS STRING)
    DIM nulPos AS _UNSIGNED LONG: nulPos = INSTR(s, _CHR_NUL)
    String_ToBStr = _IIF(nulPos, LEFT$(s, nulPos - 1), s)
END FUNCTION

''' @brief Converts a BASIC string to a C-style string (null-terminated).
''' @param s The BASIC string to convert.
''' @return The converted C-style string.
FUNCTION String_ToCStr$ (s AS STRING)
    String_ToCStr = s + _CHR_NUL
END FUNCTION

''' @brief Formats a string using a format string and a STRING argument.
''' @param fmtStr The format string.
''' @param s The STRING argument.
''' @return The formatted string.
FUNCTION String_FormatString$ (fmtStr AS STRING, s AS STRING)
    DECLARE LIBRARY
        SUB __String_FormatString ALIAS "snprintf" (buf AS STRING, BYVAL bufSize AS _UNSIGNED _OFFSET, fmt AS STRING, s AS STRING)
    END DECLARE

    DIM buffer AS STRING: buffer = STRING$(LEN(fmtStr) + LEN(s) + 16, _ASC_NUL)
    __String_FormatString buffer, LEN(buffer), String_ToCStr(fmtStr), String_ToCStr(s)

    String_FormatString = String_ToBStr(buffer)
END FUNCTION

''' @brief Formats a string using a format string and a LONG argument.
''' @param fmtStr The format string.
''' @param n The LONG argument.
''' @return The formatted string.
FUNCTION String_FormatLong$ (fmtStr AS STRING, n AS LONG)
    DECLARE LIBRARY
        SUB __String_FormatLong ALIAS "snprintf" (buf AS STRING, BYVAL bufSize AS _UNSIGNED _OFFSET, fmt AS STRING, BYVAL n AS LONG)
    END DECLARE

    DIM buffer AS STRING: buffer = STRING$(LEN(fmtStr) + 64, _ASC_NUL)
    __String_FormatLong buffer, LEN(buffer), String_ToCStr(fmtStr), n

    String_FormatLong = String_ToBStr(buffer)
END FUNCTION

''' @brief Formats a string using a format string and a _INTEGER64 argument.
''' @param fmtStr The format string.
''' @param n The _INTEGER64 argument.
''' @return The formatted string.
FUNCTION String_FormatInteger64$ (fmtStr AS STRING, n AS _INTEGER64)
    DECLARE LIBRARY
        SUB __String_FormatInteger64 ALIAS "snprintf" (buf AS STRING, BYVAL bufSize AS _UNSIGNED _OFFSET, fmt AS STRING, BYVAL n AS _INTEGER64)
    END DECLARE

    DIM buffer AS STRING: buffer = STRING$(LEN(fmtStr) + 128, _ASC_NUL)
    __String_FormatInteger64 buffer, LEN(buffer), String_ToCStr(fmtStr), n

    String_FormatInteger64 = String_ToBStr(buffer)
END FUNCTION

''' @brief Formats a string using a format string and a SINGLE argument.
''' @param fmtStr The format string.
''' @param f The SINGLE argument.
''' @return The formatted string.
FUNCTION String_FormatSingle$ (fmtStr AS STRING, f AS SINGLE)
    DECLARE LIBRARY
        SUB __String_FormatSingle ALIAS "snprintf" (buf AS STRING, BYVAL bufSize AS _UNSIGNED _OFFSET, fmt AS STRING, BYVAL f AS SINGLE)
    END DECLARE

    DIM buffer AS STRING: buffer = STRING$(LEN(fmtStr) + 256, _ASC_NUL)
    __String_FormatSingle buffer, LEN(buffer), String_ToCStr(fmtStr), f

    String_FormatSingle = String_ToBStr(buffer)
END FUNCTION

''' @brief Formats a string using a format string and a DOUBLE argument.
''' @param fmtStr The format string.
''' @param d The DOUBLE argument.
''' @return The formatted string.
FUNCTION String_FormatDouble$ (fmtStr AS STRING, d AS DOUBLE)
    DECLARE LIBRARY
        SUB __String_FormatDouble ALIAS "snprintf" (buf AS STRING, BYVAL bufSize AS _UNSIGNED _OFFSET, fmt AS STRING, BYVAL d AS DOUBLE)
    END DECLARE

    DIM buffer AS STRING: buffer = STRING$(LEN(fmtStr) + 512, _ASC_NUL)
    __String_FormatDouble buffer, LEN(buffer), String_ToCStr(fmtStr), d

    String_FormatDouble = String_ToBStr(buffer)
END FUNCTION
