
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

