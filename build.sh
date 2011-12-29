#!/bin/sh
coffee --join widgets.js --compile src/keys.coffee src/widgets.coffee src/container.coffee src/button.coffee src/textinput.coffee src/textarea.coffee src/checkbox.coffee src/radio.coffee src/radiogroup.coffee src/numeric-widget.coffee src/slider.coffee src/stepper.coffee src/filepicker.coffee src/dropdownlist.coffee src/colorpicker.coffee src/core.coffee
docco src/*.coffee
