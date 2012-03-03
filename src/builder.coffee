# <link rel="stylesheet" href="../css/styles.css" media="screen">
#
# This file contains the classes used in the demo file.

#### TableBuilder
#
# `TableBuilder` creates a table containing widgets.
class TableBuilder
    constructor:( @options )->

    build:->
        cols = [0..@options.cols-1]
        rows = [0..@options.rows-1]

        hasColumnHeaders = @options.columnHeaders?
        hasRowHeaders    = @options.rowHeaders?

        table = $("<table></table>")
        table.addClass @options.tableClass if @options.tableClass?

        if @options.title?
            colspan = @options.cols
            colspan += 1 if hasRowHeaders
            table.append $ "<tr><th colspan='#{ colspan }'
                                    class='table-header'>
                                #{ @options.title }
                            </th></tr>"

        if hasColumnHeaders
            tr = $("<tr></tr>")
            opts =
                builder:this
                table:table
                tr:tr

            tr.append "<td></td>" if hasRowHeaders

            for col in cols
                th = $("<th class='column-header'></th>")

                opts.col = col
                opts.th = th

                th.text @options.columnHeaders opts

                tr.append th

            table.append tr

        for row in rows
            tr = $("<tr></tr>")
            table.append tr

            opts =
                builder:this
                table:table
                tr:tr

            if hasRowHeaders
                th = $("<th class='row-header'></th>")


                opts.row = row
                opts.th = th

                th.text @options.rowHeaders opts

                tr.append th

            for col in cols
                td = $("<td></td>")
                tr.append td

                if @options.cls?
                    unit = new BuildUnit @options.cls, @options.args
                    widget = unit.build()
                    widget.attach td
                    opts.widget = widget

                opts[k] = v for k,v of {
                    td:td
                    col:col
                    row:row
                }

                @options.cells? opts

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
