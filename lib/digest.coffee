Q = require('q')
_ = require('underscore')

# Wrap marked to preserve the markdown source
marked = (src) ->
  data = require('meta-marked')(src)
  data.src = src
  data

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
        _.extend juice.inlineContent(html, css), _src: html._src

  @getHTML: (mdFile) ->
    FS.readFile(mdFile, 'utf8')
      .then marked # Markdown -> HTML
      .then ({ html, meta, src }) ->
        # Construct a new digest email with default jade template
        new Email(Config.jadeTemplate, { html, meta, src }).renderHTML()

  @getCSS: (stylFile) ->
    FS.readFile(stylFile, 'utf8')
      .then Q.nbind(stylus.render, stylus)

module.exports = { Digest }

