# The `Radio` widget is a kind of `CheckBox` that can
# be only set to true by the user.
#
# They're generaly used in combination with a `RadioGroup`.
#
# Here some live instances :
# <div id="livedemos"></div>
# <link rel="stylesheet" href="../css/styles.css" media="screen">
# <link rel="stylesheet" href="../css/widgets.css" media="screen">
#
# <script type='text/javascript'
#         src='../depends/jquery-1.6.1.min.js'></script>
# <script type='text/javascript'
#         src='../depends/jquery.mousewheel.js'></script>
# <script type='text/javascript' src='../depends/signals.js'></script>
# <script type='text/javascript' src='../lib/widgets.js'></script>
#
# <script type='text/javascript'>
# var radio1 = new Radio();
# var radio2 = new Radio();
# var radio3 = new Radio();
#
# radio2.set( "readonly", true );
# radio2.set( "checked", true );
# radio3.set( "disabled", true );
#
# radio1.attach("#livedemos");
# radio2.attach("#livedemos");
# radio3.attach("#livedemos");
# </script>
class Radio extends CheckBox

  # The target for a `Radio` must be an input with the type `radio`.
  checkTarget:( target )->
    unless @isInputWithType target, "radio"
      throw new Error "Radio target must be an input with a radio type"

  # The dummy for the radio is just a `<span>` element
  # with a `radio` class.
  createDummy:->
    $ "<span class='radio'></span>"

  # Toggle is unidirectionnal. The only way to
  # uncheck a radio is by code.
  toggle:->
    super() unless @get "checked"

@Radio = Radio
