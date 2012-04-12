$( document ).ready ->

  module "menu model tests"

  test "MenuModel should contains a list of action items", ->

    item1 = display: "irrelevant"
    item2 = display: "irrelevant"

    model = new MenuModel item1, item2

    assertThat model.size(), equalTo 2
    assertThat model.items[0] is item1
    assertThat model.items[1] is item2

  test "MenuModel should prevent invalid or in complete actions
      to be passed in its constructor",->

    item1 = action: ->
    item2= display: "irrelevant", action:"irrelevant"
    item3 = null
    item4 = "foo"

    model = new MenuModel item1,
                item2,
                item3,
                item4

    assertThat model.size(), equalTo 0

  test "MenuModel should allow to add items later", ->

    model = new MenuModel

    item1 = display: "irrelevant"
    item2 = display: "irrelevant"

    model.add item1, item2

    assertThat model.size(), equalTo 2
    assertThat model.items[0] is item1
    assertThat model.items[1] is item2

  test "MenuModel should prevent invalid or incomplete actions
      to be added",->

    item1 = action: ->
    item2 = display: "irrelevant", action:"irrelevant"
    item3 = null
    item4 = "foo"

    model = new MenuModel

    model.add item1,
          item2,
          item3,
          item4

    assertThat model.size(), equalTo 0

  test "MenuModel should allow to remove items", ->

    item1 = display: "display1"
    item2 = display: "display2"
    item3 = display: "display3"

    model = new MenuModel item1, item2, item3

    model.remove item1, item2

    assertThat model.size(), equalTo 1
    assertThat model.items[0] is item3

  test "When modified, a MenuModel should dispatch
      a contentChanged signal", ->

    model = new MenuModel

    item = display: "irrelevant"

    signalCalled = false
    listener = ->
      signalCalled = true

    model.contentChanged.add listener

    model.add item

    assertThat signalCalled

    signalCalled = false

    model.remove item

    assertThat signalCalled

  test "A MenuModel should be able to handle sub models", ->
    item3 = display: "display3"
    item4 = display: "display4"
    item1 = display: "display1"
    item2 = display: "display2", menu:new MenuModel item3, item4

    model = new MenuModel item1, item2

    assertThat model.items[1].menu.items, arrayWithLength 2
    assertThat model.items[1].menu.items[ 0 ] is item3
    assertThat model.items[1].menu.items[ 1 ] is item4

  module "menu list tests"

  test "A MenuList should take a MenuModel as argument", ->

    item1 = display: "display1"
    item2 = display: "display2"
    item3 = display: "display3"

    model = new MenuModel item1, item2, item3
    list = new MenuList model

    assertThat list.get("model") is model

  test "MenuList's dummy should be a list that contains
      the elements in the model", ->

    item1 = display: "display1"
    item2 = display: "display2"
    item3 = display: "display3"

    model = new MenuModel item1, item2, item3
    list = new MenuList model

    assertThat list.dummy.children("li").length, equalTo 3
    assertThat list.dummy.children("li").first().text(), equalTo "display1"
    assertThat list.dummy.children("li").last().text(), equalTo "display3"

  test "MenuList provides a size property", ->

    item1 = display: "display1"
    item2 = display: "display2"
    item3 = display: "display3"

    model = new MenuModel item1, item2, item3
    list = new MenuList model

    list.set "size", 4

    assertThat list.get("size"), strictlyEqualTo 4

  test "MenuList should set the height of the list according
      to its size when size isn't null and the model's
      size is bigger", ->

    item1 = display: "display1"
    item2 = display: "display2"
    item3 = display: "display3"
    item4 = display: "display4"
    item5 = display: "display5"
    item6 = display: "display6"

    model = new MenuModel item1, item2, item3, item4, item5, item6
    list = new MenuList model
    list.set "size", 4

    list.attach "body"

    height = list.dummy.children().first()[0].offsetHeight * 4

    assertThat list.dummy.attr("style"), contains "height: #{height}px"

    list.detach()

  test "Setting null as size should reset the dummy", ->

    item1 = display: "display1"
    item2 = display: "display2"
    item3 = display: "display3"
    item4 = display: "display4"
    item5 = display: "display5"
    item6 = display: "display6"

    model = new MenuModel item1, item2, item3, item4, item5, item6
    list = new MenuList model
    list.set "size", 4

    list.attach "body"

    list.set "size", null

    assertThat list.dummy.attr("style"), hamcrest.not contains "height"

    list.detach()

  test "MenuList should add a specific class to the dummy
      when items are hidden", ->

    item1 = display: "display1"
    item2 = display: "display2"
    item3 = display: "display3"
    item4 = display: "display4"
    item5 = display: "display5"
    item6 = display: "display6"

    model = new MenuModel item1, item2, item3, item4, item5, item6
    list = new MenuList model
    list.set "size", 4

    list.attach "body"

    assertThat list.dummy.hasClass "cropped"

    list.detach()

  test "Changes made to the cropped state should dispatch
      a cropChanged signal", ->

    item1 = display: "display1"
    item2 = display: "display2"
    item3 = display: "display3"
    item4 = display: "display4"
    item5 = display: "display5"
    item6 = display: "display6"

    signalCalled = false
    signalSource = null
    signalValue = null

    model = new MenuModel item1, item2, item3, item4, item5, item6
    list = new MenuList model

    list.cropChanged.add ( source, crop )->
      signalCalled = true
      signalSource = source
      signalValue = crop

    list.set "size", 4

    list.attach "body"

    assertThat signalCalled
    assertThat signalSource is list
    assertThat signalValue is true

    signalCalled = false
    signalSource = null
    signalValue = null

    list.set "size", null

    assertThat signalCalled
    assertThat signalSource is list
    assertThat signalValue is false

    list.detach()

  test "Setting a size greater that the model content should
      not crop the list", ->

    item1 = display: "display1"
    item2 = display: "display2"
    item3 = display: "display3"

    model = new MenuModel item1, item2, item3
    list = new MenuList model
    list.set "size", 4

    list.attach "body"

    assertThat not list.dummy.hasClass "cropped"

    list.detach()

  test "Altering the model of a list with a given size should
      affect its crop", ->

    item1 = display: "display1"
    item2 = display: "display2"
    item3 = display: "display3"

    model = new MenuModel item1, item2, item3
    list = new MenuList model
    list.set "size", 4

    list.attach "body"

    model.add item4, item5, item6

    assertThat list.dummy.hasClass "cropped"

    model.remove item4, item5, item6

    assertThat not list.dummy.hasClass "cropped"

    list.detach()

  test "MenuList should null the selection if the passed-in index
      is out of bounds", ->

    item1 = display: "display1"
    item2 = display: "display2"
    item3 = display: "display3"

    model = new MenuModel item1, item2, item3
    list = new MenuList model

    list.select 5

    assertThat list.selectedIndex, equalTo -1

  test "Clicking on a list item should trigger
      the corresponding action", ->

    itemActionTriggered = false

    item1 = display: "display1"
    item2 = display: "display2", action:->
      itemActionTriggered = true
    item3 = display: "display3"

    model = new MenuModel item1, item2, item3
    list = new MenuList model

    $( list.dummy.children("li")[1] ).mouseup()

    assertThat itemActionTriggered

  test "Clicking on a readonly select's list item shouldn't
      trigger the corresponding action", ->

    itemActionTriggered = false

    item1 = display: "display1"
    item2 = display: "display2", action:->
      itemActionTriggered = true
    item3 = display: "display3"

    model = new MenuModel item1, item2, item3
    list = new MenuList model
    list.set "readonly", true

    $( list.dummy.children("li")[1] ).mouseup()

    assertThat not itemActionTriggered

  test "Clicking on a disabled select's list item shouldn't
      trigger the corresponding action", ->

    itemActionTriggered = false

    item1 = display: "display1"
    item2 = display: "display2", action:->
      itemActionTriggered = true
    item3 = display: "display3"

    model = new MenuModel item1, item2, item3
    list = new MenuList model
    list.set "disabled", true

    $( list.dummy.children("li")[1] ).mouseup()

    assertThat not itemActionTriggered

  test "Changing the model's content should update the list", ->

    item1 = display: "display1"
    item2 = display: "display2"
    item3 = display: "display3"

    model = new MenuModel item1, item2, item3
    list = new MenuList model

    model.remove model.items[2]

    assertThat list.dummy.children("li").length, equalTo 2
    assertThat list.dummy.children("li").first().text(), equalTo "display1"
    assertThat list.dummy.children("li").last().text(), equalTo "display2"

  test "Passing the mouse over a list item should select it", ->

    item1 = display: "display1"
    item2 = display: "display2"
    item3 = display: "display3"

    model = new MenuModel item1, item2, item3
    list = new MenuList model

    list.dummy.children("li").last().mouseover()

    assertThat list.selectedIndex, equalTo 2
    assertThat list.dummy.children("li").last().hasClass "selected"

  test "Passing the mouse over a readonly select's list item
      shouldn't select it", ->

    item1 = display: "display1"
    item2 = display: "display2"
    item3 = display: "display3"

    model = new MenuModel item1, item2, item3
    list = new MenuList model
    list.set "readonly", true

    list.dummy.children("li").last().mouseover()

    assertThat list.selectedIndex, equalTo -1

  test "Passing the mouse over a disabled select's list item
      shouldn't select it", ->

    item1 = display: "display1"
    item2 = display: "display2"
    item3 = display: "display3"

    model = new MenuModel item1, item2, item3
    list = new MenuList model
    list.set "disabled", true

    list.dummy.children("li").last().mouseover()

    assertThat list.selectedIndex, equalTo -1


  test "Pressing the up key should move the selection up", ->

    item1 = display: "display1"
    item2 = display: "display2"
    item3 = display: "display3"

    model = new MenuModel item1, item2, item3
    list = new MenuList model

    list.select 1

    list.keydown
      keyCode: keys.up
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->

    assertThat list.selectedIndex, equalTo 0
    assertThat list.dummy.children("li").first().hasClass "selected"

  test "Pressing the down down should move the selection down", ->

    item1 = display: "display1"
    item2 = display: "display2"
    item3 = display: "display3"

    model = new MenuModel item1, item2, item3
    list = new MenuList model

    list.select 1

    list.keydown
      keyCode: keys.down
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->

    assertThat list.selectedIndex, equalTo 2
    assertThat list.dummy.children("li").last().hasClass "selected"

  test "Pressing the up key when the selection is at the top should
      move the selection to the bottom", ->

    item1 = display: "display1"
    item2 = display: "display2"
    item3 = display: "display3"

    model = new MenuModel item1, item2, item3
    list = new MenuList model

    list.select 0

    list.keydown
      keyCode: keys.up
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->

    assertThat list.selectedIndex, equalTo 2
    assertThat list.dummy.children("li").last().hasClass "selected"

  test "Pressing the down key when the selection is at the bottom
      should move the selection to the top", ->

    item1 = display: "display1"
    item2 = display: "display2"
    item3 = display: "display3"

    model = new MenuModel item1, item2, item3
    list = new MenuList model

    list.select 2

    list.keydown
      keyCode: keys.down
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->

    assertThat list.selectedIndex, equalTo 0
    assertThat list.dummy.children("li").first().hasClass "selected"

  test "Pressing the enter key should trigger the action
      of the selected item", ->

    actionTriggered = false

    item1 = display: "display1"
    item2 = display: "display2", action:->
      actionTriggered = true
    item3 = display: "display3"

    model = new MenuModel item1, item2, item3
    list = new MenuList model

    list.select 1

    list.keydown
      keyCode: keys.enter
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->

    assertThat actionTriggered

  test "Pressing the space key should trigger the action
      of the selected item", ->

    actionTriggered = false

    item1 = display: "display1"
    item2 = display: "display2", action:->
      actionTriggered = true
    item3 = display: "display3"

    model = new MenuModel item1, item2, item3
    list = new MenuList model

    list.select 1

    list.keydown
      keyCode: keys.space
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->

    assertThat actionTriggered

  test "Pressing the up key should prevent the default behavior", ->

    item1 = display: "display1"
    item2 = display: "display2"
    item3 = display: "display3"

    model = new MenuModel item1, item2, item3
    list = new MenuList model

    list.select 1

    preventDefaultCalled = false

    list.keydown
      keyCode: keys.up
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->
        preventDefaultCalled = true

    assertThat preventDefaultCalled

   test "Pressing the down key should prevent the default behavior", ->

    item1 = display: "display1"
    item2 = display: "display2"
    item3 = display: "display3"

    model = new MenuModel item1, item2, item3
    list = new MenuList model

    list.select 1

    preventDefaultCalled = false

    list.keydown
      keyCode: keys.down
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->
        preventDefaultCalled = true

    assertThat preventDefaultCalled

  test "Pressing the up key on a readonly select shouldn't
      move the selection up", ->

    item1 = display: "display1"
    item2 = display: "display2"
    item3 = display: "display3"

    model = new MenuModel item1, item2, item3
    list = new MenuList model

    list.select 1
    list.set "readonly", true

    list.keydown
      keyCode: keys.up
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->

    assertThat list.selectedIndex, equalTo 1

  test "Pressing the down key on a readonly select shouldn't
      move the selection down", ->

    item1 = display: "display1"
    item2 = display: "display2"
    item3 = display: "display3"

    model = new MenuModel item1, item2, item3
    list = new MenuList model

    list.select 1
    list.set "readonly", true

    list.keydown
      keyCode: keys.down
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->

    assertThat list.selectedIndex, equalTo 1

  test "Pressing the up key on a disabled select shouldn't
      move the selection up", ->

    item1 = display: "display1"
    item2 = display: "display2"
    item3 = display: "display3"

    model = new MenuModel item1, item2, item3
    list = new MenuList model

    list.select 1
    list.set "disabled", true

    list.keydown
      keyCode: keys.up
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->

    assertThat list.selectedIndex, equalTo 1

  test "Pressing the down key on a disabled select shouldn't
      move the selection down", ->

    item1 = display: "display1"
    item2 = display: "display2"
    item3 = display: "display3"

    model = new MenuModel item1, item2, item3
    list = new MenuList model

    list.select 1
    list.set "disabled", true

    list.keydown
      keyCode: keys.down
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->

    assertThat list.selectedIndex, equalTo 1

  test "MenuList items that contains a sub model should
      have a specific class", ->

    item1 = display: "display1"
    item2 = display: "display2", menu:new MenuModel
    item3 = display: "display3"
    item4 = display: "display4"

    item2.menu.add item3, item4

    model = new MenuModel item1, item2
    list = new MenuList model

    assertThat list.dummy.children("li").last().hasClass "menu"

  test "Passing the mouse over a MenuList item that contains
      a submodel should popup a new menulist next to the former", ->

    item1 = display: "display1"
    item2 = display: "display2", menu:new MenuModel
    item3 = display: "display3"
    item4 = display: "display4"

    item2.menu.add item3, item4

    model = new MenuModel item1, item2
    list = new MenuList model

    list.attach "body"

    left = list.dummy.offset().left + list.dummy.width()
    top = list.dummy.children("li").last().offset().top

    list.dummy.children("li").last().mouseover()

    assertThat list.childList.dummy.parent().length, equalTo 1
    assertThat list.childList.dummy.attr("style"),
           contains "left: #{left}px;"
    assertThat list.childList.dummy.attr("style"),
           contains "top: #{top}px;"

    list.detach()
    list.childList.detach()

  test "Passing the mouse over a basic item when a child list
      is displayed should close the child list", ->

    item1 = display: "display1"
    item2 = display: "display2", menu:new MenuModel
    item3 = display: "display3"
    item4 = display: "display4"

    item2.menu.add item3, item4

    model = new MenuModel item1, item2
    list = new MenuList model

    list.attach "body"

    left = list.dummy.offset().left + list.dummy.width()
    top = list.dummy.children("li").last().offset().top

    list.dummy.children("li").last().mouseover()
    list.dummy.children("li").first().mouseover()

    assertThat list.childList.dummy.parent().length, equalTo 0

    list.detach()

  test "Closing a child list should make it lose the focus", ->
    item1 = display: "display1", menu:new MenuModel( display:"display3" )
    item2 = display: "display2"
    model = new MenuModel item1, item2
    list = new MenuList model

    list.attach "body"

    list.dummy.children("li").first().mouseover()
    list.childList.grabFocus()

    list.dummy.children("li").last().mouseover()

    assertThat not list.childList.hasFocus
    assertThat list.hasFocus

    list.detach()
    list.childList.detach()

  test "Closing a child list should also close the descendant list", ->
    item1 =
      display: "display1",
      menu: new MenuModel(
        display: "display3",
        menu:new MenuModel( display: "display4" ) )

    item2 = display: "display2"
    model = new MenuModel item1, item2
    list = new MenuList model

    list.attach "body"

    list.dummy.children("li").first().mouseover()
    list.childList.dummy.children("li").first().mouseover()

    list.dummy.children("li").last().mouseover()

    assertThat list.childList.childList.dummy.parent().length, equalTo 0

    list.detach()

  test "A childlist should have a reference to its parent", ->

    item1 =
      display: "display1",
      menu:new MenuModel( display: "display3" )
    item2 = display: "display2"
    model = new MenuModel item1, item2
    list = new MenuList model

    list.attach "body"

    list.dummy.children("li").first().mouseover()

    assertThat list.childList.parentList is list

    list.detach()
    list.childList.detach()

  test "A menu should stop the propagation of the mousedown event", ->

    item1 = display: "display1"
    item2 = display: "display2"
    model = new MenuModel item1, item2
    list = new MenuList model
    stopImmediatePropagationCalled = false

    list.mousedown stopImmediatePropagation: ->
      stopImmediatePropagationCalled = true

    assertThat stopImmediatePropagationCalled

  test "Passing the mouse over an item should give the focus to the list", ->

    item1 = display: "display1"
    item2 = display: "display2"
    model = new MenuModel item1, item2
    list = new MenuList model

    list.dummy.children("li").first().mouseover()

    assertThat list.hasFocus

  test "Coming back from a child list to the original menu item1
      should blur the child list", ->

    item1 = display: "display1", menu:new MenuModel( display:"display3" )
    item2 = display: "display2"
    model = new MenuModel item1, item2
    list = new MenuList model

    list.attach "body"

    list.dummy.children("li").first().mouseover()
    list.childList.dummy.children("li").first().mouseover()
    list.dummy.children("li").first().mouseover()

    assertThat not list.childList.hasFocus

    list.detach()
    list.childList.detach()

  test "Coming back from a child list to a menu item that
      also have a submenu should change the child List", ->

    item1 = display: "display1", menu:new MenuModel( display:"display3" )
    item2 = display: "display2", menu:new MenuModel( display:"display4" )
    model = new MenuModel item1, item2
    list = new MenuList model

    list.attach "body"

    list.dummy.children("li").first().mouseover()
    list.childList.dummy.children("li").first().mouseover()
    list.dummy.children("li").last().mouseover()

    assertThat not list.childList.hasFocus
    assertThat list.childList.get("model") is item2.menu

    list.detach()
    list.childList.detach()

  test "Pressing the right key when the selection
      is on a sub menu should move the focus
      to the child list", ->

    item1 = display: "display1", menu:new MenuModel({ display:"display3"})
    item2 = display: "display2"

    model = new MenuModel item1, item2
    list = new MenuList model

    list.dummy.children("li").first().mouseover()

    list.keydown
      keyCode: keys.right
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->

    assertThat list.childList.hasFocus

    list.childList.detach()

  test "Pressing the left key when the focus is on a child
      list should return the focus to the parent", ->

    item1 = display: "display1", menu:new MenuModel({ display:"display3"})
    item2 = display: "display2"

    model = new MenuModel item1, item2
    list = new MenuList model

    list.dummy.children("li").first().mouseover()
    list.childList.dummy.children("li").first().mouseover()

    list.childList.keydown
      keyCode: keys.left
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->

    assertThat not list.childList.hasFocus
    assertThat list.hasFocus

    list.childList.detach()

  test "Items that provide a hidden property
        with true will not be displayd", ->

    item1 = display: "display1"
    item2 = display: "display2", hidden: true

    model = new MenuModel item1, item2
    list = new MenuList model

    list.attach "body"

    assertThat list.dummy.find("li").filter(":visible").length, equalTo 1

    list.detach()

  test "MenuList that appear outside of the visible page area should
        adjust their position to fit in", ->

    w = $ window
    sW = w.width()
    sH = w.height()
    sX = w.scrollLeft()
    sY = w.scrollTop()

    item1 = display: "display1"
    item2 = display: "display2", hidden: true

    model = new MenuModel item1, item2
    list = new MenuList model

    list.dummy.css
      left: "#{sX + sW - 10}px"
      top: "#{sY + sH - 10}px"

    list.attach "body"

    assertThat list.dummy.position(), hasProperties
      left: equalTo sX + w.width() - list.dummy.width()
      top: equalTo sY + w.height() - list.dummy.height()

    list.detach()

  test "MenuList's child list that appear outside of the visible
        page area should adjust their position to fit in", ->

    item1 = display: "display1", menu:new MenuModel({
      display:"display3"
    },{
      display:"display4"
    })

    item2 = display: "display2", menu:new MenuModel({
      display:"display5"
    },{
      display:"display6"
    })

    w = $ window
    sW = w.width()
    sH = w.height()
    sX = w.scrollLeft()
    sY = w.scrollTop()
    model = new MenuModel item1, item2
    list = new MenuList model

    list.dummy.css
      left: "#{sX + sW - 10}px"
      top: "#{sY + sH - 10}px"

    list.attach "body"

    list.dummy.children().first().mouseup()

    # TODO: Complete this test

  item1 = display: "display1", action:-> console.log "item 1 clicked"
  item2 = display: "display2", action:-> console.log "item 2 clicked"
  item3 = display: "display3", menu:new MenuModel
  item4 = display: "display4", action:-> console.log "item 4 clicked"
  item5 = display: "display5", action:-> console.log "item 5 clicked"
  item6 = display: "display6", menu:new MenuModel
  item7 = display: "display7", action:-> console.log "item 7 clicked"
  item8 = display: "display8", action:-> console.log "item 8 clicked"
  item9 = display: "display9", action:-> console.log "item 9 clicked"
  item10 = display: "display10", action:-> console.log "item 10 clicked"
  item11 = display: "display11", action:-> console.log "item 11 clicked"
  item12 = display: "display12", action:-> console.log "item 12 clicked"

  item3.menu.add item4, item5, item6
  item6.menu.add item7, item8

  model = new MenuModel item1, item2, item3, item9, item10, item11, item12
  list1 = new MenuList model
  list2 = new MenuList model
  list3 = new MenuList model

  list1.set "size", 4

  list2.set "readonly", true
  list3.set "disabled", true

  list1.addClasses "dummy"
  list2.addClasses "dummy"
  list3.addClasses "dummy"

  $("#qunit-header").before $ "<h4>MenuList</h4>"
  list1.before "#qunit-header"
  list2.before "#qunit-header"
  list3.before "#qunit-header"
