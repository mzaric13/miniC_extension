//OPIS: forEach proslednjena funkcija koja ne vraca tip niza

unsigned func(unsigned a) {
	return a + 5u;
}

int func1() {
	int a[3];
	a[0] = 1;
	a[1] = 2;
	a[2] = 3;
	a.forEach(func);
	return a[0];
}

int main() {
	return func1();
}
