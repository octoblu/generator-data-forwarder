debug       = require('debug')('data-forwarder:<%= appname %>')
_           = require 'lodash'
MeshbluHttp = require 'meshblu-http'
<%= classPrefix %>  = require '../models/<%= filePrefix %>-model'

class MessageController

  message: (req, res) =>
    message = req.body
    meshblu = new MeshbluHttp req.meshbluAuth
    @getDeviceConfig meshblu, (error, {connectionString, queueName}={}) =>
      return res.sendError(error) if error?
      <%= instancePrefix %> = new <%= classPrefix %>
      <%= instancePrefix %>.onMessage {message, options}, (error) =>
        return res.sendError error if error?
        res.sendStatus 201

  getDeviceConfig: (meshblu, callback) =>
    meshblu.whoami (error, device) =>
      return callback error if error?
      callback null, device

module.exports = MessageController
