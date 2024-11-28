.section .data 
	
.section .text
	.global sort_array

sort_array:
	movq $0, %rcx
	movl (%rdi,%rcx,4), %r8d
	
outer_loop:
	cmpq %rsi, %rcx
	je end
	
	movq %rcx, %rdx
	addq $1, %rdx
	
	jmp inner_loop
	
inner_loop:
	cmpq %rsi, %rdx
	je increment_outer
	
	movl (%rdi, %rdx, 4),%r9d
	
	cmpl %r8d, %r9d
	jl swap_elements
		jmp increment_inner
		
swap_elements:
	movl %r8d, %r10d
	movl %r9d, %r8d
	movl %r10d,%r9d
	movl %r9d, (%rdi, %rdx, 4)
	jmp increment_inner
	
increment_inner:
	addq $1, %rdx
	jmp inner_loop
	
increment_outer:
	movl %r8d, (%rdi, %rcx, 4)
	addq $1, %rcx
	movl (%rdi, %rcx, 4), %r8d
	jmp outer_loop
	
end:
	ret
