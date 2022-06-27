//OPIS: sintaksna greska za forEach

int func1(int a) {
	return a + 5;
}

int func() {
	int a[3];
	a.foreach(func1);
	return a[0];
}

int main() {
	return func();
}
