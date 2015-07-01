void jugar(String game){
	String[] plays = String[3];
	plays[0] = "rock";
	plays[1] = "paper";
	plays[2] = "scissors";

	Integer cpuplay = rand#3;

	if(game==plays[0]){
		if(cpuplay==0){
			println("cpu also played rock");
			return;
		}
		if(cpuplay==1){
			println("cpu wins with paper");
			return;
		}
		if(cpuplay==2){
			println("cpu played scissors. you win!");
		}
	}
	if(game==plays[1]){
		if(cpuplay==0){
			println("cpu played rock. you win!");
			return;
		}
		if(cpuplay==1){
			println("cpu also played paper");
			return;
		}
		if(cpuplay==2){
			println("cpu wins with scissors");
		}
	}
	if(game==plays[2]){
		if(cpuplay==0){
			println("cpu wins with rock");
			return;
		}
		if(cpuplay==1){
			println("cpu played paper. you win!");
			return;
		}
		if(cpuplay==2){
			println("capu also played scissors");
			return;
		}
	}
}

main{
	println("rock paper or scissors");
	String s = read;
	jugar(s);
}

