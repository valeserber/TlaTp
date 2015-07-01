Boolean esPrimo (Integer numero) {
	Boolean primo = true;
	Integer num = numero;
	Integer divisor = 2;
    while (((divisor<num)&&(primo==true))){
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

}
