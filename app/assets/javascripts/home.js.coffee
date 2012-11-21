# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.client = client = new Faye.Client("http://#{window.location.host}/faye")

subscription = client.subscribe '/stage', (message)->
  $(document.body).append "<div style='color: #{message.color};'>#{message.text}</div>"


$('button').live 'click', (evt)=>
  d = $(evt.currentTarget).data()
  client.publish '/stage', d