# <link rel="stylesheet" href="../css/styles.css" media="screen">
#
# This file contains the classes used in the demo file.
#
#  * [TableBuilder](#TableBuilder)
#  * [BuildUnit](#BuildUnit)

# <a name="TableBuilder"></a>
#### TableBuilder
#
# `TableBuilder` creates a table containing widgets.
class TableBuilder
  # Create a new `TableBuilder` with the passed-in `options`
  # containing the build setup, `options` being an object.
  #
  # *Available Options*
  #
  #  * `rows`: The number of rows of the table
  #  * `cols`: The number of columns of the table
  #  * `cls`: The class of widget to put in each cell.
  #    When ommited the cells are leaved empty.
  #  * `args`: The arguments to pass to the widget's class constructor.
  #  * `title`: A string that will be displayed in a header at the top
  #    of the table.
  #  * `tableClass`: A string that will fill the `class` attribute
  #    of the table.
  #  * `cells`: A function that will be called for each cell in the table.
  #    The function will receive an object containing the elements
  #    of the context. This object will contains :
  #    - `builder`: A reference to the current builder.
  #    - `table`: The jQuery object containing the table.
  #    - `tr`: The current row in a jQuery object.
  #    - `td`: The current cell in a jQuery object.
  #    - `row`: The number of the current row (0-based)
  #    - `col`: The number of the current column (0-based)
  #    - `widget`: Contains a reference to the widget if the `cls` option
  #      is provided.
  #  * `rowHeaders`: A function that will be called for each row and which
  #    return will be used as content for the row header. The function will
  #    receive an object containing the elements of the context.
  #    This object will contains :
  #    - `builder`: A reference to the current builder.
  #    - `table`: The jQuery object containing the table.
  #    - `tr`: The current row in a jQuery object.
  #    - `row`: The number of the current row (0-based)
  #  * `columnHeaders`:A function that will be called for each row and which
  #    return will be used as content for the row header. The function will
  #    receive an object containing the elements of the context.
  #    This object will contains :
  #    - `builder`: A reference to the current builder.
  #    - `table`: The jQuery object containing the table.
  #    - `tr`: The current row in a jQuery object.
  #    - `th`: The current header cell in a jQuery object.
  #    - `col`: The number of the current column (0-based)
  #
  constructor:( @options )->

  # Builds and returns a table according to the current `options`
  # of this builder.
  build:->
    # Ranges used to iterate over rows and columns.
    cols = [0..@options.cols-1]
    rows = [0..@options.rows-1]

    # Does the table has columns and rows headers.
    hasColumnHeaders = @options.columnHeaders?
    hasRowHeaders    = @options.rowHeaders?

    table = $("<table></table>")
    table.addClass @options.tableClass if @options.tableClass?

    # If `options.title` is defined, a row containing a single cell
    # will be added at the top of the table. The text content of the
    # cell is the value of the option.
    if @options.title?
      colspan = @options.cols
      colspan += 1 if hasRowHeaders
      table.append $ "<tr><th colspan='#{ colspan }'
                              class='table-header'>
                          #{ @options.title }
                      </th></tr>"

    # If a function is provided in `options.columnHeaders` each column
    # of the table will have a header which content is the return of the
    # function called with the corresponding context.
    if hasColumnHeaders
      # Creates a row for hosting the header cells.
      tr = $("<tr></tr>")
      table.append tr
      # An initial cell is appended if the table also have row headers.
      tr.append "<td></td>" if hasRowHeaders

      # Creates a context object that will contains all the elements
      # to pass to the column header function.
      context =
        builder:this
        table:table
        tr:tr

      # Iterates over the columns.
      for col in cols
        # Each header cell has a specific class.
        th = $("<th class='column-header'></th>")
        tr.append th

        # The context object is updated with the current column
        # elements.
        context.col = col
        context.th = th

        # Calls the header function and affect the result
        # to the cell header.
        th.text @options.columnHeaders context

    # Iterates over the rows.
    for row in rows
      # Creates
      tr = $("<tr></tr>")
      table.append tr

      # Prepare the context for each row.
      context =
        builder:this
        table:table
        tr:tr
        row:row

      # If a row header function is provided, a header cell is created
      # with the result of the call of the function with the context
      # object.
      if hasRowHeaders
        th = $("<th class='row-header'></th>")
        tr.append th

        context.th = th

        th.text @options.rowHeaders context


      # Iterates over the columns.
      for col in cols
        td = $("<td></td>")
        tr.append td

        # If `options.cls` is defined, a widget is created and placed
        # within the cell.
        if @options.cls?
          unit = new BuildUnit cls:@options.cls, args:@options.args
          widget = unit.build()
          widget.attach td
          context.widget = widget

        # The context is then updated with the cell and the column
        # index.
        context[k] = v for k,v of {
          td:td
          col:col
        }
        # If `options.cell` is defined, the function is called with
        # the current context.
        @options.cells? context
    # Returns the produced table.
    table

# <a name="BuildUnit"></a>
#### BuildUnit

# Builds an instance of a class with the specified arguments
class BuildUnit
  # Create a new `BuildUnit` with the passed-in `options`
  # containing the build setup, `options` being an object.
  #
  # *Available Options*
  #
  #  * `cls`: The class to build.
  #  * `args`: The arguments to pass to the class constructor.
  #  * `set`: An object containing a list of propeties to set
  #    on the object.
  #  * `callback`: A function that will be called with the created
  #    instance at the end of the build.
  constructor:( @options )->

  # Process to the build and returns the created object.
  build:->
    o = @construct @options.cls, @options.args
    if o.set instanceof Function then o.set @options.set
    else o[k] = @options.set[k] for k of @options.set

    @options.callback? o
    o

  # Realize the concrete instanciation of the object.
  construct:( klass, args )->
    # In javascript, an object can't be constructed by calling either
    # `call` or `apply` on the constructor function. Thus, to be able
    # to pass arguments contained in an array to the constructor
    # we need to have a bunch of function that instanciate a class with
    # a number of arguments corresponding to the number of elements
    # in the array.
    f = BUILDS[ if args? then args.length else 0 ]
    f klass, args

# Contains all the function that will instanciate a class with a specific
# number of arguments. These functions are all generated at runtime with
# the `Function` constructor.
BUILDS=(
  new Function( "return new arguments[0](#{
    ("arguments[1][#{j-1}]" for j in [0..i] when j isnt 0 ).join ","
  });") for i in [0..24]
)

@BuildUnit = BuildUnit
@TableBuilder = TableBuilder
