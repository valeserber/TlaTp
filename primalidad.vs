Boolean esPrimo (Integer numero) {
	Boolean primo = true;
	Integer num = numero;
	Integer divisor = 2;
   	while(((primo==true)&&(divisor<num))){
		Integer aux = num%divisor;
		if(aux==0){
			primo = false;
			return primo;
		}else{
			divisor = divisor+1;
		}
	}
	return primo;
}

main {
	print("Ingrese un numero: ");
	String s = read;
	Integer number = ^is;
	Boolean a = esPrimo(number);
	print("El numero "+number+" es primo: ");
	println(a);
}
