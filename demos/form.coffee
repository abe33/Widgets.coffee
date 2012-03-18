handleState=(opts)->
  opts.widget.addClasses "dummy"
  opts.widget.set STATES[ opts.row ], true if STATES[ opts.row ]

rowHeaders=(opts)-> ([ "Normal", "Readonly", "Disabled" ])[opts.row]

STATES = [
  null,
  "readonly",
  "disabled",
]
BUILDS=[
  {
    title:"SquarePicker"
    cls:SquarePicker
    rows:3
    cols:1
    tableClass:"float"
    rowHeaders:rowHeaders
    cells:(opts)->
      opts.widget.set
        rangeX:[0,100],
        rangeY:[0,100]

      opts.widget.set "value", [20,45]

      if opts.y is 1 then opts.widget.set "readonly",true
      else if opts.y is 2 then opts.widget.set "disabled",true

      handleState opts
  },{
    title:"MenuList"
    cls:MenuList
    rows:3
    cols:1
    args:[ new MenuModel( { display:"Item 1" },
               { display:"Item 2" },
               { display:"Item 3" },
               { display:"Item 4" },
               { display:"Item 5" },
               { display:"Item 6" })]
    tableClass:"float"
    rowHeaders:rowHeaders
    cells:handleState
  },{
    title:"ColorPicker"
    cls:ColorPicker
    rows:3
    cols:1
    tableClass:"float"
    rowHeaders:rowHeaders
    cells:(opts)->
      opts.widget.set "value","#859900"
      handleState opts

  },{
    title:"Calendar"
    cls:Calendar
    rows:3
    cols:3
    args:[new Date()]
    tableClass:"float"
    rowHeaders:rowHeaders
    cells:(opts)->
      handleState opts
      opts.widget.set "mode", (["date","month","week"])[opts.col]
    columnHeaders:(opts)->
      (["Date","Month","Week"])[opts.col]
  }
]

$(document).ready ->

  $("form").widgets()

  # for build in BUILDS
  #   builder = new TableBuilder build
  #   $("form").first().after "<a name='#{build.title}'></a>"
  #   $("form").first().after builder.build()

  # input= new TextInput
  # button= new Button
  #   display:"<b>Say Hello!</b>"
  #   action:->
  #     alert "#{ input.get "value" } said: Hello World!"

  # input.attach "body"
  # button.attach "body"

