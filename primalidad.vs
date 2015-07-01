Boolean esPrimo (Integer numero) {
	Boolean primo = true;
	Integer num = numero;
	Integer divisor = 2;
   	while(((primo==true)&&(divisor<num))){
		if((num%divisor)==0){
			primo = false;
			return primo;
		}else{
			divisor = divisor+1;
		}
	}
	return primo;
}

main {
	String s = read;
	Integer number = ^is;
	Boolean a = esPrimo(number);
	println(a);
}
