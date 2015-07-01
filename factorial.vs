Integer factorial(Integer numero){
	Integer num = numero;
	Integer rta = 1;
	while (num>0) {
		rta = rta*num;
		num = num-1;
	}
	return rta;
}

main {
	String s = read;
	Integer number = ^is;
	Integer a = factorial(number);
	println(a);
}
