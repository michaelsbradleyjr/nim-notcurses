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

# write a brief explanation

type Puaw = ptr UncheckedArray[Wchar]
const nc_seqs_header = "notcurses/ncseqs.h"
{.pragma: nc_seqs, header: nc_seqs_header, nodecl.}

# can be `let` instead of `var` with recent enough releases of Nim 1.4+
var
  NCBOXLIGHTW_impc        {.nc_seqs, importc: "NCBOXLIGHTW"       .}: Puaw
  NCBOXHEAVYW_impc        {.nc_seqs, importc: "NCBOXHEAVYW"       .}: Puaw
  NCBOXROUNDW_impc        {.nc_seqs, importc: "NCBOXROUNDW"       .}: Puaw
  NCBOXDOUBLEW_impc       {.nc_seqs, importc: "NCBOXDOUBLEW"      .}: Puaw
  NCBOXASCIIW_impc        {.nc_seqs, importc: "NCBOXASCIIW"       .}: Puaw
  NCBOXOUTERW_impc        {.nc_seqs, importc: "NCBOXOUTERW"       .}: Puaw
  NCWHITESQUARESW_impc    {.nc_seqs, importc: "NCWHITESQUARESW"   .}: Puaw
  NCWHITECIRCLESW_impc    {.nc_seqs, importc: "NCWHITECIRCLESW"   .}: Puaw
  NCCIRCULARARCSW_impc    {.nc_seqs, importc: "NCCIRCULARARCSW"   .}: Puaw
  NCWHITETRIANGLESW_impc  {.nc_seqs, importc: "NCWHITETRIANGLESW" .}: Puaw
  NCBLACKTRIANGLESW_impc  {.nc_seqs, importc: "NCBLACKTRIANGLESW" .}: Puaw
  NCSHADETRIANGLESW_impc  {.nc_seqs, importc: "NCSHADETRIANGLESW" .}: Puaw
  NCBLACKARROWHEADSW_impc {.nc_seqs, importc: "NCBLACKARROWHEADSW".}: Puaw
  NCLIGHTARROWHEADSW_impc {.nc_seqs, importc: "NCLIGHTARROWHEADSW".}: Puaw
  NCARROWDOUBLEW_impc     {.nc_seqs, importc: "NCARROWDOUBLEW"    .}: Puaw
  NCARROWDASHEDW_impc     {.nc_seqs, importc: "NCARROWDASHEDW"    .}: Puaw
  NCARROWCIRCLEDW_impc    {.nc_seqs, importc: "NCARROWCIRCLEDW"   .}: Puaw
  NCARROWANTICLOCKW_impc  {.nc_seqs, importc: "NCARROWANTICLOCKW" .}: Puaw
  NCBOXDRAWW_impc         {.nc_seqs, importc: "NCBOXDRAWW"        .}: Puaw
  NCBOXDRAWHEAVYW_impc    {.nc_seqs, importc: "NCBOXDRAWHEAVYW"   .}: Puaw
  NCARROWW_impc           {.nc_seqs, importc: "NCARROWW"          .}: Puaw
  NCDIAGONALSW_impc       {.nc_seqs, importc: "NCDIAGONALSW"      .}: Puaw
  NCDIGITSSUPERW_impc     {.nc_seqs, importc: "NCDIGITSSUPERW"    .}: Puaw
  NCDIGITSSUBW_impc       {.nc_seqs, importc: "NCDIGITSSUBW"      .}: Puaw
  NCASTERISKS5_impc       {.nc_seqs, importc: "NCASTERISKS5"      .}: Puaw
  NCASTERISKS6_impc       {.nc_seqs, importc: "NCASTERISKS6"      .}: Puaw
  NCASTERISKS8_impc       {.nc_seqs, importc: "NCASTERISKS8"      .}: Puaw
  NCANGLESBR_impc         {.nc_seqs, importc: "NCANGLESBR"        .}: Puaw
  NCANGLESTR_impc         {.nc_seqs, importc: "NCANGLESTR"        .}: Puaw
  NCANGLESBL_impc         {.nc_seqs, importc: "NCANGLESBL"        .}: Puaw
  NCANGLESTL_impc         {.nc_seqs, importc: "NCANGLESTL"        .}: Puaw
  NCEIGHTHSB_impc         {.nc_seqs, importc: "NCEIGHTHSB"        .}: Puaw
  NCEIGHTHST_impc         {.nc_seqs, importc: "NCEIGHTHST"        .}: Puaw
  NCEIGHTHSL_impc         {.nc_seqs, importc: "NCEIGHTHSL"        .}: Puaw
  NCEIGHTHSR_impc         {.nc_seqs, importc: "NCEIGHTHSR"        .}: Puaw
  NCHALFBLOCKS_impc       {.nc_seqs, importc: "NCHALFBLOCKS"      .}: Puaw
  NCQUADBLOCKS_impc       {.nc_seqs, importc: "NCQUADBLOCKS"      .}: Puaw
  NCSEXBLOCKS_impc        {.nc_seqs, importc: "NCSEXBLOCKS"       .}: Puaw
  NCBRAILLEEGCS_impc      {.nc_seqs, importc: "NCBRAILLEEGCS"     .}: Puaw
  NCSEGDIGITS_impc        {.nc_seqs, importc: "NCSEGDIGITS"       .}: Puaw
  NCSUITSBLACK_impc       {.nc_seqs, importc: "NCSUITSBLACK"      .}: Puaw
  NCSUITSWHITE_impc       {.nc_seqs, importc: "NCSUITSWHITE"      .}: Puaw
  NCCHESSBLACK_impc       {.nc_seqs, importc: "NCCHESSBLACK"      .}: Puaw
  NCCHESSWHITE_impc       {.nc_seqs, importc: "NCCHESSWHITE"      .}: Puaw
  NCDICE_impc             {.nc_seqs, importc: "NCDICE"            .}: Puaw
  NCMUSICSYM_impc         {.nc_seqs, importc: "NCMUSICSYM"        .}: Puaw

proc `$`(wc: Wchar): string {.borrow.}
proc `==`(x, y: Wchar): bool {.borrow.}

macro compare(names: static openArray[string]): untyped =
  # debugEcho names
  result = newStmtList()
  for name in names:
    # debugEcho ident name
    let wa = ident name
    # debugEcho ident(name & "_impc")
    let wa_impc = ident(name & "_impc")
    result.add quote do:
      # var impc {.nc_seqs, importc: `name`.}: ptr UncheckedArray[Wchar]
      echo ""
      for wc in `wa`:
        echo wc
      echo ""
      echo `wa`.len
      echo ""
      var i = 0
      while true:
        let wc = `wa_impc`[][i]
        echo wc
        if wc == 0.wchar: break
        inc i
      echo ""
      echo i + 1
      for j in 0..(`wa`.len - 1):
        check:
          `wa`[j] == `wa_impc`[][j]
  # debugEcho toStrLit(result)

suite "ABI tests (no init)":
  test "compare wide strings from notcurses/ncseqs.h":
    compare [
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
