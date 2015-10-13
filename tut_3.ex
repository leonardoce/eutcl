--@+leo-ver=4-thin
--@+node:leonardo.20070409191738:@thin tut_3.ex
--@@language euphoria

include tcllib.e

--@<<main window>>
--@+node:leonardo.20070409191928:<<main window>>
procedure main_window()
    tcl_execute("wm title . {Listbox example}")
    
    tcl_execute("frame .f")
    tcl_execute("listbox .f.list -yscroll {.f.vscroll set}")
    tcl_execute("scrollbar .f.vscroll -command {.f.list yview}")
    tcl_execute("grid .f.list -row 0 -column 0 -sticky news")
    tcl_execute("grid .f.vscroll -row 0 -column 1 -sticky news")
    tcl_execute("grid columnconfigure .f 0 -weight 1")
    tcl_execute("grid rowconfigure .f 0 -weight 1")
    
    tcl_execute("label .lb -text {Please enter a value to add:}")
    tcl_execute("entry .en")
    tcl_execute("button .bt -text {Add Value} -command euph_add_value")
    
    tcl_execute("pack .f -expand 1 -fill both")
    tcl_execute("pack .lb")
    tcl_execute("pack .en -expand 0 -fill x")
    tcl_execute("pack .bt -expand 0 -fill x")
end procedure
--@nonl
--@-node:leonardo.20070409191928:<<main window>>
--@nl
--@<<add value callback>>
--@+node:leonardo.20070409192027:<<add value callback>>
function add_value_callback()
    sequence content
    
    content=tcl_eval(".en get")
    if length(content)=0 then
        tcl_execute("tk_messageBox -message {Please enter a value} -icon info -type ok")
    else
        tcl_execute_f(".f.list insert end {%s}", {content})
    end if
    
    return ""
end function

tcl_register_command("euph_add_value", routine_id("add_value_callback"))
--@nonl
--@-node:leonardo.20070409192027:<<add value callback>>
--@nl

main_window()
tk_main_loop()
--@nonl
--@-node:leonardo.20070409191738:@thin tut_3.ex
--@-leo
