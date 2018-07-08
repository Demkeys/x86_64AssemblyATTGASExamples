	.globl _start
	.text
_start:
	#Open file. This returns a file descriptor if successful.
	movq $0x2, %rax		#System call 2, open
	movq $filepath, %rdi	#Param 1: Pointer to buffer
	movq $0x0, %rsi		#Param 2: Flag
	syscall

	movq %rax, %r10		#Copy return value from rax to r10

	#Set offset for opened file. 
	movq $0x8, %rax		#System call 8, lseek
	movq %r10, %rdi		#Param 1: File Descriptor
	movq $0x0, %rsi		#Param 2: Offset (zero = beginning of file)
	movq $0x0, %rdx		#Param 3: Whence
	syscall

	#Read upto 255 bytes from file and store into buffer
	movq $0x0, %rax		#System call 0, read
	movq %r10, %rdi		#Param 1: File Descriptor
	movq $msg, %rsi		#Param 2: Pointer to buffer
	movq $msg_len, %rdx	#Param 3: Count
	syscall
	
	#Write upto 255 bytes stored in buffer
	movq $0x1, %rax		#System call 1, write
	movq $0x0, %rdi		#Param 1: File Descriptor
	movq $msg, %rsi		#Param 2: Pointer to buffer
	movq $msg_len, %rdx	#Param 3: Count
	syscall

	#Close file
	movq $0x3, %rax		#System call 3, close
	movq %r10, %rdi		#Param 1: File Descriptor
	syscall

	#Exit program
	movq $0x3C, %rax	#System call 60, exit
	syscall

	.data
filepath:	.string	"./mytext01"
msg:		.space	0xff
msg_len=.-msg
