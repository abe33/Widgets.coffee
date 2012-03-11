# A `Stepper` is a widget that allow the manipulation of
# a number through a text input and two buttons to increment
# or decrement the value.
#
# Here some live instances :
# <div id="livedemos"></div>
# <link rel="stylesheet" href="../css/styles.css" media="screen">
# <link rel="stylesheet" href="../css/widgets.css" media="screen">
#
# <script type='text/javascript' src='../depends/jquery-1.6.1.min.js'></script>
# <script type='text/javascript'
#         src='../depends/jquery.mousewheel.js'></script>
# <script type='text/javascript' src='../depends/signals.js'></script>
# <script type='text/javascript' src='../lib/widgets.js'></script>
#
# <script type='text/javascript'>
# var stepper1 = new Stepper();
# var stepper2 = new Stepper();
# var stepper3 = new Stepper();
#
# stepper2.set( "readonly", true );
# stepper2.set( "checked", true );
# stepper3.set( "disabled", true );
#
# stepper1.attach("#livedemos");
# stepper2.attach("#livedemos");
# stepper3.attach("#livedemos");
# </script>
class Stepper extends NumericWidget

    @mixins HasFocusProvidedByChild, Spinner

    spinnerDummyClass:"stepper"

    constructor:(target)->
        super target

        unless @get("step")? then @set "step", 1

        @updateDummy @get("value"), @get("min"), @get("max"), @get("step")

    #### Target Management

    # The target for a `Stepper` must be an input with the type `number`.
    checkTarget:( target )->
        unless @isInputWithType target, "number"
            throw new Error """Stepper target must be an input
                               with a number type"""

    #### Dummy Management

    # The value of the widget is displayed within its input.
    updateDummy:( value, min, max, step )->
        @focusProvider.val value

    # When the value of the input is changed, the new value go through
    # the validation function.
    validateInput:->
        # The input's value is parsed to a float.
        value = parseFloat @focusProvider.attr("value")

        # And if the resulting value is a number, it's affected
        # to this widget's value.
        unless isNaN value
            @set "value", value
        else
            @updateDummy @get("value"), @get("min"), @get("max"), @get("step")

    drag:( dif )-> @set "value", @get("value") + dif * @get("step")

@Stepper = Stepper
