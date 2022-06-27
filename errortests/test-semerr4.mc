//OPIS: neodgovarajuci tipovi u dodeli

int func() {
	int a[3];
	unsigned b;
	unsigned c;
	a[1] = 3;
	b = 5u;
	c = a[1];
	return a[1];
}

int main() {
	return func();
}
