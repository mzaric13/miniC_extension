//OPIS: sintaksna greska za deklaraciju niza bez velicine

int func1() {
	int a[];
	int b;
	return 1;
}

int main() {
	return func1();
}
