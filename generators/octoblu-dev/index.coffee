yeoman = require 'yeoman-generator'
chalk  = require 'chalk'
path   = require 'path'

class DevelopmentGenerator extends yeoman.Base
  writing: =>
    @appname = require(path.join( process.cwd(), 'package.json')).name
    context = {@appname}
    @template "deployment-files/generator/projects/_dev-deployment.json", "octoblu-dev/deployment-files/generator/projects/#{@appname}.json", context
    @template "deployment-files/generator/public-env/_SERVICE_URL", "octoblu-dev/deployment-files/generator/public-env/#{@appname}/SERVICE_URL", context
    @template "_install.sh", "octoblu-dev/install.sh", context

  end: =>
    @log "\nAlright, you can (probably) run #{@appname} on octoblu-dev!"
    @log "Run #{chalk.bold.underline.green 'octoblu-dev/install.sh'} if you want to add them to the octoblu-dev project and generate the appropriate files."


module.exports = DevelopmentGenerator
