//RETURN: 7

int func2(int a) {
	return a + 2;
}

int func1() {
	int a[] = {1, 2, 3};
	int c[3];
	int d;
	int b[] = {3, 4};
	d = 5;
	if (b[0] > 4) {
		d = 10;
	}
	return func2(d);
}

int main() {
	return func1();
}
