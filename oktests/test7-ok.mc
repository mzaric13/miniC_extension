//OPIS: slozeniji primer nizovi i forEach
//RETURN: 59

int func() {
	int a;
	int b[5];
	int c;
	int d[3];
	b[0] = 10;
	b[3] = 6;
	d[1] = 4;
	d[2] = 13;
	a = b[0] + d[1];
	c = b[3] + d[2];
	if (a < c)
		return a;
	else
		return c;
}

int func1(int a) {
	return a + 10;
}

int func3(int a) {
	int c;
	int b[] = {3, 4, 5};
	b.forEach(func1); // {13, 14, 15}
	c = func(); // 14
	return a + c + b[0] + b[1] + b[2]; // 3 + 14 + 13 + 14 + 15
}

int main() {
	int a;
	a = 3;
	return func3(a);
}
