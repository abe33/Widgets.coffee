module "dropdownlist tests"

test "DropDownList should accept select node as target", ->
    target = $( "<select></select>" )[0]

    ddl = new DropDownList target

    assertThat ddl.target is target

test "DropDownList shouldn't accept anything else that a select as target", ->
    target = $( "<input></input>" )[0]

    errorRaised = false

    try
        ddl = new DropDownList target
    catch e
        errorRaised = true
    
    assertThat errorRaised

test "DropDownList's dummy should display the selected option label", ->

    target = $( "<select>
                    <option>foo</option>
                    <option selected value='__BAR__' label='BAR'>bar</option>
                 </select>" )[0]
    ddl = new DropDownList target

    assertThat ddl.dummy.find(".value").text(), equalTo "BAR"

test "DropDownList's dummy should display the selected option", ->

    target = $( "<select>
                    <option>foo</option>
                    <option selected value='BAR'>bar</option>
                 </select>" )[0]
    ddl = new DropDownList target

    assertThat ddl.dummy.find(".value").text(), equalTo "bar"   

test "DropDownList should display the select's options in a dummy child", ->

    target = $( "<select>
                    <option>foo</option>
                    <option selected>bar</option>
                 </select>" )[0]
    ddl = new DropDownList target

    assertThat ddl.dummy.find(".list").children().length, equalTo 2

test "DropDownList dummy's options content should be the corresponding option label", ->

    target = $( "<select>
                    <option label='FOO'>foo</option>
                    <option selected>bar</option>
                 </select>" )[0]
    ddl = new DropDownList target

    assertThat ddl.dummy.find(".list").children().first().text(), equalTo "FOO"
    assertThat ddl.dummy.find(".list").children().last().text(), equalTo "bar"

test "DropDownList dummy's list should be the hidden at creation", ->

    target = $( "<select>
                    <option>foo</option>
                    <option selected>bar</option>
                 </select>" )[0]
    ddl = new DropDownList target

    assertThat ddl.dummy.find(".list").attr("style"), contains "display: none;"

test "Clicking on the widget when the list is hidden should display the list", ->

    target = $( "<select>
                    <option>foo</option>
                    <option selected>bar</option>
                 </select>" )[0]
    ddl = new DropDownList target

    ddl.dummy.click()

    assertThat ddl.dummy.find(".list").attr("style"), contains "display: block;"

test "Clicking on the widget when the list is visible should hide the list", ->

    target = $( "<select>
                    <option>foo</option>
                    <option selected>bar</option>
                 </select>" )[0]
    ddl = new DropDownList target

    ddl.dummy.click()
    ddl.dummy.click()

    assertThat ddl.dummy.find(".list").attr("style"), contains "display: none;"



target = $( "<select>
                <option>List Item 1</option>
                <option selected>List Item 2</option>
                <option>List Item 3</option>
                <option>List Item 4</option>
             </select>" )[0]
ddl = new DropDownList target

$("#qunit-header").before $ "<h4>DropDownList</h4>"
$("#qunit-header").before ddl.dummy
