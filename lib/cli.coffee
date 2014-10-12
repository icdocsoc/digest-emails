#!/usr/bin/env coffee

Config = require('../config')
{ CliTasks } = require('./helpers/cli_tasks')

DigestCli = require('commander')
  .version '0.0.1'
  .option '-s, --send [email.md]', 'Send email'
  .option '-c, --compile [email.md]', 'Compile email source'
  .option '-o, --output-dir [./compiled]', 'Output for compiled email', Config.outputDir
  .option '-j, --jade-template [template.jade]', 'Base jade template for email html', Config.jadeTemplate
  .option '-S, --styl-template [template.styl]', 'Base stylus template for email css', Config.stylTemplate
  .parse(process.argv)

# Load any arg values into config
for own k,v of Config when DigestCli[k]?
  Config[k] = DigestCli[k]

if DigestCli.compile?

  CliTasks.compileFile {
    mdFile: DigestCli.compile
    outputDir: Config.outputDir
  }
    .done()

else if DigestCli.send?

  CliTasks.sendEmail {
    mdFile: DigestCli.send
  }
    .done()


