class <%= classPrefix %>
  constructor: ->
    console.warn 'Implement this guy to do something!'

    onMessage ({message, config}, callback) =>
      console.warn 'I should have done something.'
      callback()

module.exports = <%= classPrefix %>
