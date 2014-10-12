Digest Email Generator
=============

Generator for DoCSoc digest emails. See [this blog post](http://pete-hamilton.co.uk/2013/11/07/society-newsletters-nodejs/)

# Installation

- `brew install nodejs`
- `git clone git@github.com:icdocsoc/digest-emails.git`
- `cd digest-emails`
- `npm install`
- `npm install coffee-script -g`

# Writing
Write emails in the `emails` folder

- `h1` tags are listed at the top as an agenda-style list, unless there aren't any.

# Sending Emails

- First write your email in the ./emails folder
- Once written, execute `./lib/cli.coffee --send ./emails/selected-email.md`
- Enter the required details for email addressee
- Send!

If you encounter any errors in this process, then most likely you are missing the `DOCSOC_MAIL_PASSWORD` environment variable.
This is used to communicate with the SMTP server, and should be set for a successful send.
Either add this to (a non source controller) dotfile, or prefix the send command with `DOCSOC_MAIL_PASSWORD=<pass> ./lib/cli...`.

# Contributing

Just follow the following recommended process:

- Fork it
- Create your feature branch (`git checkout -b my-new-feature`)
- Commit your changes (`git commit -am 'Add some feature'`)
- Push to the branch (`git push origin my-new-feature`)
- Create new Pull Request
