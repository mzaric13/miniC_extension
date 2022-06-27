//OPIS: jednostavan callback primer sa parametrima
//RETURN; 10

void func(int c) {
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
	callback(c);
	return a + b[3] + c;
}

int main() {
	return func1(func);
}
