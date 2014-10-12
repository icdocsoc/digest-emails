Q = require('q')
nodemailer = require('nodemailer')

Config = require('../../config')

class DocEmailAccount

  @FROM: Config.mailbox.fromSignature
  @TRANSPORT_OPTIONS: Config.mailbox.smtp

  @MAILER: nodemailer.createTransport(@TRANSPORT_OPTIONS)

  @sendMail: ({ to, subject, text, html }) =>
    Q.nbind(@MAILER.sendMail, @MAILER) {
      from: @FROM
      to, subject, text, html
    }

module.exports = { DocEmailAccount }
