--@+leo-ver=4-thin
--@+node:leonardo.20070409104005.1:@thin hello_world.ex
--@@language euphoria

include tcllib.e

tcl_execute("wm title . {Hello world}")
tcl_execute("button .bt -text {Quit} -command {destroy .}")
tcl_execute("label .lb -text {Hello world!}")
tcl_execute("pack .lb .bt")
tk_main_loop()
--@nonl
--@-node:leonardo.20070409104005.1:@thin hello_world.ex
--@-leo
