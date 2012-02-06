$( document ).ready ->

	module "radiogroup tests"

	test "A RadioGroup should allow any number of Radio as constructor arguments", ->

		group = new RadioGroup new Radio, new Radio, new Radio

		assertThat group.radios, arrayWithLength 3

	test "A RadioGroup should listen to the checkedChanged signal of its radios", ->
		
		signalCalled = false

		class MockRadioGroup extends RadioGroup
			radioCheckedChanged:( radio, checked )->
				signalCalled = true

		radio = new Radio
		group = new MockRadioGroup radio

		radio.set "checked", true

		assertThat signalCalled

	test "A RadioGroup should allow to add a Radio after its instanciation", ->

		group = new RadioGroup

		group.add new Radio

		assertThat group.radios, arrayWithLength 1

	test "A RadioGroup should listen to a Radio added via the add method", ->
		
		signalCalled = false

		class MockRadioGroup extends RadioGroup
			radioCheckedChanged:( radio, checked )->
				signalCalled = true
		
		radio = new Radio
		group = new MockRadioGroup

		group.add radio

		radio.set "checked", true

		assertThat signalCalled

	test "A RadioGroup should allow to remove a radio", ->

		radio = new Radio
		group = new RadioGroup radio

		group.remove radio

		assertThat group.radios, arrayWithLength 0


	test "A RadioGroup shouldn't listen to a Radio that have been removed", ->
		
		signalCalled = false

		class MockRadioGroup extends RadioGroup
			radioCheckedChanged:( radio, checked )->
				signalCalled = true
		
		radio = new Radio
		group = new MockRadioGroup radio

		group.remove radio

		radio.set "checked", true

		assertThat not signalCalled

	test "A RadioGroup shouldn't allow to add twice the same radio", ->

		radio = new Radio
		group = new RadioGroup radio

		group.add radio

		assertThat group.radios, arrayWithLength 1

	test "Adding a checked radio should automatically select it", ->

		radio = new Radio
		radio.set "checked", true
		
		group = new RadioGroup radio

		assertThat group.selectedRadio, equalTo radio

	test "RadioGroup should be able to select a radio in the group", ->

		radio1 = new Radio
		radio2 = new Radio
		radio3 = new Radio

		group = new RadioGroup radio1, radio2, radio3

		group.select radio1

		assertThat group.selectedRadio, radio1

	test "Given three radios in a group, checking one should uncheck the others", ->

		radio1 = new Radio
		radio2 = new Radio
		radio3 = new Radio

		radio1.set "checked", true

		group = new RadioGroup radio1, radio2, radio3

		group.select radio3

		assertThat not radio1.get "checked"
		assertThat not radio2.get "checked"
		assertThat radio3.get "checked"

	test "Given three radios in a group, clicking on one should uncheck the others", ->

		radio1 = new Radio
		radio2 = new Radio
		radio3 = new Radio

		radio1.set "checked", true

		group = new RadioGroup radio1, radio2, radio3

		radio3.click()

		assertThat not radio1.get "checked"
		assertThat not radio2.get "checked"
		assertThat radio3.get "checked"

	test "Given three radios in a group, unchecking the selected one should clear the selection", ->

		radio1 = new Radio
		radio2 = new Radio
		radio3 = new Radio

		radio1.set "checked", true

		group = new RadioGroup radio1, radio2, radio3

		radio1.set "checked", false

		assertThat group.selectedRadio, nullValue()

	test "Given three radios in a group, calling select without an argument should clear the selection.", ->

		radio1 = new Radio
		radio2 = new Radio
		radio3 = new Radio

		radio1.set "checked", true

		group = new RadioGroup radio1, radio2, radio3

		group.select()

		assertThat group.selectedRadio, nullValue()

	test "Selection change on a radio group should dispatch a selectionChanged signal.", ->

		signalCalled = false
		signalSource = null
		signalOldRadio = null
		signalNewRadio = null

		radio1 = new Radio
		radio2 = new Radio
		radio3 = new Radio

		group = new RadioGroup radio1, radio2, radio3

		group.selectionChanged.add ( group, oldSel, newSel )->
			signalCalled = true
			signalSource = group
			signalOldRadio = oldSel
			signalNewRadio = newSel
		
		group.select radio1

		assertThat signalCalled
		assertThat signalSource is group
		assertThat signalOldRadio, nullValue()
		assertThat signalNewRadio is radio1

	test "The selectionChanged signal shouldn't be dispatched when select is called with the current selection", ->
		signalCallCount = 0

		radio1 = new Radio
		radio2 = new Radio
		radio3 = new Radio

		group = new RadioGroup radio1, radio2, radio3
		group.selectionChanged.add ->
			signalCallCount++
		
		group.select radio1
		group.select radio1

		assertThat signalCallCount, equalTo 1


	radio1 = new Radio
	radio2 = new Radio
	radio3 = new Radio
	radio3.set "checked", true
	radio3.set "disabled", true 

	group = new RadioGroup radio1, radio2, radio3

	$("#qunit-header").before $ "<h4>RadioGroup</h4>"
	$("#qunit-header").before radio1.dummy
	$("#qunit-header").before radio2.dummy
	$("#qunit-header").before radio3.dummy
