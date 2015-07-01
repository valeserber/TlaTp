Integer holas(Integer num){
	if(num>5){
		return 10;
	}
	if(num>=3){
		return 15;
	}else{
		return 20;
	}
}

main {

	print("Ingrese un numero: ");
	Integer num = ^iread;
	println("Valor devuelto: "+holas(num));
}
