//OPIS: callback nije tipa void

int func() {
	int a;
	a = 5;
	return a;
}

int func1(callback) {
	int a;
	a = 10;
	callback();
	return a;
}

int main() {
	return func1(func);
}
