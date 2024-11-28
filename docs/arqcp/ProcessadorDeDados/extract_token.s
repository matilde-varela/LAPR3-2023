.section .data
	
.section .text

.global extract_token	 # int extract_token(char* input, char* token, int* output);
extract_token:
# *input -> rdi
# *token -> rsi
# *output -> rdx

movl $0, %r10d
movl $0, %r11d
movl $0,%r9d
movl $0,%r8d

movb (%rsi, %r11, 1), %r9b	# token char

loop:
	movb (%rdi, %r10, 1), %r8b	# input char

	cmpb $0, %r8b		#se a string terminar, entao termina-se a execução da função
	je done

	cmpb %r8b, %r9b		#compara os caracteres em ambos os registos, se forem iguais avalia se se segue o token esperado
	je checkToken

	increments:
		incl %r10d
		jmp loop

checkToken:
	cmpb $0, %r9b
	je getTokenInfo		# se nao saiu do loop entao quer dizer que todos os caracteres até ao fim do token são iguais

	cmpb %r9b, %r8b		# compara se os caracteres sao sao iguais, se nao forem sai do loop
	jne notToken

	incl %r10d					# incrementa o apontador do input
	incl %r11d					# incrementa o apontador do token
	movb (%rdi, %r10, 1), %r8b	# aloca o novo caracter apontado no input em r8
	movb (%rsi, %r11, 1), %r9b	# aloca o novo caracter apontado no token em r9
	jmp checkToken


getTokenInfo:
movq $0, %r9
movl $0, %eax

	retrieveValueLoop:

		cmpb $0, %r8b
		je end
		
		cmpb $'#', %r8b		#inicio de um novo token - fim do atual
		je end

		cmpb $'.', %r8b
		je valueIncrements	# se o numero tiver casas decimais ignora e adiciona o resto dos digitos

		cmpb $':', %r8b		# ignorar simbolos e letras
		jge done

		imull $10, %eax		# multiplica por 10 o numero atual para inserir no output
		movzbl %r8b, %r9d	# conversao de bit para double word -> char para int
		subl $'0', %r9d		# subtração do valor ASCII de 0 para o codigo representar o numero que se espera
		addl %r9d, %eax		# adiciona-se o novo numero, ao output

		valueIncrements:
			incl %r10d
			movb (%rdi, %r10, 1), %r8b
			jmp retrieveValueLoop

notToken:
	movl $0, %r11d
	movb (%rsi, %r11, 1), %r9b		# faz-se reset do apontador do token
	jmp increments

end:
	cmpl $0, %eax
	je done
	movl %eax, (%rdx)
	movl $1, %eax

done:
	ret
