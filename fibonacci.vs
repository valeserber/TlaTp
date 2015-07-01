Integer fibonacci (Integer numero) {
	Integer a = 0;
	Integer b = 1;
	Integer c = 0;
	Integer i = 0;
	Integer num = numero;
	if (num==1) {
		return 1;
	}
	while (i<(num-1)) {
		c = a+b;
		a = b;
		b = c;
		i = i+1;
	}
	return c;
}

main {
	String s = read;
	Integer number = ^is;
	Integer a = fibonacci(number);
	println(a);
}
