# Widgets.coffee

Widgets.coffee is an attempt to create a ui widget library for coffescript through TDD.

Widgets replace html entities by dummies that can be styled and animated and that offer a common behavior accross browser. These dummies are simple html elements controlled behind the scene by a widget instance.

## Usages

The first use case is the replacement of form elements in a page:

    $(document).ready ->
      $("form").widgets()

It will takes all the forms in the page and replace all the `input`, `select` and `textarea` it contains by widgets.

Each widget will be bind to its target. In that case its all the html form element that was preset in the form.
Each input type, select and textarea are mapped to a specific class of widget.
These widgets will handle the modification of their target's value through their dummy. This dummy being inserted in the DOM next to its target. The target is either hidden or reused by the widget.

Several input of type `radio` in a radiogroup (having the same `name`) will lead to the creation of a `RadioGroup` that will handle the states of the created `Radios`.

If a `reset` button is present, its widget will handle calling the `reset` function on each input widget.

You can also call the `widgets` plugin on a set of elements:

    $("input,textarea").widgets()

The second use case is the creation of Widgets from javascript:

    input = new TextInput
    button = new Button display:"<b>Say Hello!</b>", action:->
      alert "#{ input.get("value") } said: Hello World!"

    input.attach "body"
    button.attach "body"

It creates a text input and a button and append them to the page body. The button receive an `action` object that will open an alert with the content of the text input. As dummies are simple html element, we can insert html element within the button dummy through the `display` property.

## Signals VS Events

Widgets provides [signals](http://en.wikipedia.org/wiki/Signals_and_slots) rather that events. Signals are a different implementation of the [Observer](http://en.wikipedia.org/wiki/Observer_pattern) pattern. It differs from [ECMA events](http://www.w3.org/TR/DOM-Level-2-Events/ecma-script-binding.html) in that a signal dispatch only one event and that it don't necessarly use an event object as information carrier. In that regard signals are much simpler and easier to use than events and are well suited for graphic interfaces.

To register to a widget's signal you can do:

    input = new TextInput

    input.valueChanged.add ( widget, value )->
      # do something

It register an anonymous function to receive the `valueChanged` signal (dispatched by every widget whose value was changed).

Every widgets provides the following signals:

 * `valueChanged`: When the value of the widget changed.
 * `propertyChanged`: When the value of a property of the widget changed.
 * `stateChanged`: When the state of the widget (disabled, readonly, etc..) changed.
 * `attached`: When the widget's dummy is inserted in the DOM.
 * `detached`: When the widget's dummy is detached from the DOM.

### Dependencies

 * [signals.coffee][1]: Provides the Signal class.
 * [jQuery][2]: Widgets are available as a jQuery plugin and make use of it.

[1]: http://github.com/abe33/CoffeeScript-Signal
[2]: http://http://jquery.com/
