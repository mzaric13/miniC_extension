//OPIS: relacioni izraz sa elementom niza
// RETURN: 26


int func(int a) {
	int b[2];
	b[0] = 5;
	b[1] = 10;
	if (b[0] > 3)
		a = 6;
	return a + b[1];
}

int main() {
	int a;
	a = 10;
	return a + func(2);
}
