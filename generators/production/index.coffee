yeoman = require 'yeoman-generator'
chalk  = require 'chalk'
path   = require 'path'
_      = require 'lodash'

class ProductionGenerator extends yeoman.Base
  writing: =>
    @appname = _.kebabCase @appname
    context = {@appname}
    @template "_install.sh", "production/install.sh", context
    @_templateCluster 'major.d', context
    @_templateCluster 'minor.d', context

  _templateCluster: (clusterName, context) =>
    envDir = "deployment-files/_cluster.d/octoblu/_service-name/env"
    deployFileDir = "production/deployment-files/#{clusterName}/octoblu/#{@appname}/env"

    @template "#{envDir}/_DEBUG", "#{deployFileDir}/DEBUG", context
    @template "#{envDir}/_MESHBLU_PORT", "#{deployFileDir}/MESHBLU_PORT", context
    @template "#{envDir}/_MESHBLU_SERVER", "#{deployFileDir}/MESHBLU_SERVER", context
    @template "#{envDir}/_SERVICE_URL", "#{deployFileDir}/SERVICE_URL", context


  end: =>
    @log "\nAlright, you can (probably) run #{@appname} in production!"
    @log "Run #{chalk.bold.underline.blue 'production/install.sh'} if you want to add them to the the-stack-env-production project and generate the appropriate files."


module.exports = ProductionGenerator
