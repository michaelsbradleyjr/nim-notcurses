import std/os
import notcurses/core

let
  nc = Nc.init NcOptions.init DrainInput
  stdn = nc.stdPlane

const
  ul = NcChannel.init(0x00, 0x00, 0x00, 0xff, 0xff, 0xff)
  ur = NcChannel.init(0x00, 0xff, 0xff, 0xff, 0x00, 0x00)
  ll = NcChannel.init(0xff, 0x00, 0x00, 0x00, 0xff, 0xff)
  lr = NcChannel.init(0xff, 0xff, 0xff, 0x00, 0x00, 0x00)

proc gradA() =
  stdn.gradient(0, 0, 0, 0, ul, ur, ll, lr, "A", NcStyles.None).expect
  nc.render.expect
  sleep 1000

proc gradStriations() =
  stdn.gradient(0, 0, 0, 0, ul, ur, ll, lr, "▄", NcStyles.None).expect
  nc.render.expect
  sleep 1000
  stdn.gradient(0, 0, 0, 0, ul, ur, ll, lr, "▀", NcStyles.None).expect
  nc.render.expect
  sleep 1000

proc gradHigh() =
  const
    ul = NcChannel.init(0x00, 0x00, 0x00)
    ur = NcChannel.init(0x00, 0xff, 0xff)
    ll = NcChannel.init(0xff, 0x00, 0x00)
    lr = NcChannel.init(0xff, 0xff, 0xff)
  stdn.gradient2x1(0, 0, 0, 0, ul, ur, ll, lr).expect
  nc.render.expect
  sleep 1000

gradA()
gradStriations()
gradHigh()
