{print} = require 'util'
{spawn} = require 'child_process'

npm=(pkg, target)->
  pkg = "#{pkg}@#{target}" if target?
  exe = spawn 'npm', ['install',  pkg ]
  exe.stdout.on 'data', ( data )-> print data.toString()
  exe.stderr.on 'data', ( data )-> print data.toString()
