	PRESERVE8
	THUMB   
	INCLUDE DriverJeuLaser.inc

; ====================== zone de r�servation de donn�es,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly


;Section RAM (read write):
	area    maram,data,readwrite
		
SortieSon dcw 0
;Index = 0 
Index dcd 0
	
; ===============================================================================================
	


		
;Section ROM code (read only) :		
	area    moncode,code,readonly
; �crire le code ici		
	EXPORT CallbackSon
	EXPORT StartSon
	EXPORT SortieSon
	IMPORT Son
	IMPORT LongueurSon
	export Index

;	void CallbackSon (void)
CallbackSon proc
;	Adresse = adresse du premier echantillon
	push {r4-r7}
	ldr r0,= Son
	ldr r1,= Index
	ldr r2, [r1]
;If index <=longueurSon
	ldr r3,=LongueurSon
	ldrh r7, [r3]
	cmp r2, r7
;saute si superieur ou egal
	bge call
	
	ldr r6,= SortieSon
;Rx = son[indice]
	ldrsh r4, [r0, r2, lsl #1]
;	SortieSon = ramenerALaPlageValeur(SortieSon)
	mov r5, #720
	mul r4, r5
	asr r4, #16
	add r4, #360
	strh r4, [r6]
	mov r0, r4
	push {lr, r2, r1}
	bl PWM_Set_Value_TIM3_Ch3
	pop {lr, r2, r1}
;	Index += 1
	add r2, #1
	str r2, [r1]
	b Fin
;	Sortir si fin Tableau si Index = longueurSon(taille du tableau)
call
	push {lr}
	bl StartSon
	pop {lr}
Fin
	pop {r4-r7}
	bx lr
	endp

StartSon proc
	ldr r1 ,= Index
	mov r2, #0
	str r2, [r1]
	bx lr

	endp
	
	END	