//OPIS: deklarisanje niza
//RETURN: 10

int func() {
	int a[2];
	a[0] = 5;
	a[1] = 5;
	return a[0] + a[1];
}

int main() {
	return func();
}
