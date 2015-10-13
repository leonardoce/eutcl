--@+leo-ver=4-thin
--@+node:leonardo.20070409104452:@thin tut_4.ex
--@@language euphoria
include tcllib.e
include get.e

-- Simple summing application

--@<<main window>>
--@+node:leonardo.20070409104536:<<main window>>
procedure main_window()
    tcl_execute("wm title . {Summing app}")
    tcl_execute("label .lbfirst -text {First Number: }")
    tcl_execute("entry .first")
    tcl_execute("label .lbsecond -text {Second Number: }")
    tcl_execute("entry .second")
    tcl_execute("label .lbresult -text {Result: }")
    tcl_execute("entry .result")
    tcl_execute("button .btsum -text {Sum} -command on_sum_button")
    
    tcl_execute("grid .lbfirst -row 0 -column 0 -sticky w")
    tcl_execute("grid .first -row 0 -column 1 -sticky news")
    tcl_execute("grid .lbsecond -row 1 -column 0 -sticky w")
    tcl_execute("grid .second -row 1 -column 1 -sticky news")
    tcl_execute("grid .lbresult -row 2 -column 0 -sticky w")
    tcl_execute("grid .result -row 2 -column 1 -sticky news")
    tcl_execute("grid .btsum -row 3 -column 0 -columnspan 2 -sticky news")
    tcl_execute("grid columnconfigure . 1 -weight 1")
end procedure
--@nonl
--@-node:leonardo.20070409104536:<<main window>>
--@nl
--@<<sum_button>>
--@+node:leonardo.20070409105251:<<sum_button>>
function sum_button()
    sequence first, second, rf, rs
    
    first=tcl_eval(".first get")
    second=tcl_eval(".second get")
    
    rf=value(first)
    rs=value(second)
    
    tcl_execute(".result delete 0 end")
    if rf[1]!=GET_SUCCESS then
        tcl_execute(".result insert 0 {<first value not valid>}")
    elsif rs[1]!=GET_SUCCESS then
        tcl_execute(".result insert 0 {<second valut not valid>}")
    else
        tcl_execute_f(".result insert 0 {%d}", {rf[2]+rs[2]})
    end if
    
    return ""
end function
--@nonl
--@-node:leonardo.20070409105251:<<sum_button>>
--@nl

main_window()
tcl_register_command("on_sum_button", routine_id("sum_button"))
tk_main_loop()
--@nonl
--@-node:leonardo.20070409104452:@thin tut_4.ex
--@-leo
