#!/bin/sh

# widget.js contains all the sources
coffee --join lib/widgets.js --compile src/keys.coffee src/widgets.coffee src/container.coffee src/button.coffee src/textinput.coffee src/textarea.coffee src/checkbox.coffee src/radio.coffee src/radiogroup.coffee src/numeric-widget.coffee src/slider.coffee src/stepper.coffee src/filepicker.coffee src/menus.coffee src/selects.coffee src/colorpicker.coffee src/dates.coffee src/jquery.coffee

# text-widgets.js contains both the sources and the tests
coffee --join lib/test-widgets.js --compile src/keys.coffee src/widgets.coffee src/container.coffee src/button.coffee src/textinput.coffee src/textarea.coffee src/checkbox.coffee src/radio.coffee src/radiogroup.coffee src/numeric-widget.coffee src/slider.coffee src/stepper.coffee src/filepicker.coffee src/menus.coffee src/selects.coffee src/colorpicker.coffee src/dates.coffee src/jquery.coffee tests/test-keys.coffee tests/test-widgets.coffee tests/test-container.coffee tests/test-button.coffee tests/test-textinput.coffee tests/test-textarea.coffee tests/test-checkbox.coffee tests/test-radio.coffee tests/test-radiogroup.coffee tests/test-numeric-widget.coffee tests/test-slider.coffee tests/test-stepper.coffee tests/test-filepicker.coffee tests/test-menus.coffee tests/test-selects.coffee tests/test-colorpicker.coffee tests/test-dates.coffee tests/test-jquery.coffee

# Generates the documentation
docco src/*.coffee
