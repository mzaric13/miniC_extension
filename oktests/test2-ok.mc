//OPIS: deklarisanje niza u jednoj linije
//RETURN: 10

int func() {
	int a[] = {5, 5};
	return a[0] + a[1];
}

int main() {
	return func();
}
