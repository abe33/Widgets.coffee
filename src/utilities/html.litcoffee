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
