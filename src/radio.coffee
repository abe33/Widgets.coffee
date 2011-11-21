# The `Radio` widget is a kind of `CheckBox` that can
# be only set to true by the user.
#
# They're generaly used in combination with a `RadioGroup`. 
class Radio extends CheckBox

	# Radio only allow inputs of type `radio`.
	targetType:"radio"
		
	# The dummy for the radio is just a `<span>` element
	# with a `radio` class.
	createDummy:->
		$ "<span class='radio'></span>"
	
	# Toggle is unidirectionnal. The only way to
	# uncheck a radio is by code. 
	toggle:->
		unless @get "checked" then super() 
	

# Address the access restriction due to the sandboxing when used
# directly in a browser with the `text/coffeescript` mode. 
if window? 
	window.Radio = Radio
