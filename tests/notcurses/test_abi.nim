# this module uses extra whitespace so it can be visually scanned more easily

import std/macros
import pkg/unittest2
import notcurses/abi

when not defined(windows):
  suite "ABI tests":
    setup:
      let flags = NCOPTION_CLI_MODE or NCOPTION_DRAIN_INPUT or NCOPTION_SUPPRESS_BANNERS
      var opts = notcurses_options(flags: flags)
      let nc = notcurses_init(addr opts, stdout)
      if nc.isNil: raise (ref Defect)(msg: "Notcurses failed to initialize")

    teardown:
      let code = notcurses_stop nc
      if code < 0: raise (ref Defect)(msg: "Notcurses failed to stop")
      discard

    test "test 1":
      check: true

    test "test 2":
      check: true

# wide string literals in notcurses/notcurses.h are defined in
# abi/constants.nim as Nim `const` via `macro L` that calculates at
# compile-time arrays of wchar_t (type Wchar); it's also possible to access
# those wide strings via importc (two possibilities: as normal arrays of known
# length, or as ptr UncheckedArray)

# to ensure that `macro L` is implemented correctly, a test is provided below
# that compares arrays generated with `macro L` and those accessed via importc

const ncseqsNames = [
  "NCBOXLIGHTW",
  "NCBOXHEAVYW",
  "NCBOXROUNDW",
  "NCBOXDOUBLEW",
  "NCBOXASCIIW",
  "NCBOXOUTERW",
  "NCWHITESQUARESW",
  "NCWHITECIRCLESW",
  "NCCIRCULARARCSW",
  "NCWHITETRIANGLESW",
  "NCBLACKTRIANGLESW",
  "NCSHADETRIANGLESW",
  "NCBLACKARROWHEADSW",
  "NCLIGHTARROWHEADSW",
  "NCARROWDOUBLEW",
  "NCARROWDASHEDW",
  "NCARROWCIRCLEDW",
  "NCARROWANTICLOCKW",
  "NCBOXDRAWW",
  "NCBOXDRAWHEAVYW",
  "NCARROWW",
  "NCDIAGONALSW",
  "NCDIGITSSUPERW",
  "NCDIGITSSUBW",
  "NCASTERISKS5",
  "NCASTERISKS6",
  "NCASTERISKS8",
  "NCANGLESBR",
  "NCANGLESTR",
  "NCANGLESBL",
  "NCANGLESTL",
  "NCEIGHTHSB",
  "NCEIGHTHST",
  "NCEIGHTHSL",
  "NCEIGHTHSR",
  "NCHALFBLOCKS",
  "NCQUADBLOCKS",
  "NCSEXBLOCKS",
  "NCBRAILLEEGCS",
  "NCSEGDIGITS",
  "NCSUITSBLACK",
  "NCSUITSWHITE",
  "NCCHESSBLACK",
  "NCCHESSWHITE",
  "NCDICE",
  "NCMUSICSYM"
]

macro mkImpc(names: static openArray[string]): untyped =
  # debugEcho names
  result = newStmtList()
  for name in names:
    let
      cname = ident(name)
      impc_aw = ident(name & "_impc_aw")
      impc_puaw = ident(name & "_impc_puaw")
    result.add quote do:
      # can be `let` instead of `var` with recent enough releases of Nim 1.4+
      var
        `impc_aw` {.header: "notcurses/ncseqs.h", importc: `name`, nodecl.}: array[`cname`.len, Wchar]
        `impc_puaw` {.header: "notcurses/ncseqs.h", importc: `name`, nodecl.}: ptr UncheckedArray[Wchar]
  # debugEcho toStrLit(result)

mkImpc ncseqsNames

proc `==`(x, y: Wchar): bool {.borrow.}

macro compareW(names: static openArray[string]): untyped =
  # debugEcho names
  result = newStmtList()
  for name in names:
    let
      wa = ident name
      wa_impc_aw = ident(name & "_impc_aw")
      wa_impc_puaw = ident(name & "_impc_puaw")
    result.add quote do:
      var i = 0
      while true:
        let wc = `wa_impc_puaw`[][i]
        if wc == 0.wchar: break
        inc i
      check: `wa`.len == i + 1
      for j in 0..(`wa`.len - 1):
        check:
          `wa`[j] == `wa_impc_aw`[j]
          `wa`[j] == `wa_impc_puaw`[][j]
  # debugEcho toStrLit(result)

# to ensure that `string.fromWide` is implemented correctly, a test is provided
# below that compares wide strings converted to Nim strings with the string
# literals they should match

const
  NCBOXLIGHTW_ns        = "┌┐└┘─│"
  NCBOXHEAVYW_ns        = "┏┓┗┛━┃"
  NCBOXROUNDW_ns        = "╭╮╰╯─│"
  NCBOXDOUBLEW_ns       = "╔╗╚╝═║"
  NCBOXASCIIW_ns        = "/\\\\/-|"
  NCBOXOUTERW_ns        = "🭽🭾🭼🭿▁🭵🭶🭰"
  NCWHITESQUARESW_ns    = "◲◱◳◰"
  NCWHITECIRCLESW_ns    = "◶◵◷◴"
  NCCIRCULARARCSW_ns    = "◜◝◟◞"
  NCWHITETRIANGLESW_ns  = "◿◺◹◸"
  NCBLACKTRIANGLESW_ns  = "◢◣◥◤"
  NCSHADETRIANGLESW_ns  = "🮞🮟🮝🮜"
  NCBLACKARROWHEADSW_ns = "⮝⮟⮜⮞"
  NCLIGHTARROWHEADSW_ns = "⮙⮛⮘⮚"
  NCARROWDOUBLEW_ns     = "⮅⮇⮄⮆"
  NCARROWDASHEDW_ns     = "⭫⭭⭪⭬"
  NCARROWCIRCLEDW_ns    = "⮉⮋⮈⮊"
  NCARROWANTICLOCKW_ns  = "⮏⮍⮎⮌"
  NCBOXDRAWW_ns         = "╵╷╴╶"
  NCBOXDRAWHEAVYW_ns    = "╹╻╸╺"
  NCARROWW_ns           = "⭡⭣⭠⭢⭧⭩⭦⭨"
  NCDIAGONALSW_ns       = "🮣🮠🮡🮢🮤🮥🮦🮧"
  NCDIGITSSUPERW_ns     = "⁰¹²³⁴⁵⁶⁷⁸⁹"
  NCDIGITSSUBW_ns       = "₀₁₂₃₄₅₆₇₈₉"
  NCASTERISKS5_ns       = "🞯🞰🞱🞲🞳🞴"
  NCASTERISKS6_ns       = "🞵🞶🞷🞸🞹🞺"
  NCASTERISKS8_ns       = "🞻🞼✳🞽🞾🞿"
  NCANGLESBR_ns         = "🭁🭂🭃🭄🭅🭆🭇🭈🭉🭊🭋"
  NCANGLESTR_ns         = "🭒🭓🭔🭕🭖🭧🭢🭣🭤🭥🭦"
  NCANGLESBL_ns         = "🭌🭍🭎🭏🭐🭑🬼🬽🬾🬿🭀"
  NCANGLESTL_ns         = "🭝🭞🭟🭠🭡🭜🭗🭘🭙🭚🭛"
  NCEIGHTHSB_ns         = " ▁▂▃▄▅▆▇█"
  NCEIGHTHST_ns         = " ▔🮂🮃▀🮄🮅🮆█"
  NCEIGHTHSL_ns         = "▏▎▍▌▋▊▉█"
  NCEIGHTHSR_ns         = "▕🮇🮈▐🮉🮊🮋█"
  NCHALFBLOCKS_ns       = " ▀▄█"
  NCQUADBLOCKS_ns       = " ▘▝▀▖▌▞▛▗▚▐▜▄▙▟█"
  NCSEXBLOCKS_ns        = " 🬀🬁🬂🬃🬄🬅🬆🬇🬈🬊🬋🬌🬍🬎🬏🬐🬑🬒🬓▌🬔🬕🬖🬗🬘🬙🬚🬛🬜🬝🬞🬟🬠🬡🬢🬣🬤🬥🬦🬧▐🬨🬩🬪🬫🬬🬭🬮🬯🬰🬱🬲🬳🬴🬵🬶🬷🬸🬹🬺🬻█"
  NCBRAILLEEGCS_ns      = "⠀⠁⠈⠉⠂⠃⠊⠋⠐⠑⠘⠙⠒⠓⠚⠛⠄⠅⠌⠍⠆⠇⠎⠏⠔⠕⠜⠝⠖⠗⠞⠟⠠⠡⠨⠩⠢⠣⠪⠫⠰⠱⠸⠹⠲⠳⠺⠻⠤⠥⠬⠭⠦⠧⠮⠯⠴⠵⠼⠽⠶⠷⠾⠿⡀⡁⡈⡉⡂⡃⡊⡋⡐⡑⡘⡙⡒⡓⡚⡛⡄⡅⡌⡍⡆⡇⡎⡏⡔⡕⡜⡝⡖⡗⡞⡟⡠⡡⡨⡩⡢⡣⡪⡫⡰⡱⡸⡹⡲⡳⡺⡻⡤⡥⡬⡭⡦⡧⡮⡯⡴⡵⡼⡽⡶⡷⡾⡿⢀⢁⢈⢉⢂⢃⢊⢋⢐⢑⢘⢙⢒⢓⢚⢛⢄⢅⢌⢍⢆⢇⢎⢏⢔⢕⢜⢝⢖⢗⢞⢟⢠⢡⢨⢩⢢⢣⢪⢫⢰⢱⢸⢹⢲⢳⢺⢻⢤⢥⢬⢭⢦⢧⢮⢯⢴⢵⢼⢽⢶⢷⢾⢿⣀⣁⣈⣉⣂⣃⣊⣋⣐⣑⣘⣙⣒⣓⣚⣛⣄⣅⣌⣍⣆⣇⣎⣏⣔⣕⣜⣝⣖⣗⣞⣟⣠⣡⣨⣩⣢⣣⣪⣫⣰⣱⣸⣹⣲⣳⣺⣻⣤⣥⣬⣭⣦⣧⣮⣯⣴⣵⣼⣽⣶⣷⣾⣿"
  NCSEGDIGITS_ns        = "🯰🯱🯲🯳🯴🯵🯶🯷🯸🯹"
  NCSUITSBLACK_ns       = "♠♣♥♦"
  NCSUITSWHITE_ns       = "♡♢♤♧"
  NCCHESSBLACK_ns       = "♟♜♞♝♛♚"
  # https://github.com/dankamongmen/notcurses/pull/2712
  # NCCHESSWHITE_ns     = "♙♖♘♗♕♔"
  NCCHESSWHITE_ns       = "♟♜♞♝♛♚"
  NCDICE_ns             = "⚀⚁⚂⚃⚄⚅"
  NCMUSICSYM_ns         = "♩♪♫♬♭♮♯"
  NCBOXLIGHT_ns         = "┌┐└┘─│"
  NCBOXHEAVY_ns         = "┏┓┗┛━┃"
  NCBOXROUND_ns         = "╭╮╰╯─│"
  NCBOXDOUBLE_ns        = "╔╗╚╝═║"
  NCBOXASCII_ns         = "/\\\\/-|"
  NCBOXOUTER_ns         = "🭽🭾🭼🭿▁🭵🭶🭰"

macro compareN(names: static openArray[string]): untyped =
  # debugEcho names
  result = newStmtList()
  for name in names:
    let
      wa = ident name
      ns = ident(name & "_ns")
    result.add quote do:
      check: string.fromWide(`wa`) == `ns`
  # debugEcho toStrLit(result)

suite "ABI tests (no init)":
  test "compare constants with wide strings importc'd from notcurses/ncseqs.h":
    compareW ncseqsNames

  test "compare wide strings converted to Nim strings with string literals":
    compareN ncseqsNames
    check:
      $NCBOXLIGHT  == NCBOXLIGHT_ns
      $NCBOXHEAVY  == NCBOXHEAVY_ns
      $NCBOXROUND  == NCBOXROUND_ns
      $NCBOXDOUBLE == NCBOXDOUBLE_ns
      $NCBOXASCII  == NCBOXASCII_ns
      $NCBOXOUTER  == NCBOXOUTER_ns
