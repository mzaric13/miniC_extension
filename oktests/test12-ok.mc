//OPIS: poziv funkcije sa prosledjene dve razlicite callback
//RETURN: 20

void cb1(int a) {
	int c;
	c = a + 10;
}

void cb2(int a) {
	int b;
	b = 10;
}

int func(callback) {
	int a[] = {5, 6, 7};
	int b;
	int c[] = {2, 3, 4, 5};
	b = a[0] + 7 - 2 + c[3];
	callback(a[1]);
	return b;
}

int main() {
	int a;
	int b;
	int c;
	a = func(cb1);
	c = 10;
	b = func(cb2);
	return a + b - c;
}
