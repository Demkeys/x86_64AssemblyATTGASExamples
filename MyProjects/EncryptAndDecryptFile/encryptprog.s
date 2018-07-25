	.globl	_start
	.text
_start:
	pushq %rbp
	movq %rsp, %rbp
#####################################
	movq $0x1, %rax		# Write, asking user for 8 characters. Only 8 bytes will be used, rest will be ignored.	
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
	subq $0x8, %rax
	pushq %rax		# -0x18(%rbp) : address where f_data ends
	pushq %r15		# -0x20(%rbp) : size of data
	movq -0x18(%rbp), %r12

	# Decrypt last 8 bytes of file to get XOR'd p_key. If supplied p_key is wrong
	# the correct XOR'd p_key won't be revealed. The correct XOR'd p_key is required
	# in order to correctly decrypt all of the data.
	movq (%rax), %rbx	# Store last 8 bytes of file in %rbx
	movq -0x8(%rbp), %rax   # Store user supplied p_key in %rax
	movq $0x2222222222222222, %rcx	# Random 8 bytes in %rcx
	xchgb %al, %ah
	rorq $0xf, %rax
	xorq %rax, %rcx
	xorq %rcx, %rbx		# XOR'd p_key revealed, if supplied p_key is correct


	pushq %rbx		# -0x28(%rbp) : XOR'd p_key
	movq $f_data, %rsp	# Stack pointer now points to f_data memory location

decodedata:
	movq (%rsp), %rax	# Move 8 bytes (of f_data) from memory into rax register				
	movq -0x28(%rbp), %rbx	# Move 8 bytes (of p_key) from memory into rbx register
	xorq %rbx, %rax		# Perform bitwise XOR on rbx and rax, store result in rax
	xchgb %al, %ah		# Swap lower and higher bytes of ax register
	rolq $0x10, %rax	# Rotate rax register bits to the left by 16 bits
	xchgb %al, %ah		# Swap lower and higher bytes of ax register
	rolq $0x10, %rax        # Rotate rax register bits to the left by 16 bits
	xchgb %al, %ah		# Swap lower and higher bytes of ax register
	rolq $0x20, %rax        # Rotate rax register bits to the left by 32 bits
	xchgb %al, %ah		# Swap lower and higher bytes of ax register
	movq %rax, (%rsp)	# Overwrite 8 bytes (of f_data) that were read from memory earlier
	addq $0x8, %rsp		# Increment stackpointer register by 8
	cmp %r12, %rsp		# Compare rsp and r12 register values. Both contain memory addresses.
	jl decodedata		# If rsp is less than r12, jump to decodedata label (basically loop)

	movq -0x28(%rbp), %rax
	movq $0x1111111111111111, %rbx
	movq -0x8(%rbp), %rcx
	xorq %rax, %rbx
	xorq %rbx, %rcx
	movq %rcx, -0x28(%rbp)

	movq $0x8, %rax		#LSeek (to set the offset of the file descriptor to the beginning)
	movq -0x10(%rbp), %rdi
	movq $0x0, %rsi
	movq $0x0, %rdx
	syscall

	movq $0x4d, %rax	# FTruncate (to change the size of the file to the original size)
	movq -0x10(%rbp), %rdi
	movq -0x28(%rbp), %rsi
	syscall

	movq $0x1, %rax		# Write	to file descriptor
	movq -0x10(%rbp), %rdi
	movq $f_data, %rsi
	movq -0x28(%rbp), %rdx
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
f_data:	.space	4096			# Buffer to hold read/write data
f_data_len = . - f_data
