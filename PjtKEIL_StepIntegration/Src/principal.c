

#include "DriverJeuLaser.h"
#include "GestionSon.h"
#include "Affichage_Valise.h"
#include <stdlib.h>

extern int DFT_ModuleAuCarre(short int * Signal64ech, char k);
extern short LeSignal;
short TabValeur[64];
int TabResult[64];
int i;
int Score[4]={0, 0, 0, 0};
int EstCompter[4]={0};
int Maj=0 ;

void CallbackStick (void){
	Start_DMA1(64);
	Wait_On_End_Of_DMA1();
	Stop_DMA1;
	
	for(int k = 0; k < 64; k++){
		TabResult[k] = DFT_ModuleAuCarre(TabValeur, k);
	}
	
	for(int j = 0; j < 4; j++){
		if ((TabResult[j+17]>0x9999A) && (EstCompter[j]==0)) {
			StartSon();
			Score[j]++;
			Prepare_Afficheur(j+1,Score[j]);
			EstCompter[j]++;
			Maj=1;
		}else if ((TabResult[j+17]<0x9999A) && (EstCompter[j]==1)) {
			EstCompter[j]=0;
		}
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
Systick_Prio_IT(9,CallbackStick );
SysTick_On ;
SysTick_Enable_IT ;
/* Configuration ADC */
Init_TimingADC_ActiveADC_ff( ADC1, 72 );
Single_Channel_ADC( ADC1, 2 );
/* Configuration timer 2 pour déclencher l'ADC */
Init_Conversion_On_Trig_Timer_ff( ADC1, TIM2_CC2, 225 );
/* Configuration DMA */
Init_ADC1_DMA1( 0, TabValeur );
/* Configuration SON */
	
Timer_1234_Init_ff(TIM4, 6552);
Active_IT_Debordement_Timer(TIM4, 1, CallbackSon);
PWM_Init_ff(TIM3,3,720);
GPIO_Configure(GPIOB, 0, OUTPUT, ALT_PPULL);

/* Configuration Aff */
Init_Affichage();

/*Config Premiere Affichage*/
int numLed = 0;
Prepare_Set_LED(numLed);
Choix_Capteur(numLed+1);
Mise_A_Jour_Afficheurs_LED();


//============================================================================	
	
	
while	(1)
	{
		if (Maj) {
			Prepare_Clear_LED(numLed);
			numLed = rand()%4;
			Prepare_Set_LED(numLed);
			Choix_Capteur(numLed+1);
			Mise_A_Jour_Afficheurs_LED();
			Maj=0;
		}
	}
}

