//RETURN: 58

int func1(int a) {
	return a + 3;
}

int func() {
	int a[3];
	int c;
	a[0] = 1;
	a[1] = 2;
	a[2] = 3;
	a.forEach(func1);
	c = a[0] + a[1] + a[2];
	return c;
}

int func2() {
	int b[2];
	int a;
	b[0] = 10;
	b[1] = 100;
	b.forEach(func1);
	return b[0];
}

int func3(int a) {
	int b[3];
	int c;
	int d[2];
	b[0] = 10;
	d[1] = 12;
	c = 5;
	return b[0] + d[1] + c + a;
}

int main() {
	int a;
	int b;
	int c;
	a = func(); // 15
	b = func2(); // 13
	c = func3(3); // 30
	return a + b + c;
}
