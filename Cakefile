fs            = require 'fs'
{print}       = require 'util'
{spawn, exec} = require 'child_process'

contents = [
    "keys",
    "mixins",
    "module",
    "widgets",
    "container",
    "button",
    "textinput",
    "textarea",
    "checkbox",
    "radio",
    "radiogroup",
    "numeric-widget",
    "slider",
    "stepper",
    "filepicker",
    "menus",
    "selects",
    "colorpicker",
    "dates",
    "jquery"
]

dependencies=
    keys            :[]
    widgets         :[ "keys", "module", "mixins" ]
    container       :[ "keys", "module", "mixins", "widgets" ]
    button          :[ "keys", "module", "mixins", "widgets" ]
    textinput       :[ "keys", "module", "mixins", "widgets" ]
    textarea        :[ "keys", "module", "mixins", "widgets" ]
    checkbox        :[ "keys", "module", "mixins", "widgets" ]
    radio           :[ "keys", "module", "mixins", "widgets", "checkbox" ]
    radiogroup      :[ "keys", "module", "mixins", "widgets", "checkbox", "radio" ]
    'numeric-widget':[ "keys", "module", "mixins", "widgets" ]
    slider          :[ "keys", "module", "mixins", "widgets", "numeric-widget" ]
    stepper         :[ "keys", "module", "mixins", "widgets", "numeric-widget" ]
    filepicker      :[ "keys", "module", "mixins", "widgets" ]
    menus           :[ "keys", "module", "mixins", "widgets" ]
    selects         :[ "keys", "module", "mixins", "widgets", "menus" ]
    colorpicker     :[ "keys", "module", "mixins", "widgets", "textinput", "checkbox", "radio", "radiogroup" ]
    dates           :[ "keys", "module", "mixins", "widgets" ]
    jquery          :contents[ 0..-2 ]

testContents =[
    "test-helpers",
    "test-keys",
    "test-widgets",
    "test-container",
    "test-button",
    "test-textinput",
    "test-textarea",
    "test-checkbox",
    "test-radio",
    "test-radiogroup",
    "test-numeric-widget",
    "test-slider",
    "test-stepper",
    "test-filepicker",
    "test-menus",
    "test-selects",
    "test-colorpicker",
    "test-dates",
    "test-jquery"
]
try
    fs.lstatSync ".tmp"
catch e
    fs.mkdirSync ".tmp"

join = ( dir, contents, inFile, callback ) ->
    files = ( "#{dir}/#{file}.coffee" for file in contents when file not in [ "mixins", "module", "test-helpers" ] )

    options = ['--join', inFile, '--compile' ].concat files

    coffee = spawn 'coffee', options
    coffee.stdout.on 'data', (data) -> print data.toString()
    coffee.stderr.on 'data', (data) -> print data.toString()
    coffee.on 'exit', (status) -> callback?() if status is 0

testTask=(file)->
    task "test:#{file}", "Run tests for the #{file} file", ->
        src = ".tmp/widgets.js"
        test = ".tmp/test-widgets.js"

        join "src", dependencies[ file ].concat( file ), src, ->
            console.log "#{file} sources compiled"
        
            join "tests", [ "test-helpers", "test-#{file}" ], test, ->
                console.log "#{file} tests compiled"

                o = spawn 'firefox', [ "test-tmp.html" ]
                o.stdout.on 'data', (data) -> print data.toString()
                o.stderr.on 'data', (data) -> print data.toString()
                o.on 'exit', (status) -> callback?() if status is 0

testTask file for file in contents 
            
task 'build', "Compiles the sources, the tests, and the documentation", ->
    invoke "build:lib"
    invoke "build:tests"
    invoke "docs"

task 'build:lib', 'Generate the whole lib file', ->
    file = "lib/widgets.js"
    join "src", contents, file, ->
        console.log "#{file} generated"

task 'build:tests', 'Generate the whole tests file', ->
    file = "lib/test-widgets.js"
    join "tests", testContents, file, ->
        console.log "#{file} generated"


task 'docs', 'Generate annotated source code with Docco', ->
    files = ( "src/#{file}.coffee" for file in contents )
    docco = spawn 'docco', files
    docco.stdout.on 'data', (data) -> print data.toString()
    docco.stderr.on 'data', (data) -> print data.toString()
    docco.on 'exit', (status) -> callback?() if status is 0