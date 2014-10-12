path = require('path')

module.exports =
Config = {

  templatesDir: BASE = path.join(__dirname, 'base')

  stylTemplate: path.join(BASE, 'template.styl')
  jadeTemplate: path.join(BASE, 'template.jade')

  outputDir: path.join(BASE, 'compiled')

  dateFormat: 'MMMM Do YYYY'
  showSocial: false
  showSponsorship: false

}

