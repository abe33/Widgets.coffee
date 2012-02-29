$(document).ready ->

    module "buildunit tests"

    test "BuildUnit should build an object without any arguments", ->
        constructorCalled = false

        class A
            constructor:->
                constructorCalled = true

        unit = new BuildUnit A
        o = unit.build()

        assertThat constructorCalled
        assertThat o instanceof A

    test "BuildUnit should allow to pass constructor arguments", ->

        constructorArgs = null
        args = [ 165, "irrelevant", true ]

        class B
            constructor:->
                constructorArgs = (a for a in arguments)

        unit = new BuildUnit B, args
        o = unit.build()

        assertThat constructorArgs, array.apply null, args

    test "BuildUnit should allow to set properties on the created
          object object", ->

        class C

        unit = new BuildUnit C, null, property1:"value 1", property2:"value 2"

        o = unit.build()
        assertThat o.property1, equalTo "value 1"
        assertThat o.property2, equalTo "value 2"

    test "BuildUnit should callback if a function is provided", ->

        class D

        callbackCalled = false
        callbackArg = null

        unit = new BuildUnit D, null, null, (arg)->
            callbackCalled = true
            callbackArg = arg

        o = unit.build()
        assertThat callbackCalled
        assertThat o is callbackArg

    module "tablebuilder tests"

    test "TableBuilder should be able to build a table
          and allow a callback to modify its content", ->

        table = new TableBuilder
            cls:Button
            args:[ display:"Button", action:-> ]
            rows:3
            cols:3
            callback:(opts)->
                opts.td.addClass "foo"
                opts.widget.set "disabled", true

        t = table.build()

        assertThat t.find("td").length, equalTo 9
        assertThat t.find("td").hasClass "foo"
        assertThat t.find("td").children().hasClass "disabled"

    test "TableBuilder should provide a specific class on its results", ->

        table = new TableBuilder
            cls:Button
            args:[ display:"Button", action:-> ]
            rows:3
            cols:3
            tableClass:"className"
            callback:(opts)->
                opts.td.addClass "foo"
                opts.widget.set "disabled", true

        t = table.build()

        assertThat t.hasClass "className"

    test "TableBuilder should add a header cell if table title is provided", ->
        table = new TableBuilder
            tableTitle:"Buttons"
            cls:Button
            args:[ display:"Button", action:-> ]
            rows:3
            cols:3
            callback:(opts)->
                opts.td.addClass "foo"
                opts.widget.set "disabled", true

        t = table.build()

        assertThat t.find("th").length, equalTo 1
        assertThat t.find("th").text(), contains "Buttons"
        assertThat t.find("th").attr("colspan"), equalTo "3"


    # Some live demos
    states = [ null, "readonly", "disabled" ]
    colors = [ null, "green", "blue" ]

    table = new TableBuilder
        tableTitle:"Buttons"
        tableClass:"float"
        cls:Button,
        args:[ display:"Button", action:-> ]
        rows:3
        cols:3
        callback:(opts)->
            opts.widget.addClasses colors[ opts.x ] if colors[ opts.x ]?
            opts.widget.set states[ opts.y ], true if states[ opts.y ]?

            opts.td.addClass "state" if opts.x is 0

    $("#qunit-header").before table.build()
