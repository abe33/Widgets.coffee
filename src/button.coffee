class Button extends Widget
  # Here some live instances :
  #
  #= require button

  # The `Button` constructor can be called both with an target input:
  #
  #     button = new Button target
  #
  # Or with an `action` object:
  #
  #     button = new Button action: ->
  #         console.log "action triggered"
  #
  # If you need to pass both a target and an action, pass the target
  # as the first argument and the action as the second:
  #
  #     button = new Button target, action: ->
  #         console.log "action triggered"
  #
  # Action object must have an `action` property that contains a function
  # to trigger on clicks. An optionnal `display` property can be set on the
  # action, the string it contains will be used to generate the content
  # of the button dummy.
  #
  # For instance, the following button will have its label displayed in bold:
  #
  #     button = new Button display: "<b>label</b>", action:->
  #         console.log "action triggered"
  constructor: (args...) ->

    switch args.length
      when 1
        [arg] = args
        if typeof arg.action is "function"
          action = arg
        else
          target = arg
      when 2 then [target, action] = args

    super target

    # The action object of this button.
    @action = action

    # Initialize the button's content with the provided data.
    @updateContent()
    @hideTarget()

    if @hasTarget and @jTarget.attr("type") is "reset"
      @jTarget.click (e) -> e.preventDefault()

    #### Keyboard Controls

    # Both the `Enter` and `Space` keys can be used instead
    # of the click to trigger the button.
    @registerKeyDownCommand keystroke(keys.space), @click
    @registerKeyDownCommand keystroke(keys.enter), @click

  #### Target Management

  # The target for a button must an input with one of the following types:
  # `button`, `reset` or `submit`.
  checkTarget: (target) ->
    unless @isInputWithType target, "button", "reset", "submit"
      throw new Error """Buttons only support input with a type in button,
                         reset or submit as target"""

  #### Dummy Management

  # The base structure of a button is simply a `span`
  # with a `button` class.
  createDummy: ->
    $("<span class='button'></span>")

  # The real content of the button is produced
  # in the `updateContent` method.
  updateContent: ->
    # All the previous content is removed beforehand.
    @dummy.find(".content").remove()

    action = @get "action"
    value = @get "value"

    # The action's data are preferred to the widget's value
    # to generate the content. However, if no `display` property
    # is present in the action object, the button fall back
    # to the value.
    if action? and action.display?
      @dummy.append $("<span class='content'>#{action.display}</span>")
    else
      @dummy.append $("<span class='content'>#{value}</span>")

  # Cacth changes mades to the `action` or `value` properties
  # to force a refresh of the button's content.
  handlePropertyChange: (property, value) ->
    super property, value

    if property in ["value", "action"] then @updateContent()

  #### Events Handler

  # Catch clicks on the button.
  click: (e) ->
    return if @cantInteract()

    action = @get "action"

    # Both the action and the target are triggered on a click.
    action.action() if action?
    @jTarget.click() if @hasTarget

@Button = Button
