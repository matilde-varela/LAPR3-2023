.section .data

.section .text
	
	.global enqueue_value
	
enqueue_value:
    movl (%rcx), %r9d
    movl %r8d, (%rdi,%r9,4)
    movl (%rdx), %r8d

	subl $1, %esi

	call checkWrite
	pushq %r9
	call checkRead
	popq %r9
	
	movl %r8d, (%rdx)
	movl %r9d, (%rcx)
	
	ret
	
checkRead: 
	cmpl %r8d, %r9d
	je secondCheck
	
	addl $1, %r9d
	cmpl %r8d, %r9d
	je secondCheck
	subl $1, %r9d
	
	cmpl $2, %r9d 
	je secondCheck
	ret
	
secondCheck:
	cmpl %r8d, %esi 
	jle resetRead
	addl $1, %r8d
	ret
	
resetRead:
	movl $0, %r8d
	ret
	
checkWrite:
	cmpl %r9d, %esi
	jle resetWrite
	addl $1, %r9d
	ret
	
resetWrite:	
	movl $0, %r9d
	ret
