import std/os
import pkg/notcurses
# or: import pkg/notcurses/core

# locale can be set manually but it's generally not necessary because Notcurses
# attempts to do it automatically; this is just an example of using setLocale
setLocale(LC_ALL, "").expect

# if locale was set manually then use flag InhibitSetLocale
let
  flags = [InitFlags.CliMode, InhibitSetLocale]
  nc = Nc.init NcOpts.init flags
  stdn = nc.stdPlane

const
  notice1 = "\nThis program is *not* indicative of real scrolling speed\n"
  notice2 = "\npress q to quit\n\n"

stdn.setStyles Styles.Bold
stdn.putStr notice1
stdn.setStyles Styles.None
stdn.putStr notice2

# https://codepoints.net/cjk_unified_ideographs
const
  first = 0x4e00'u16
  last  = 0x9fff'u16

var u = first
while true:
  let input = nc.getNonblocking
  if input.isSome and input.get.codepoint == 'q': break
  stdn.putWc u.wchar
  nc.render
  if u < last: inc u
  else: u = first
  sleep 10

stdn.putStr "\n\n"

nc.stop

# rendering after each putWc isn't necessary but it makes the auto-scroll
# behavior of Notcurses' CLI mode visually more apparent in the compiled
# program's output

# see comment in ./cli1.nim re: scrolling/rendering bugs
