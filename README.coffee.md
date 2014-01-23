
## Interaction

How an interaction can be defined, in a context where the action
controller is external to widgets.

Let's start with some basic description:

  1. It starts with the user producing an input. This input can be:
    - a keyboard input
    - a mouse input
    - a touch input
    - a sound input
    - a visual input
  2. The user input can last some time, with some feedback expliciting
     the way the input goes, such as how it start, how it progress, how
     it ends. Feedbacks can take the following forms:
    - a visual feedback
    - a sonor feedback
    - a physical feedback (vibrations, and maybe sensitive onscreen
      feedback in a near future)
  3. The user ends the input, the computer may now interpret and process
     this input.
  4. This process can last some time, with some feedback on the progress
     and conclusion of the progress.

### How describing these steps in a way that *gestures* can be changed at will with little pain?

The `Strategy` pattern seems like an obvious choice here. Gestures are objects
composed by the interaction.

### How several gestures with the same starting point differenciates themselves?

They probably have to delegate some responsibilities to a manager based
on the type of device used for the gestures (mouch, keyboard, touch).
In that context the manager will have to ask each concerned gestures if
they can handle the current action.

For instance, in a swipe motion, each of the four directions starts on
a `touchstart` event, but according to the direction one will prevail.

#### Does it need to be fixed at some point?

Maybe the gesture can send a lock request to the manager at some point.
In the previous example, once the motion reach a given distance from the
start the gesture that match the current direction may lock the remaining
motion. Ending the motion back at the starting point trigger the interaction
abort.

### How does available gestures are defined according to browser capabilities?

Mostly using features detection(such as in [this article](http://perfectionkills.com/detecting-event-support-without-browser-sniffing/)).

Each gestures/feedbacks/interactions may use `Modernizr` tests to define if its availability.

### What does producing feedbacks imply?

Feedbacks are essencially listeners of gestures and interactions. But each feedback can works on a different event, with different informations.

## Concrete Stuff

### Typical events flow

For keyboard:

  - keydown/keypress
  - keyup

For mouse:

  - mouseover/mouseenter
  - mousedown
  - mousemove
  - mouseup
  - mouseout/mouseleave

For touchscreen:

  - touchstart
  - touchmove
  - touchend

### Interfaces

Some interfaces draft (pseudo code):

    interface Timeable
      started: [Signal]
      updated: [Signal]
      ended: [Signal]

    interface Interaction
      @include Timeable

      aborted: [Signal]

      gestures: [Array]  # gestures by targets
      feedbacks: [Array] # feedbacks by targets
      processor: [Action]

    interface Gesture
      @include Timeable

    interface DeviceEventsManager
      register: (gesture, event) ->

    interface Feedback
      feedbacks: [Array]

Widgets can have one or more interactions.

    interface Widget
      interactions: [Array]

In that context, interactions must be bounds to the widget's model
in some way.


