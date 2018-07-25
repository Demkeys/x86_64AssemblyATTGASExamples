	.globl	_start
	.text
_start:
	pushq %rbp
	movq %rsp, %rbp
#####################################
	movq $0x1, %rax		# Write, asking user for 8 characters. Only 8 bytes of input will be used. Rest will be ignored.
	movq $0x0, %rdi
	movq $p_key_msg, %rsi
	movq $p_key_msg_len, %rdx
	syscall

	movq $0x0, %rax		# Read user input
	movq $0x0, %rdi
	movq $p_key, %rsi
	movq $p_key_len, %rdx
	syscall

	pushq p_key		# -0x8(%rbp) : p_key value
	
	movq $0x2, %rax		# Open file
	movq $f_path, %rdi
	movq $0x2, %rsi
	syscall

	pushq %rax		# -0x10(%rbp) : file descriptor

	movq $0x0, %rax		# Read from file descriptor
	movq -0x10(%rbp), %rdi
	movq $f_data, %rsi
	movq $f_data_len, %rdx
	syscall
	
	movq %rax, %r15
	addq $f_data, %rax	# Calculate address where f_data ends
	addq $0x8, %rax		# Add 8 to the previously calculated address
	pushq %rax		# -0x18(%rbp) : address where f_data ends
	pushq %r15		# -0x20(%rbp) : size of data
	movq -0x18(%rbp), %r12	# Store address where f_data ends, in r12

	movq -0x8(%rbp), %r13	# Store p_key in r13
	movq -0x20(%rbp), %r14	# Store size of data in r14
	xorq %r13, %r14		# XOR the two and store result in r13
	movq $0x1111111111111111, %r13 # Store random 8 bytes in r13
	xorq %r13, %r14		# XOR r13 and r14 to generate a XOR'd p_key, which should almost always be 8 bytes long

	push %r14		# -0x28(%rbp) : XOR'd p_key value
	movq $f_data, %rsp	# Stack pointer now points to f_data memory location

encodedata:
	movq (%rsp), %rax	# Move 8 bytes (of f_data) from memory into rax register
	movq -0x28(%rbp), %rbx	# Move 8 bytes (of p_key) from memory into rbx register
	xchgb %al, %ah		# Swap lower and higher bytes of ax register
	rorq $0x20, %rax	# Rotate rax register bits to the right by 32 bits
	xchgb %al, %ah		# Swap lower and higher bytes of ax register
	rorq $0x10, %rax	# Rotate rax register bits to the right by 16 bits
	xchgb %al, %ah		# Swap lower and higher bytes of ax register
	rorq $0x10, %rax	# Rotate rax register bits to the right by 16 bits
	xchgb %al, %ah		# Swap lower and higher bytes of ax register
	xorq %rax, %rbx		# Perform bitwise XOR between rax and rbx, store result in rbx
	movq %rbx, (%rsp)	# Overwrite 8 bytes (of f_data) that were read from memory earlier
	addq $0x8, %rsp		# Increment stackpointer register by 8
	cmp %r12, %rsp		# Compare rsp and r12 register values. Both contain memory addresses.
	jl encodedata		# If rsp is less that r12, jump to encodedata label (basically loop)			

	# The last 8 bytes of the data stores the XOR'd key. These next few instructions
	# further encrypt the key, so that it has to be decrypted before it can be used.
	# If it's not decrypted properly, none of the data will be decrypted properly.
	movq -0x8(%rbp), %rax		# p_key
	movq $0x2222222222222222, %rbx	# Random 8 bytes
	movq -0x8(%rsp), %rcx		# XOR'd p_key
	xchgb %ah, %al
	rorq $0xf, %rax
	xorq %rax, %rbx
	xorq %rbx, %rcx			# rcx now contains the encrypted XOR'd p_key
	movq %rcx, -8(%rsp)		

	# Calculating new length of data using start and end positions of data.
	movq $f_data, %rax	
	movq %rsp, %rbx
	subq %rax, %rbx
	movq %rbx, -0x30(%rbp)

	movq $0x8, %rax		# LSeek (to set the offset of the file descriptor to the beginning)
	movq -0x10(%rbp), %rdi
	movq $0x0, %rsi
	movq $0x0, %rdx
	syscall

	movq -0x30(%rbp), %r15	# Store data size in r15

	movq $0x1, %rax		# Write	to file descriptor
	movq -0x10(%rbp), %rdi
	movq $f_data, %rsi
	movq %r15, %rdx
	syscall

	movq $0x3, %rax		# Close file descriptor
	movq -0x10(%rbp), %rdi
	syscall


#####################################
	movq %rbp, %rsp
	popq %rbp

	movq $0x3C, %rax
	syscall

	.data
p_key_msg:
	.ascii "Enter 8 characters: "
p_key_msg_len = . - p_key_msg
p_key:	.space 1024			# Buffer to hold 8 character pass key	
p_key_len = . - p_key
f_path:	.ascii "./testtext02"		# Filename
f_data:	.space	4096			# Buffer to hold read/write data. Size is in bytes.
f_data_len = . - f_data
