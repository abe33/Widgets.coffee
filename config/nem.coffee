{print} = require 'util'
{spawn} = require 'child_process'

# The `npm` function excute an `npm install` of the specified `pkg` package.
# Optionally a target can be specified for the installed package
# (see the [npm install documentation](http://npmjs.org/doc/install.html)
# for more details)
npm=(pkg, target)->
  pkg = "#{pkg}@#{target}" if target?
  exe = spawn 'npm', ['install',  pkg ]
  exe.stdout.on 'data', ( data )-> print data.toString()
  exe.stderr.on 'data', ( data )-> print data.toString()
