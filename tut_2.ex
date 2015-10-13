--@+leo-ver=4-thin
--@+node:leonardo.20070409133419:@thin tut_2.ex
--@@language euphoria

-- Example for a callback with arguments

include tcllib.e

function cmd_callback(sequence val)
    tcl_execute_f("tk_messageBox -icon info -type ok -message {Hi, %s}",{val})
    return ""
end function

tcl_register_command("cmd_callback", routine_id("cmd_callback"))
tcl_execute("wm title . {Callback with arguments example}")
tcl_execute("entry .en")
tcl_execute("label .lb -text {Your name?}")
tcl_execute("button .bt -text {Click here!} -command {cmd_callback [.en get]}")
tcl_execute("pack .lb .en .bt")
tk_main_loop()
--@nonl
--@-node:leonardo.20070409133419:@thin tut_2.ex
--@-leo
