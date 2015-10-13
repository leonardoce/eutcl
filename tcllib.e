--@+leo-ver=4-thin
--@+node:leonardo.20070409103811.1:@thin tcllib.e
--@@language euphoria

--@<<LICENSE>>
--@+node:leonardo.20070409134403:<<LICENSE>>
--@@nocolor

--@+at
-- Copyright (c) 2007, Leonardo Cecchi
-- 
-- All rights reserved.
-- 
-- Redistribution and use in source and binary forms, with or without 
-- modification, are permitted provided that the following conditions are met:
-- 
--     * Redistributions of source code must retain the above copyright 
-- notice, this list of conditions and the following disclaimer.
--     * Redistributions in binary form must reproduce the above copyright 
-- notice, this list of conditions and the following disclaimer in the 
-- documentation and/or other materials provided with the distribution.
--     * Neither the name of Leonardo Cecchi nor the names of its contributors 
-- may be used to endorse or promote products derived from this software 
-- without specific prior written permission.
-- 
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
-- "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
-- LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
-- A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER 
-- OR
-- CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
-- EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
-- PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
-- PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
-- LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
-- NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--@-at
--@@c
--@nonl
--@-node:leonardo.20070409134403:<<LICENSE>>
--@nl

-- vim: foldmethod=marker syntax=euphoria ai

--=head1 TclTk Wrapper for Euphoria
--=p This wrapper works for Linux and for Windows.
--=  With this wrapper you can mix tcl/tk code with euphoria code and so
--=  you can use the tk toolkit withing your euphoria program making
--=  a cross-platform GUI
--=p You should remember, before using the wrapper, to call the
--=  Tcl_Init function
--=p If you want, you can customize the constants at the start of the file
--=  tcllib.e in order to reflect your system:
-- TODO Error when you can not find the Tcl/Tk libraries
with trace

include dll.e
include dllutils.e
include machine.e
include get.e
include misc.e

--=head2 Global variables and user configurations
--=p TCL_LIB is the name of the dynamic library of the tcl interpreter. For example
--=  in windows you have something like "tcl84.dll", in linux you have something
--=  like "libtcl8.4.so"
constant TCL_LIB={"libtcl8.5.so", "libtcl8.4.so", "tcl85.dll", "tcl84.dll", "tcl83.dll"}

--=p TK_LIB is the name of the dynamic library of the tk interpreter. For example
--=  in windows you have something like "tk84.dll", in linux you have something
--=  like "libtk8.4.so"
constant TK_LIB={"libtk8.5.so", "libtk8.4.so", "tk85.dll", "tk84.dll", "tk83.dll"}

--=p The name of the default euphoria callback
constant TCL_CALLBACK_COMMAND="euphoria_callback"


include dll.e
include machine.e

-- Error handler
procedure tcl_error_handler(sequence msg)
    puts(2, msg)
    ? 0 / 0
end procedure

--@<<Utilities>>
--@+node:leonardo.20070409094346:<<Utilities>>
-- Library helper
--@<<open_dll_helper>>
--@+node:leonardo.20070411195947:<<open_dll_helper>>
function open_dll_helper(sequence dlls)
    atom lib
    sequence msg
    lib=-1

    for i=1 to length(dlls) by 1 do
      lib=open_dll(dlls[i])
      if lib!=0 then
        exit
      end if
    end for
    
    if lib=0 then
      msg="Couldn't find a library within: "
      for i=1 to length(dlls) by 1 do
        msg=msg & dlls[i] & "/"
      end for
      tcl_error_handler(msg)
    end if

    return lib
end function
--@nonl
--@-node:leonardo.20070411195947:<<open_dll_helper>>
--@nl

--=head2 Utilities
--@<<tcl_string_escape>>
--@+node:leonardo.20070411195947.1:<<tcl_string_escape>>
--=p function tcl_string_escape(sequence orig)
--=  This function escape the string in "orig" in order to include
--=  the resulting string within another tcl command
global function tcl_string_escape(sequence orig)
    sequence dest
    dest={}
    for i=1 to length(orig) by 1 do
	dest=dest & sprintf("\\x%x", {orig[i]})
    end for
    return dest
end function
--@nonl
--@-node:leonardo.20070411195947.1:<<tcl_string_escape>>
--@nl
--@-node:leonardo.20070409094346:<<Utilities>>
--@nl

--@<<Callback Registry>>
--@+node:leonardo.20070409094514:<<Callback Registry>>
-- Callback registry {{{
sequence callbacks, command_callbacks
integer new_callback_id

callbacks = {}
new_callback_id = 1

command_callbacks = {}

-- Callback registry
--@<<add_callback>>
--@+node:leonardo.20070411195947.2:<<add_callback>>
-- Add a callback to the registry {{{
function add_callback(integer routine, sequence arguments)
  integer id
  id=new_callback_id
  new_callback_id+=1
  callbacks=append(callbacks, {id, routine, arguments})
  return length(callbacks)
end function
-- }}}
--@nonl
--@-node:leonardo.20070411195947.2:<<add_callback>>
--@nl
--@<<remove_callback>>
--@+node:leonardo.20070411195947.3:<<remove_callback>>
-- Remove a callback from the registry {{{
procedure remove_callback(integer callback_id)
  sequence new_registry
  new_registry={}
  for i = 1 to length(callbacks) by 1 do
    if callbacks[i][1] != callback_id then
      new_registry=append(new_registry, callbacks[i])
    end if
  end for
  callbacks=new_registry
end procedure
-- }}}
--@nonl
--@-node:leonardo.20070411195947.3:<<remove_callback>>
--@nl
--@<<call_callback>>
--@+node:leonardo.20070411200023:<<call_callback>>
-- Call a callback in the registry {{{
procedure call_callback(integer callback_id)
  for i = 1 to length(callbacks) by 1 do
    if callbacks[i][1] = callback_id then 
      call_proc(callbacks[i][2], callbacks[i][3])
    end if
  end for
end procedure
-- }}}
--@nonl
--@-node:leonardo.20070411200023:<<call_callback>>
--@nl
--@<<add_command_callback>>
--@+node:leonardo.20070411200023.1:<<add_command_callback>>
-- Add a callback to the commands registry {{{
procedure add_command_callback(sequence name, integer r_id)
  for i = 1 to length(command_callbacks) by 1 do
    if equal(command_callbacks[i][1], name) then
      tcl_error_handler(sprintf("Callback already present: %s\n", {name}))
    end if
  end for  
  command_callbacks=append(command_callbacks, {name, r_id})
end procedure
-- }}}
--@nonl
--@-node:leonardo.20070411200023.1:<<add_command_callback>>
--@nl
--@<<remove_command_callback>>
--@+node:leonardo.20070411200023.2:<<remove_command_callback>>
-- Remove a callback from the commands registry {{{
procedure remove_command_callback(sequence name)
  sequence new_callbacks
  new_callbacks={}
  for i = 1 to length(command_callbacks) by 1 do
    if not equal(command_callbacks[i][1], name) then
      new_callbacks=append(new_callbacks, command_callbacks[i])
    end if
  end for
  command_callbacks=new_callbacks
end procedure
-- }}}
--@nonl
--@-node:leonardo.20070411200023.2:<<remove_command_callback>>
--@nl
--@<<call_command_callback>>
--@+node:leonardo.20070411200034:<<call_command_callback>>
-- Call a command callback in the registry {{{
function call_command_callback(sequence name, sequence args)
  for i=1 to length(command_callbacks) do
    if equal(command_callbacks[i][1], name) then
      return call_func(command_callbacks[i][2], args)
    end if
  end for
  tcl_error_handler("Unknown command callback: " & name & "\n")
end function
-- }}}
--@nonl
--@-node:leonardo.20070411200034:<<call_command_callback>>
--@nl
--@-node:leonardo.20070409094514:<<Callback Registry>>
--@nl

--@<<TCL Dll Access>>
--@+node:leonardo.20070409094616:<<TCL Dll Access>>
integer interpreter
atom tcllib, tklib
integer c_tcl_createinterp, c_tcl_init, c_tcl_eval, c_tcl_getstringresult
integer c_tcl_freeresult, c_tk_init, c_tk_mainloop, c_tcl_createcommand
integer c_tcl_getvar, c_tcl_findexecutable, c_tcl_setresult
integer c_tcl_deleteinterp, c_tcl_exit

constant TCL_GLOBAL_ONLY=1
constant TCL_OK=0
constant TCL_VOLATILE=1

tcllib=open_dll_helper(TCL_LIB)
tklib=open_dll_helper(TK_LIB)
c_tcl_createinterp=define_c_func_helper(tcllib, "Tcl_CreateInterp", {}, C_POINTER)
c_tcl_deleteinterp=define_c_proc_helper(tcllib, "Tcl_DeleteInterp", {C_POINTER})
c_tcl_exit=define_c_proc_helper(tcllib, "Tcl_Exit", {C_INT})
c_tcl_init=define_c_func_helper(tcllib, "Tcl_Init", {C_POINTER}, C_INT)
c_tcl_eval=define_c_func_helper(tcllib, "Tcl_Eval", {C_POINTER, C_POINTER}, C_INT)
c_tcl_getstringresult=define_c_func_helper(tcllib, "Tcl_GetStringResult", {C_POINTER}, C_POINTER)
c_tcl_freeresult=define_c_proc_helper(tcllib, "Tcl_FreeResult", {C_POINTER})
c_tk_init=define_c_func_helper(tklib, "Tk_Init", {C_POINTER}, C_INT)
c_tk_mainloop=define_c_proc_helper(tklib, "Tk_MainLoop", {C_POINTER})
c_tcl_createcommand=define_c_proc_helper(tcllib, "Tcl_CreateCommand", {C_POINTER, C_POINTER, C_POINTER, C_POINTER, C_POINTER})
c_tcl_getvar=define_c_func_helper(tcllib, "Tcl_GetVar", {C_POINTER, C_POINTER, C_INT}, C_POINTER)
c_tcl_findexecutable=define_c_proc_helper(tcllib, "Tcl_FindExecutable", {C_POINTER})
c_tcl_setresult=define_c_proc_helper(tcllib, "Tcl_SetResult", {C_POINTER, C_POINTER, C_POINTER})
--@-node:leonardo.20070409094616:<<TCL Dll Access>>
--@nl

--@<<TCL Callback Management>>
--@+node:leonardo.20070409094737:<<TCL Callback Management>>
--@<<tcl_error>>
--@+node:leonardo.20070411202358:<<tcl_error>>
-- Print the TCL Error and abort the program
procedure tcl_error()
    atom cstring, cerror
    
    cstring=allocate_string("errorInfo")
    cerror=c_func(c_tcl_getvar, {interpreter, cstring, TCL_GLOBAL_ONLY})
    free(cstring)
    tcl_error_handler("TCL Error: " & peek_string(cerror))
end procedure
--@nonl
--@-node:leonardo.20070411202358:<<tcl_error>>
--@nl
--@<<tcl_callback>>
--@+node:leonardo.20070411202358.1:<<tcl_callback>>
-- Global tcl callback
global function tcl_callback(atom client_data, atom interpr, atom argc, atom argv)
    atom argument_ptr
    sequence argument, argument_value
    
    if argc<2 then
      puts(1, "Wrong callback... missing argument!")
    else
      -- I'm recovering the argument
      argument_ptr=peek4u(argv+4)
      argument=peek_string(argument_ptr)
      argument_value=value(argument)
      if argument_value[1]=GET_SUCCESS then
        call_callback(argument_value[2])
      else
        puts(2, sprintf("Unknown routine id: %s", {argument}))
        abort(1)
      end if
    end if
    
    return TCL_OK
end function
--@nonl
--@-node:leonardo.20070411202358.1:<<tcl_callback>>
--@nl
--@<<tcl_command_callback>>
--@+node:leonardo.20070411202358.2:<<tcl_command_callback>>
-- Command tcl callback
function tcl_command_callback(atom client_data, atom interpr, atom argc, atom argv)
    atom argument_ptr
    sequence arguments, command_name, result
    
    -- I'm recovering the command name
    command_name=peek_string(peek4u(argv))
    -- I'm recovering the arguments
    arguments={}
    for i=2 to argc by 1 do
      arguments=append(arguments, peek_string(peek4u(argv+4*(i-1))))
    end for
    -- I'm searching and calling the function
    result=call_command_callback(command_name, arguments)
    -- Result handling
    argument_ptr=allocate_string(result)
    c_proc(c_tcl_setresult, {interpr, argument_ptr, TCL_VOLATILE})
    free(argument_ptr)
    return TCL_OK
end function
--@nonl
--@-node:leonardo.20070411202358.2:<<tcl_command_callback>>
--@nl
--@<<register_tcl_callback>>
--@+node:leonardo.20070411202358.3:<<register_tcl_callback>>
--=head2 Callback management
--=p function register_tcl_callback(integer routine, sequence arguments)
--=p Register a tcl callback.
--=  This function return a tcl command that will call the routine with the
--=  specified id with the specified arguments. You can use this function
--=  to obtain a callback for your gui components.
global function register_tcl_callback(integer routine, sequence arguments)
    integer callback_id
    callback_id=add_callback(routine, arguments)
    return TCL_CALLBACK_COMMAND & " " & sprintf("%d",callback_id)
end function
--@nonl
--@-node:leonardo.20070411202358.3:<<register_tcl_callback>>
--@nl
--@<<tcl_unregister_callback>>
--@+node:leonardo.20070411202358.4:<<tcl_unregister_callback>>
--=p procedure unregister_tcl_callback(integer routine)
--=p This procedure will delete the callback that call the routine with a 
--=  specified id from the callback registry.
global procedure tcl_unregister_callback(integer callback_id)
    remove_callback(callback_id)
end procedure
--@nonl
--@-node:leonardo.20070411202358.4:<<tcl_unregister_callback>>
--@nl
--@<<tcl_register_command>>
--@+node:leonardo.20070411202358.5:<<tcl_register_command>>
--=p procedure register_tcl_command(sequence cmdname, integer routine)
--=p This procedure will create a new tcl command that, when called,
--   will execute the integer function with routine_id routine.
--   The tcl arguments will be encoded as string and the result should
--   be a string
global procedure tcl_register_command(sequence cmdname, integer routine)
  atom strptr, proc

  add_command_callback(cmdname, routine)
  strptr=allocate_string(cmdname)
  if platform()=WIN32 then
    proc=call_back({'+',routine_id("tcl_command_callback")})
  else
    proc=call_back(routine_id("tcl_command_callback"))
  end if
  c_proc(c_tcl_createcommand, {interpreter, strptr, proc, NULL, NULL})
  free(strptr)
end procedure
-- }}}
--@nonl
--@-node:leonardo.20070411202358.5:<<tcl_register_command>>
--@nl
--@<<tcl_init>>
--@+node:leonardo.20070411202358.6:<<tcl_init>>
-- Library initialization {{{
--=head2 Library initialization 
--=p procedure tcl_init()
--=p You must call tcl_init() before using any tcl/tk instruction. This procedure
--=  inits the tcl interpreter and the tk toolkit. If something goes wrong this
--=  procedure stop the program calling abort(1)
global procedure tcl_init()
    integer status
    sequence args
    atom cmdname, proc, arg0
    
    -- Find executable
    args=command_line()
    arg0=allocate_string(args[1])
    c_proc(c_tcl_findexecutable, {arg0})
    free(arg0)
    
    -- Init
    interpreter=c_func(c_tcl_createinterp, {})
    status=c_func(c_tcl_init, {interpreter})
    if status != TCL_OK then
      tcl_error()
    end if
    status=c_func(c_tk_init, {interpreter})
    if status != TCL_OK then
      tcl_error()
    end if
    
    -- Callback setup
    cmdname=allocate_string(TCL_CALLBACK_COMMAND)
    if platform()=WIN32 then
      proc=call_back({'+',routine_id("tcl_callback")})
    else
      proc=call_back(routine_id("tcl_callback"))
    end if
    c_proc(c_tcl_createcommand, {interpreter, cmdname, proc, NULL, NULL})
    free(cmdname)
end procedure
--@nonl
--@-node:leonardo.20070411202358.6:<<tcl_init>>
--@nl

--@-node:leonardo.20070409094737:<<TCL Callback Management>>
--@nl

--@<<TCL Command Gateway>>
--@+node:leonardo.20070409094821:<<TCL Command Gateway>>
--@<<tcl_execute>>
--@+node:leonardo.20070411202543:<<tcl_execute>>
--=head2 Tcl/Tk wrapper
--=p procedure tcl_execute(sequence command)
--=  This procedure will execute a tcl command loosing the result. If there is a 
--=  tcl error (the command is wrong) the application will be stopped with abort(1)
global procedure tcl_execute(sequence stringa)
    atom cstring, result
    
    cstring=allocate_string(stringa)
    result=c_func(c_tcl_eval, {interpreter, cstring})
    free(cstring)
    
    if result != TCL_OK then
      tcl_error()
    end if
end procedure
--@nonl
--@-node:leonardo.20070411202543:<<tcl_execute>>
--@nl
--@<<tcl_execute_f>>
--@+node:leonardo.20070411202543.1:<<tcl_execute_f>>
--=p procedure tcl_execute_f(sequence command, sequence args)
--=  Calling this procedure is the same as calling tcl_execute(sprintf(command,args))
global procedure tcl_execute_f(sequence command, sequence args)
    tcl_execute(sprintf(command, args))
end procedure
--@nonl
--@-node:leonardo.20070411202543.1:<<tcl_execute_f>>
--@nl
--@<<tcl_eval>>
--@+node:leonardo.20070411202543.2:<<tcl_eval>>
--=p function tcl_eval(sequence command)
--=p This procedure will execute a tcl command and the result is returned as a
--=  string. Is there is a error (the command is wrong) the application will be 
--=  stopped with abort(1)
global function tcl_eval(sequence stringa)
    atom cstring
    sequence str
    
    tcl_execute(stringa)
    
    cstring=c_func(c_tcl_getstringresult, {interpreter})
    str=peek_string(cstring)
    c_proc(c_tcl_freeresult, {interpreter})
    
    return str
end function
--@nonl
--@-node:leonardo.20070411202543.2:<<tcl_eval>>
--@nl
--@<<tcl_eval_f>>
--@+node:leonardo.20070411202543.3:<<tcl_eval_f>>
--=p function tcl_eval_f(sequence command, sequence args)
--=p Calling this procedure is the same as calling
--=  tcl_eval(sprintf(command, args))
global function tcl_eval_f(sequence command, sequence args)
    return tcl_eval(sprintf(command,args))
end function
--@nonl
--@-node:leonardo.20070411202543.3:<<tcl_eval_f>>
--@nl
--@<<tk_main_loop>>
--@+node:leonardo.20070411202543.4:<<tk_main_loop>>
--=p procedure tk_main_loop()
--=p Start the tk main loop. You should call this function after setting
--=  up the gui for your application. See the examples.
--=  After executing the tk main loop the application is closed and the
--   interpreted deallocated
global procedure tk_main_loop()
    c_proc(c_tk_mainloop, {interpreter})
    c_proc(c_tcl_deleteinterp, {interpreter})
    c_proc(c_tcl_exit, {0})
end procedure
--@nonl
--@-node:leonardo.20070411202543.4:<<tk_main_loop>>
--@nl
--@-node:leonardo.20070409094821:<<TCL Command Gateway>>
--@nl

--@<<Optional X11 Config>>
--@+node:leonardo.20070409094851:<<Optional X11 Config>>
--=p function tk_config_x11
--=  Installs some great-looking fonts on a unix environment
global procedure tk_config_x11()
    tcl_execute("font create guifont -family {Verdana} -size 10")
    tcl_execute("font create textfont -family {Courier new} -size 12")
    tcl_execute("option add \"*Menu.font\" \"guifont\"")
    tcl_execute("option add \"*Label.font\" \"guifont\"")
    tcl_execute("option add \"*Message.font\" \"guifont\"")
    tcl_execute("option add \"*Button.font\" \"guifont\"")
    tcl_execute("option add \"*Radiobutton.font\" \"guifont\"")
    tcl_execute("option add \"*Checkbutton.font\" \"guifont\"")
    tcl_execute("option add \"*Text.font\" \"textfont\"")
    tcl_execute("option add \"*Canvas.font\" \"guifont\"")
    tcl_execute("option add \"*Listbox.font\" \"guifont\"")
    tcl_execute("option add \"*Entry.font\" \"textfont\"")
    tcl_execute("option add \"*Text.borderWidth\" 1")
    tcl_execute("option add \"*Canvas.borderWidth\" 1")
    tcl_execute("option add \"*Button.borderWidth\" 1")
    tcl_execute("option add \"*Scrollbar.borderWidth\" 1")
    tcl_execute("option add \"*Entry.borderWidth\" 1")
    tcl_execute("option add \"*Listbox.borderWidth\" 1")
    tcl_execute("option add \"*Menu.borderWidth\" 1")
    tcl_execute("option add \"*Menu.activeBorderWidth\" 1")
    tcl_execute("option add \"*Listbox.selectBorderWidth\" 0")
    tcl_execute("option add \"*Listbox.selectBackground\" \"#0000a0\"")
    tcl_execute("option add \"*Listbox.selectForeground\" \"#ffffff\"")
    tcl_execute("option add \"*Listbox.background\" \"#ffffff\"")
    tcl_execute("option add \"*Text.background\" \"#ffffff\"")
    tcl_execute("option add \"*Entry.background\" \"#ffffff\"")
end procedure
--@-node:leonardo.20070409094851:<<Optional X11 Config>>
--@nl

tcl_init()
if platform()=LINUX then
  tk_config_x11()
end if
--@nonl
--@-node:leonardo.20070409103811.1:@thin tcllib.e
--@-leo
