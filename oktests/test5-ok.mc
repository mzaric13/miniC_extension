//OPIS: test forEach
//RETURN: 5

int func(int a) {
	return a - 2;
}

int func1() {
	int a[3];
	a[0] = 4;
	a[1] = 2;
	a[2] = 5;
	a.forEach(func);
	return a[0] + a[1] + a[2];
}

int main() {
	return func1();
}
