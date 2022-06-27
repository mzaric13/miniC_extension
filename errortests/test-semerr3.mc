//OPIS: array not defined

int func() {
	int b;
	b[0] = 1;
	return b;
}

int main() {
	return func();
}
