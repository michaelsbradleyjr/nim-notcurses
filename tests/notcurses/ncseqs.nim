import notcurses/abi/constants

# should be able to do these on the fly in the macro that will be used to
# construct the tests from a static array of constants

# write a brief explanation

const nc_seqs_header = "notcurses/ncseqs.h"
{.pragma: nc_seqs, header: nc_seqs_header, nodecl.}

# can be `let` instead of `var` with recent enough releases of Nim 1.4+
var
  NCBOXLIGHTW_impc*        {.nc_seqs, importc: "NCBOXLIGHTW"       .}: ptr UncheckedArray[Wchar]
  NCBOXHEAVYW_impc*        {.nc_seqs, importc: "NCBOXHEAVYW"       .}: ptr UncheckedArray[Wchar]
  NCBOXROUNDW_impc*        {.nc_seqs, importc: "NCBOXROUNDW"       .}: ptr UncheckedArray[Wchar]
  NCBOXDOUBLEW_impc*       {.nc_seqs, importc: "NCBOXDOUBLEW"      .}: ptr UncheckedArray[Wchar]
  NCBOXASCIIW_impc*        {.nc_seqs, importc: "NCBOXASCIIW"       .}: ptr UncheckedArray[Wchar]
  NCBOXOUTERW_impc*        {.nc_seqs, importc: "NCBOXOUTERW"       .}: ptr UncheckedArray[Wchar]
  NCWHITESQUARESW_impc*    {.nc_seqs, importc: "NCWHITESQUARESW"   .}: ptr UncheckedArray[Wchar]
  NCWHITECIRCLESW_impc*    {.nc_seqs, importc: "NCWHITECIRCLESW"   .}: ptr UncheckedArray[Wchar]
  NCCIRCULARARCSW_impc*    {.nc_seqs, importc: "NCCIRCULARARCSW"   .}: ptr UncheckedArray[Wchar]
  NCWHITETRIANGLESW_impc*  {.nc_seqs, importc: "NCWHITETRIANGLESW" .}: ptr UncheckedArray[Wchar]
  NCBLACKTRIANGLESW_impc*  {.nc_seqs, importc: "NCBLACKTRIANGLESW" .}: ptr UncheckedArray[Wchar]
  NCSHADETRIANGLESW_impc*  {.nc_seqs, importc: "NCSHADETRIANGLESW" .}: ptr UncheckedArray[Wchar]
  NCBLACKARROWHEADSW_impc* {.nc_seqs, importc: "NCBLACKARROWHEADSW".}: ptr UncheckedArray[Wchar]
  NCLIGHTARROWHEADSW_impc* {.nc_seqs, importc: "NCLIGHTARROWHEADSW".}: ptr UncheckedArray[Wchar]
  NCARROWDOUBLEW_impc*     {.nc_seqs, importc: "NCARROWDOUBLEW"    .}: ptr UncheckedArray[Wchar]
  NCARROWDASHEDW_impc*     {.nc_seqs, importc: "NCARROWDASHEDW"    .}: ptr UncheckedArray[Wchar]
  NCARROWCIRCLEDW_impc*    {.nc_seqs, importc: "NCARROWCIRCLEDW"   .}: ptr UncheckedArray[Wchar]
  NCARROWANTICLOCKW_impc*  {.nc_seqs, importc: "NCARROWANTICLOCKW" .}: ptr UncheckedArray[Wchar]
  NCBOXDRAWW_impc*         {.nc_seqs, importc: "NCBOXDRAWW"        .}: ptr UncheckedArray[Wchar]
  NCBOXDRAWHEAVYW_impc*    {.nc_seqs, importc: "NCBOXDRAWHEAVYW"   .}: ptr UncheckedArray[Wchar]
  NCARROWW_impc*           {.nc_seqs, importc: "NCARROWW"          .}: ptr UncheckedArray[Wchar]
  NCDIAGONALSW_impc*       {.nc_seqs, importc: "NCDIAGONALSW"      .}: ptr UncheckedArray[Wchar]
  NCDIGITSSUPERW_impc*     {.nc_seqs, importc: "NCDIGITSSUPERW"    .}: ptr UncheckedArray[Wchar]
  NCDIGITSSUBW_impc*       {.nc_seqs, importc: "NCDIGITSSUBW"      .}: ptr UncheckedArray[Wchar]
  NCASTERISKS5_impc*       {.nc_seqs, importc: "NCASTERISKS5"      .}: ptr UncheckedArray[Wchar]
  NCASTERISKS6_impc*       {.nc_seqs, importc: "NCASTERISKS6"      .}: ptr UncheckedArray[Wchar]
  NCASTERISKS8_impc*       {.nc_seqs, importc: "NCASTERISKS8"      .}: ptr UncheckedArray[Wchar]
  NCANGLESBR_impc*         {.nc_seqs, importc: "NCANGLESBR"        .}: ptr UncheckedArray[Wchar]
  NCANGLESTR_impc*         {.nc_seqs, importc: "NCANGLESTR"        .}: ptr UncheckedArray[Wchar]
  NCANGLESBL_impc*         {.nc_seqs, importc: "NCANGLESBL"        .}: ptr UncheckedArray[Wchar]
  NCANGLESTL_impc*         {.nc_seqs, importc: "NCANGLESTL"        .}: ptr UncheckedArray[Wchar]
  NCEIGHTHSB_impc*         {.nc_seqs, importc: "NCEIGHTHSB"        .}: ptr UncheckedArray[Wchar]
  NCEIGHTHST_impc*         {.nc_seqs, importc: "NCEIGHTHST"        .}: ptr UncheckedArray[Wchar]
  NCEIGHTHSL_impc*         {.nc_seqs, importc: "NCEIGHTHSL"        .}: ptr UncheckedArray[Wchar]
  NCEIGHTHSR_impc*         {.nc_seqs, importc: "NCEIGHTHSR"        .}: ptr UncheckedArray[Wchar]
  NCHALFBLOCKS_impc*       {.nc_seqs, importc: "NCHALFBLOCKS"      .}: ptr UncheckedArray[Wchar]
  NCQUADBLOCKS_impc*       {.nc_seqs, importc: "NCQUADBLOCKS"      .}: ptr UncheckedArray[Wchar]
  NCSEXBLOCKS_impc*        {.nc_seqs, importc: "NCSEXBLOCKS"       .}: ptr UncheckedArray[Wchar]
  NCBRAILLEEGCS_impc*      {.nc_seqs, importc: "NCBRAILLEEGCS"     .}: ptr UncheckedArray[Wchar]
  NCSEGDIGITS_impc*        {.nc_seqs, importc: "NCSEGDIGITS"       .}: ptr UncheckedArray[Wchar]
  NCSUITSBLACK_impc*       {.nc_seqs, importc: "NCSUITSBLACK"      .}: ptr UncheckedArray[Wchar]
  NCSUITSWHITE_impc*       {.nc_seqs, importc: "NCSUITSWHITE"      .}: ptr UncheckedArray[Wchar]
  NCCHESSBLACK_impc*       {.nc_seqs, importc: "NCCHESSBLACK"      .}: ptr UncheckedArray[Wchar]
  NCCHESSWHITE_impc*       {.nc_seqs, importc: "NCCHESSWHITE"      .}: ptr UncheckedArray[Wchar]
  NCDICE_impc*             {.nc_seqs, importc: "NCDICE"            .}: ptr UncheckedArray[Wchar]
  NCMUSICSYM_impc*         {.nc_seqs, importc: "NCMUSICSYM"        .}: ptr UncheckedArray[Wchar]
