$(document).ready ->

  module "buildunit tests"

  test "BuildUnit should build an object without any arguments", ->
    constructorCalled = false

    class A
      constructor: ->
        constructorCalled = true

    unit = new BuildUnit cls: A
    o = unit.build()

    assertThat constructorCalled
    assertThat o instanceof A

  test "BuildUnit should allow to pass constructor arguments", ->

    constructorArgs = null
    args = [ 165, "irrelevant", true ]

    class B
      constructor: ->
        constructorArgs = (a for a in arguments)

    unit = new BuildUnit cls:B, args: args
    o = unit.build()

    assertThat constructorArgs, array.apply null, args

  test "BuildUnit should allow to set properties on the created
      object object", ->

    class C

    unit = new BuildUnit cls: C, set:
      property1: "value 1",
      property2: "value 2"

    o = unit.build()
    assertThat o.property1, equalTo "value 1"
    assertThat o.property2, equalTo "value 2"

  test "BuildUnit should cell if a function is provided", ->

    class D

    cellCalled = false
    cellArg = null

    unit = new BuildUnit cls:D, callback: (arg)->
      cellCalled = true
      cellArg = arg

    o = unit.build()
    assertThat cellCalled
    assertThat o is cellArg

  module "tablebuilder tests"

  test "TableBuilder should be able to build a table
      and allow a cell to modify its content", ->

    table = new TableBuilder
      cls: Button
      args:[ action: -> ]
      rows: 3
      cols: 3
      cells: (opts)->
        opts.td.addClass "foo"
        opts.widget.set "disabled", true

    t = table.build()

    assertThat t.find("td").length, equalTo 9
    assertThat t.find("td").hasClass "foo"
    assertThat t.find("td").children().hasClass "disabled"

  test "TableBuilder should provide a specific class on its results", ->

    table = new TableBuilder
      cls: Button
      args:[ action: -> ]
      rows: 3
      cols: 3
      tableClass: "className"
      cells: (opts)->
        opts.td.addClass "foo"
        opts.widget.set "disabled", true

    t = table.build()

    assertThat t.hasClass "className"

  test "TableBuilder should add a general header cell
      if table title is provided", ->
    table = new TableBuilder
      title: "Buttons"
      cls: Button
      args:[ action: -> ]
      rows: 3
      cols: 3

    t = table.build()

    assertThat t.find("th").length, equalTo 1
    assertThat t.find("th").hasClass "table-header"
    assertThat t.find("th").text(), contains "Buttons"
    assertThat t.find("th").attr("colspan"), equalTo "3"

  test "TableBuilder should add a header for each column
      if a function is provided", ->

    table = new TableBuilder
      cls: Button
      args:[ action: -> ]
      rows: 3
      cols: 3
      columnHeaders: (opts)->
        "foo#{opts.col+1}"

    t = table.build()

    assertThat t.find("th").length, equalTo 3
    assertThat t.find("th").hasClass "column-header"
    assertThat $(t.find("th")[0]).text(), equalTo "foo1"
    assertThat $(t.find("th")[1]).text(), equalTo "foo2"
    assertThat $(t.find("th")[2]).text(), equalTo "foo3"

  test "TableBuilder should add a header for each row
      if a function is provided", ->

    table = new TableBuilder
      cls: Button
      args:[ action: -> ]
      rows: 3
      cols: 3
      rowHeaders: (opts)->
        "foo#{opts.row + 1}"

    t = table.build()

    assertThat t.find("th").length, equalTo 3
    assertThat t.find("th").hasClass "row-header"
    assertThat $(t.find("th")[0]).text(), equalTo "foo1"
    assertThat $(t.find("th")[1]).text(), equalTo "foo2"
    assertThat $(t.find("th")[2]).text(), equalTo "foo3"

  test "TableBuilder should add adjust the colspan
      and column headers when row headers are provided", ->

    table = new TableBuilder
      cls: Button
      args:[ action: -> ]
      rows: 3
      cols: 3
      title: "Foo"
      columnHeaders: (opts)->
        "foo#{opts.col+1}"
      rowHeaders: (opts)->
        "foo#{opts.row + 1}"

    t = table.build()

    assertThat t.find("th").first().attr("colspan"), equalTo "4"
    assertThat $(t.find("tr")[1]).children().length, equalTo 4

  test "TableBuilder shouldn't create anything in a cell
      unless the cls options is provided", ->

    table = new TableBuilder
      rows: 3
      cols: 3

    t = table.build()
    assertThat t.length, equalTo 1
    assertThat t.find("td").length, equalTo 9

    t.find("td").each (i,o)->
      assertThat $(o).children().length, equalTo 0

  # Some live demos
  states = [ null, "readonly", "disabled" ]
  colors = [ null, "blue", "green" ]
  colHeaderLabels = [ "Normal", "Blue", "Green" ]
  rowHeaderLabels = [ "Normal", "Readonly", "Disabled" ]

  table = new TableBuilder
    title: "Buttons"
    cls: Button,
    args:[ display: "Button", action:-> ]
    rows: 3
    cols: 3
    tableClass: "float dummy"
    columnHeaders: (opts)-> colHeaderLabels[opts.col]
    rowHeaders: (opts)-> rowHeaderLabels[opts.row]
    cells: (opts)->
      opts.widget.addClasses colors[ opts.col ] if colors[ opts.col ]?
      opts.widget.set states[ opts.row ], true if states[ opts.row ]?

  $("#qunit-header").before "<h4>TableBuilder</h4>"
  $("#qunit-header").before table.build()
