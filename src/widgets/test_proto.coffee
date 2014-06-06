
widgets.define 'test_proto', mixins: [
  widgets.Activable
], class TestProto
  constructor: (@element) ->
    @on_activate = => console.log 'activated'
    @on_deactivate = => console.log 'deactivated'
