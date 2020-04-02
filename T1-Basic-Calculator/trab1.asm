.data
menuInicial:  .asciiz "\nDigite sua opção(C -> Calculadora | M -> memória):  " 
strCalculadora: .asciiz "\nVocê está na calculadora ! \nDigite alguma das opções (+ -> SOMA | - -> subtração | / -> DIVISAO | * -> MULTIPLICAÇÃO | R -> Raiz | P -> Potenciação  | T -> TABUADA | F -> FATORIAL |  I -> FIBONACCI): " 

#opções da calculadora
strAdicao:  .asciiz "\nEstá é uma operação de soma !"
strSubtracao:  .asciiz "\nEstá é uma operação de subtração !"
strMultiplicacao: .asciiz "\nEstá é uma operação de multiplicação !"
strDivisao:  .asciiz "\nEstá é uma operação de divisao !"
strRaiz: .asciiz "\n Está é uma operação de Raiz: "
strPotencia:  .asciiz "\nEstá é uma operação de potencia !"
strFat: .asciiz "\n Está é uma operação de Fatorial: "
strTab: .asciiz "\n Está é uma operação de Tabuada: "

# Digite o primeiro/segundo numero
strN1: .asciiz "\nDigite o primeiro numero: "
strN2: .asciiz "Digite o segundo numero: "

# mensagens de erro
strErrorDiv: .asciiz "Não pode dividir por 0 !" #erro na divisão
strErrorRaiz: .asciiz "Raiz de número negativo não existe ! Tente de Novo !"  #erro na raiz
strErrorFatorial: .asciiz "Fatorial de número negativo não existe ! Tente de Novo !"  #erro fatorial

strResultado: .asciiz "O resultado: "
strMenu2: .asciiz "\nEscolha uma das três memórias: "
strShowM: .asciiz "\nMemória "
strE: .asciiz " é: "


strFibo: .asciiz "\n Está é uma operação de Fibonacci: "

msg: .asciiz " "
msgTb1: .asciiz " * "
msgTb2: .asciiz " = "
msgTb3: .asciiz "\n"


strM1: .asciiz "\n Salvando operação na menória 1 (s1)"
strM2: .asciiz "\n Salvando operação na menória 2 (s2)"
strM3: .asciiz "\n Salvando operação na menória 3 (s3)"

n0: .float 0.0
n1: .float 1.0
n11: .float 11.0
n1Negativo: .float -1.0

.text
.globl main

main:
 	# variáveis para o switch da memória
 	li $t5, 1
	li $t6, 0
	li $t7, 0
	
	lwc1 $f5, n11
	lwc1 $f6, n0
	lwc1 $f7, n0
	
 	# MENU inicial #################################################
 	MENU_INICIAL:
 	la $a0, menuInicial #Digite sua opção (C -> Calculadora | M -> memória): 
 	jal printStr #printa a string em A0
 	jal leitura1char #retorna o char lido em t1
 	beq $t1, 'M', ifMenu2
 	beq $t1, 'C', ifMenu1

 	j FIM
 	

#Podemos comparar o valor de $v0 com algum caracter
ifMenu2:
	la $a0, strMenu2 # print opção escolhida
 	jal printStr
 	jal leitura1char #retorna o char lido em t1
	
	beq $t1, '1', showM1
	beq $t1, '2', showM2
	beq $t1, '3', showM3

	j FIM
	
ifMenu1:
	la $a0, strCalculadora # "Você está na calculadora -> Digite a opção"
 	jal printStr 
 	jal leitura1char #retorna o char lido em t1

	#opções calculadora
	beq $t1, '+', ADICAO 
	beq $t1, '-', SUBTRACAO
	beq $t1, '/', DIVISAO
	beq $t1, '*', MUTIPLICACAO
	beq $t1, 'R', RAIZ
	beq $t1, 'P', POTENCIA
	beq $t1, 'F', FATORIAL
	beq $t1, 'T', TABUADA
	beq $t1, 'I', FIBONACCI
	beq $t1, 'X', FIM
	beq $t1, 'V', MENU_INICIAL
	
	
	#termina o programa caso o usuário não escolha uma opção correta
	j FIM
	
ifMemoria:
	beq $t5, 1, saveM1
	beq $t6, 1, saveM2
	beq $t7, 1, saveM3
	j FIM
	
saveM1:

	la $a0, strM1 # Print Salvando m1
 	jal printStr 
 	
	mov.s $f5, $f3
	
	li $t5, 0
	li $t6, 1
	li $t7, 0
 	 
		
	j MENU_INICIAL
	
showM1:
	la $a0, strShowM  #memoria
 	jal printStr
 	  
 	move $a0, $t1  #n memoria
 	jal printChar
 	
 	la $a0, strE  #é
 	jal printStr

	mov.s $f3, $f5
	jal printFloat

	j MENU_INICIAL
	
showM2:
	la $a0, strShowM  #memoria
 	jal printStr
 	
 	move $a0, $t1 #n memoria
 	jal printChar
 	
 	la $a0, strE  #é
 	jal printStr
	
	
	mov.s $f3, $f6
	jal printFloat

	j MENU_INICIAL
	
showM3:
	
	la $a0, strShowM  #memoria
 	jal printStr
 	
 	move $a0, $t1 #n memoria
 	jal printChar
 	
 	la $a0, strE  #é
 	jal printStr
	
	mov.s $f3, $f7
	jal printFloat

	j MENU_INICIAL
	
saveM2:

	la $a0, strM2 # Print Salvando m2
 	jal printStr 
 	
	mov.s $f6, $f3
	li $t5, 0
	li $t6, 0
	li $t7, 1
 	 
	
	j MENU_INICIAL
	
saveM3:

	la $a0, strM3 # Print Salvando m3
 	jal printStr 
 	
	mov.s $f7, $f3
	li $t5, 1
	li $t6, 0
	li $t7, 0
	
	j MENU_INICIAL
	
	

#faz a operação de soma e devolve o resultado em F3
ADICAO: 
	la $a0, strAdicao # Está é uma operação de soma
	jal printStr # print	
	
	
	la $a0, strN1 	# digite o primeiro num
	jal printStr
	jal leituraFloat 	#leitura primeiro num (FO)
	mov.s $f1, $f0		 # F0 -> F1
	
	la $a0, strN2
	jal printStr
	jal leituraFloat #leitura segundo num
	mov.s $f2, $f0 # F2 -> F0
	
	
	#operação de soma
	add.s $f3, $f1, $f2
	
	la $a0, strResultado #O resultado é:
	jal printStr
	
	
	jal printFloat # print do que está em f3
	jal ifMemoria
	
			
#faz a operação de subtração e devolve o resultado em F3	
SUBTRACAO: 
	la $a0, strSubtracao # Esta é uma operação de subtração
	jal printStr # print	
	
	
	la $a0, strN1 #digite o primeiro num
	jal printStr
	jal leituraFloat #leitura primeiro num
	mov.s $f1, $f0 
	
	
	la $a0, strN2 #digite o segundo num
	jal printStr
	jal leituraFloat #leitura segundo num
	mov.s $f2, $f0
	
	#opração de subtração
	sub.s $f3, $f1, $f2
	
	la $a0, strResultado #O resultado é 
	jal printStr
	jal printFloat
	
	jal ifMemoria

#faz a operação de multiplicação e devolve o resultado em F3
MUTIPLICACAO:
	la $a0, strMultiplicacao # Esta é uma operação de multiplicação
	jal printStr # print
	
	la $a0, strN1 #Digite o primeiro num
	jal printStr
	jal leituraFloat #leitura primeiro num
	mov.s $f1, $f0
	
	la $a0, strN2 #Digite o primeiro num
	jal printStr
	jal leituraFloat #leitura segundo num
	mov.s $f2, $f0
		
	#op de multiplicação
	mul.s $f3, $f1, $f2
	
	la $a0, strResultado #O resultado é
	jal printStr
	jal printFloat
	
	jal ifMemoria

#faz a operação de divisão e devolve o resultado em F3	
DIVISAO: 
	la $a0, strDivisao # operação de divisão
	jal printStr # print	
	
	
	la $a0, strN1 # Digite o primeiro numero
	jal printStr
	jal leituraFloat #leitura primeiro num
	mov.s $f1, $f0
	
	la $a0, strN2 # Digite o segundo numero
	jal printStr
	jal leituraFloat # leitura segundo num
	mov.s $f2, $f0
	
	lwc1 $f8, n0 # carrega 0 em f8
	c.eq.s $f2, $f8 # verifica se o divisor é zero
	bc1t  errorDiv # caso 0, pula para o erro
	
	# operação de divisao
	div.s $f3, $f1, $f2
	
	
	la $a0, strResultado # o resultado é
	jal printStr
	jal printFloat
	
	jal ifMemoria
	
# caso 0, erro na divisão	
errorDiv:
	la $a0, strErrorDiv
	jal printStr
	j DIVISAO #volta para operação de divisão
	
#faz a operação de raiz e devolve o resultado em F3		
RAIZ: 
	la $a0, strRaiz # operação de raiz
	jal printStr # print	
	
	la $a0, strN1 # Digite o primeiro numero
	jal printStr
	jal leituraFloat #leitura primeiro num
	mov.s $f1, $f0
	
	lwc1 $f8, n0 # carrega 0 no f10
	c.lt.s $f1, $f8 #if (F1 < 0)
	bc1t  errorRaiz # caso < 0, pula para o erro
	
	#operação de raiz
	sqrt.s $f3, $f1	
	
	la $a0, strResultado # o resultado é
	jal printStr
	jal printFloat
	
	jal ifMemoria
	
# caso < 0, erro na raiz	
errorRaiz:
	la $a0, strErrorRaiz
	jal printStr
	j ifMenu1

#faz a operação de potencia e devolve o resultado em F3
POTENCIA: 
	la $a0, strPotencia #Operação de Potencia
	jal printStr # print	
	
	
	la $a0, strN1 # Digite o primeiro numero
	jal printStr
	jal leituraFloat #leitura primeiro num
	mov.s $f1, $f0
	
	
	la $a0, strN2 # Digite o segundo numero
	jal printStr
	jal leituraFloat # leitura segundo num
	mov.s $f2, $f0
	
	
	######### OPERAÇÃO DE POTENCIA #####
	
	lwc1 $f10, n0	#setando flag expoente negativo false
	
	lwc1 $f3, n1 	#f3 registrador de resultado
	lwc1 $f7, n1
	lwc1 $f8, n0
	
	
	c.lt.s  $f2, $f8	# verifica se o expoente <=  0
	bc1f loop_potencia	# significa que o numero é > 0
	
	c.eq.s  $f2, $f8	# verifica se o expoente é  == 0 caso n^0
	bc1t  fimPotencia
	
	
	c.lt.s  $f2, $f8	# verifica se o expoente é < 0
	bc1t  flagExpNegativo
	
	flagExpNegativo:
		lwc1 $f10, n1Negativo				 
		mul.s $f2, $f10, $f2 		#f2  = f2 * -1
		lwc1 $f10, n1 			#setando flag expoente negativo true

		loop_potencia:
			# multiplicacao	
			mul.s $f3, $f3, $f1 #f3 -> F3(resultado) * F1 (primeiro input)
			
			sub.s $f2, $f2, $f7 #f2 ->  f2--;
		
			#Se t2 não for 0
			c.eq.s $f2, $f8	
			bc1f loop_potencia

	fimPotencia:
		
		#f2 sempre é zero ****
		
		c.eq.s  $f10, $f2 		### verificando se a flag é false 
		bc1t  resultadoPotencia
		
		lwc1 $f2, n1	
		div.s $f3,$f2,$f3
		
	resultadoPotencia:
		
		la $a0, strResultado # resultado potencia
		jal printStr
		jal printFloat
		
	jal ifMemoria
	
#faz a operação de fatorial e devolve o resultado em F3		
FATORIAL:
	la $a0, strFat # operação de fatorial
	jal printStr # print	
	
	
	la $a0, strN1 # Digite o primeiro numero
	jal printStr
	jal leituraFloat #leitura primeiro num
	mov.s $f1, $f0
	
	#OPERAÇÃO DE FATORIAl
	
	lwc1 $f2, n0
	
	c.eq.s $f1, $f2 #compara se a entrada é  (f1 != 0)
	bc1f fatorialDiferenteDe0
	lwc1 $f1, n1 # fatorial == 1

fatorialDiferenteDe0:
	c.lt.s $f1, $f2 #compara se a entrada < 0 
	bc1t erroFat

	lwc1 $f10, n1
	mov.s $f3, $f1
	mov.s $f2, $f1
	
	
	c.eq.s $f1, $f10 #compara se a entrada é um
	bc1t respFatorial
	
	
		loop:
			sub.s $f2, $f2, $f10
			mul.s $f3, $f3, $f2
				
			c.eq.s $f2, $f10 #compara se o f2 é um
			bc1f loop
	
	
	respFatorial:
		
	la $a0, strResultado # o Resultado é
	jal printStr
	jal printFloat
		
	jal ifMemoria	
	
# caso < 0, erro o fatorial
erroFat:
	la $a0, strErrorFatorial
	jal printStr
	j ifMenu1
	
TABUADA:
	la $a0, strTab # operação de tabuada
	jal printStr # print	
	
	
	la $a0, strN1 # Digite o primeiro numero
	jal printStr
	jal leituraFloat #leitura primeiro num
	mov.s $f1, $f0
	
	lwc1 $f10, n1
	lwc1 $f2, n0
	lwc1 $f11, n11
	
	loop_tab:
		mul.s $f3, $f2, $f1
		
		# Bloco para impressão de um float
		mov.s $f12, $f3
		mov.s $f3, $f1
		jal printFloat
	
		mov.s $f3, $f12
		
		# Bloco para imprissão de uma string
		la $a0,msgTb1
		jal printStr
		
		# Bloco para impressão de um float
		
		mov.s $f3, $f2
		jal printFloat
		
		mov.s $f3 $f12
		
		# Bloco para imprissão de uma string
		la $a0,msgTb2
		jal printStr
	
		# Bloco para impressão de um float
		jal printFloat
		
		# Bloco para imprissão de uma string
		la $a0,msgTb3
		jal printStr
		
		add.s $f2, $f2, $f10

		c.eq.s $f2, $f11
		bc1f loop_tab
		
	jal ifMemoria

FIBONACCI:
	li $v0, 4
		la $a0, strFibo
		syscall
		
		li $v0, 4
		la $a0, strN1
		syscall
	
		li $v0, 5# Pede p/ ler inteiro
		syscall  # chama para ler
		
		la  $t1, 0($v0)  # carrega o inteiro lido em $t1

		li $v0, 4
		la $a0, strN2
		syscall
	
		li $v0, 5# Pede p/ ler inteiro
		syscall  # chama para ler
		
		la  $t2, 0($v0)  # carrega o inteiro lido em $t2
		
		#int fib0 = 0;
		li $t3, 0
		
		#int fib1 = 1; 
		li $t4, 1
		
		#int aux = 0; 
		li $a1, 0
		
		fibo_loop:
		blt $t2, $t4, fim_fibonacci # se b > fib0 o laço acaba
	
		la $a1, ($t4)     # aux = fib1
		add $t4, $t4, $t3 # fib1 = fib1 + fib0
		la $t3, ($a1)     # fib0 = aux
	
		bge $t3, $t1, if 
	
		j fibo_loop # jump back to the top

		if:
			#imprime fib0
			li $v0, 1	# código para imprimir um inteiro
			la $a0, ($t3)	# avisa para imprimir
			syscall		# executa a chamado do SO para imprimir
			li $v0, 4
			la $a0, msg
			syscall
			j fibo_loop # Volta ao topo
			
fim_fibonacci:	
	jal convert_int_float
	jal ifMemoria	
	

convert_int_float:	
	sw   $t3, -88($fp)
	lwc1 $f3, -88($fp)
	cvt.s.w $f3, $f3
	

leitura1char:
	li $v0, 12 # 8 -> leitura de caracter syscall
 	syscall
 	move $t1, $v0 #move de volta o char para A0
 	jr $ra 
 
#leitura de float no $F0
leituraFloat:
	li $v0, 6
 	syscall
 	jr $ra 
 	
 #print do que tem no registrador $F3	
printFloat:
	mov.s $f12, $f3
	li $v0, 2
	syscall 
	jr $ra	
 
 #print do que tem no registrador $a0	
printStr:
	li $v0, 4 
	syscall 
	jr $ra
	
 #print do que tem no registrador $a0	
printChar:
	li $v0, 11 
	syscall 
	jr $ra
	
	
#A0 -> t2
save$t2$a0:
	move $t2, $a0   
	jr $ra
	
	
# t2 -> a0	
save$a0$t2:
	move $a0, $t2   
	jr $ra
	
FIM:
	li $v0, 10
	syscall
	
	
