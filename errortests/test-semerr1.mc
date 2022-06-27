//OPIS: semanticka greska za tip vrednosti u nizu

int func() {
	int a[2];
	a[0] = 5u;
	return a[0];
}

int main() {
	return func();
}
