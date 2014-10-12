Q = require('q')
path = require('path')
winston = require('winston')

prompt = require('prompt')
get = Q.nbind(prompt.get, prompt)

{ Digest } = require('../digest')
{ DocEmailAccount } = require('./email_account')
{ FS } = require('./fs')('writeFile')

class CliTasks

  # Will compile and output the markdown file to the given output directory.
  #
  # params {Object} {
  #   mdFile {String} path to markdown email template
  #   outputDir {String} base directory for outputting file
  # }
  #
  # Will return promise that is resolved on successful write.
  @compileFile: ({ mdFile, outputDir }) ->

    outFile = path.basename(mdFile).replace(/\.md$/, '.html')
    outPath = path.join(outputDir, outFile)

    winston.info "Compiling email #{mdFile} to #{outPath}..."
    Digest.renderHTMLWithCSS(mdFile)
      .then FS.writeFile.bind(null, outPath)
      .then -> winston.info 'Compiled!'

  # Given a markdown file, will prompt for email details and send email.
  #
  # params {Object} {
  #   mdFile {String} path to markdown email template
  # }
  #
  # Will return a promise that is resolved on successful send.
  @sendEmail: ({ mdFile }) ->

    winston.info "Sending email composed with markdown file #{mdFile}..."

    Digest.renderHTMLWithCSS(mdFile).then (html) ->
      get(['To', 'Subject']).then ({ To: to, Subject: subject }) ->
        DocEmailAccount.sendMail ({ to, subject, text: html._src, html })

    .then -> console.log 'Sent!'

module.exports = { CliTasks }

