
;---------Reloj de la Tiva--------------------------------
SYSCTL_RCGCGPIO_R 	   EQU 0x400FE608
;---------Modo Analógico----------------------------------
GPIO_PORTB_AMSEL_R     EQU 0x40005528;
;---------Permite desactivarFuncion Alternativa-----------
GPIO_PORTB_PCTL_R      EQU 0x4000552C;
;---------Especificación de dirección---------------------
GPIO_PORTB_DIR_R      EQU  0x40005400;
;---------Funciones Alternativas--------------------------
GPIO_PORTB_AFSEL_R    EQU  0x40005420;
;---------Habilita el modo digital------------------------
GPIO_PORTB_DEN_R      EQU   0x4000551C;
	
	
	
;---------Puerto B-----------------------------------------
PB                EQU 0x400053FC; Esta suma se realiza en hexadecimal.
	
	
	
;---------Constante PCTL----------------------------------	
PCTL				  EQU 2_11111111; Como se utilizarán todos los pines.
	
	
	
Cont				  EQU 1000000; Valor del contrador

		AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT  Start


Start
	BL Conf; Salto, guarda la dirección posterior en el Registro 14
	B  PuertoBActivo ; Salto
	

Conf

;---------Reloj para el puerto B-------------------------
	LDR R1, =SYSCTL_RCGCGPIO_R; Asignación de valores de constante a un registro.
	LDR R0, [R1]
	ORR R0, R0, #0x02 ; Valor para activar el reloj del puerto B.
	STR R0, [R1]
	NOP
	NOP
	
	
	
;--------Desactiva la función analógica------------------
	LDR R1, =GPIO_PORTB_AMSEL_R;
	LDR R0, [R1]
	BIC R0, R0, #0xFF; Valor segun el numero del puerto.
	STR R0, [R1]
;--------Permite deshabilitar las funciones alternativas-
	LDR R1, =GPIO_PORTB_PCTL_R 
	LDR R0, [R1]
	LDR R2, =PCTL
	LDR R3,[R2]
	BIC R0, R0, R3;  Configura el puerto como GPIO. 
	STR R0, [R1]
;--------Configuración como I/O--------------------------
	LDR R1, =GPIO_PORTB_DIR_R 
	LDR R0, [R1]
	ORR R0, R0, #0xFF;  Output. Valor segun el numero del puerto.
	STR R0, [R1]
;--------Deshabilita las funciones alternativas----------	
	LDR R1, =GPIO_PORTB_AFSEL_R 
	LDR R0, [R1]
	BIC R0, R0, #0xFF;  Desabilita las demas funciones. 
	STR R0, [R1]
;--------Habilita el puerto como entrada y salida digital-
	LDR R1, =GPIO_PORTB_DEN_R       
    LDR R0, [R1]                    
    ORR	 R0,#0xFF;		Activa el puerto digital.    
    STR R0, [R1]   
;--------Salto, regresa a la linea posterior al salto BL---
	BX LR



;--------Contador de iteraciones---------------------------

Contador
	SUB R10, #1 ; Resta
	CMP R10, #0 ; Comparación
	BNE Contador ; Condición No igual
	BX LR
	
		
;--------Activar PB1 ----------------------------------
PuertoBActivo
	LDR R1, =PB
	MOV R0, #0xFF; Encender el bit.
	STR R0, [R1];
	LDR R10, =Cont
	BL Contador
	
PuertoBInactivo
	LDR R1, =PB
	MOV R0, #0x00; Encender el bit.
	STR R0, [R1];
	LDR R10, =Cont
	BL Contador
	B PuertoBActivo
	

	ALIGN
	END


