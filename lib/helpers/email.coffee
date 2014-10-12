Q = require('q')
_ = require('underscore')

jsdom = require('jsdom')
jade = require('jade')
moment = require('moment')

Config = require('../../config')

class Email

  constructor: (@jadeTemplate = Config.jadeTemplate, { @html, meta }) ->
    @initMeta(meta)

  # Causes the html to be rendered. Returns a promise that is resolved with
  # final HTML text.
  renderHTML: ->
    @createEnv()
      .then @loadAgenda.bind(@)
      .then @compileWithMeta.bind(@)

  # Sets default page meta-data.
  initMeta: (pageMeta) ->
    @meta = _.extend {
      agenda: []
      showSponsorship: Config.showSponsorship
      showSocial: Config.showSocial
      date: moment().format(Config.dateFormat ? 'MMMM Do YYYY')
    }, pageMeta

  # Uses jsdom to construct a window environment, allowing page parsing.
  createEnv: ->

    jsdom.env {
      html: @html
      scripts: ['http://code.jquery.com/jquery.js']
      done: (deferred = Q.defer()).makeNodeResolver()
    }

    return deferred.promise

  # Uses window handle to parse agenda list.
  loadAgenda: (window) ->
    agenda = @meta.agenda
    window.$('h1').each ->
      agenda.push window.$(@).text()
    return window

  # Uses jade to compile the initial html content, injecting the parsed meta
  # data as locals.
  compileWithMeta: (window) ->
    console.error @meta
    html = jade.renderFile @jadeTemplate, {
      page: @meta
      content: @html
    }

module.exports = { Email }

