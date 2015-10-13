--@+leo-ver=4-thin
--@+node:leonardo.20070409103811.2:@thin dllutils.e
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

include machine.e
include dll.e

--@<<open_dll_helper>>
--@+node:leonardo.20070409103852:<<open_dll_helper>>
global function open_dll_helper(sequence dlls)
    atom lib

    lib=-1
    for i=1 to length(dlls) by 1 do
      lib=open_dll(dlls[i])
      if lib!=0 then
        exit
      end if
    end for

    if lib=0 then
      puts(2, "Can't find library:\n")
      for i=1 to length(dlls) by 1 do
        puts(2, dlls[i])
        puts(2, "\n")
      end for
      ? 0 / 0
    end if
    
    return lib
end function
--@nonl
--@-node:leonardo.20070409103852:<<open_dll_helper>>
--@nl
--@<<peek_string>>
--@+node:leonardo.20070409103926:<<peek_string>>
global function peek_string(atom a)
    -- read a lpsz string from address a
    -- Credit: Pete Eberlein
    integer i
    sequence s
    s = ""
    if a then
	i = peek(a)        
	while i do
	    s = append(s, i)
	    a = a + 1
	    i = peek(a)
	end while
    end if
    return s
end function
--@nonl
--@-node:leonardo.20070409103926:<<peek_string>>
--@nl
--@<<define_c_func_helper>>
--@+node:leonardo.20070409103926.1:<<define_c_func_helper>>
global function define_c_func_helper(integer cLib, sequence functionName, sequence args, object returnValue)
  integer result
  result=define_c_func(cLib, functionName, args, returnValue)
  if result=-1 then
    puts(2, "Can't find function:\n")
    puts(2, functionName)
    ? 0/0
  end if
  return result
end function
--@nonl
--@-node:leonardo.20070409103926.1:<<define_c_func_helper>>
--@nl
--@<<define_c_proc_helper>>
--@+node:leonardo.20070501232826:<<define_c_proc_helper>>
global function define_c_proc_helper(integer cLib, sequence functionName, sequence args)
  integer result
  result=define_c_proc(cLib, functionName, args)
  if result=-1 then
    puts(2, "Can't find function:\n")
    puts(2, functionName)
    ? 0/0
  end if
  return result
end function
--@nonl
--@-node:leonardo.20070501232826:<<define_c_proc_helper>>
--@nl
--@-node:leonardo.20070409103811.2:@thin dllutils.e
--@-leo
