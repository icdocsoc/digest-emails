# Packages
path = require("path")
jade = require("jade")
marked = require("meta-marked")
fs = require("fs")
juice = require("juice")
stylus = require("stylus")
jsdom = require("jsdom")
moment = require("moment")

# Other Variables
templatesDir = path.join(__dirname, "templates")
file = "./emails/test/index.md"

# Render CSS
getCSS = (callback) ->
  fs.readFile __dirname + "/template.styl", "utf8", (err, data) ->
    throw err if err
    stylus.render data, (err, css) ->
      throw err if err
      callback css

getHTML = (file, callback) ->
  fs.readFile file, "utf8", (err, rawMarkdown) ->
    throw err if err

    data = marked(rawMarkdown) # Markdown -> HTML

    # Extract H1 contents to create agenda, add to meta
    jsdom.env
      html: data.html
      done: (errors, window) ->
        data.meta.agenda = []
        for h in window.document.querySelectorAll("h1")
          data.meta.agenda.push h.textContent

        data.meta.show_social = (data.meta.show_social isnt false)
        data.meta.show_sponsorship = (data.meta.show_sponsorship isnt false)
        if data.meta.date and data.meta.date isnt ""
          data.meta.date = moment(data.meta.date).format("MMMM Do YYYY")

        html = jade.renderFile "template.jade",
          page: data.meta
          content: data.html

        callback html

renderFile = (file, callback) ->
  getHTML file, (html) ->
    getCSS (css) ->
      callback juice.inlineContent(html, css)

outputHTML = (name, html, callback) ->
  fs.writeFile name, html, (err) ->
    throw err if err
    callback() if callback

fs.readdir "./emails/", (err, files) ->
  throw err if err
  console.log "Rendering Emails"
  files.forEach (file) ->
    return if file[0] is "." # Ignore .DS_Store
    console.log "  - " + file + " -> compiled/" + file.replace(".md", ".html")
    renderFile "emails/" + file, (html) ->
      outputHTML "compiled/" + file.replace("md", "html"), html, ->

