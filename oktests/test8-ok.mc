//OPIS: jednostavan primer callback bez parametara
//RETURN: 10

void func() {
	int a;
	int b;
	a = 7;
	b = 8;
}

int func1(callback) {
	int a;
	int b[7];
	int c;
	a = 5;
	b[3] = 4;
	c = 1;
	callback();
	return a + b[3] + c;
}

int main() {
	return func1(func);
}
