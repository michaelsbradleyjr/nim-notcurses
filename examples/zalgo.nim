import pkg/notcurses/core
# or: import pkg/notcurses

let
  nc = Nc.init NcOpts.init [InitFlags.CliMode, DrainInput]
  cy = nc.stdPlane.cursorY.int32

proc putCentered(s: string, y: int32) =
  discard nc.stdPlane.putStrAligned(s & "\n", Align.Center, cy + y)

putCentered("Pack my box with five dozen liquor jugs",           00)
putCentered("sɓnɾ ɹonbıl uǝzop ǝʌıɟ ɥʇıʍ xoq ʎɯ ʞɔɐԀ",           01)
putCentered("ꙅǫuꞁ ɿoupi| ᴎɘƹob ɘviᎸ ʜƚiw xod ʏm ʞɔɒꟼ",           02)
putCentered("P̸̯̼͙̻̲͚̜͚͈̩̎͠a̶̯̳̱̟͚͇̩̯̬͂̒̒̌̅͊̽̿͗̈́͘͝ͅć̸̮̦̩̭͓̫̟̹̆͂͒̓͆̈̅̀͐̿̚ͅk̶̡̻̜̼̙͍̥̗̯̠̜͓̪̽ ̷̮͚̺͎̗̂̈́̿̑͝m̴̩͍̺̟͓̼͓͇̟̙͂̏̈́͆̎́̐̐̽̕̚͘͜ͅy̵̧̻̗̦̯̱̬̤͈̦̺͗̓͛ ̵̣̤͕͙̟͛͌͑̉͘͝b̵̨̡̨̯̞̘͕̰̙̬̳͇̮͖̹͗o̶̻̫͑̎͑̽̈́̚̚̕ͅx̵̢̦̗̳̝̻̗̟̘̻̼͚̰̓̇̓͛̀ ̸͈̜͙́̍͂̅̃̿͘w̵̧̪̻̤̮̑͊͌̈́͋́̔͂̑̌͑͋̇͂ḯ̴̺͛̒̔̏́̅̓̾̔̊̆͗͠͝t̷̢̛̟͉͕̗̙̭̖͈̼̂̎́͌͜͝h̸̢̨̜̤̗͎̳̖͙̺̹̭̘̞̀̀̓̊̐̀͐̈́̀̿͆̔̄͝ͅ ̴̹̙̜̥͕͖͑́͛̈́̄̈́̿̕f̶̡̢̳̗͉̩͖̹͚̗̩̰͖̀̂͗͌̑i̴̧̝̰͎͕̣͓͓̋͒̇̀̾͐̃̚̕v̵̛̠̩̪̻̟͕̭͕̗̲̼̽͗͐̄̈́̾͂̍̔̎͌̌͘͝e̵̢̤͇̪̻͚̜͉̻͉̝͙͗̀̃̐͋̌̋̌̈́̅̈̌̉͘͜ ̶̡̢̭͙̤͑̑͂̐͛̑̍͑͌̀͛d̴̨̧͍̫͔͔̫̻̗̙͖̞̱͆̒͂̈̐͑̕̚͠͝ó̸̰̠̦̦̞̼̘͔̥͎͕̦̯̑̀̇̈́̎̄͘z̴̡̧̡̦̦̙̞̪̣̤͕̫̳̈̉͌̃͌͛̀͌̎̃̌͒͜͝ȩ̷̻͖̥̬̹̖̫͛͐̍̂̾̀͑͊̎̀̊̏̕ͅn̵̢̢̧͚̜͉̯̲͕̒͊̒͌͋͗̓́͂͝ ̵̡̧̨̛̛͓͚̘̺̲̺̻̻̫̾̄̒̑̄̄̏̇̍̽͜l̴̗̩͍̰̇i̴̡̭̳͉̘̩͚̽̏̿̈̔́̂̈́̊͝q̷̫͚̌̅̈́̓̐̎ů̶̢͈̪͔̅̓̀̓̓̈͆̍͋͋̉͝͠ǫ̵̻͠r̵̰̯̠̟̬͖̳͔̚ͅ ̶̡̣̭̥̻̭͙͎̰̜̥̜̊j̷̧̡̟̝̼̞̭͙͈̘̇̾̽͊̄̈̍͗͒͑͜u̷̡̪̤̖̣̰͈̽̀̚͜g̸̨̢̧̳̙̝̠̩̜̻͙̘̪̞̈́͐̈́̇̆̎̈ͅs̶̫͑͂̂͛̋̇̅̒͝.̴͈̖̮̪̮͓̹̈̐̇̓̇͝",          03)
putCentered("Ⓟⓐⓒⓚ ⓜⓨ ⓑⓞⓧ ⓦⓘⓣⓗ ⓕⓘⓥⓔ ⓓⓞⓩⓔⓝ ⓛⓘⓠⓤⓞⓡ ⓙⓤⓖⓢ",           04)
putCentered("φąçҟ ʍվ ҍօ× աìէհ ƒìѵҽ ժօՀҽղ Ӏìզմօɾ ʝմցʂ",           05)
putCentered("P⃞a⃞c⃞k⃞m⃞y⃞b⃞o⃞x⃞w⃞i⃞t⃞h⃞f⃞i⃞v⃞e⃞d⃞o⃞z⃞e⃞n⃞l⃞i⃞q⃞u⃞o⃞r⃞j⃞u⃞g⃞s⃞.⃞",                 06)
putCentered("P⃣a⃣c⃣k⃣m⃣y⃣b⃣o⃣x⃣w⃣i⃣t⃣h⃣f⃣i⃣v⃣e⃣d⃣o⃣z⃣e⃣n⃣l⃣i⃣q⃣u⃣o⃣r⃣j⃣u⃣g⃣s⃣.⃣",                 07)
putCentered("ᴘᴀᴄᴋ ᴍʏ ʙᴏx ᴡɪᴛʜ ꜰɪᴠᴇ ᴅᴏᴢᴇɴ ʟɪQᴜᴏʀ ᴊᴜɢꜱ",           08)
putCentered("🅝🅔🅖🅐🅣🅘🅥🅔 🅒🅘🅡🅒🅛🅔🅢 🅐🅡🅔 🅐🅛🅢🅞 🅐🅥🅐🅘🅛🅐🅑🅛🅔 ",              09)
putCentered("🄴 🅂 🄲 🄷 🄴 🅆  🄲 🄸 🅁 🄲 🄻 🄴 🅂  🄶 🄴 🅃  🅂 🅀 🅄 🄰 🅁 🄴 🅂 ", 10)
putCentered("🅰 🅱🅴🅰🆄🆃🅸🅵🆄🅻 🆄🆂🅴 🅾🅵 🅽🅴🅶🅰🆃🅸🆅🅴 🆂🆀🆄🅰🆁🅴🆂",               11)
putCentered("į̵̢̡̢̨̨̛͈̤͇̭͈̣̗̮̫̫̰̤̳̘̞̥̟͙̞̥͉̳̜̫̣̯̗̠͖̲̪̘̟͉͖̜͔̪͈̜̼̩̥̗͔̭͔̠̺̫̺̦͇̐͛̉̃͒̿̒͆̅̐̆͆͌͋̎̈́̓̔̓͌̌̀̽̾̈́̄̈́̇̒̀͆͆͌̄́̎̋̑̀͊̐̆̚̚̚̚͜͜͜͝͠͠͝ͅͅn̵̡̢̧̧̧̢̢̛̛̙̩͈̦̠̳̜͖̤͍̻̹̼̯̦̦̰͕͈͈̖̬̣̦͓̳̣̮͙͓̣͖̲͉̭̞̤̞͙̝̝͔͓̗͓̣͙͕̲̩̠̬̑̊̈̐͛͒̎̐͒̓̆̌͊̅̿̂͛̈́̈́́̉̽̔̓̔̎̈̿͒̃̊̾̏̇̈́̋́͆̐̈́͛̔̓̄̀͋̊̃͛͑̋͂̔̈̐͐͐̆̇͌̓́́̿́̍̈́̈́̈́͋̄͆̈͛͂̇͗̅̓̀̈́̂͂̆̃̈́̈́̓̓̐̔̌̍̋͐̚̕̚͘͘͘͘̚̚͘͘͜͝͝͝͝͠͝e̶̡̨̨̧̨̨̨̧̦͇̖͔̫̹̺̺̯͈̺̫̗͈̲͕̮͈͓̭̱͔͈͚̬̰̜͇̼̙̰̣͎͕̠̥̯̖̣̬̗͎̓͑͌̊̇͆͐͑̂̎͋̑͐̀̅̂͌̽̉̊̀͌̓̈́̀͛̐́̋̈͑͆̐̑̉̐̍́̈́̅̿͒̕̕̚͜͜͝͝͠ļ̷̢̨̢̢̡̡̣͕͈̩͔̻̬̻͙͙̩̲͇͈̥͎̖̻͖̮̪̞̠̹͍̙͖̳̱͓̘͖̱̱͕̯̰͙̝̣͕̭̮̿̑͘͜͜͜ự̴̡̡̨̨̢̨̨̤͈̝̟̣̠͖̗͙̗̖̦̯͍̘̟͎̝͔͙̗͎̟̺̣͖̝̩̜̜̖̳̹͍̦̩͔̜̘̲͈̮̠͚̭̭̜͉̘̫̰̺̫͖̗̦̮͓̗̻̖͍̥̤͎͖̣̻̝͚͙̤̥͎̖̯͙̯̫̘̜̘̤̠̯͖͉͍̎̈͐̄̊̈̊̌͑̎͂͒͌́̃͐̐̉͗̽̀͂̃̒͋̂̀̊̉́̃̄̄̍̆́̑͑̇̇̾́̊̂͊̐͑̾̀͊̒̓́̂̐̄͋̀̈́̅̏̒̎̊̒͂͐̑͐̉́̄̂̀̕̕͘̕̕͘̕̕̕͜͜͝͝͝͝͝͝͠͝ć̵̡̨̨̢̢̛̛͔̩̦͓̥̠̜̳̯̮̩̜̖͖̘̜̖͖̖̳̹̲̻̯̬̪̰̭͇̮͉̳͉̬̬͇͉̟̲̞̱̯̖̗̞͚͎͓͔͍͈̲͇̳͈̦̠͚̲͎̦͙̰̲̬̝̞̟̪͈̘̖̦̩̝̩͕͈̦̯͙̞̖̥̺̝̗̔͊̂̈́́̿̾̾͛̈͐̔̉̈͐̈́̈̉͑̃̂͋́̆̓̒̈̈̉͛̏̅͌͌̆̓́͊̂̾̈̚͘͘͜͜͜͝͠͝͠͠͠͝͠ͅͅͅt̶̡̡̧̛̛̮̘̹̼̺̹͓̠͖̳̺̹̘̥͙͇̪̩͇̖̦̾͐̍̇͊̅̅̇̀̂̏̀̆̑͗̑͆͊̾̎͗̋̊̇̒͛̀̇͂̒͆̀̊̽̑̀̐̅̔̅̀̋͆͐̋́͆̒̓̐͐́͂̐̋̇̿̑͆̅͑͐́̄́̈́̌̈́͋̄̎͌̈́̅̍̎̓̑̕̚͘̚̚͜͠͠͝͝͠͝ͅą̵̧̛̛͎͕̯̪͚̫̟̺͚̱͎͚̹̟̖̦̼͍̦͙̹̹̰̫̤̯͚̠̼͉̭̳̓͗̈́̎̀̇͌͌͌̐̌̀̾̀̈̍̾̓̀͌͑̔̆̋̇̇̈́̔̌̈́̐͒͌̒̐̋̅̀̉͆̒̓̀͌̒̒͋̐̀̒̇̉̅̏̾̕͘̕͝͝͠͝ͅͅb̷̧̧̡̢̨̧̡̡̛̛̛͈̩̰͖̰̹̯̪͍̯͉͙̺̬̝̟̥̜͙̙͕͇̗̪̬̣̙͕̙̙͉͔̦̦̼̜̳̤̺͕͇̠̲̘̼̲̦̺̝̪̲̣̠̪̮͉̮͙̥̤̫̫͉͍̤͍͙̺̩̫̜͚̞̫̺͍̺̣͍̥̠͓̯̳̳̖̟͉̄̏͛̆͊͆͆̆̐̀̏̎̊͆̾͋̇͑̓̒͑̂͛́͊͗̇̔̾͆͂̒̃͋͊̊̆̀̈̊̌͗̈̿̄̀́̌̌̑͐͂̈́̇͛̒̏̒̋̅̆̈̽̽̅̐͊͆̿̐̌̈̂̓͌̀̋͛͛̎͒͒͋̏̐̀̒̇̀̐́̕͘̕͜͜͜͜͜͝͝͝͠͠͝͠͝ͅl̴̨̨̢̨̨̢̧̨̧̨͍͕̟̲͙̺̯̹̺̟̼̜͍̙̣̼̬̺͕͚̤̙͍͓̳̘͍̠̙͍͎̝̮͍̤̰̩̯̦̠̦̻̣̜͎͉͓͎̦̝̖̲͚̦͓̭̩͉͖̘̟̪͔͎̪̰͓͔̟̬͂̌̈̉͋͘ͅͅͅê̸̡̨̧̧̧̡̧̧̨̧̛̛̝͕̪̲̟̣͍̹̻̠̥̟̯͔̻̗̙̳̺͍̗̬̥̼͕͖͈͔̝̩͙͔̜̩̫͕̠͇͔͍̥͚͕͉̬̩̫̟͉̝̭̖̳̳̰̘͙͓̙͍̙̞̣̖̝̦̰̰̺̰̺̖̦̝͈̲͈̗̬̦̺̹͎̯̭̟̺̯̠̬̮̝̰͙̗͎͈͔̮̲̯̩̪͈͙̲̪̱̦̩̘̲̈̋̒̉̑̈́̍̀̄̇̓́̓̾̌̒̏͌͒̂͆̆̈́́͐̾̈́͌̍͌̉̐̐̑̇̽̑̋̆͗̑̆̌͂͛̑́̒̅̌̌̀͗͂̅̎̋̈́̅͑̌̄̃̾̎͌͒͑͊̍̂̾͋̉̒̋̃̒̑̈͋̊̒͆̏̎̊̃̕̚̚̕͘̕͘͘̚͜͜͠͠͝͝͝͝͝͝͠͠͝ͅͅͅͅͅ ̷̧̡̢̡̧̢̧̧̡̨̖̤̺̤̮̗̭̬̰̰̟̳͚̱̩͍̱̰̩̠̮͕͓̣̺̳͈͔̟̳̣͈̱̰̬̞̖̦͔̼̹̥͖͈͚̩̼͖̬̞̩͎͇̞̬̯̟͕̞̗͖̘̙͖̞͓̜̭͖̹̱̙̖͔̭̲̻̘͚͇͍̱̹͇̱̬̘̲͕̝̗̳̰͖̮̞͉̗̝͖̥̹̣̣̬̠̘̦͚̫̜̻̱̌̀͂̃̑̓̄̈́͐̌͒̐́͑̂̇͋͗́́͗̍͊̐͑̾͂̍̈́̏̈́́̑̌̓̎̈́̐̑͗̊̇̈́͂̚͘̚͜͜͝͝͝͝͝͝ͅͅͅm̷̢̡̛̛͚̹̻̮̘̤̩̬͙͎̈́̿̂̍͂̽̀͒͌́̃͑̓̿̉̀͑̈̓͒͘̕͝͝͝͠ͅǫ̶̢̢̢̨̼͇̗͕͖͚̤̤̰̰̯̜͕͍̠̳̰͕̣͍̱̞̮̠̳̤̭̰̫͖̘͉̠̝̹̩̳̳̱͔͍̲̪̱͔̫̠͑́͋́́̓̀͋̈́̍̉̅̾́͘͘͜͜͠ḑ̸̢̨̡̛̛͍̞͉̝̖͓̝̳̝̲͈̗̼͖̤̯͈̮̮͇̹̲̰̟͎̼̏͂́̃̈̀̾̅̊̍̒͛̓̒̆̀͐͗̍̆͛͊̂͗̃́̓͑̃̇͒͌͛̆̋̈́̑̕͝ͅą̸̛̛̗̠̙̳̣̯͇̙̯̰̊͒̆̔͛͌̄̓̒͐̑̏̃̊̏͌͊͑̒̂̂͂̈́̐̎̂̀͒̓̅̈́͊́́̒̾̑̒̒̉͛́̃̔̈̀̍͋͑̓͆̂̿̽̏́͑͂̀̍̀̓̒͛̊̋̈̑̎̅̀̉̑̈́͑̓̐͑̾̃̒͊̉̒̓̌̀͑̍͑̾͊̿͌̔̏͗͗̈́͘͘͘̚̕͘̕͘̕͘͠͠͝ͅĺ̴̨̨̡̧̡̧̨̧̡̡̢̡͖͔̗̮͓̼̗͈͔̳̬̞̺͙̩̣̩̥͎̙̭̯̖̪̫͎͇̪̯̬̠͓͖̣͇͍̮̮͈̟̫͚͉̻͈̖̗̠̙̝͙̠̰͚̱̲̤̺̪̭̫̱̫̠̞͓̹̮̖̘̣̓̿́̌͂̀̇͐̈́̾̀̂̍͆͛͗͊̈́̀̈́͑̎͋̒͒̕̚̕̚̕͜͠͠͠ͅͅi̴̧̨̢̝͎͇̠̭̟͇̭͙͚̳̭̘͈̟͓͈̥̭͚͈͍̲̲͔̤͉͈̎̈͂͆̀͛͋͊̏͊͗͋̓̐̉̆̒̈́͊̏̈͋́̓̿̾͛̒̓̅͛̚̕͜͜͝͠͝ͅͅṯ̶̡̛̪͚̮̩̤̗͇̗͍̩̬̲͔͙̼̯͉͓̃̐̽̐̌͂̑͊͊͝y̷̨̡̧̢̧̧̧̧̡̡̨̧͈̫͉̟̠̘̜̟̜̻̭̜̦̻̺̮͖̫̺͙̰̟̥̱̝̤̘͙̳̜͔̼̹̹͉̳̰̻̳̩̻̺̫͈̼̘͉͓͎̙͔̣̥̪̺͎̙̹͕͇̖̤̗͙͈͉̭̦̺͈̞̼̗̜̯̞̠̬̱̼͈͇̖̬͕͕̬̮͖̤̜͔͙̻̤͈͓̣̖͓̘̘̬̳̻̜̲̳̏̄̂̈́̒̃̎̇̏͆͊̓̎́̓͛̄͆̃͆̈́́͊̋̈́̾̈͒̍͊̔̆̉̏͐̿͆̂̊̀̌̀̽̆̋̓́͆̓̈́̚͘͜͜͜͝ͅͅͅͅͅ ̴̢̧̧̨̢̨̡̡̨̢̨̛̛̛̥͓̬͍̭̫̬̬̱̩͇̱̗͚̲̘͉̘͇͓̮͇̹̱̠͖̦͈̟̮̬̦̝͚͙̝̠͖̞̖̱̥̜̯̼͓̫̹͖̘͓̣͎̱̘̰̦̺̪͙̜͓̼͚̺̖̞̻͈͚̲͙̗͈̱̯̘͈̟̞̞͈̬̤̦̹̹̿̐̅́͛̒͐͋́̓̊̊̋̊͐̈́̇̍͒̑̎̿̀͑̉͒̾̀̈̈́̂̐͋͑͗̓͒̑̔̌̏͒̑̓͒̏͌̀͌̋̂̇̓̈͗̓͛̉͑͗͒̾̐͊̏̈́̅́̈̾͋̐͂̽̈̏̐̀̆̃͗̓̚̕̕̕̚̚͝͝͝͝ͅǫ̵̢̡̨̡̨̡̨̤̤̖͕̠̥̰̠̩̙̰̮̜̘̪̭̭̯̺̭͚͙̞̜̪̰͚̘̭̻͓͈̺͉̯͔͖̯̠̭̰̫̲͈̦̖͖̪̣̰͖͎̙͚̙̹̰̬̜̲̱̘̘̪̭̣̻̫͓̼̦̦̘̩̥̱̣̺̌̇͒̊̃̐̾̍̈́̅̉̊͐͒̀͆̉̀̇͊̕̕͜͜͝ͅͅͅͅͅͅͅf̷̨̨̧̨̢̢̨̧̛̮̖̝͎̻̟̦̗͕͍̻̫̤̰̣̜̮͙̱̝̮͈̫̯̣̻̪͚̘͍͈̝̱̞͚͔̣̗̱̳̰̣̦̘̦̮̞̬̗͈̘̤̦̞̞̱̠̹̖̣̰̦̦͍̙̫̲̮̲͇̼̗͓̹̹͓̬̩͍̦͍̆͊̀̆͂͑̾̔̎̎̿͂̀̐̈́̈̇͒̔̋̇̒͆̏̋͋͒͊̏̉̏̎͛̋̔͐̈̈́̿͋̽̀̈́͗͒̑̽͋̏̅̌̇̓͑̅̿͐̂͆͆̃̈̈́̌̈́̆̌̋̎̀̾͆͂̿̃̃̐͒͌̃́̑̐̽́̐̔̔̅̄͘̚̚͘̚͘̚͘͜͜͝͝͝͠͠͝͝͠͠ ̷̡̡̨̨̧̛̛̱̼̜͙̜͔̠̹̺̞̰̞̟̘͚̣̮̼̞̙̘̱͔̖̬͈͖͇̳̪͚̩̰̠̦͖̫͖͈̗͍̩̤̂̆̂͂̓̾̑̉́̏͊́̉͗͌͆̒̑̅̓̅̑͛͐̌̅͑̍̋͛͒̆͆̐̇̒̌́͐̔̐͂̽̋̋̐̾̆̆̀̋̈́̆̔̀̎͐̄̌̀̈͑̂͛̈́͐̈́͋̽͊͑̔̀͛͑͑̐̎͋̾̓͗̍͋̏̈́͛̂͒̉̅̊̂̆͂́̅͑̾͆̈́̇̆̑͋̐̋̚̚̚̚͘͘̚̚̕͘͠͝͝͝͝͝͝͝͝͝ͅt̸̨̛̛̛̛̙͕̪̬̣͚̩͕̺̯̹͂̿̃̊̔̇̄̌̉̒̆͐̈́̌͐̓̿͊͊͆̈́̄̌͂̓̅̐̓̐͒̍̽̓͊̄̏͌́̃̓̉́̀̈̿̓͌̆̅̎̇͒͐̀͗̉̀͂̏̓̀̈́͑͐̾̿̌̉̔̓͌͛̈͌́̊̕̕̚̕̕̕͘̚͠͝͝͠͝͝͝͝͝͠h̴̡̨̡̨̧̛̛̛̳͙̳̦͚̫̟̰͔̘̼̣̳̲̯͍̮͚̝͔̠͔͓̥̫̜̩̟̝͖̼͉͎̹̲̤̝̤̠̤̮͖͙͉̫̦̖͇̤̝̼̝̖̲̠̥̦͍͈͇̼͇̙̟̱͕̦̘͍͕̗̩͇͚̩͙̻̣͙̥͕͎̬̙̙̰͇͕͎͎̹̼̭̘̠̟̲͇̟͖͂̋̏̅̔̏͋̇̀͐̅͂̿̍̒͛́̾͗̑͂͊͂̀̋̓̀̓̽̔̋̐̈̓̀͑̑̒̒̍͑͌͌̎́͛̄͛͛̅́͗̿̚̚̕͘̚͜͝͝͝͝ͅͅę̶̢̡̨̡̧̨̢̢̛̛̛̛̛͉̬̜̘̪͕̪̖͚͚̝̜̜̩̹̗̰̫̼͕̼̰͔̞̤̬̞͓̖͙͙̣̰̭̹̫̬̘̯̭̟͖͉̖̰̗̮̯̭̿͒͒̌͐͛͒̿̋̐͂͌̾̾̀̉͆̾̆̇͋̒̿͂͐̍̄̽͌͆̏̉̐̈́̿̎̒̃̉̀͌̉̈́͌͊̇̒̔͌̈́̆̆̌̅̈͛͆͆̋̓̀͋̓̓̔͛́̃̾͛̂͊͂͑̐̑͑̉̐̂̊̒̕͘̕͘̕͘̚͘͜͜͝͝͝͝͠͠ͅ ̶̡̧̨̧̧̧̨̧̡̨̧̺̯͍͖̺̟̖͇̜͚̟̪̟̤̠̭͓͇̩͉̯̮͉͚͓̯̼̝̘͕͕͔͈͉̱̠̱͇̞̗̠̱̪̟̯͔͖͓̺̫̪̠͉̺͕̟̮̲̰͔̻̮͓͈̮̭̥̱͇̰͈̟̮̥̣̭̯̹̑̈́̿̅̾̃̄͆̆̉̔̂͗͐̒̄̈̈̋̈͊̾̀̓̾̒͘͜͠͝͝v̴̨̡̡̧̨̨̧̛̛̛̛̻͕͔̠͚͎̱̪̮͓̘̟͓͚̜̯͚̼͉͉̯̖͓͖̖̪̹͖̱̝̫̜̖̠̙̺̳͇̭͈̯̹̺̮̝̲͎̮̮̦͓͈͍̳̫̞͓͉̰̺͇̻̩̗̩̞̺̻̬̬̮͈̗͇͉̝͔̺̖̲͉̭͎̞̣̈́̎͊͗̾̌̅͋́̀̍̓͆̈̀͑̎̏̉̽͗̀̄͋̋̍͊̅̽̈́͑̉̓̐̀̾̀̀̎͑͆̿̈́͆͆̉̎͆̈́̃̓͐͑̃̐̊̏̒͛̀͌͑̐̆̅̋̿͐͒͂̅̃̍̄͆̈̎̔̆̓̇̈̾̾̇̿̈͌͆̔̄̀͘̕̚̕͘͘͜͜͜͜͝͠͝͠͝͠͝͝ͅͅͅͅi̵̢̧̧̢̡̡̨̡̛͙͙̲̫͙̪̠̹͕̲̺̻̜̜̭̠̱̟̙͖͖̘͍̣̙̬͈̜̣͍͙̘̟͚͙͕͉̲̺͍̜͎͚̘̫͇̲̗̲̞̞̩̫̗̫͍̲̥̺̮̻̹̝̹͉̪̪̭͓̰̭̠̤̝̰͕̮͍͖͕̙̖̫͉̭͓̰̱̳̫̠͍̬͉̣̱̮̳̲̭̮̪̭̗̳̳̲̞̻̯͙̎̅̈́̍͒̄̀̀̾̒͐̾̃̂̑́̅́̈́̑̈́̏͐͑̑̄̇̍̌̚̕̕̕̕͜͠͠͝͝͝͝ͅͅş̴̛̛͎̜̖͓̏̒̽̽́̿́̀̎́̐͒͋́͊̓̎͌̋̉̒̾͒͐̌̕͘ͅĩ̴̡̡̢̨̛̛̛͙̹̗̭͔̱͈̠̟̹̬̯̯̱͔̞͓̯͓̩̯̻̹̯̤̭̭͔̬͓͍͈͔̝̯͉̻̦̝̪̰̜̣̝̲̱͈̥̦̼͔̹̩͔̫̳̖̭̜̖̯̙̘̗̳͈͇̤̥͔̯̜͕̜̟̬̻̲̎͌͒̈́͗̂̇̓́̎̈́̄̾̿͑̂͒̀͌̆́͛͑̀̐̎͗͐̈́̈͊̐́́̈́͛̊͌̓͂̔̊́̉̋́̂̿̎̋̄͂͂͊͛̍̽͋̑̾͋̎̇̐̊̔͐̓̈́̀̇̾̆̃͑̌̂̀̊̀̒͐̒̍̍̒̒̓͗̎̽̌̄̒̄͌̓͊̿̂̊͋̀̈́̃͋̈̍́͆̑̑͘͘͘͘̕͘͘͜͜͝͝͠͠͠ͅͅͅb̵̧̧͓̻͚̰̰̻͕̮͕̹̱̲̞͙̝̹̆̊̔͑̓̐́͛̿̔̓̿̅̂̉̎͂͗̀̿͒͐̈̑͂̏͒̑̾̽̇̄̾̑̄̊̌̀͒̾͂̉̍͋̋̇̏̆̕̚̕͘͝͝͠͝l̷̢̧̨̢̡̨̢̡̡̛̗̤̹̞̱̬͎̗̣͍͈̦̝͇̱̖̮̩͙͉̪̞̮͙͍͍͔̘̭̻̼̘̺͙̪̳̣̱̲̲͈͔͍͎͙̙̲̟̥̪̺̩̺͓̜̗̬͙̬̳̜͍̻̩̙̭͈̘̗̝̦͓͇̟̭̦͚͖̥̤̦̻͈̘̩̭͇̫̩̺̟̪̝̩̟̰̥̞̥̝̮̖̺̟̺̗̗͇̦͙͙̞̽̑͑̊̐̓̀́̓͗̇̓͗͋̑̆͋̅͋͛̈̋̈́͛̚͘͜͜͜ͅͅͅͅȩ̴̨̨̢̡̨̼̻̻̝͔̱̘͕̥͚̟̦̻͖̺̼͇̼̬̙̦̫̝̗̥̞̥̻̦̙̬̩̠̟̺͖̪͚̲̙̪̲̻̺̺̥͈̝̲͉̟̥͇̰̻̫̟̣̰̫̹̲̦̬̼̦͓͍͎̙̼͎̤̥̻̪̩͖̼̱͇̗̋͋̐͂͑̊͊̉̿̉͗̎͋͌͌̀͒͋̐̃͊͗̆̑̀͒̈́̂̀͒͌̕̚̕͘͜ͅ",               14)

nc.stop

# `putStrAligned` sporadically returns errors, possibly related to
# scrolling/rendering bugs mentioned in ./cli1.nim
