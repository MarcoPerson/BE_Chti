	PRESERVE8
	THUMB   
	INCLUDE DriverJeuLaser.inc

; ====================== zone de réservation de données,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly


;Section RAM (read write):
	area    maram,data,readwrite

;char FlagCligno;
FlagCligno dcb 1
	
; ===============================================================================================

		
;Section ROM code (read only) :		
	area    moncode,code,readonly
; écrire le code ici		
	EXPORT timer_callback
	EXPORT FlagCligno

;void timer_callback(void)
timer_callback proc
	
	
	ldr r2,=FlagCligno
	ldr r0,[r2]
;	if (FlagCligno==1)
	cmp r0,#1
	
	bne Sinon
;	FlagCligno=0;
	mov r1, #0
	strb r1, [r2]
	mov r0, #1
;	GPIOB_Set(1);
	push {lr, r2}
	bl GPIOB_Set
	pop {lr, r2}
	b Fin
;	else
Sinon
;	FlagCligno=1;
	
	mov r1, #1
	strb r1, [r2]
	mov r0, #1
;	GPIOB_Clear(1);
	push {lr, r2}
	bl GPIOB_Clear
	pop {lr, r2}
Fin 	
	bx lr
	
;void timer_callback(void)
;{
;	if (FlagCligno==1)
;	{
;		FlagCligno=0;
;		GPIOB_Set(1);
;	}
;	else
;	{
;		FlagCligno=1;
;		GPIOB_Clear(1);
;	}
;		
;}


	endp
		
		
	END	
		
		ljkhgiuhoi