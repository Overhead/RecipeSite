this.get_new_element = (template, data) ->
  new_html = template
  Object.keys(data).forEach (key) ->
    to_replace = RegExp('{ ' + key + ' }', 'g')
    new_html = new_html.replace(to_replace, data[key])
  $(new_html)