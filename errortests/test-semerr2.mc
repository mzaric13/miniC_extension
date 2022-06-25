//OPIS: index out of range

int func() {
	int a[3];
	a[3] = 4;
	return a[0];
}

int main() {
	return func();
}
