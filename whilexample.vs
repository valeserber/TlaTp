void hola(Integer number) {
	Integer i = 0;
	while (i<number){
		println("hola!");
		i = i+1;
	}
}

main {
	print("Ingrese un numero: ");
	Integer num = ^iread;
	hola(num);
}
