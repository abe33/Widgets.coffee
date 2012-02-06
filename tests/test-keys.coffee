$( document ).ready ->

	module "keystroke function tests"

	test "The keystroke function should return an object with the specified keyCode", ->

		ks = keystroke 10

		assertThat ks.keyCode, equalTo 10

	test "The keystroke function should return an object with the passed-in keycode and modifier", ->

		ks = keystroke 0, 7

		assertThat ks.modifiers, equalTo 7

	test "Modifier's properties should be false when modifiers is 0",->

		ks = keystroke 0

		assertThat ks, hasProperty "ctrl", strictlyEqualTo false
		assertThat ks, hasProperty "shift", strictlyEqualTo false
		assertThat ks, hasProperty "alt", strictlyEqualTo false

	test "Ctrl property should be true when mofifiers is 1",->

		ks = keystroke 0, 1

		assertThat ks.ctrl

	test "Shift property should be true when mofifiers is 2",->

		ks = keystroke 0, 2

		assertThat ks.shift

	test "Alt property should be true when mofifiers is 4",->

		ks = keystroke 0, 4

		assertThat ks.alt

	test "All modifier's property should be true when mofifiers is 7",->

		ks = keystroke 0, 7

		assertThat ks.ctrl
		assertThat ks.shift
		assertThat ks.alt

	test "Two calls to keystroke with the same arguments should return the same instance", ->

		ks1 = keystroke 16, 7
		ks2 = keystroke 16, 7

		assertThat ks1, strictlyEqualTo ks2

	test "The keystroke object should be able to match an event object", ->
		
		ks = keystroke 16, 7
		
		assertThat ks.match
			keyCode:16
			ctrlKey:true
			shiftKey:true
			altKey:true

	test "The string representation of a keystroke should be a human readable representation", ->

		ks = keystroke keys.a, keys.mod.ctrl + keys.mod.shift

		assertThat ks.toString(), equalTo "Ctrl+Shift+A"

