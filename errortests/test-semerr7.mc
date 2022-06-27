//OPIS: forEach funckija nije definisana

int func() {
	int a[2];
	a.forEach(nonDefined);
	return a[0];
}

int main() {
	return func();
}
