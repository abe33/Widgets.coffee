
### widgets.self_and_ancestors

Iterates over the specified `element` and its ancestors and call the `block`
each time.

    widgets.self_and_ancestors = (element, block) ->
      block.call this, element
      widgets.ancestors element, block

### widgets.ancestors

Iterates over the specified `element`'s ancestors and call the `block` each time.

    widgets.ancestors = (element, block) ->
      parent = element.parentNode

      if parent? and parent isnt element
        block.call this, parent
        $w.ancestors parent, block

### widgets.find_ancestor

Returns the first ancestor of `element` that matches the specified `selector`.

    widget.find_ancestor = (element, selector) ->
      for ancestor in widgets.all_ancestors(element)
        return ancestor if ancestor.matchesSelector? selector

### widgets.all_ancestors

Returns an {Array} of the ancestors of `element`.

    widgets.all_ancestors = (element) ->
      results = []
      widgets.ancestors element, (ancestor) -> results.push ancestor
      results

### widgets.as_node_list

Ensures that the passed in argument have an {Array} like interface or wraps it
inside an {Array} otherwise.

    widgets.as_node_list = (node) ->
      return [] unless node?
      if node.length? then node else [node]

### widgets.has_class

Returns `true` if all the elements in the node list contains the specified
class.

    widgets.has_class = (nl, cls) ->
      nl = widgets.as_node_list nl

      Array::every.call nl, (n) -> ///(\s|^)#{cls}(\s|$)///.test n.className

### widgets.add_class

Adds the specified class to all the elements in the node list unless they
already have that class.

    widgets.add_class = (nl, cls) ->
      nl = widgets.as_node_list nl
      Array::forEach.call nl, (node) ->
        node.className += " #{cls}" unless widgets.has_class node, cls

### widgets.remove_class

Removes the specified class from all the elements in the node list.

    widgets.remove_class = (nl, cls) ->
      nl = widgets.as_node_list nl
      Array::forEach.call nl, (node) ->
        node.className = node.className.replace ///\b#{cls}\b///g, ''

### widgets.toggle_class

Adds the class to the elements of the node list that doesn't have it or
removes it from those that have it.

The third argument is a boolean that will force the output if specified. If
`true` the class will be added to elements, if `false` the class will be
removed.

    widgets.toggle_class = (nl, cls, b) ->
      nl = widgets.as_node_list nl
      Array::forEach.call nl, (node) ->
        has_class = if b? then not b else widgets.has_class node, cls
        if has_class
          widgets.remove_class node, cls
        else
          widgets.add_class node, cls


### widgets.escape_html

Replace `<`and `>` characters with `&lt;` and `&gt;`.

    widgets.escape_html = (str) ->
      str
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')

### widgets.strip_html

Removes all tags inside the string and returns only the text content.

    widgets.strip_html = (str) ->
      n = document.createElement 'span'
      n.innerHTML = str
      n.textContent


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
