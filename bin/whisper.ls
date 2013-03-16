## Module whisper ######################################################
#
# A task-based automation app. Leiningen style!
#
# 
# Copyright (c) 2013 Quildreen "Sorella" Motta <quildreen@gmail.com>
# 
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


### -- Usage -----------------------------------------------------------
doc = '''
      Whisper --- A task-based automation app. Leiningen style!

      Usage:
        whisper <task> [<args>...] [options]

      Options:
        -v, --version           Displays the version and exits.
        -h, --help              Displays this screen and exits.
        -f, --file=<file>       Directory containing the .whisper to load.
        -e, --env=<kind>        Defines the configuration environment [default: *]. 
      '''

### -- Dependencies ----------------------------------------------------
path                                     = require 'path'
whisper                                  = require '../lib/'
{ run }                                  = require '../lib/runner'
{ load-config, find-local-config }       = require '../lib/config'
{ environment-for, default-environment } = require '../lib/environment'
{ all-tasks }                            = require '../lib/tasks'
      

### -- Main ------------------------------------------------------------
{docopt} = require 'docopt'
pkg-meta = require '../package'


# Parse options
options = docopt doc, version: pkg-meta.version
dir     = options['<file>'] or '.'
env     = if options['env'] => environment-for options['<env>']
          else              => default-environment!


# Change to the root of the project (if local)
let project-root = find-local-config dir
    if project-root => process.chdir (path.dirname project-root)


# Load configuration
(require '../lib/core') whisper
(load-config dir).for-each (config) -> config whisper


# Execute task
run env, options['<task>'], ...options['<args>']

