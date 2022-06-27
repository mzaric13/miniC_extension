//OPIS: nije poslat argument u callback funkciju

void func(int a) {
	int b;
	b = a + 4;
}

int func1(callback) {
	int a;
	int b;
	a = 10;
	b = a + 5;
	callback();
	return b;
}

int main() {
	return func1(func);
}
