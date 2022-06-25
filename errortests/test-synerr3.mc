//OPIS: sintaksna greska za callback parametar

void func1() {
	int a;
	a = 5;
}

int func(kalbek) {
	int a;
	a = 5;
	kalbek();
	return a;
}

int main() {
	return func(func1);
}
