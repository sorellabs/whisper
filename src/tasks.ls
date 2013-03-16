## Module tasks ########################################################
#
# Defines and handles tasks.
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


### -- Dependencies ----------------------------------------------------
{ Base }    = require 'boo'
{ Promise } = require 'cassie'
make-error  = require 'flaw'


### -- Error handling --------------------------------------------------

task-exists-e = (task) ->
  make-error '<task-exists-e>' \
           , """
             A task named \"#{task.name}\" has already been registered:

             #{task.name} (#{task.dependencies.join ', '})
                 #{task.description or ''}
             """


### -- Core implementation ---------------------------------------------
all-tasks = {}


Task = Base.derive {
  ##### λ init
  # :: String, [String], String, (Environment -> ()) -> Task
  init: (@name, @dependencies, @description, @fun) ->
    _async    = false
    _executed = false
    @register!
    this
    
  ##### λ execute
  # :: Environment -> Promise
  execute: (env, ...args) -> unless @_executed
    @_promise  = Promise.make
    @_executed = true
    result = @fun env, ...args

    switch 
    | @_async   => @_promise
    | otherwise => @_promise.bind result

  else => @_promise
    

  ##### λ async
  # :: Bool -> Bool
  async: (v=true) -> @_async = v


  ##### λ done
  # :: a -> Promise a
  done: (status) -> @_promise.bind status


  ##### λ register
  # :: () -> ()
  register: ->
    | @name of all-tasks => throw task-exists-e this
    | otherwise          => all-tasks[@name] = this
}



task = (name, deps, desc, fun) -> Task.make name, deps, desc, fun
  


### -- Exports ---------------------------------------------------------
module.exports = { Task, task, all-tasks }
