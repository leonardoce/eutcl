<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet ekr_test?>
<leo_file>
<leo_header file_format="2" tnodes="0" max_tnode_index="0" clone_windows="0"/>
<globals body_outline_ratio="0.5">
	<global_window_position top="20" left="20" height="866" width="1160"/>
	<global_log_window_position top="0" left="0" height="0" width="0"/>
</globals>
<preferences/>
<find_panel_settings/>
<vnodes>
<v t="leonardoce.20080109144522.1"><vh>@chapters</vh></v>
<v t="leonardo.20070409135003" a="E"><vh>Documentation</vh>
<v t="leonardo.20070409135003.1" tnodeList="leonardo.20070409135003.1,leonardo.20070409134403"><vh>@nosent LICENSE</vh>
<v t="leonardo.20070409134403"><vh>&lt;&lt;LICENSE&gt;&gt;</vh></v>
</v>
<v t="leonardo.20070409135319" tnodeList="leonardo.20070409135319"><vh>@nosent CHANGES</vh></v>
<v t="leonardo.20070414133751" tnodeList="leonardo.20070414133751"><vh>@nosent README</vh></v>
</v>
<v t="leonardo.20070409103811"><vh>Library</vh>
<v t="leonardo.20070409134403"><vh>&lt;&lt;LICENSE&gt;&gt;</vh></v>
<v t="leonardo.20070409103811.1"><vh>@thin tcllib.e</vh></v>
<v t="leonardo.20070409103811.2"><vh>@thin dllutils.e</vh></v>
</v>
<v t="leonardo.20070409104005" a="E"><vh>Demos</vh>
<v t="leonardo.20070409104005.1"><vh>@thin hello_world.ex</vh></v>
<v t="leonardo.20070409132846"><vh>@thin tut_1.ex</vh></v>
<v t="leonardo.20070409133419"><vh>@thin tut_2.ex</vh></v>
<v t="leonardo.20070409191738"><vh>@thin tut_3.ex</vh></v>
<v t="leonardo.20070409104452"><vh>@thin tut_4.ex</vh></v>
<v t="leonardo.20070409193318" a="V"><vh>@thin simple_edit.exw</vh></v>
</v>
<v t="leonardo.20070409104130"><vh>Launchers</vh>
<v t="leonardo.20070409104130.1"><vh>@button hello_world</vh></v>
<v t="leonardo.20070409133118"><vh>@button tut_1</vh></v>
<v t="leonardo.20070409104855"><vh>@button tut_2</vh></v>
<v t="leonardo.20070409133937"><vh>@button tut_3</vh></v>
<v t="leonardo.20070409193128"><vh>@button tut_4</vh></v>
<v t="leonardo.20070409193458"><vh>@button simple edit</vh></v>
</v>
</vnodes>
<tnodes>
<t tx="leonardo.20070409103811"></t>
<t tx="leonardo.20070409104005"></t>
<t tx="leonardo.20070409104130"></t>
<t tx="leonardo.20070409104130.1">import os
os.system("xterm -e exu hello_world.ex")</t>
<t tx="leonardo.20070409104855">import os
os.system("xterm -ls -e exu tut_2.ex")</t>
<t tx="leonardo.20070409133118">import os
os.system("xterm -ls -e \"exu tut_1.ex\"")</t>
<t tx="leonardo.20070409133937">import os
os.system("xterm -ls -e \"exu tut_3.ex\"")</t>
<t tx="leonardo.20070409134403">@nocolor

@
Copyright (c) 2007, Leonardo Cecchi

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of Leonardo Cecchi nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
@c</t>
<t tx="leonardo.20070409135003"></t>
<t tx="leonardo.20070409135003.1">&lt;&lt;LICENSE&gt;&gt;</t>
<t tx="leonardo.20070409135319">@
@nocolor
Recent changes
--------------

1/5/2007 - Checked the c procedure/functions access
12/4/2007 - Enabled ActiveTcl 8.5 in Windows
11/4/2007 - Forced termination of the tcl interpreter after the tk_main_loop
11/4/2007 - Fixed bug with ActiveTcl 8.4/Windows. The callback functions want the cdecl specification. Why?
11/4/2007 - Fixed bug in open_dll_helper error string
@c</t>
<t tx="leonardo.20070409193128">import os
os.system("xterm -ls -e \"exu tut_4.ex\"")</t>
<t tx="leonardo.20070409193458">import os
os.system("xterm -ls -e \"exu simple_edit.ex\"")</t>
<t tx="leonardo.20070414133751">@nocolor
This is a simple tcl/tk interpreter interface that should work in Linux and in Windows.
For feedback please contact leonardoce at interfree.it</t>
<t tx="leonardoce.20080109144522.1"></t>
</tnodes>
</leo_file>
