`WEB_SOCKET_DEBUG = true;
 WEB_SOCKET_SWF_LOCATION = '/WebSocketMain.swf';`
jQuery ($)->
  nyoibo = new Nyoibo("ws://localhost:3030/", "ws-progress")
  form = $('#ws-form')
  nyoibo.prepare_upload = -> true
  nyoibo.before_upload  = ->
    form.hide()
  nyoibo.after_upload   = ->
    form.get(0).reset()
    form.show()
  nyoibo.upload_abort   = -> true

  $('#ws-form input[type=submit]').click ->
    params = {}
    for i, input of form.serializeArray()
      params[input.name] = input.value

    unless nyoibo.upload(form.find('input[type=file]').get(0).files[0], params)
      alert nyoibo.errors.join(", ")
    return false
