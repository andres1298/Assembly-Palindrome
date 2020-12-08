ORG 1000h
BIEN DB "INGRESE LA FRASE A ANALIZAR:"
FBIEN DB 0
PAL DB "LA FRASE ES UN PALINDROMO"
FPAL DB 0
NPAL DB "LA FRASE NO ES UN PALINDROMO"
FNPAL DB 0

ORG 1500h
FRASE DB "YO SOY"
FFRASE DB 0

ORG 1600h
INI DW 0
FIN DW 0
BAND DB 0

; DH ALMACENA EL CARACTER DE INICIO DEL ARREGLO
; DL ALMACENA EL CARACTER DEL FINAL DEL ARREGLO
ORG 2000h
INICIO: MOV BX, OFFSET FRASE ; Posicion inicial del arreglo
	MOV INI, BX
	MOV BX, OFFSET FFRASE - 1 ; Posicion final del arreglo
	MOV FIN, BX
	
CICLO: CALL ACTU ; Inicio del ciclo | Se llama la rutina ACTU, que modifica DH y DL
				 ; En DH esta el caracter inicial y en DL el caracter final

VALINI: CMP DH, 20h ; Se valida si el caracter inicial (DH) es un espacio
	JNZ VALFIN
	MOV BAND, 1h ; Si lo es, se levanta una bandera
	INC INI ; Se omite el caracter al incrementar la posicion de memoria en INI
	
	
VALFIN: CMP DL, 20h ; Se valida si el caracter final (DL) es un espacio
	JNZ COND
	MOV BAND, 1h ; Si lo es, se levanta una bandera
	DEC FIN ; Se omite el caracter al decrecer la posicion de memoria en FIN

COND: CMP BAND, 1h ; Se valida el valor de la bandera. Si es 1, se realiza otra actualizacion
	JNZ COMP ; De lo contrario se salta a la comparacion de los datos
	
INTE: CALL ACTU ; Actualizacion intermedia de datos
	MOV BAND, 0 ; La bandera se reinicia a 0
	
COMP: MOV AX, INI ; Inicia la comparacion de los caracteres inicial y final de la frase
	MOV CX, FIN
	CMP AX, CX ; Se comparan las posiciones de memoria
	JZ CORRE ;  Si son iguales, ya se valido toda la frase, por lo que es un palindromo
	CMP DH, DL ; Se comparan los caracteres
	JNZ INCOR ; Si son diferentes no es un palindromo
	
AUMEN: INC INI ; Se incrementa la posicion de memoria de INI
	DEC FIN ;  Se reduce la posicion de memoria de FIN
	JMP CICLO ; Salto para ejecutar nuevamente las instrucciones

ACTU: MOV BX, INI
	MOV DH, [BX]
	MOV BX, FIN
	MOV DL, [BX]
	RET
	
CORRE: MOV BX, OFFSET PAL ; SE IMPRIME EL MENSAJE DE CORRECTO
	MOV AL, OFFSET FPAL - OFFSET PAL
	INT 7
	JMP FINAL
	
INCOR: MOV BX, OFFSET NPAL ; SE IMPRIME EL MENSAJE DE INCORRECTO
	MOV AL, OFFSET FNPAL - OFFSET NPAL
	INT 7
	JMP FINAL
	
FINAL: HLT
END