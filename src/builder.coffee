# This file contains the classes used in the demo file.

#### TableBuilder
#
# `TableBuilder` creates a table containing widgets.
class TableBuilder
    constructor:( @options )->

    build:->
        table = $("<table></table>")
        table.addClass @options.tableClass if @options.tableClass?

        if @options.tableTitle?
            table.append $ "<tr><th colspan='#{ @options.cols }'>
                                #{ @options.tableTitle }
                            </th></tr>"

        for y in [0..@options.rows-1]
            tr = $("<tr></tr>")
            table.append tr

            for x in [0..@options.cols-1]
                td = $("<td></td>")
                tr.append td

                unit = new BuildUnit @options.cls, @options.args
                widget = unit.build()
                widget.attach td

                @options.callback? (
                    builder:this
                    widget:widget
                    table:table
                    tr:tr
                    td:td
                    x:x
                    y:y
                )

        table

# Builds an instanceofof a class with the specified arguments
class BuildUnit
    constructor:( @klass, @args = [], @set = {}, @callback = null )->

    build:->
        o = @construct @klass, @args
        if o.set instanceof Function then o.set @set
        else o[k] = @set[k] for k of @set

        @callback? o
        o

    construct:( klass, args )->
        f = BUILDS[ args.length ]
        f klass, args

BUILDS=(
    new Function( "return new arguments[0](#{
        ("arguments[1][#{j-1}]" for j in [0..i] when j isnt 0 ).join ","
    });") for i in [0..24]
)

@BuildUnit = BuildUnit
@TableBuilder = TableBuilder
