## Read and Write System Calls example ##

To assemble, link and run:

`as myreadandwriteprog.s -o myreadandwriteprog.o; ld myreadandwriteprog.o -o myreadandwriteprog; ./myreadandwriteprog`

_Note: Make sure the buffer size is big enough, because if the user enters more characters than the buffer size, 
the extra characters will get entered as the next command after the program exits._
