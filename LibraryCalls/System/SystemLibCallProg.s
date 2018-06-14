# This is an example showing how to use the 'system' library call.
# Type 'man 3 system' in the terminal to get more info about the 'system' library call.

        .globl main
	.text
main:
	movq $cmd1, %rdi	#First parameter of 'system' library call
	call system		
	
	movq $cmd2, %rdi	#First parameter of 'system' library call
	call system		

	movq $0x3C, %rax	#Exit system call number
	syscall

	.data
cmd1:	.string "echo abc"
cmd2:	.string "ls"
