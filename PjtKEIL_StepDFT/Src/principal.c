

#include "DriverJeuLaser.h"

extern int DFT_ModuleAuCarre(short int * Signal64ech, char k);
extern short LeSignal;
int TabValeur[64];

int main(void)
{

// ===========================================================================
// ============= INIT PERIPH (faites qu'une seule fois)  =====================
// ===========================================================================

// Apr�s ex�cution : le coeur CPU est clock� � 72MHz ainsi que tous les timers
CLOCK_Configure();
	
for(int i = 0; i < 64; i++){
	TabValeur[i] = DFT_ModuleAuCarre(&LeSignal, i);
}


//============================================================================	
	
	
while	(1)
	{
	}
}

