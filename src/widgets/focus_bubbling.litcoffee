### bubbling_focus

This widgets decorates all the dom path until the current element with
a `focus` class when the element have the focus.

    widgets.define 'bubbling_focus', (element) ->
      blur = ->
        widgets.remove_class document.querySelectorAll('.focus'), 'focus'

      element.addEventListener 'blur', -> blur()
      element.addEventListener 'focus', ->
        blur()
        widgets.self_and_ancestors element, (el) ->
          widgets.add_class el, 'focus'
