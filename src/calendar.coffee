class Calendar extends Widget
  # Here some live instances :
  #
  #= require calendar

  # The `Calendar` is a `DropDownPopup` bound to dates widgets.
  @mixins DropDownPopup

  # Constants that stores the table headers and the month names.
  @DAYS   = ["M","T","W","T","F","S","S",]
  @MONTHS = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun",
              "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ]

  # A `Calendar` accept a `Date` and a mode as constructor arguments.
  constructor:(@value = new Date(), @mode = "date")->
    super()
    # By default, the current value is displayed at startup. It
    # means that the calendar displayed month and year will be the
    # one of the value.
    @display @value

  # Set the current year and month displayed by the `Calendar` on those
  # of the passed-in `Date` object.
  display:(date)->
    @month = date.firstDateOfMonth()
    @updateDummy()

  #### Dummy Management

  # The dummy for a `Calendar` is a `span` with a `calendar` class.
  #
  # The dummy contains five anchor object that allow to increment
  # or decrement the displayed month and year, and that allow to display
  # the current date.
  #
  # The last element in the calendar dummy is a table that display the
  # current month and year of the widget.
  createDummy:->
    dummy = $ "<span class='calendar'>
                 <h3></h3>
                 <a class='prev-year'>Previous Year</a>
                 <a class='prev-month'>Previous Month</a>
                 <a class='next-month'>Next Month</a>
                 <a class='next-year'>Next Year</a>
                 <table></table>
                 <a class='today'>Today</a>
               </span>"

    # Clicking on the `today` anchor display the current date.
    dummy.find("a.today").click (e)=>
      @display new Date unless @cantInteract()

    # Clicking on the `prev-year` anchor decrement the year
    # of the current display.
    dummy.find("a.prev-year").click (e)=>
      @display @month.incrementYear -1 unless @cantInteract()
    # Clicking on the `next-year` anchor increment the year
    # of the current display.
    dummy.find("a.next-year").click (e)=>
      @display @month.incrementYear 1 unless @cantInteract()

    # Clicking on the `prev-month` anchor decrement the month
    # of the current display.
    dummy.find("a.prev-month").click (e)=>
      @display @month.incrementMonth -1 unless @cantInteract()
    # Clicking on the `next-month` anchor increment the month
    # of the current display.
    dummy.find("a.next-month").click (e)=>
      @display @month.incrementMonth 1 unless @cantInteract()

    return dummy

  # Updating the dummy means recreating the table rows and cells
  # according to the current displayed date.
  updateDummy:->
    @createCells @month

    # Get the first day in the month.
    monthStartDay = @month.getDay() - 1
    monthStartDay = 6 if monthStartDay is -1

    # Get a reference to the first day of the week of the first
    # day of the month.
    date = @month.clone().incrementDate -monthStartDay

    # And for each cells in the table the date of the corresponding
    # day is affected as the cell text.
    @dummy.find("td").each (i, o)=>
      td = $ o
      td.text date.date()
      # The date corresponding to the cell is stored in the cell's name.
      td.attr "name", Date.dateToString date
      # When the first cell in a row is processed, the row header
      # receive the week number as content.
      td.parent().find("th").text date.week() if td.index() is 1
      # Change the state of the cell according to the date it carry.
      @cellState td, date
      # The date is then incremented for the next cell.
      date.incrementDate 1

    # The month and year displayed in the widget header is updated
    # with the current displayed date.
    h3 = @dummy.find("h3")
    h3.text "#{ Calendar.MONTHS[@month.month()] } #{ @month.year() }"

  # Creates the cells to display the passed-in date
  createCells:(date)->
    # Gets a reference to the table.
    table = @dummy.find "table"
    # Removes all the listeners that was previously registered.
    table.find("td").unbind "mouseup", @cellDelegate
    # Removes the whole table content.
    table.children().remove()

    # Creates the column header with the days.
    header = $("<tr><th></th></tr>")
    header.append "<th>#{ day }</th>" for day in Calendar.DAYS
    table.append header

    # Creates the function that will be bound to each cells.
    @cellDelegate =(e)=> @cellSelected e

    # For all the lines needed to display the current month
    # a row is created.
    for y in [0..@rowsNeeded date]
      # The first cell of the row is a header cell that will contains
      # the week number.
      line = $("<tr><th class='week'></th></tr>")
      # And then for the seven days of each week, a cell is created.
      for x in [0..6]
        cell = $ "<td></td>"
        # Each cell are automatically bound to the `cellSelected`
        # method through the `cellDelegate` function.
        cell.bind "mouseup", @cellDelegate
        # The cell is appended to the row.
        line.append cell
      # The row is appended to the table.
      table.append line

  # Returns the number of rows needed to display each week overlapped
  # by the `date` to display. Each rows correspond to a complete week.
  rowsNeeded:(date)->
    day = date.firstDateOfMonth().getDay()
    day = 7 if day is 0
    days = date.monthLength() + day
    Math.ceil(days / 7) - 1

  #### Selection Management

  # When a click is done on a cell, the value is changed according
  # to the cell.
  cellSelected:(e)->
    unless @cantInteract()
      e.stopImmediatePropagation()
      @set "value", Date.dateFromString $(e.target).attr "name"
      @comfirmChanges() if @caller?

  # Updates a cell according to the passed-in `date` and the current
  # mode of this `Calendar`.
  cellState:(td, date)->
    value = @get("value")
    sameDate = date.date() is value.date()
    sameWeek = date.week() is value.week()
    sameMonth = date.month() is value.month()
    sameYear = date.year() is value.year()

    # According to the `Calendar` mode the cells are selected
    # if they match the widget's value.
    switch @get("mode")
      when "date"
        td.addClass "selected" if sameDate and sameMonth and sameYear
      when "month"
        td.addClass "selected" if sameMonth and sameYear
      when "week"
        td.addClass "selected" if sameWeek and sameYear

    # Cells that represent dates in a different month are blurred.
    td.addClass "blurred" if date.month() isnt @month.month()
    td.addClass "today" if date.isToday()

  #### Properties Accessors

  # Changing the value of the calendar change also the displayed month.
  set_value:(property, value)->
    super property, value
    @display value
    value

  # Changes the mode of the `Calendar`.
  set_mode:(property, value)->
    if value not in ["date", "month", "week"] then return @get "mode"

    @[property] = value
    @updateDummy()
    value

  #### Dialog Placeholders

  # When requested, a calendar set its value to the caller's date.
  setupDialog:(caller)->
    @set "value", @originalValue = caller.get "date"

  # Comfirm the changes by affecting the value to the caller.
  comfirmChanges:->
    @caller.set "date", @get "value"
    @close()

  # Pressing enter directly comfirm the changes.
  comfirmChangesOnEnter:->
    @comfirmChanges()


@Calendar = Calendar
