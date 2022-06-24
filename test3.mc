//RETURN: 12

void func1(int c) {
	int a;
	int b;
	a = 1;
	b = 2;
}

int func(callback) {
	int a[2];
	a[0] = 1;
	a[1] = 5;
	callback(a[0]);
	return a[0] + a[1];
}

int func2(callback) {
	int a;
	int b;
	a = 6;
	b = 10;
	callback(a);
	return a;
}

int main() {
	int a;
	a = 2;
	a = func2(func1);	
	return a + func(func1);
}
