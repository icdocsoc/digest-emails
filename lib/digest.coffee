Q = require('q')
_ = require('underscore')

marked = require('meta-marked')
juice = require('juice')
stylus = require('stylus')

Config = require('../config')

{ FS } = require('./helpers/fs')('readFile', 'writeFile')
{ Email } = require('./helpers/email')

class Digest

  @renderHTMLWithCSS: (mdFile, stylTemplate = Config.stylTemplate) =>
    Q.all [ @getHTML(mdFile), @getCSS(stylTemplate) ]
      .spread (html, css) ->
        # Use juice to inline all CSS into the html
        juice.inlineContent(html, css)

  @getHTML: (mdFile) ->
    FS.readFile(mdFile, 'utf8')
      .then marked # Markdown -> HTML
      .then ({ html, meta }) ->
        # Construct a new digest email with default jade template
        new Email(Config.jadeTemplate, { html, meta })
          .renderHTML()

  @getCSS: (stylFile) ->
    FS.readFile(stylFile, 'utf8')
      .then Q.nbind(stylus.render, stylus)

module.exports = { Digest }

