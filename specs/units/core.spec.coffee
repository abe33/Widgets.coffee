describe widgets, ->
  fixture 'dummy_widget.html'

  before ->
    widgets.define 'dummy', (element) ->

    widgets 'dummy', '.dummy', on: 'custom:event'

    spyOn(widgets, 'dummy').andCallFake()

    document.dispatchEvent(new Event 'custom:event')

  subject -> widgets.dummy

  it -> should haveBeenCalled
