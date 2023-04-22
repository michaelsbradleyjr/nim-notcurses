# L[num] comments below pertain to sources for Notcurses v3.0.9
# https://github.com/dankamongmen/notcurses/tree/v3.0.9/include

# this module uses extra whitespace so it can be visually scanned more easily

import ../wide

const
  # L9 - notcurses/ncseqs.h
  NCBOXLIGHTW*  = L"┌┐└┘─│"
  NCBOXHEAVYW*  = L"┏┓┗┛━┃"
  NCBOXROUNDW*  = L"╭╮╰╯─│"
  NCBOXDOUBLEW* = L"╔╗╚╝═║"
  NCBOXASCIIW*  = L("/\\\\/-|")
  NCBOXOUTERW*  = L"🭽🭾🭼🭿▁🭵🭶🭰"

  # L17 - notcurses/ncseqs.h
  NCWHITESQUARESW*   = L"◲◱◳◰"
  NCWHITECIRCLESW*   = L"◶◵◷◴"
  NCCIRCULARARCSW*   = L"◜◝◟◞"
  NCWHITETRIANGLESW* = L"◿◺◹◸"
  NCBLACKTRIANGLESW* = L"◢◣◥◤"
  NCSHADETRIANGLESW* = L"🮞🮟🮝🮜"

  # L25 - notcurses/ncseqs.h
  NCBLACKARROWHEADSW* = L"⮝⮟⮜⮞"
  NCLIGHTARROWHEADSW* = L"⮙⮛⮘⮚"
  NCARROWDOUBLEW*     = L"⮅⮇⮄⮆"
  NCARROWDASHEDW*     = L"⭫⭭⭪⭬"
  NCARROWCIRCLEDW*    = L"⮉⮋⮈⮊"
  NCARROWANTICLOCKW*  = L"⮏⮍⮎⮌"
  NCBOXDRAWW*         = L"╵╷╴╶"
  NCBOXDRAWHEAVYW*    = L"╹╻╸╺"

  # L35 - notcurses/ncseqs.h
  NCARROWW*     = L"⭡⭣⭠⭢⭧⭩⭦⭨"
  NCDIAGONALSW* = L"🮣🮠🮡🮢🮤🮥🮦🮧"

  # L39 - notcurses/ncseqs.h
  NCDIGITSSUPERW* = L"⁰¹²³⁴⁵⁶⁷⁸⁹"
  NCDIGITSSUBW*   = L"₀₁₂₃₄₅₆₇₈₉"

  # L43 - notcurses/ncseqs.h
  NCASTERISKS5* = L"🞯🞰🞱🞲🞳🞴"
  NCASTERISKS6* = L"🞵🞶🞷🞸🞹🞺"
  NCASTERISKS8* = L"🞻🞼✳🞽🞾🞿"

  # L48 - notcurses/ncseqs.h
  NCANGLESBR*   = L"🭁🭂🭃🭄🭅🭆🭇🭈🭉🭊🭋"
  NCANGLESTR*   = L"🭒🭓🭔🭕🭖🭧🭢🭣🭤🭥🭦"
  NCANGLESBL*   = L"🭌🭍🭎🭏🭐🭑🬼🬽🬾🬿🭀"
  NCANGLESTL*   = L"🭝🭞🭟🭠🭡🭜🭗🭘🭙🭚🭛"
  NCEIGHTHSB*   = L" ▁▂▃▄▅▆▇█"
  NCEIGHTHST*   = L" ▔🮂🮃▀🮄🮅🮆█"
  NCEIGHTHSL*   = L"▏▎▍▌▋▊▉█"
  NCEIGHTHSR*   = L"▕🮇🮈▐🮉🮊🮋█"
  NCHALFBLOCKS* = L" ▀▄█"
  NCQUADBLOCKS* = L" ▘▝▀▖▌▞▛▗▚▐▜▄▙▟█"
  NCSEXBLOCKS*  = L" 🬀🬁🬂🬃🬄🬅🬆🬇🬈🬊🬋🬌🬍🬎🬏🬐🬑🬒🬓▌🬔🬕🬖🬗🬘🬙🬚🬛🬜🬝🬞🬟🬠🬡🬢🬣🬤🬥🬦🬧▐🬨🬩🬪🬫🬬🬭🬮🬯🬰🬱🬲🬳🬴🬵🬶🬷🬸🬹🬺🬻█"

  # L59 - notcurses/ncseqs.h
  NCBRAILLEEGCS* = L"⠀⠁⠈⠉⠂⠃⠊⠋⠐⠑⠘⠙⠒⠓⠚⠛⠄⠅⠌⠍⠆⠇⠎⠏⠔⠕⠜⠝⠖⠗⠞⠟⠠⠡⠨⠩⠢⠣⠪⠫⠰⠱⠸⠹⠲⠳⠺⠻⠤⠥⠬⠭⠦⠧⠮⠯⠴⠵⠼⠽⠶⠷⠾⠿⡀⡁⡈⡉⡂⡃⡊⡋⡐⡑⡘⡙⡒⡓⡚⡛⡄⡅⡌⡍⡆⡇⡎⡏⡔⡕⡜⡝⡖⡗⡞⡟⡠⡡⡨⡩⡢⡣⡪⡫⡰⡱⡸⡹⡲⡳⡺⡻⡤⡥⡬⡭⡦⡧⡮⡯⡴⡵⡼⡽⡶⡷⡾⡿⢀⢁⢈⢉⢂⢃⢊⢋⢐⢑⢘⢙⢒⢓⢚⢛⢄⢅⢌⢍⢆⢇⢎⢏⢔⢕⢜⢝⢖⢗⢞⢟⢠⢡⢨⢩⢢⢣⢪⢫⢰⢱⢸⢹⢲⢳⢺⢻⢤⢥⢬⢭⢦⢧⢮⢯⢴⢵⢼⢽⢶⢷⢾⢿⣀⣁⣈⣉⣂⣃⣊⣋⣐⣑⣘⣙⣒⣓⣚⣛⣄⣅⣌⣍⣆⣇⣎⣏⣔⣕⣜⣝⣖⣗⣞⣟⣠⣡⣨⣩⣢⣣⣪⣫⣰⣱⣸⣹⣲⣳⣺⣻⣤⣥⣬⣭⣦⣧⣮⣯⣴⣵⣼⣽⣶⣷⣾⣿"

  # L76 - notcurses/ncseqs.h
  NCSEGDIGITS* = L"🯰🯱🯲🯳🯴🯵🯶🯷🯸🯹"

  # L79 - notcurses/ncseqs.h
  NCSUITSBLACK* = L"♠♣♥♦"
  NCSUITSWHITE* = L"♡♢♤♧"
  NCCHESSBLACK* = L"♟♜♞♝♛♚"
  # https://github.com/dankamongmen/notcurses/pull/2712
  # NCCHESSWHITE* = L"♙♖♘♗♕♔"
  NCCHESSWHITE* = L"♟♜♞♝♛♚"
  NCDICE*       = L"⚀⚁⚂⚃⚄⚅"
  NCMUSICSYM*   = L"♩♪♫♬♭♮♯"

  # L87 - notcurses/ncseqs.h
  NCBOXLIGHT*  = "┌┐└┘─│".cstring
  NCBOXHEAVY*  = "┏┓┗┛━┃".cstring
  NCBOXROUND*  = "╭╮╰╯─│".cstring
  NCBOXDOUBLE* = "╔╗╚╝═║".cstring
  NCBOXASCII*  = "/\\\\/-|".cstring
  NCBOXOUTER*  = "🭽🭾🭼🭿▁🭵🭶🭰".cstring
