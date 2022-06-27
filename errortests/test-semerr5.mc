//OPIS: neodgovarajuci tip u num_exp

int simFunc() {
	return 1;
}

int func() {
	unsigned a[3];
	unsigned b[3];
	int c;
	int d;
	a[1] = 5u;
	b[2] = 6u;
	d = 3;
	c = d + b[2] + a[1] + simFunc();
	return c;
}

int main() {
	return func();
}
