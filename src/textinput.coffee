# The `TextInput` widget wrap the target within a `span` in order to
# allow custom styling.
#
# Here some live instances where a prefix to the field
# was created using the `:before` selector through css :
# <div id="livedemos"></div>
# <link rel="stylesheet" href="../css/styles.css" media="screen">
# <link rel="stylesheet" href="../css/widgets.css" media="screen">
#
# <script type='text/javascript' src='../depends/jquery-1.6.1.min.js'></script>
# <script type='text/javascript' src='../depends/jquery.mousewheel.js'></script>
# <script type='text/javascript' src='../depends/signals.js'></script>
# <script type='text/javascript' src='../lib/widgets.js'></script>
#
# <script type='text/javascript'>
# var input1 = new TextInput();
# var input2 = new TextInput();
# var input3 = new TextInput();
#
# input1.dummyClass = input1.dummyClass + " a";
# input2.dummyClass = input2.dummyClass + " b";
#
# input1.set("value", "hello");
# input2.set("value", "readonly");
# input3.set("value", "disabled");
#
# input2.set("readonly", true);
# input3.set("disabled", true);
#
# input1.attach("#livedemos");
# input2.attach("#livedemos");
# input3.attach("#livedemos");
# </script>
class TextInput extends Widget

  @mixins HasFocusProvidedByChild

  constructor:(target)->

    # The `target` is mandatory in the `TextInput` constructor so a default
    # target is created when nothing is passed to the constructor.
    target = $("<input type='text'></input>")[0] unless target?

    super target

    @maxlength = @valueFromAttribute "maxlength"

    @valueIsObsolete = false

  #### Target management

  # The target for a `TextInput` must be an input with the
  # type `text` or `password`.
  checkTarget:(target)->
    unless @isInputWithType target, "text", "password"
      throw new Error "TextInput must have an input text as target"

  #### Dummy management

  # The dummy for a `TextInput` is a `span` with a `text` class on it.
  createDummy:->
    dummy = $ "<span class='text'></span>"

    # The target of the widget is appended to the dummy.
    dummy.append @jTarget
    @focusProvider = @jTarget

    dummy

  #### Properties accessors

  # Handles the `maxlength` attribute of the target.
  set_maxlength:(property, value)->
    if value?
      @jTarget.attr "maxlength", value
    else
      @jTarget.removeAttr "maxlength"
    @[property] = value

  #### Events handling

  # When the user types some text in the target, the widget's
  # value is marked as obsolete.
  input:(e)->
    @valueIsObsolete = true

  # When the `change` event occurs, the content of the
  # target is saved as the new widget's value and the obsolete
  # flag is set to `false`.
  #
  # The flag is unset after the value's affectation, and since
  # a `valueChanged` signal is dispatched, the `valueIsObsolete`
  # property allow a listener to know if the change done to the
  # widget was done by a user input.
  change:(e)->
    @set "value", @valueFromAttribute "value"
    @valueIsObsolete = false
    false

@TextInput = TextInput
