{print} = require 'util'
{spawn} = require 'child_process'

packages = []

# The `npm` function register `pkg` as a `npm install` package.
# Optionally a target can be specified for the installed package
# (see the [npm install documentation](http://npmjs.org/doc/install.html)
# for more details)
npm=(pkg, target)->
  pkg = "#{pkg}@#{target}" if target?
  packages.push pkg

# Packages declared for install in the `Nemfile` are inserted below
# by the cake install file.
###NPM_DECLARATION###

# Executes npm install with the declared dependencies.
exe = spawn 'npm', ['install' ].concat packages
exe.stdout.on 'data', (data)-> print data.toString()
exe.stderr.on 'data', (data)-> print data.toString()
