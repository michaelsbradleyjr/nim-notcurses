import notcurses/cli

let
  nc = Nc.init
  stdn = nc.stdPlane

proc putAndRender(s: string) =
  stdn.putStr(s & "\n").expect
  nc.render.expect

proc blankLine() =
  putAndRender ""

blankLine()
while true:
  putAndRender "press any key, q to quit"
  let ni = nc.getBlocking

  # really want `$ni.evType` and `$ni.id` to print utf8 and e.g.
  # `$ni.id != "q"` utf8 comparison but may be some tricky business with uint32
  # checking and an enum that has the higher-val key encodings, e.g. can they
  # go in an enum where RHS is tuple with (number, "NC_KEY_BLAH") so it's easy
  # to compare *and* print utf8 strings re: that enum, for e.g. easily visually
  # identifying keypresses by put'ing or logging them

  # Note: Nim's std/unicode module claims to support Unicode v12.0.0, but iirc
  # Notcurses supports v14.0.0, any implications beyond "missing Runes"? (iiuc)

  # if not (ni.eventType == NcType.Release or $ni.id != "q"): break

  # putAndRender "NI.EVTYPE: " & $ni.evType
  # putAndRender "NI.ID: " & $ni.id

  if not (ni.evType == 3 or ni.id != 113): break
blankLine()
nc.stop.expect