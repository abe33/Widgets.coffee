# The `RadioGroup` class handle a set of `Radio` widget.
# Only one `Radio` can be checked at one time in a `RadioGroup`.
class RadioGroup

	constructor:( radios... )->
		#### RadioGroup signals

		# The `selectionChanged` signal is dispatched when the selection
		# of the current radio group has changed.
		#
		# *Callback arguments*
		#
		#  * `group`  : The `RadioGroup` which had its selection changed.
		#  * `oldSel` : The old selected radio.
		#  * `newSel` : The new selected radio.
		@selectionChanged = new Signal
		
		# You can pass any number of `Radio` objects as argument in the constructor.
		# They will be added in the group through the `add` method.
		@radios = []
		@add radio for radio in radios

	#### Radios management
	
	# Adds a `Radio` in this group unless this radio is already
	# registered. 
	add:( radio )->
		unless @contains radio
			@radios.push radio

			# The radio group register itself to the `checkedChanged` 
			# signal of the added radio.
			radio.checkedChanged.add @radioCheckedChanged, this

			# Adding a checked radio automatically makes it the selected
			# radio for this group.
			if radio.get "checked" then @selectedRadio = radio
	
	# Removes a radio from this group.
	remove:( radio )->
		if @contains radio
			@radios.splice @indexOf( radio ), 1
			radio.checkedChanged.remove @radioCheckedChanged, this

	# Returns `true` if the passed-in `radio` is registered in this group.
	contains:( radio )->
		@indexOf( radio ) isnt -1
	
	# Returns the index of the `radio` in this group.
	indexOf:( radio )->
		@radios.indexOf radio 
	
	#### Selection

	# Flag used to prevent infinite loops during a selection phase. 
	checkedSetProgrammatically:false

	# Set the passed-in `radio` as the selected radio. 
	# The previously selected radio is then unchecked.
	select:( radio )->
		
		unless radio is @selectedRadio
			# The `checkedSetProgrammatically` flag is set to `true`
			# at the beggining of the selection process. It will prevent
			# the changes done by the `select` function on the radios
			# to produce a new call to `select` from the signal listener.
			@checkedSetProgrammatically = true
			
			# Save the old radio for the signal dispatch.
			oldSelectedRadio = @selectedRadio

			# The previous selected is unchecked.
			if @selectedRadio? then	@selectedRadio.set "checked", false

			# Calling `select` without arguments clear the selection
			# and uncheck all the children radios.
			@selectedRadio = radio

			if @selectedRadio? 
				# The new selected radio is checked if it wasn't the case already.
				if not @selectedRadio.get "checked" then @selectedRadio.set "checked", true
			
			# Unset the flag. Now the widget will handle signals dispatched
			# by its children radio.
			@checkedSetProgrammatically = false

			# Finally, the `selectionChanged` signal is dispatched with both 
			# the old and the new selection radios.
			@selectionChanged.dispatch this, oldSelectedRadio, @selectedRadio

	
	#### Radio signals listeners
	
	# Listen to the `checkedChanged` signal of the radio.
	#
	# If the source radio is checked, it became the new selected radio for
	# this group. Otherwise, if it was the selected radio, the `selectedRadio` 
	# is set to `null`.
	radioCheckedChanged:( radio, checked )->
		unless @checkedSetProgrammatically
			if checked 
				@select radio
			else if radio is @selectedRadio
				@selectedRadio = null

# Address the access restriction due to the sandboxing when used
# directly in a browser with the `text/coffeescript` mode. 
if window? 
	window.RadioGroup = RadioGroup
