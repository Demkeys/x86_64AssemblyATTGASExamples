# Open and Read File #

This example shows how to open an existing file and read upto 255 bytes from it. The program will open the file (if it exists), set and offset to start reading from, read 255 bytes of the file data, and output the data to the terminal and then close the file. This is all done using only system calls. This program is meant to be assembled, linked and run on Linux.

*NOTE: There must be a file named __mytext01__ or the program won't work.*

To assemble, link and run program:
* `as openfileprog.s -o openfileprog.o`
* `ld openfileprog.o -o openfileprog`
* `./openfileprog`

To get more info on the system calls used type `man 2 [system call name]` in your terminal. For example, `man 2 open`.
