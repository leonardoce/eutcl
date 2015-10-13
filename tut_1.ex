--@+leo-ver=4-thin
--@+node:leonardo.20070409132846:@thin tut_1.ex
--@@language euphoria

-- The simplier program (excluding hello world)

include tcllib.e

function cmd_callback()
    tcl_execute("tk_messageBox -icon info -type ok -message {Hi from Euphoria}")
    return ""
end function

tcl_register_command("cmd_callback", routine_id("cmd_callback"))
tcl_execute("button .bt -text {Click here!} -command cmd_callback")
tcl_execute("pack .bt")
tk_main_loop()
--@nonl
--@-node:leonardo.20070409132846:@thin tut_1.ex
--@-leo
