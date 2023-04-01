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
  NCBRAILLEEGCS_ns =
    "\u2800\u2801\u2808\u2809\u2802\u2803\u280a\u280b\u2810\u2811\u2818\u2819\u2812\u2813\u281a\u281b" &
    "\u2804\u2805\u280c\u280d\u2806\u2807\u280e\u280f\u2814\u2815\u281c\u281d\u2816\u2817\u281e\u281f" &
    "\u2820\u2821\u2828\u2829\u2822\u2823\u282a\u282b\u2830\u2831\u2838\u2839\u2832\u2833\u283a\u283b" &
    "\u2824\u2825\u282c\u282d\u2826\u2827\u282e\u282f\u2834\u2835\u283c\u283d\u2836\u2837\u283e\u283f" &
    "\u2840\u2841\u2848\u2849\u2842\u2843\u284a\u284b\u2850\u2851\u2858\u2859\u2852\u2853\u285a\u285b" &
    "\u2844\u2845\u284c\u284d\u2846\u2847\u284e\u284f\u2854\u2855\u285c\u285d\u2856\u2857\u285e\u285f" &
    "\u2860\u2861\u2868\u2869\u2862\u2863\u286a\u286b\u2870\u2871\u2878\u2879\u2872\u2873\u287a\u287b" &
    "\u2864\u2865\u286c\u286d\u2866\u2867\u286e\u286f\u2874\u2875\u287c\u287d\u2876\u2877\u287e\u287f" &
    "\u2880\u2881\u2888\u2889\u2882\u2883\u288a\u288b\u2890\u2891\u2898\u2899\u2892\u2893\u289a\u289b" &
    "\u2884\u2885\u288c\u288d\u2886\u2887\u288e\u288f\u2894\u2895\u289c\u289d\u2896\u2897\u289e\u289f" &
    "\u28a0\u28a1\u28a8\u28a9\u28a2\u28a3\u28aa\u28ab\u28b0\u28b1\u28b8\u28b9\u28b2\u28b3\u28ba\u28bb" &
    "\u28a4\u28a5\u28ac\u28ad\u28a6\u28a7\u28ae\u28af\u28b4\u28b5\u28bc\u28bd\u28b6\u28b7\u28be\u28bf" &
    "\u28c0\u28c1\u28c8\u28c9\u28c2\u28c3\u28ca\u28cb\u28d0\u28d1\u28d8\u28d9\u28d2\u28d3\u28da\u28db" &
    "\u28c4\u28c5\u28cc\u28cd\u28c6\u28c7\u28ce\u28cf\u28d4\u28d5\u28dc\u28dd\u28d6\u28d7\u28de\u28df" &
    "\u28e0\u28e1\u28e8\u28e9\u28e2\u28e3\u28ea\u28eb\u28f0\u28f1\u28f8\u28f9\u28f2\u28f3\u28fa\u28fb" &
    "\u28e4\u28e5\u28ec\u28ed\u28e6\u28e7\u28ee\u28ef\u28f4\u28f5\u28fc\u28fd\u28f6\u28f7\u28fe\u28ff"
  NCSEGDIGITS_ns =
    "\u{0001fbf0}\u{0001fbf1}\u{0001fbf2}\u{0001fbf3}\u{0001fbf4}" &
    "\u{0001fbf5}\u{0001fbf6}\u{0001fbf7}\u{0001fbf8}\u{0001fbf9}"
  NCSUITSBLACK_ns = "\u2660\u2663\u2665\u2666"
  NCSUITSWHITE_ns = "\u2661\u2662\u2664\u2667"
  NCCHESSBLACK_ns = "\u265f\u265c\u265e\u265d\u265b\u265a"
  NCCHESSWHITE_ns = "\u265f\u265c\u265e\u265d\u265b\u265a"
  NCDICE_ns       = "\u2680\u2681\u2682\u2683\u2684\u2685"
  NCMUSICSYM_ns   = "\u2669\u266A\u266B\u266C\u266D\u266E\u266F"
  NCBOXLIGHT_ns  = "┌┐└┘─│"
  NCBOXHEAVY_ns  = "┏┓┗┛━┃"
  NCBOXROUND_ns  = "╭╮╰╯─│"
  NCBOXDOUBLE_ns = "╔╗╚╝═║"
  NCBOXASCII_ns  = "/\\\\/-|"
  NCBOXOUTER_ns  = "🭽🭾🭼🭿▁🭵🭶🭰"

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
      $NCBOXLIGHT == NCBOXLIGHT_ns
      $NCBOXHEAVY == NCBOXHEAVY_ns
      $NCBOXROUND == NCBOXROUND_ns
      $NCBOXDOUBLE == NCBOXDOUBLE_ns
      $NCBOXASCII == NCBOXASCII_ns
      $NCBOXOUTER == NCBOXOUTER_ns
