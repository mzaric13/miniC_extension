//OPIS: test sa svim elementima zadatka
//RETURN: 81

void cbFuncPar(int a) {
	int b;
	b = a + 6;
}

void cbFunc() {
	int a;
	a = 5;
}

int funcFe(int a) {
	return a + 4;
}

int func(int a) {
	int b[7];
	int c;
	int d[] = {1, 2, 3};
	b[0] = 5;
	b[1] = 6;
	b[2] = 13;
	d.forEach(funcFe); // {5, 6, 7}
	c = b[0] + d[1]; // 11
	return c + b[2] + a; // 24 + a
}

int func1(callback) {
	int a[3];
	a[0] = 1;
	a[1] = 2;
	a[2] = 3;
	a.forEach(funcFe); // {5, 6, 7}
	callback(a[1]);
	return a[0] + a[1] + a[2]; // 18
}

int func2(callback) {
	int a;
	int b[] = {3, 4, 5};
	int c;
	a = 12;
	callback();
	c = 1;
	b.forEach(funcFe); // {7, 8, 9}
	return b[2] + a; // 21
}

int main() {
	int a;
	int b[2];
	int c;
	b[0] = 6;
	a = func1(cbFuncPar); // 18
	b[1] = func2(cbFunc); // 21
	c = func(a); // 42
	return a + b[1] + c; // 18 + 21 + 42
}
