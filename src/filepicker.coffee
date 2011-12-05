# The `FilePicker` widget is a special case, since the `file` input behavior
# cannit be emulate through javascript the real target is used as the trigger
# for the widget's action.
#
# In that regards the testability of the widget cannot be guaranted concerning
# the behavior of the target. Click emulation through javascript on a `file` input
# is generally considered as opening a popup and then prevented by the browser.
class FilePicker extends Widget
	constructor:(target)->

		# The `target` is mandatory in the `FilePicker` constructor. 
		unless target? and ( $ target ).attr("type") is "file"
			throw "FilePicker must have an input file as target"
		
		super target

		# The target is hidden when the widget is either readonly or disabled.
		if @cantInteract() then @hideTarget()

		# Target's changes are binded to an internal callback.
		@jTarget.bind "change", (e)=>
			@targetChange e
	
	# When the target's changed the `value`'s text is then replaced with
	# the new value. 
	targetChange:(e)->
		@setValueLabel if @jTarget.val()? then @jTarget.val() else "Browse"
		@dummy.attr "title", @jTarget.val()
	
	# This method allow to test the change of the `value`'s text.
	setValueLabel:( label )->
		@dummy.children(".value").text label

	# The dummy for a `FilePicker` is a `span` with a `filepicker` class on it.
	createDummy:->
		# It contains two `span` children for an icon and the value display.
		dummy = $ "<span class='filepicker'>
				  	<span class='icon'></span>
				  	<span class='value'>Browse</span>
				 </span>"
		# The widget's target is part of the dummy, at the top.
		# Generally the target's opacity should be set to `0`
		# in a stylesheet. And its position should be absolute
		# within the widget in order to cover the whole widget
		# and allow the click to take effect.
		dummy.append @jTarget

		dummy

	# Disabling a `FilePicker` hides the target, in the contrary
	# enabling the widget will display the target again.
	set_disabled:( property, value )->
		if value then @hideTarget() else unless @get("readonly") then @showTarget()
		super property, value
	
	# When a widget allow writing in it, the target is visible, otherwise the
	# target is hidden. 
	set_readonly:( property, value )->
		if value then @hideTarget() else unless @get("disabled") then @showTarget()
		super property, value

	# Display the target if defined.
	showTarget:->
		if @hasTarget then @jTarget.show()
	
# Address the access restriction due to the sandboxing when used
# directly in a browser with the `text/coffeescript` mode. 
if window? 
	window.FilePicker = FilePicker