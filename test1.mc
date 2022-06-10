// RETURN 0

int func1(int a) {
	return a + 3;
}

int func() {
	int a[3];
	int b[] = {1, 2, 3};
	a[0] = 1;
	a[1] = 2;
	a[2] = 3;
	a.forEach(func1);
	return 0;
}

int main() {
	return 0;
}
