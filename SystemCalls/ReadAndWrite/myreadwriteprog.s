# This is an example of using the Read and Write system calls.
# You can type 'man 2 read' and 'man 2 write' in the 
# terminal to get info about these two methods.

	.globl	_start
	.text
_start:
	movq $1, %rax		#Write system call number
	movq $0, %rdi		#Input File Descriptor
	movq $qmsg, %rsi	#Pointer to Buffer
	movq $qmsg_len, %rdx	#Number of chars to write
	syscall

	movq $0, %rax		#Read system call number
	movq $0, %rdi		#Input File Descriptor
	movq $msg, %rsi		#Pointer to Buffer
	movq $msg_len, %rdx	#Number of chars to read
	syscall

	movq $1, %rax		#Write system call number
	movq $0, %rdi		#Input File Descriptor
	movq $amsg, %rsi	#Pointer to Buffer
	movq $amsg_len, %rdx	#Number of chars to write
	syscall

	movq $1, %rax		#Write system call number
	movq $0, %rdi		#Input File Descriptor
	movq $msg, %rsi		#Pointer to Buffer
	movq $msg_len, %rdx	#Number of chars to write
	syscall

	movq $0x3C, %rax	#Exit system call number
	syscall

	.data
qmsg:	.string "Enter less than 1024 characters: "
qmsg_len=.-qmsg
amsg:	.string "You typed: "
amsg_len=.-amsg
msg:	.space	1024
msg_len=.-msg
