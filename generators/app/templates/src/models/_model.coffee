class <%= classPrefix %>
  constructor: ->
    console.warn 'implement <%= classPrefix %>.onMessage if you want this service to actually do something.'

  onMessage: ({message, forwarderConfig}, callback) =>
    console.warn 'implement <%= classPrefix %>.onMessage if you want this service to actually do something.'
    console.log JSON.stringify {message,forwarderConfig}, null, 2
    callback()

module.exports = <%= classPrefix %>
