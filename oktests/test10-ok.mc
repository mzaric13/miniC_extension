//OPIS: slozeniji primer callback poziva
//RETURN: 28

void func(int a) {
	int b;
	b = a + 3;
}

void func1() {
	int a;
	a = 10;
}

int func2(callback) {
	int a;
	int b;
	a = 10;
	b = 7;
	callback(a);
	return a + b + 4;
}

int func3(callback) {
	int a;
	a = 7;
	callback();
	return a;
}

int main() {
	int a;
	int b;
	a = func2(func);
	b = func3(func1);
	return a + b;
}
