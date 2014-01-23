
## widgets

The `widgets` module is in fact a function you can use to register
the widgets to use in a page.

For instance, the following snippet:

```coffeescript
widgets 'checkbox', 'input[type=checkbox]', on: 'load'
```

Will call `widgets.foo` with each node matching the selector `input[type=checkbox]` on the `load` event.

You can also pass a function as the last argument that will be called
for every elements handled by the defined widget after its handling by
the widget function.

    widgets = (name, selector, options={}, block) ->

The `on` option can contains either an array or a string with events names
separated with a space.

      events = options.on
      events = events.split /\s+/g if typeof events is 'string'

      handler = (e) ->

Only dom elements that haven't been handled yet are retrieve using the
selector expression.

          elements = document.querySelectorAll "#{selector}:not(.#{name}-handled)"

          Array::forEach.call elements, (element) ->
            res = widgets[name] element, Object.create(options)
            element.className += " #{name}-handled"
            block?.call element, element, res

The `handler` function is registered for each events.

      events.forEach (event) ->
        document.addEventListener event, handler

The module bootstrap for both NodeJS and browsers.

    isCommonJS = typeof module isnt "undefined"

    if isCommonJS
      exports = module.exports = widgets
    else
      exports = window.widgets = widgets

The module version is stored in the module.

    widgets.version = '0.0.0'

### widgets.defines

The `define` method registers the passed-in `block` on `widgets[name]`.

    widgets.define = (name, block) ->
      widgets[name] = block

### widgets.deprecated

The `deprecated` method serve to flag a function as deprecated. The
`deprecated` method creates a new error and gets its stack trace in order
to track the line and the files where the deprecated method was called.

```coffeescript
myFunc = ->
  widgets.deprecated '''
    myFunc is deprecated and may be removed in later version.
    Use myOtherFunc instead.
  '''
```

    widgets.deprecated = (message) ->
      parseLine = (line) ->
        if line.indexOf('@') > 0
          if line.indexOf('</') > 0
            [m, o, f] = /<\/([^@]+)@(.)+$/.exec line
          else
            [m, f] = /@(.)+$/.exec line
        else
          if line.indexOf('(') > 0
            [m, o, f] = /at\s+([^\s]+)\s*\(([^\)])+/.exec line
          else
            [m, f] = /at\s+([^\s]+)/.exec line

        [o,f]

      e = new Error()
      caller = ''
      if e.stack?
        s = e.stack.split('\n')
        [deprecatedMethodCallerName, deprecatedMethodCallerFile] = parseLine s[3]

        caller = if deprecatedMethodCallerName
          " (called from #{ deprecatedMethodCallerName } at #{ deprecatedMethodCallerFile })"
        else
           "(called from #{ deprecatedMethodCallerFile })"

      console.log "DEPRECATION WARNING: #{ message }#{ caller }"
