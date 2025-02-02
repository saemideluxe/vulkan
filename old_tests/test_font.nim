import std/times
import std/unicode

import semicongine


proc main() =
  # setup engine
  var engine = InitEngine("Test fonts")
  engine.InitRenderer([])

  # build scene
  var scene = Scene(name: "main")
  var font = LoadFont("DejaVuSans.ttf", lineHeightPixels = 210'f32)
  var origin = InitPanel(transform = Scale(0.01, 0.01))
  var main_text = font.InitText("".toRunes, maxLen = 255, color = NewVec4f(1, 0.15, 0.15, 1), maxWidth = 1.0, transform = Scale(0.0005, 0.0005))
  var help_text = font.InitText("""Controls

Horizontal alignment:
  F1: Left
  F2: Center
  F3: Right
Vertical alignment:
  F4: Top
  F5: Center
  F6: Bottom""".toRunes, horizontalAlignment = Left, verticalAlignment = Top, transform = Translate(-0.9, -0.9) * Scale(0.0002, 0.0002))
  scene.Add origin
  scene.Add main_text
  scene.Add help_text
  engine.LoadScene(scene)
  mixer[].LoadSound("key", "key.ogg")
  mixer[].SetLevel(0.5)

  while engine.UpdateInputs() and not KeyIsDown(Escape):
    var t = cpuTime()
    main_text.Color = NewVec4f(sin(t) * 0.5 + 0.5, 0.15, 0.15, 1)

    # add character
    if main_text.text.len < main_text.maxLen - 1:
      for c in [Key.A, Key.B, Key.C, Key.D, Key.E, Key.F, Key.G, Key.H, Key.I,
          Key.J, Key.K, Key.L, Key.M, Key.N, Key.O, Key.P, Key.Q, Key.R, Key.S,
          Key.T, Key.U, Key.V, Key.W, Key.X, Key.Y, Key.Z]:
        if KeyWasPressed(c):
          discard mixer[].Play("key")
          if KeyIsDown(ShiftL) or KeyIsDown(ShiftR):
            main_text.text = main_text.text & ($c).toRunes
          else:
            main_text.text = main_text.text & ($c).toRunes[0].toLower()
      if KeyWasPressed(Enter):
        discard mixer[].Play("key")
        main_text.text = main_text.text & Rune('\n')
      if KeyWasPressed(Space):
        discard mixer[].Play("key")
        main_text.text = main_text.text & Rune(' ')

    # remove character
    if KeyWasPressed(Backspace) and main_text.text.len > 0:
      discard mixer[].Play("key")
      main_text.text = main_text.text[0 ..< ^1]

    # alignemtn with F-keys
    if KeyWasPressed(F1): main_text.horizontalAlignment = Left
    elif KeyWasPressed(F2): main_text.horizontalAlignment = Center
    elif KeyWasPressed(F3): main_text.horizontalAlignment = Right
    elif KeyWasPressed(F4): main_text.verticalAlignment = Top
    elif KeyWasPressed(F5): main_text.verticalAlignment = Center
    elif KeyWasPressed(F6): main_text.verticalAlignment = Bottom

    origin.Refresh()
    main_text.text = main_text.text & Rune('_')
    main_text.Refresh()
    main_text.text = main_text.text[0 ..< ^1]
    help_text.Refresh()
    engine.RenderScene(scene)
  engine.Destroy()


when isMainModule:
  main()
