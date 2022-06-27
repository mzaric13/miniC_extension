//OPIS: prosledjen argument callbacku koji ga ne prima

void func() {
	int a;
	a = 10;
}

int func1(callback) {
	int a;
	int b;
	a = 10;
	callback(a);
	return b;
}

int main() {
	return func1(func);
}
