//OPIS: slozeniji primer sa nizovima
//RETURN: 23

int func(int a) {
	return a + 3;
}

int func1() {
	int a[2];
	int b;
	int c[3];
	a[0] = 5;
	c[2] = 7;
	b = 10;
	c[0] = func(a[0]);
	return c[0] + a[0] + b;
}

int main() {
	return func1();
}
