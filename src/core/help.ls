## Module help #########################################################
#
# Displays help for registered tasks.
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

module.exports = (whisper) ->

  ### -- Error handling ------------------------------------------------
  make-error = require 'flaw'

  no-task-e = -> 
    make-error '<no-task-e>'
             , "`help` expects a task name, none was given."

  unknown-task-e = (n) ->
    make-error '<unknown-task-e>'
             , "The task \"#n\" is not registered."

  ### -- Tasks ---------------------------------------------------------
  whisper.task 'help'
             , []
             , """Displays usage information for a given task.

               Usage: whisper help [task]
               """
             , (env, name) -> 
                 | not name  => throw no-task-e!
                 | otherwise => do
                                if name of whisper.all-tasks
                                  task = whisper.all-tasks[name]
                                  console.log """
                                              \# #{name}

                                              #{task.description}
                                              """
                                else => throw unknown-task-e name
