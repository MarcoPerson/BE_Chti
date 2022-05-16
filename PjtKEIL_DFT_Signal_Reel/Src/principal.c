

#include "DriverJeuLaser.h"

extern int DFT_ModuleAuCarre(short int * Signal64ech, char k);
extern short LeSignal;
short TabValeur[64];
int TabResult[64];
int i;
void callback(void){
	Start_DMA1(64);
	Wait_On_End_Of_DMA1();
	Stop_DMA1;
	
	for(int k = 0; k < 64; k++){
		TabResult[k] = DFT_ModuleAuCarre(TabValeur, k);
	}
}

int main(void)
{

// ===========================================================================
// ============= INIT PERIPH (faites qu'une seule fois)  =====================
// ===========================================================================

// Après exécution : le coeur CPU est clocké à 72MHz ainsi que tous les timers
CLOCK_Configure();
/* Le timer systick */
Systick_Period_ff(360000);
Systick_Prio_IT(2,callback );
SysTick_On ;
SysTick_Enable_IT ;
/* Configuration ADC */
Init_TimingADC_ActiveADC_ff( ADC1, 72 );
Single_Channel_ADC( ADC1, 2 );
/* Configuration timer 2 pour déclencher l'ADC */
Init_Conversion_On_Trig_Timer_ff( ADC1, TIM2_CC2, 225 );
/* Configuration DMA */
Init_ADC1_DMA1( 0, TabValeur );



//============================================================================	
	
	
while	(1)
	{
	}
}

