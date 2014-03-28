
### widgets.tag

Returns a new DOM element with a `nodeName` equal to `name` and containing
the specified `attrs` as attributes.

Attributes names containing a dash character can be passed as nested objects.
That means that the two following expression produces the same elements:

```coffeescript
tag = widgets.tag 'div', 'data-id': 1

tag = widgets.tag 'div', data: { id : 1 }
```

    widgets.tag = (name, attrs={}) ->
      flatten_object = (object) ->
        new_object = {}

        recursion = (object, new_object, prefix='') ->
          for k,v of object
            k = k.replace /_/g, '-'
            if typeof v is 'object'
              recursion v, new_object, prefix + k + '-'
            else
              new_object[prefix + k] = v

        recursion object, new_object
        new_object


      node = document.createElement name
      attrs = flatten_object attrs

      if attrs.id?
        node.id = attrs.id
        delete attrs.id

      if attrs.class?
        node.className = attrs.class
        delete attrs.class

      node.setAttribute(attr, value) for attr, value of attrs

      node

### widgets.tag_html

Returns a {String} corresponding to an element created with the `tag` method

    widgets.tag_html = (name, attrs) -> widgets.tag(name, attrs).outerHTML


### widgets.content_tag

Creates a DOM element as the `tag` method do, but it also allow to set its
content.

The content can be either a {String} passed before the attributes object,
or a function passed as the last argument.

When a {String} is passed as content, it is affected using the `innerHTML`
property of the created element.

When a {Function} is passed as content, it's returned value is appended to
the created element.

    widgets.content_tag = (name, content='', attrs={}) ->
      [attrs, content] = [content, attrs] if typeof attrs is 'function'
      [attrs, content] = [content, ''] if typeof content is 'object'

      node = widgets.tag name, attrs
      node.innerHTML = if typeof content is 'function'
        res = content.call node
        res?.outerHTML or String(res)
      else
        String(content)
      node

### widgets.content_tag_html

Returns a {String} corresponding to an element created with the `content_tag`
method.

    widgets.content_tag_html = (name, content, attrs) ->
      widgets.content_tag(name,content, attrs).outerHTML

### widgets.icon

Returns a DOM element corresponding to an icon such as
[FontAwesome](http://fontawesome.io/) ones.

    widgets.icon = (name, options={}) ->
      if options['class']
        options['class'] += ' ' + widgets.icon_class(name)
      else
        options['class'] = widgets.icon_class(name)

      widgets.content_tag('i', '', options)

### widgets.icon_class

Returns a {String} corresponding to the specified icon class.

    widgets.icon_class = (name) -> "fa fa-#{name}"

### widgets.icon_html

Returns a {String} corresponding to an element created with the `icon`
method.

    widgets.icon_html = (name, options) -> widgets.icon(name, options).outerHTML
