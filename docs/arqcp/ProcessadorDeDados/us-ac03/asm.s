.section .data 
	
.section .text
	.global move_num_vec # int move_num_vec(int* array, int length, int* read, int* write, int num, int* vec)
	
	# %rdi -> *array
	# %rsi -> length 
	# %rdx -> *read
	# %rcx -> *write
	# %r8 -> num
	# %r9 -> *vec
	
	# r10 -> read
	# r11 -> write
		
move_num_vec:   
    cmpl %esi, %r8d					#Compara os valores do num com o valor do length
    jg not_enough_elements

    movl (%rdx), %r10d          	#Copia o valor de %rdx (read) para o %r10
    movl (%rcx), %r11d          	#Copia o valor de %rcx (write) para o %r11
    
    cmpl %r10d, %esi				#Compara o valor de %esi (length) com o valor de %r11d (read)
    jle not_enough_elements
    
    cmpl %r11d, %esi				#Compara o valor de %esi (length) com o valor de %r11d (write)
    jle not_enough_elements
    
    
check_pointers:
   	cmpl %r11d, %r10d
    je not_enough_elements
    
	movl %esi, %eax					#Coloca o valor de %esi (length) em %eax
    subl %r10d, %eax				#Subtrai o valor de %r10d (read) ao valor de %eax
    addl %r11d, %eax				#Adiciona o valor de %r11d (write) ao valor de %eax
    cmpl %r8d, %eax					#Compara o valor de %eax (resultado) com o valor de %r8d
    jl not_enough_elements

    mov %r8d, %ecx               	#Copia o valor de %r8d (num) para %ecx


copy_loop:
	cmpl $0, %ecx					#Compara 0 com o valor de %ecx
	je copy_complete
	
	cmpl %r10d, %esi				#Compara o valor de read com o length
	jle resart_read
	
	pushq %rdx						#Salvaguarda o valor de %rdx
    leaq (%rdi, %r10, 4), %rdx		#Coloca o endereço do buffer que se encontra na posição indicada pelo valor de %r10
    movl (%rdx), %eax           	#Coloca o valor do buffer em %eax
    movl %eax, (%r9)				#Coloca o valor do buffer no novo array
    popq %rdx						#Restaura o valor de %rdx
    addl $1, (%rdx)					#Incrementa o valor apontado por %rdx
    
    incl %r10d						#Incrementa o valor de %r10d
    addq $4, %r9					#Incrementa o %r9 (apontador do nov array)	
    decl %ecx                   	#Decrementa o valor de %ecx (contador do loop)
    jmp copy_loop               	#Continua o loop até o valor de %ecx ser 0                     	
	
resart_read:
	movl $0, %r10d					#Coloca 0 em %r10d (read)
	movl $0, (%rdx)					#Coloca 0 no valor apontado por %rdx (read)
	jmp copy_loop
    
copy_complete:
	mov $1, %eax                 	#Coloca 1 em %eax
    jmp end  
		
not_enough_elements:
	movl $0, %eax             		#Coloca 0 em %eax

end:
	ret 

