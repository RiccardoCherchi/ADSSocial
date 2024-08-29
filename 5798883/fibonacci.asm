.macro print_str(%x) # Macro per printare una stringa tramite la sua syscall
	li a7, 4
	la a0, %x
	ecall
.end_macro
	
.macro print_int(%x) # Macro per printare un intero tramite la sua syscall
	li a7, 1
	mv a0, %x
	ecall
.end_macro

.macro read_int(%x) # Macro per leggere un intero tramite la sua syscall e salvarne il risultato in %x
	li a7, 5
	ecall
	mv %x, a0
.end_macro
.data # Definisco le variabili nel semento data che usero successivamente
	req: .string "Enter the number of terms of series : "
	res: .string "\nFibonnaci Series : "
	space: .string " "
	new_line: .string "\n"

.text

main:
	li t1, 2 # inizializzo il valore per controllare il caso base di fib
	li t2, 0 # Inzializzo il valore i per il ciclo while
	print_str(req) # Stampo la stringa req
	read_int(t3) # Leggo l'intero da console
	print_str(res) # Stampo la stringa res
while:
	beq t3, t2, exit # Controllo se i ha raggiunto il valore desiderato e esco dal while (while i < x)
	mv a0, t2 # Carico l'argomento della funzione (i) fib in a0
	jal fib # Chiamo la funzione fib(x)
	mv s2, a0 # Salvo il risultato della funzione 
	print_str(space) # Stampo uno spazio per indentare la risposta
	print_int(s2) # Salvo il risultato della funzione
	addi t2, t2, 1 # Incremento il contatore i del while
	j while # Torno indietro e ripeto il ciclo fino a quando la condizione inziale non e' verificata
exit:
	li a7, 10 # Eseguo una syscall di uscita con valore di uscita 0 di default (return 0)
	ecall

fib:
	addi sp, sp, -8 # Alloco lo stack necessario per salvare due variabili di 4 byte
	sw ra, 4(sp) # Salvo il return address nello stack
	sw a0, 8(sp) # Salvo l'argomento a0 nello stack
test:
	blt a0, t1, base # controllo il caso base, nel caso che l'argomento (x) sia minore di 2 passo al caso base
passo:
	addi a0, a0, -1 # decremento l'argomento per la chiamata (x - 1)
	jal fib # chamo fib(x-1)
	lw a1, 8(sp) # Recupero l'argomento precedente
	sw a0, 8(sp) # Salvo l'argomento attuale
	addi a0, a1, -2 # Decremento l'argomento (x - 2)
	jal fib # Chiamo fib(x-2)
	lw a1, 8(sp) # Recupero il risultato di fib(x-1)
	lw ra, 4(sp) # Recupero il return address precedente
	add a0, a0, a1 # Eseguo la somma tra fib(x-1) e fib(x-2)

base:
	addi sp, sp, 8 # Dealloco lo stack aggiungendo la quantita di byte precedentemente allocata
	ret # Esco dalla funzione ritornando a0 come risultato di fib
