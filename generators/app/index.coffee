util       = require 'util'
path       = require 'path'
url        = require 'url'
yeoman     = require 'yeoman-generator'
_          = require 'lodash'
helpers    = require './helpers'
chalk      = require 'chalk'

class OctobluServiceGenerator extends yeoman.Base
  constructor: (args, options, config) ->
    super
    @option 'github-user'
    @currentYear = (new Date()).getFullYear()
    {@realname, @githubUrl} = options
    @skipInstall = options['skip-install']
    @githubUser  = options['github-user']

  initializing: =>
    @appname = _.kebabCase @appname
    @noDataForwarder = _.replace @appname, /^data-forwarder-/, ''
    @env.error 'appname must start with "data-forwarder-", exiting.' unless _.startsWith @appname, 'data-forwarder-'

  prompting: =>
    return if @githubUser?

    done = @async()

    prompts = [
      {
        name: 'githubUser'
        message: 'Would you mind telling me your username on GitHub?'
        default: 'octoblu'
      }
      {
        type: 'confirm'
        name: 'octobluDev'
        message: 'Generate octoblu-dev config files?'
        default: true
      }
    ]

    @prompt prompts, (props) =>
      {@githubUser, @octobluDev, @production} = props
      done()

  userInfo: =>
    return if @realname? and @githubUrl?

    done = @async()

    helpers.githubUserInfo @githubUser, (error, res) =>
      @env.error error if error?
      @realname = res.name
      @email = res.email
      @githubUrl = res.html_url
      done()

  configuring: =>
    @copy '_gitignore', '.gitignore'

  writing: =>
    filePrefix     = _.kebabCase @noDataForwarder
    instancePrefix = _.camelCase @noDataForwarder
    classPrefix    = _.upperFirst instancePrefix
    constantPrefix = _.toUpper _.snakeCase @noDataForwarder

    context = {
      @githubUrl
      @realname
      @appname
      filePrefix
      classPrefix
      instancePrefix
      constantPrefix
    }
    @template "_package.json", "package.json", context
    @template "schemas/_configure-schema.json", "schemas/configure-schema.json", context
    @template "examples/_example.sh", "examples/example.sh", context
    @template "test/_mocha.opts", "test/mocha.opts", context
    @template "test/_test_helper.coffee", "test/test_helper.coffee", context
    @template "src/config-generators/_forwarder-device-config-generator.coffee", "src/config-generators/forwarder-device-config-generator.coffee", context
    @template "src/controllers/_device-controller.coffee", "src/controllers/device-controller.coffee", context
    @template "src/controllers/_message-controller.coffee", "src/controllers/message-controller.coffee", context
    @template "src/models/_model.coffee", "src/models/#{filePrefix}-model.coffee", context
    @template "src/_server.coffee", "src/server.coffee", context
    @template "src/_router.coffee", "src/router.coffee", context
    @template "_command.js", "command.js", context
    @template "_command.coffee", "command.coffee", context
    @template "_coffeelint.json", "coffeelint.json", context
    @template "_travis.yml", ".travis.yml", context
    @template "_Dockerfile", "Dockerfile", context
    @template "_dockerignore", ".dockerignore", context
    @template "README.md", "README.md", context
    @template "LICENSE", "LICENSE", context

  install: =>
    return if @skipInstall

    @installDependencies npm: true, bower: false

  end: =>
    @log "\nCongratulations!!! You just generated #{@appname}"
    if @octobluDev
      @composeWith 'data-forwarder:octoblu-dev', options: {@appname}
    else
      @log "But wait, there's more! Run #{chalk.bold.underline.green 'yo data-forwarder:octoblu-dev'} if you want to generate files to run this in octoblu-dev"

    if @production
      @composeWith 'data-forwarder:production', options: {@appname}
    else
      @log "But wait, there's more! Run #{chalk.bold.underline.blue 'yo data-forwarder:production'} if you want to generate files to run this in production"

module.exports = OctobluServiceGenerator
