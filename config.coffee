path = require('path')

module.exports =
Config = {

  templatesDir: BASE = path.join(__dirname, 'base')

  stylTemplate: path.join(BASE, 'template.styl')
  jadeTemplate: path.join(BASE, 'template.jade')

  outputDir: path.join(__dirname, 'compiled')

  dateFormat: 'MMMM Do YYYY'
  showSocial: false
  showSponsorship: false

  mailbox: {

    fromSignature: 'DoCSoc <guilds.docsoc@ic.ac.uk>'

    smtp: {
      port: 465
      secure: true
      host: 'smtp.cc.ic.ac.uk'
      auth:
        user: 'docsoc'
        pass: process.env.DOCSOC_MAIL_PASSWORD
    }

  }

}

