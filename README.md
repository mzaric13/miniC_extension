# miniC_extension
Predmet: Programski prevodioci
Student: Matija Zarić
Smer: Softversko inženjerstvo i informacione tehnologije
Broj indeksa: SW 24/2019


Potrebni alati:
	1. Bison: u linux terminalu instalira se komandom: $ sudo apt install bison
	2. Flex: u linux terminalu instalira se komandom: $ sudo apt install flex

Način pokretanja:
	1. Klonirati repozitorijum sa github-a
	2. Pozicionirati se u folder miniC_extension
	3. Otvoriti terminal u tom folderu
	4. Za pokretanje sa uspešnim testovima, pokrenuti komandu: $ make test TEST="oktests/*"
	5. Za pokretanje testova sa greškama, pokrenuti komandu: $ make test TEST="errortests/*"

