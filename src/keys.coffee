# This file contains the various classes and methods related
# to key strokes.
#
# Key strokes are represented by the `KeyStroke` object.
# It should only exist one instance of the `KeyStroke`
# class for a given key combination. That's the purpose
# of the `keystroke` function.

# Use the `keystroke` function to get a `KeyStroke` instance
# corresponding to the passed `keyCode` and `modifiers`.
#
# To get a key stroke you should do the following:
#
#     keystroke keys.a, keys.mod.ctrl + keys.mod.shift
#
# As you can see above, the `modifiers` value is an integer produced
# by adding different modifiers together.
keystroke = (keyCode, modifiers) ->

  # The `keystroke` function ensure that only one `KeyStroke` instance
  # exist for a given combination, it allow to use the equal operator
  # to compare key strokes.
  #
  # Consequently, the following expression is true :
  #
  #     (keystroke keys.a) is (keystroke.keys.a)
  #
  if "#{keyCode}-#{modifiers}" of KeyStroke.instances
    KeyStroke.instances["#{keyCode}-#{modifiers}"]
  else
    KeyStroke.instances["#{keyCode}-#{modifiers}"] = new KeyStroke keyCode,
                                                                   modifiers

#### KeyStroke

# The `KeyStroke` class isn't meant to be instanciated manually,
# use the `keystroke` function instead.
class KeyStroke

  # All key stroke instances are stored at the class level.
  @instances = {}

  # Takes the `keyCode` and the `modifiers` and initialize
  # the specific modifiers properties.
  constructor: (keyCode, modifiers) ->

    @keyCode    = keyCode
    @modifiers  = modifiers
    # `ctrl` mofifier is stored in the first bit, `shift`
    # in the second and `alt` in the third
    @ctrl       = (modifiers & 0x01) is 1
    @shift      = (( modifiers >> 1 ) & 0x01) is 1
    @alt        = (( modifiers >> 2 ) & 0x01) is 1

  # Compare the passed-in key event with the current instance.
  match: (e) ->
    e.keyCode  is @keyCode and
    e.ctrlKey  is @ctrl    and
    e.shiftKey is @shift   and
    e.altKey   is @alt

  # Provide a human readable representation of the key stroke.
  # For exemple, the following keystroke :
  #
  #     keystroke keys.z, keys.mod.ctrl
  #
  # Will output as `Ctrl+Z`.
  toString: ->
    a = []

    if @ctrl  then a.push "Ctrl"
    if @shift then a.push "Shift"
    if @alt   then a.push "Alt"

    for k, v of keys
      if @keyCode is v
        a.push k.toUpperCase()
        break

    a.join "+"

#### Constants

# A list of keys codes and modifiers values.
keys =
  # Stores the modifiers values.
  # Use additions to produce the final modifier, such as in:
  #
  #     keystroke keys.a, keys.mod.ctrl + keys.mod.shift
  mod:
    ctrl          : 1
    shift         : 2
    alt           : 4
  # Here starts the key codes.
  backspace       : 8
  tab             : 9
  enter           : 13
  shift           : 16
  ctrl            : 17
  alt             : 18
  pause           : 19
  caps_lock       : 20
  escape          : 27
  space           : 32
  page_up         : 33
  page_down       : 34
  end             : 35
  home            : 36
  left            : 37
  up              : 38
  right           : 39
  down            : 40
  insert          : 45
  decimal         : 46
  key_0           : 48
  key_1           : 49
  key_2           : 50
  key_3           : 51
  key_4           : 52
  key_5           : 53
  key_6           : 54
  key_7           : 55
  key_8           : 56
  key_9           : 57
  a               : 65
  b               : 66
  c               : 67
  d               : 68
  e               : 69
  f               : 70
  g               : 71
  h               : 72
  i               : 73
  j               : 74
  k               : 75
  l               : 76
  m               : 77
  n               : 78
  o               : 79
  p               : 80
  q               : 81
  r               : 82
  s               : 83
  t               : 84
  u               : 85
  v               : 86
  w               : 87
  x               : 88
  y               : 89
  z               : 90
  left_window_key : 91
  right_window_key: 92
  select          : 93
  numpad_0        : 96
  numpad_1        : 97
  numpad_2        : 98
  numpad_3        : 99
  numpad_4        : 100
  numpad_5        : 101
  numpad_6        : 102
  numpad_7        : 103
  numpad_8        : 104
  numpad_9        : 105
  multiply        : 106
  add             : 107
  subtract        : 109
  decimal_point   : 110
  divide          : 111
  f1              : 112
  f2              : 113
  f3              : 114
  f4              : 115
  f5              : 116
  f6              : 117
  f7              : 118
  f8              : 119
  f9              : 120
  f10             : 121
  f11             : 122
  f12             : 123
  num_lock        : 144
  scroll_lock     : 145
  semi_colon      : 186
  equal_sign      : 187
  comma           : 188
  dash            : 189
  period          : 190
  forward_slash   : 191
  grave_accent    : 192
  open_bracket    : 219
  back_slash      : 220
  close_bracket   : 221
  single_quote    : 222

@keystroke = keystroke
@keys  = keys
