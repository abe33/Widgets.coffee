$( document ).ready ->

  module "singleselect tests"

  test "SingleSelect should accept select node as target", ->
    target = $( "<select></select>" )[0]

    select = new SingleSelect target

    assertThat select.target is target

  test "SingleSelect shouldn't accept anything else that
      a select as target", ->
    target = $( "<input></input>" )[0]

    errorRaised = false

    try
      select = new SingleSelect target
    catch e
      errorRaised = true

    assertThat errorRaised

  test "SingleSelect shouldn't accept a select with multiple
      attribute as target", ->
    target = $( "<select multiple></select>" )[0]

    errorRaised = false

    try
      select = new SingleSelect target
    catch e
      errorRaised = true

    assertThat errorRaised

  test "SingleSelect's dummy should display the selected option label", ->

    target = $( "<select>
            <option>foo</option>
            <option selected value='__BAR__'
                label='BAR'>bar</option>
           </select>" )[0]
    select = new SingleSelect target

    assertThat select.dummy.find(".value").text(), equalTo "BAR"
    assertThat select.get("value"), equalTo "__BAR__"

  test "SingleSelect's dummy should display the selected option", ->

    target = $( "<select>
            <option>foo</option>
            <option selected value='BAR'>bar</option>
           </select>" )[0]
    select = new SingleSelect target

    assertThat select.dummy.find(".value").text(), equalTo "bar"
    assertThat select.get("value"), equalTo "BAR"

  test "SingleSelect's selected index should be the index
      of the child with the selected attribute", ->

    target = $( "<select>
            <option>foo</option>
            <option selected>bar</option>
           </select>" )[0]
    select = new SingleSelect target

    assertThat select.selectedPath, array 1

  test "Setting the value should change the selected index", ->

    target = $( "<select>
            <option>foo</option>
            <option selected value='BAR'>bar</option>
           </select>" )[0]
    select = new SingleSelect target

    select.set "value", "foo"

    assertThat select.selectedPath, array 0
    assertThat select.dummy.find(".value").text(), equalTo "foo"

    select.set "value", "BAR"

    assertThat select.selectedPath, array 1
    assertThat select.dummy.find(".value").text(), equalTo "bar"

  test "SingleSelect's target should be hidden at start", ->

    target = $( "<select>
            <option>foo</option>
            <option selected>bar</option>
           </select>" )
    select = new SingleSelect target[0]

    assertThat target.attr("style"), contains "display: none"

  test "SingleSelect should build a MenuModel with the option
      of the select", ->

    target = $( "<select>
            <option>foo</option>
            <option label='BAR' selected>bar</option>
           </select>" )
    select = new SingleSelect target[0]

    assertThat select.model.size(), equalTo 2
    assertThat select.model.items[0], hasProperty "display", equalTo "foo"
    assertThat select.model.items[1], hasProperty "display", equalTo "BAR"

  test "SingleSelect model's items should have an action
      that select the item", ->

    target = $( "<select>
            <option>foo</option>
            <option selected>bar</option>
           </select>" )
    select = new SingleSelect target[0]

    select.model.items[0].action()

    assertThat select.get("value"), equalTo "foo"


  test "SingleSelect should support the size attribute of the target", ->

    target = $ "<select size='2'>
            <option>foo</option>
            <option selected>bar</option>
           </select>"
    select = new SingleSelect target[0]

    assertThat select.get("size"), strictlyEqualTo 2

  test "Changes made to the widget should be reflected on the target", ->

    target = $( "<select>
            <option>foo</option>
            <option selected>bar</option>
           </select>" )
    select = new SingleSelect target[0]

    select.model.items[0].action()

    assertThat target.children("option[selected]").text(), equalTo "foo"

    select.model.items[1].action()

    assertThat target.children("option[selected]").text(), equalTo "bar"

  test "Changes made to the model should be reflected
      on the target (with add)", ->

    target = $( "<select>
            <option>foo</option>
            <option selected>bar</option>
           </select>" )
    select = new SingleSelect target[0]

    select.model.add display: "new item", value:"new value"

    assertThat target.children("option").length, equalTo 3

  test "Changes made to the model should preserve the optgroup nodes", ->

    target = $( "<select>
            <option>foo</option>
            <optgroup>
              <option selected>bar</option>
              <option>rab</option>
            </optgroup>
           </select>" )

    select = new SingleSelect target[0]

    select.model.add display: "new item", value:"new value"

    assertThat target.find("optgroup").length, equalTo 1
    assertThat target.find("optgroup").children().length, equalTo 2


  test "Items added to the model of a select should have
      their action defined automatically", ->

    target = $( "<select>
                  <option>foo</option>
                  <option selected>bar</option>
                 </select>" )
    select = new SingleSelect target[0]

    select.model.add display: "new item", value:"new value"

    select.model.items[2].action()

    assertThat target.children("option[selected]").text(),
               equalTo "new item"

  test "Changes made to the model should be reflected
      on the target (with remove)", ->

    target = $( "<select>
                  <option>foo</option>
                  <option selected>bar</option>
                 </select>" )
    select = new SingleSelect target[0]

    select.model.remove select.model.items[1]

    assertThat target.children("option").length, equalTo 1

  test "Changes made to the model should preserved the selection", ->

    target = $( "<select>
                <option>foo</option>
                <option selected>bar</option>
               </select>" )
    select = new SingleSelect target[0]

    select.model.add display: "new item", value:"new value"

    assertThat target.children("option[selected]").length, equalTo 1
    assertThat target.children("option[selected]").text(), equalTo "bar"

  test "Changes made to the model should preserve a valid selection", ->

    target = $( "<select>
                <option>foo</option>
                <option selected>bar</option>
               </select>" )
    select = new SingleSelect target[0]

    select.model.remove select.model.items[1]

    assertThat target.children("option[selected]").length, equalTo 1
    assertThat target.children("option[selected]").text(), equalTo "foo"
    assertThat select.get("value"), equalTo "foo"

  test "SingleSelect should accept a MenuModel as first argument
        in the constructor", ->

    select = new SingleSelect new MenuModel {
      display: "Item 1", value:"value 1"
    },{
      display: "Item 2", value:"value 2"
    }

    assertThat select.model.size(), equalTo 2
    assertThat select.get("value"), equalTo null

  test "Changing the model should update the SingleSelect value", ->

    select = new SingleSelect

    model = new MenuModel {
      display: "Item 1", value:"value 1"
    },{
      display: "Item 2", value:"value 2"
    }

    select.set "model", model

    assertThat select.model is model
    assertThat select.get("value"), equalTo "value 1"


  test "SingleSelect should provide a MenuList instance
      linked to the model", ->

    target = $( "<select>
                <option>foo</option>
                <option selected>bar</option>
               </select>" )
    select = new SingleSelect target[0]

    assertThat select.menuList, notNullValue()
    assertThat select.menuList.get("model") is select.model

  test "Changing the model should change the model for
        the inner MenuList", ->

    select = new SingleSelect

    model = new MenuModel {
      display: "Item 1", value:"value 1"
    },{
      display: "Item 2", value:"value 2"
    }

    select.set "model", model
    assertThat select.menuList.model is model

  test "Changing the model should fill the action property
        of items of the new model", ->

    select = new SingleSelect

    model = new MenuModel {
      display: "Item 1", value:"value 1"
    },{
      display: "Item 2", value:"value 2"
    }

    select.set "model", model
    assertThat select.model.items[0].action instanceof Function
    assertThat select.model.items[1].action instanceof Function

  test "Adding an item to the model should fill the action property
        of the new item", ->

    select = new SingleSelect new MenuModel {
      display: "Item 1", value:"value 1"
    },{
      display: "Item 2", value:"value 2"
    }

    select.model.add display: "foo", value:"bar"

    assertThat select.model.items[2].action instanceof Function

  test "Pressing the mouse on a SingleSelect should display its menuList", ->

    target = $( "<select>
                <option>foo</option>
                <option selected>bar</option>
               </select>" )
    select = new SingleSelect target[0]

    select.attach "body"

    select.dummy.mousedown()
    assertThat select.menuList.dummy.parent().length, equalTo 1

    select.detach()
    select.menuList.detach()

  test "Pressing the mouse on a SingleSelect should select
      the value in the menuList", ->

    target = $( "<select>
                <option>foo</option>
                <option selected>bar</option>
               </select>" )
    select = new SingleSelect target[0]

    select.attach "body"

    select.dummy.mousedown()
    assertThat select.menuList.selectedIndex, equalTo 1

    select.detach()
    select.menuList.detach()

  test "Pressing the mouse on a SingleSelect that have
      its menu list displayed should detach its menuList", ->

    target = $( "<select>
                <option>foo</option>
                <option selected>bar</option>
               </select>" )
    select = new SingleSelect target[0]

    select.attach "body"

    select.dummy.mousedown()
    select.dummy.mousedown()

    assertThat select.menuList.dummy.parent().length, equalTo 0

    select.detach()

  test "When displayed, the menulist should be placed below the select", ->

    target = $( "<select>
                <option>foo</option>
                <option selected>bar</option>
               </select>" )
    select = new SingleSelect target[0]

    select.attach "body"

    top = select.dummy.height() + select.dummy.offset().top
    left = select.dummy.offset().left

    select.dummy.mousedown()


    assertThat select.menuList.dummy.attr("style"),
           contains "left: #{left}px"
    assertThat select.menuList.dummy.attr("style"),
           contains "top: #{top}px"

    select.detach()
    select.menuList.detach()

  test "When displayed, clicking on a list item should hide
      the menu list", ->

    target = $( "<select>
                <option>foo</option>
                <option selected>bar</option>
               </select>" )
    select = new SingleSelect target[0]

    select.attach "body"

    select.dummy.mousedown()
    select.menuList.dummy.children().last().mouseup()

    assertThat select.menuList.dummy.parent().length, equalTo 0

    select.detach()

  test "Pressing the mouse on the select dummy should
      prevent the default behavior",->

    select = new SingleSelect
    preventDefaultCalled = false

    select.mousedown preventDefault: ->
      preventDefaultCalled = true
    , stopImmediatePropagation: ->

    assertThat preventDefaultCalled

  test "Readonly select should prevent the mousedown
      to open the menu list", ->

    target = $( "<select>
                <option>foo</option>
                <option selected>bar</option>
               </select>" )
    select = new SingleSelect target[0]
    select.set "readonly", true

    select.attach "body"

    select.dummy.mousedown()

    assertThat select.menuList.dummy.parent().length, equalTo 0

    select.detach()

  test "Pressing the mouse on a SingleSelect should
      give the focus to the menu list", ->

    target = $( "<select>
                <option>foo</option>
                <option selected>bar</option>
               </select>" )
    select = new SingleSelect target[0]

    select.attach "body"

    select.dummy.mousedown()

    assertThat select.menuList.hasFocus

    select.detach()
    select.menuList.detach()

  test "Pressing the mouse to hide the menu list should
      give the focus back to the select", ->

    target = $( "<select>
                <option>foo</option>
                <option selected>bar</option>
               </select>" )
    select = new SingleSelect target[0]

    select.attach "body"

    select.dummy.mousedown()
    select.dummy.mousedown()

    assertThat not select.menuList.hasFocus
    assertThat select.hasFocus

    select.detach()
    select.menuList.detach()

  test "When displayed, clicking on a list item should
      give the focus back to the select", ->

    target = $( "<select>
                <option>foo</option>
                <option selected>bar</option>
               </select>" )
    select = new SingleSelect target[0]

    select.attach "body"

    select.dummy.mousedown()
    select.menuList.dummy.children().last().mouseup()

    assertThat not select.menuList.hasFocus
    assertThat select.hasFocus

    select.detach()

  test "A SingleSelect should allow html content in items display", ->

    select = new SingleSelect
    select.model.add display: "<b>foo</b>", value:'foo'
    select.set "value", "foo"

    assertThat select.dummy.find("b").length, equalTo 1

  test "Pressing the mouse outside of the select and its menu
      should hide the menu", ->

    class MockSingleSelect extends SingleSelect
      documentMouseDown: (e)->
        e.pageX = 1000
        e.pageY = 1000

        super e

    target = $( "<select>
                <option>foo</option>
                <option selected>bar</option>
               </select>" )

    select = new MockSingleSelect target[0]

    select.attach "body"

    select.dummy.mousedown()

    $(document).mousedown()

    assertThat select.menuList.dummy.parent().length, equalTo 0

    select.detach()

  test "Pressing the enter key when the select has the focus
      should open the menu", ->

    target = $( "<select>
                <option>foo</option>
                <option selected>bar</option>
               </select>" )
    select = new SingleSelect target[0]

    select.attach "body"

    select.keydown
      keyCode: keys.enter
      ctrlKey: false
      shiftKey: false
      altKey: false

    assertThat select.menuList.dummy.parent().length, equalTo 1

    select.detach()
    select.menuList.detach()

  test "Pressing the space key when the select has the focus
      should open the menu", ->

    target = $( "<select>
                <option>foo</option>
                <option selected>bar</option>
               </select>" )
    select = new SingleSelect target[0]

    select.attach "body"

    select.keydown
      keyCode: keys.space
      ctrlKey: false
      shiftKey: false
      altKey: false

    assertThat select.menuList.dummy.parent().length, equalTo 1

    select.detach()
    select.menuList.detach()

  test "Pressing the space key when the select is readonly
      shouldn't open the menu", ->

    target = $( "<select>
                <option>foo</option>
                <option selected>bar</option>
               </select>" )
    select = new SingleSelect target[0]
    select.set "readonly", true

    select.attach "body"

    select.keydown
      keyCode: keys.space
      ctrlKey: false
      shiftKey: false
      altKey: false

    assertThat select.menuList.dummy.parent().length, equalTo 0

    select.detach()

  test "Pressing the up key should move the selection
      cursor to the up", ->

    target = $( "<select>
                <option>foo</option>
                <option selected>bar</option>
               </select>" )
    select = new SingleSelect target[0]

    select.keydown
      keyCode: keys.up
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->

    assertThat select.get("value"), equalTo "foo"


  test "Pressing the down key should move the selection cursor
      to the down", ->

    target = $( "<select>
                <option selected>foo</option>
                <option>bar</option>
               </select>" )
    select = new SingleSelect target[0]

    select.keydown
      keyCode: keys.down
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->

    assertThat select.get("value"), equalTo "bar"


  test "Pressing the down key should move the selection cursor
      to the start when it is already a the bottom", ->

    target = $( "<select>
                <option>foo</option>
                <option selected>bar</option>
               </select>" )
    select = new SingleSelect target[0]

    select.keydown
      keyCode: keys.down
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->

    assertThat select.get("value"), equalTo "foo"

  test "Pressing the up key should move the selection cursor
      to the end when its already at the top", ->

    target = $( "<select>
                <option selected>foo</option>
                <option>bar</option>
               </select>" )
    select = new SingleSelect target[0]

    select.keydown
      keyCode: keys.up
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->

    assertThat select.get("value"), equalTo "bar"

  test "Pressing the down key when the select has optgroups
      should move the selection to the optgroup", ->

    target = $( "<select>
                <option selected>foo</option>
                <optgroup>
                  <option>bar</option>
                  <option>rab</option>
                </optgroup>
               </select>" )

    select = new SingleSelect target[0]

    select.keydown
      keyCode: keys.down
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->

    assertThat select.get("value"), equalTo "bar"

  test "The selectedPath should be valid even when the selected
      items is in a optgroup", ->
    target = $( "<select>
                <option>foo</option>
                <optgroup>
                  <option selected>bar</option>
                  <option>rab</option>
                </optgroup>
               </select>" )

    select = new SingleSelect target[0]

    assertThat select.selectedPath, array 1, 0

  test "Moving down the selection when the selection is at the end
      of an optgroup should move the selection outside of the group", ->

    target = $( "<select>
                <optgroup>
                  <option>bar</option>
                  <option selected>rab</option>
                </optgroup>
                <option>foo</option>
               </select>" )

    select = new SingleSelect target[0]

    select.keydown
      keyCode: keys.down
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->

    assertThat select.get("value"), equalTo "foo"

  test "Moving down the selection when the selection is at the end
      of the last optgroup should move the selection to the top", ->

    target = $( "<select>
                <option>foo</option>
                <optgroup>
                  <option>bar</option>
                  <option selected>rab</option>
                </optgroup>
               </select>" )

    select = new SingleSelect target[0]

    select.keydown
      keyCode: keys.down
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->

    assertThat select.get("value"), equalTo "foo"

  test "Moving down the selection when the selection is at the end
      of the last optgroup should move the selection to the top", ->

    target = $( "<select>
                <optgroup>
                  <option>foo</option>
                </optgroup>
                <optgroup>
                  <option>bar</option>
                  <option selected>rab</option>
                </optgroup>
               </select>" )

    select = new SingleSelect target[0]

    select.keydown
      keyCode: keys.down
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->

    assertThat select.get("value"), equalTo "foo"

  test "Moving up the selection when the selection is at the start
      of an optgroup should move the selection outside of the group", ->

    target = $( "<select>
                <option>foo</option>
                <optgroup>
                  <option selected>bar</option>
                  <option>rab</option>
                </optgroup>
               </select>" )

    select = new SingleSelect target[0]

    select.keydown
      keyCode: keys.up
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->

    assertThat select.get("value"), equalTo "foo"

  test "Moving up the selection when the selection is at the start
      of an optgroup that is at the top should move the selection
      bottom", ->

    target = $( "<select>
                <optgroup>
                  <option selected>bar</option>
                  <option>rab</option>
                </optgroup>
                <option>foo</option>
               </select>" )

    select = new SingleSelect target[0]

    select.keydown
      keyCode: keys.up
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->

    assertThat select.get("value"), equalTo "foo"

  test "Moving up the selection when the selection is at the start
      of an optgroup that is at the top should move the selection
      bottom", ->

    target = $( "<select>
                <optgroup>
                  <option selected>bar</option>
                  <option>rab</option>
                </optgroup>
                <optgroup>
                  <option>foo</option>
                </optgroup>
               </select>" )

    select = new SingleSelect target[0]

    select.keydown
      keyCode: keys.up
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->

    assertThat select.get("value"), equalTo "foo"

  test "Pressing the down key should prevent the default behavior", ->

    target = $( "<select>
                <option>foo</option>
                <option selected>bar</option>
               </select>" )
    select = new SingleSelect target[0]

    preventDefaultCalled = false

    select.keydown
      keyCode: keys.down
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->
        preventDefaultCalled = true

    assertThat preventDefaultCalled

  test "Pressing the up key should prevent the default behavior", ->

    target = $( "<select>
                <option>foo</option>
                <option selected>bar</option>
               </select>" )
    select = new SingleSelect target[0]

    preventDefaultCalled = false

    select.keydown
      keyCode: keys.up
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->
        preventDefaultCalled = true

    assertThat preventDefaultCalled

  test "Pressing the up key on a readonly select shouldn't
      move the selection cursor to the up", ->

    target = $( "<select>
                <option>foo</option>
                <option selected>bar</option>
               </select>" )
    select = new SingleSelect target[0]
    select.set "readonly", true

    select.keydown
      keyCode: keys.up
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->

    assertThat select.get("value"), equalTo "bar"

  test "Pressing the down key on a readonly select shouldn't
      move the selection cursor to the down", ->

    target = $( "<select>
                <option selected>foo</option>
                <option>bar</option>
               </select>" )
    select = new SingleSelect target[0]
    select.set "readonly", true

    select.keydown
      keyCode: keys.down
      ctrlKey: false
      shiftKey: false
      altKey: false
      preventDefault: ->

    assertThat select.get("value"), equalTo "foo"

  test "Optgroups with a select should be handled as sub menus", ->

    target = $( "<select>
                <option selected>foo</option>
                <optgroup label='irrelevant'>
                  <option>bar</option>
                  <option>rab</option>
                </option>
               </select>" )
    select = new SingleSelect target[0]

    assertThat select.model.items[1].menu, notNullValue()

  test "Clicking on a list item in a child list should
      also set the value", ->

    target = $( "<select>
                <option selected>foo</option>
                <optgroup label='irrelevant'>
                  <option>bar</option>
                  <option>rab</option>
                </option>
               </select>" )
    select = new SingleSelect target[0]

    select.attach "body"

    select.dummy.mousedown()
    select.menuList.dummy.children("li").last().mouseover()
    select.menuList.childList.dummy.children("li").last().mouseup()

    assertThat select.get("value"), equalTo "rab"
    assertThat select.dummy.find(".value").text(), equalTo "rab"

    select.detach()

  test "Pressing the mouse outside of the select list
      but on a child list shouldn't close the dialog
      before mouseup", ->

    target = $( "<select>
                <option>foo</option>
                <optgroup label='irrelevant'>
                  <option>bar</option>
                  <option>rab</option>
                </option>
               </select>" )

    select = new SingleSelect target[0]

    select.attach "body"

    select.dummy.mousedown()
    select.menuList.dummy.children("li").last().mouseover()
    select.menuList.childList.dummy.children("li").last().mousedown()

    assertThat select.menuList.dummy.parent().length, equalTo 1
    assertThat select.menuList.childList.dummy.parent().length, equalTo 1

    select.detach()
    select.menuList.detach()
    select.menuList.childList.detach()

  test "Pressing the mouse on a SingleSelect should select
      the value in the menuList even when there're optgroups", ->

    target = $( "<select>
                <option>foo</option>
                <optgroup label='irrelevant'>
                  <option>bar</option>
                  <option>rab</option>
                </option>
               </select>" )
    select = new SingleSelect target[0]

    select.attach "body"

    select.dummy.mousedown()
    select.menuList.dummy.children("li").last().mouseover()
    select.menuList.childList.dummy.children("li").last().mouseup()

    assertThat select.selectedPath, array 1, 1

    select.dummy.mousedown()

    assertThat select.menuList.selectedIndex, equalTo 1
    assertThat select.menuList.childList.selectedIndex, equalTo 1

    select.detach()
    select.menuList.detach()
    select.menuList.childList.detach()

  test "The value for a select that only have optgroup
      and no selected item should be the default
      value of the select", ->

    target = $( "<select>
                <optgroup label='irrelevant'>
                  <option>bar</option>
                  <option>rab</option>
                </option>
                <optgroup label='irrelevant'>
                  <option>foo</option>
                  <option>oof</option>
                </option>
               </select>" )

    select = new SingleSelect target[0]

    assertThat select.get("value"), equalTo "bar"
    assertThat select.selectedPath, array 0, 0

  test "Empty SingleSelect should display a default label", ->

    target = $("<select></select>")[0]

    select = new SingleSelect target

    assertThat select.dummy.find(".value").text(), equalTo "Empty"

  test "Empty SingleSelect should display a default placeholder", ->

    select = new SingleSelect

    assertThat select.dummy.find(".value").text(), equalTo "Empty"

  test "Empty SingleSelect should use the title attribute
      of the target as placeholder for the display", ->

    target = $("<select title='foo'></select>")[0]

    select = new SingleSelect target

    assertThat select.dummy.find(".value").text(), equalTo "foo"

  test "SingleSelect with the default model should display
     the default placeholder", ->

    select = new SingleSelect

    assertThat select.dummy.find(".value").text(), equalTo "Empty"

  s = "<select>
          <option>List Item 1</option>
          <option selected>List Item 2</option>
          <option>Long List Item 3</option>
          <option>Very Long List Item 4</option>
          <optgroup label='Group 1'>
            <option>List Item 5</option>
            <option>List Item 6</option>
            <option>Long List Item 7</option>
          </optgroup>
          <optgroup label='Group 2'>
            <option>List Item 8</option>
            <option>List Item 9</option>
            <option>Long List Item 10</option>
          </optgroup>
         </select>"

  select1 = new SingleSelect $(s)[0]
  select2 = new SingleSelect $(s)[0]
  select3 = new SingleSelect $(s)[0]

  select2.set "readonly", true
  select3.set "disabled", true

  $("#qunit-header").before $ "<h4>SingleSelect</h4>"
  select1.before "#qunit-header"
  select2.before "#qunit-header"
  select3.before "#qunit-header"


  module "multiselect tests"

  test "MultiSelect should accept a multiple select node as target", ->
    target = $( "<select multiple></select>" )[0]

    select = new MultiSelect target

    assertThat select.target is target

  test "MultiSelect shouldn't accept anything else that
      a select as target", ->
    target = $( "<input></input>" )[0]

    errorRaised = false

    try
      select = new MultiSelect target
    catch e
      errorRaised = true

    assertThat errorRaised

  test "MultiSelect shouldn't accept a select without the multiple
      attribute as target", ->
    target = $( "<select></select>" )[0]

    errorRaised = false

    try
      select = new MultiSelect target
    catch e
      errorRaised = true

    assertThat errorRaised

  test "MultiSelect's dummy should display the selected option label", ->

    target = $( "<select multiple>
                  <option>foo</option>
                  <option selected value='__BAR__' label='BAR'>bar</option>
                  <option selected value='__FOO__' label='FOO'>foo</option>
                  <option value='__OTHER__' label='OTHER'>other</option>
                 </select>" )[0]
    select = new MultiSelect target

    assertThat select.dummy.find(".option").length, equalTo 2
    assertThat select.dummy.find(".option").first().text(), equalTo "BAR"
    assertThat select.dummy.find(".option").last().text(), equalTo "FOO"
    assertThat select.get("value"), array "__BAR__", "__FOO__"

  test "MultiSelect's selected paths should be the index
      of the children with the selected attribute", ->

    target = $( "<select multiple>
                  <option>foo</option>
                  <option selected value='__BAR__' label='BAR'>bar</option>
                  <option selected value='__FOO__' label='FOO'>foo</option>
                  <option value='__OTHER__' label='OTHER'>other</option>
                 </select>" )[0]
    select = new MultiSelect target

    assertThat select.selectedPaths, array array(1), array(2)

  test "Clicking on a displayed item of a MultiSelect should
        remove this item from the selection", ->

    target = $( "<select multiple>
                  <option>foo</option>
                  <option selected value='__BAR__' label='BAR'>bar</option>
                  <option selected value='__FOO__' label='FOO'>foo</option>
                  <option value='__OTHER__' label='OTHER'>other</option>
                 </select>" )[0]
    select = new MultiSelect target
    select.dummy.find(".option").first().mouseup()

    assertThat select.selectedPaths, array array(2)
    assertThat select.dummy.find(".option").length, equalTo 1
    assertThat select.dummy.find(".option").text(), equalTo "FOO"

  test "Clicking on a displayed item of a disabled MultiSelect shouldn't
        remove this item from the selection", ->

    target = $( "<select multiple>
                  <option>foo</option>
                  <option selected value='__BAR__' label='BAR'>bar</option>
                  <option selected value='__FOO__' label='FOO'>foo</option>
                  <option value='__OTHER__' label='OTHER'>other</option>
                 </select>" )[0]
    select = new MultiSelect target
    select.set "disabled", true
    select.dummy.find(".option").first().mouseup()

    assertThat select.selectedPaths, array array(1), array(2)
    assertThat select.dummy.find(".option").length, equalTo 2

  test "Clicking on a displayed item of a readonly MultiSelect shouldn't
        remove this item from the selection", ->

    target = $( "<select multiple>
                  <option>foo</option>
                  <option selected value='__BAR__' label='BAR'>bar</option>
                  <option selected value='__FOO__' label='FOO'>foo</option>
                  <option value='__OTHER__' label='OTHER'>other</option>
                 </select>" )[0]
    select = new MultiSelect target
    select.set "readonly", true
    select.dummy.find(".option").first().mouseup()

    assertThat select.selectedPaths, array array(1), array(2)
    assertThat select.dummy.find(".option").length, equalTo 2

  test "MultiSelect should provide a button to open a menu to add elements
        in the selection", ->

    target = $( "<select multiple>
                  <option>foo</option>
                  <option selected value='__BAR__' label='BAR'>bar</option>
                  <option selected value='__FOO__' label='FOO'>foo</option>
                  <option value='__OTHER__' label='OTHER'>other</option>
                 </select>" )[0]

    select = new MultiSelect target

    assertThat select.dummy.find(".add").length, equalTo 1

    select.dummy.find(".add").mouseup()

    assertThat select.menuList.dummy.parent().length, equalTo 1

    visibleMenuItem = select.menuList.dummy.find(".menuitem")
                                           .filter(":visible")

    assertThat visibleMenuItem.length, equalTo 2

    visibleMenuItem.first().mouseup()

    assertThat select.selectedPaths.length, equalTo 3
    assertThat select.get("value"), array "foo", "__BAR__", "__FOO__"
    assertThat select.menuList.dummy.parent().length, equalTo 0

    select.dummy.find(".add").mouseup()

    visibleMenuItem = select.menuList.dummy.find(".menuitem")
                                           .filter(":visible")

    assertThat visibleMenuItem.length, equalTo 1

    select.menuList.detach()

  test "MultiSelect should hide its target at creation", ->

    target = $( "<select multiple>
                  <option>foo</option>
                  <option selected value='__BAR__' label='BAR'>bar</option>
                  <option selected value='__FOO__' label='FOO'>foo</option>
                  <option value='__OTHER__' label='OTHER'>other</option>
                 </select>" )

    select = new MultiSelect target[0]
    assertThat target.attr("style"), contains "display: none"

  test "MultiSelect without a target should be able
        to have selection as well", ->

    item1 = display:"item 1", value:"value 1"
    item2 = display:"item 2", value:"value 2"
    item3 = display:"item 3", value:"value 3"
    item4 = display:"item 4", value:"value 4"
    item5 = display:"item 5", value:"value 5"
    item6 = display:"item 6", value:"value 6"
    item7 = display:"item 7", value:"value 7"
    item8 = display:"item 8", value:"value 8"

    model = new MenuModel item1,
                          item2,
                          item3,
                          item4,
                          display: "group",
                          menu: new MenuModel item5, item6, item7, item8

    select = new MultiSelect model

    assertThat select.get("value"), array()

    select.set "value", ["value 2", "value 8"]

    assertThat select.selectedPaths, array array(1), array(4,3)


  s = "<select multiple>
          <option>List Item 1</option>
          <option selected>Item 2</option>
          <option>Long List Item 3</option>
          <option selected>Very Long List Item 4</option>
          <optgroup label='Group 1'>
            <option>List Item 5</option>
            <option selected>List Item 6</option>
            <option>Long List Item 7</option>
          </optgroup>
          <optgroup label='Group 2'>
            <option>List Item 8</option>
            <option selected>Item 9</option>
            <option>Long List Item 10</option>
          </optgroup>
         </select>"

  select1 = new MultiSelect $(s)[0]
  select2 = new MultiSelect $(s)[0]
  select3 = new MultiSelect $(s)[0]

  select2.set "readonly", true
  select3.set "disabled", true

  $("#qunit-header").before $ "<h4>MultiSelect</h4>"
  select1.before "#qunit-header"
  select2.before "#qunit-header"
  select3.before "#qunit-header"


