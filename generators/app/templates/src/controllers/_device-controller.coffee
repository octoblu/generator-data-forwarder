_               = require 'lodash'
debug           = require('debug')('data-forwarder:<%= appname %>')
MeshbluHttp     = require 'meshblu-http'
generateConfig  = require '../config-generators/forwarder-device-config-generator'
configureSchema = require '../../schemas/configure-schema.json'

class DeviceController
  constructor: ({@serviceUrl, @deviceType, @imageUrl})->
    throw new Error('serviceUrl is required') unless @serviceUrl?
    throw new Error('deviceType is required') unless @deviceType?
    throw new Error('imageUrl is required') unless @imageUrl?

  create: (req, res) =>
    config = req.body
    {meshbluAuth}   = req
    authorizedUuid  = meshbluAuth.uuid

    deviceConfig   = generateConfig {@deviceType, @imageUrl, @serviceUrl, authorizedUuid, config}
    meshbluHttp    = new MeshbluHttp meshbluAuth

    meshbluHttp.register deviceConfig, (error, device) =>
      return res.sendError error if error?
      {uuid} = device
      subscription = {subscriberUuid: uuid, emitterUuid: uuid, type: 'message.received'}

      meshbluHttp.createSubscription subscription, (error) =>
        return res.sendError error if error?
        res.status(201).send device

  delete: (req, res) =>
    {meshbluAuth}   = req
    {uuid}          = req.params

    meshblu.unregister {uuid}, (error) =>
      return res.sendError if error?
      return res.sendStatus 200

  update: (req, res) =>
    {meshbluAuth} = req
    {uuid}        = req.params
    device        = req.body

    meshblu.update uuid, device, (error) =>
      return res.sendError if error?
      return res.sendStatus 200

  getConfigureSchema: (req, res) =>
    res.status(200).send configureSchema

  _userError: (code, message) =>
    error = new Error message
    error.code = code
    error

module.exports = DeviceController
