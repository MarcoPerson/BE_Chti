	PRESERVE8
	THUMB   
	INCLUDE DriverJeuLaser.inc

; ====================== zone de réservation de données,  ======================================
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
; écrire le code ici		
	EXPORT CallbackSon
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
;saute si superieur
	bgt Fin
	
	ldr r6,= SortieSon
;Rx = son[indice]
	ldrsh r4, [r0, r2, lsl #1]
;	SortieSon = ramenerALaPlageValeur(SortieSon)
	mov r5, #720
	mul r4, r5
	asr r4, #16
	add r4, #360
	strh r4, [r6]
;	Index += 1
	add r2, #1
	str r2, [r1]
;	Sortir si fin Tableau si Index = longueurSon(taille du tableau)
Fin
	pop {r4-r7}
	bx lr
	endp



	
	END	