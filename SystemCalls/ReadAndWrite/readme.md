## Read and Write System Calls example ##

This is an example of using the Read and Write System Calls using x86_64 Assembly AT&T GAS Syntax. This code is meant to be assembled, linked and run on Linux.

To assemble, link and run type:

`as myreadandwriteprog.s -o myreadandwriteprog.o; ld myreadandwriteprog.o -o myreadandwriteprog; ./myreadandwriteprog`

_Note: Make sure the buffer size is big enough, because if the user enters more characters than the buffer size, 
the extra characters will get entered as the next command after the program exits._

To get more info on Read and Write System Calls type:
* `man 2 read`
* `man 2 write`
