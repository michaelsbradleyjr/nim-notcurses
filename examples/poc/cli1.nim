import notcurses/cli
# or: import notcurses/core/cli

let
  nc = Nc.init
  stdn = nc.stdPlane

addNcExitProc()

proc putAndRender(s: string) =
  stdn.putStr(s & "\n").expect
  nc.render.expect

proc blankLine() =
  putAndRender ""

blankLine()

while true:
  putAndRender "press any key, q to quit"
  let ni = nc.getBlocking
  # putAndRender "NI.EVENT: " & $ni.event
  # putAndRender "NI: " & $ni
  # if not (ni.event == Release or $ni != "q"): break

  putAndRender $ni.event
  if not (ni.event == Release or ni.id != 113): break

blankLine()
