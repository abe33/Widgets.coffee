#!/bin/sh
coffee --join widgets.js --compile src/keys.coffee src/widgets.coffee src/container.coffee src/button.coffee src/textinput.coffee src/textarea.coffee src/checkbox.coffee src/radio.coffee src/radiogroup.coffee src/numeric-widget.coffee src/slider.coffee src/stepper.coffee src/filepicker.coffee src/menus.coffee src/selects.coffee src/colorpicker.coffee src/core.coffee

coffee --join test-widgets.js --compile tests/test-keys.coffee tests/test-widgets.coffee tests/test-container.coffee tests/test-button.coffee tests/test-textinput.coffee tests/test-textarea.coffee tests/test-checkbox.coffee tests/test-radio.coffee tests/test-radiogroup.coffee tests/test-numeric-widget.coffee tests/test-slider.coffee tests/test-stepper.coffee tests/test-filepicker.coffee tests/test-menus.coffee tests/test-selects.coffee tests/test-colorpicker.coffee tests/test-core.coffee

docco src/*.coffee
