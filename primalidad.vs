Boolean esPrimo (Integer numero) {
	Boolean primo = true;
	Integer num = numero;
	Integer divisor = 2;
	while (primo && divisor<num) {
		if (num % divisor==0) {
			primo = false;
			return primo;
		} else {
			divisor = divisor+1;
		}
	}
	return primo;
}

main {

}
