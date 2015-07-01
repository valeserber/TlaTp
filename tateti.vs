Object generateBoard() {
	Object ans = {
		Integer[] values = Integer[9];
		
		function void init() {
			Integer i = 0;
			while(i<9){
				values[i]=0;
				i=i+1;
			}
		}

		function Integer lineal(Integer fil, Integer col) {
			return (col*3)+fil;
		}

		function void play(Integer fil, Integer col, Integer value) {
			values[this:lineal(fil,col)] = value;
		}

		function void playRandom(Integer mark) {
			Integer i = 0;
			Integer j = 0;
			Integer[] indices = Integer[9];
			while(i<9){
				if(values[i]==0){
					indices[j] = i;
					j=j+1;
				}
				i=i+1;
			}
			Integer playIndex = rand#j;
			values[indices[playIndex]]=mark;
		}

		function Integer get(Integer fil, Integer col){
			return values[this:lineal(fil, col)];
		}

		function void printBoard() {
			Integer i = 0;
			Integer j = 0;
			while(i<3){
				while(j<3){
					Integer x = values[this:lineal(i, j)];
					String m = getMark(x);
					print(m+" ");
					j=j+1;
				}
				j=0;
				i=i+1;
				println();
			}
		}

		function Boolean gameOver(){
			Integer i = 0;
			while(i<9){
				if(values[i]==0){
					return false;
				}
				i=i+1;
			}
			return true;
		}
	};
	ans:init();
	return ans;
}

String getMark(Integer m) {
	if(m==1){
		return "X";
	}
	if(m==2){
		return "O";
	}
	return "-";
}

Boolean hasWon(Object board, Integer mark) {
	Integer x1;
	Integer x2;
	Integer x3;
	
	x1 = board:get(0, 0);
	x2 = board:get(0, 1);
	x3 = board:get(0, 2);
	if (((x1==mark&&x2==mark)&&x3==mark)){
		return true;
	}

	x1 = board:get(1, 0);
	x2 = board:get(1, 1);
	x3 = board:get(1, 2);
	if (((x1==mark&&x2==mark)&&x3==mark)){
		return true;
	}

	x1 = board:get(2, 0);
	x2 = board:get(2, 1);
	x3 = board:get(2, 2);
	if (((x1==mark&&x2==mark)&&x3==mark)){
		return true;
	}

	x1 = board:get(0, 0);
	x2 = board:get(1, 0);
	x3 = board:get(2, 0);
	if (((x1==mark&&x2==mark)&&x3==mark)){
		return true;
	}

	x1 = board:get(0, 1);
	x2 = board:get(1, 1);
	x3 = board:get(2, 1);
	if (((x1==mark&&x2==mark)&&x3==mark)){
		return true;
	}

	x1 = board:get(0, 2);
	x2 = board:get(1, 2);
	x3 = board:get(2, 2);
	if (((x1==mark&&x2==mark)&&x3==mark)){
		return true;
	}

	x1 = board:get(0, 0);
	x2 = board:get(1, 1);
	x3 = board:get(2, 2);
	if (((x1==mark&&x2==mark)&&x3==mark)){
		return true;
	}

	x1 = board:get(2, 2);
	x2 = board:get(1, 1);
	x3 = board:get(0, 0);
	if (((x1==mark&&x2==mark)&&x3==mark)){
		return true;
	}

	return false;
}

void cpuPlays(Object board, Integer mark) {
	board:playRandom(mark);
}

void humanPlays(Object board, Integer mark) {

	board:printBoard();
	print("ingrese fila: ");
	Integer fil = ^iread;
	print("ingrese columna: ");
	Integer col = ^iread;
	if((fil<0||fil>=3)){
		println("juga bien!");
		humanPlays(board, mark);
		return;
	}
	if((col<0||col>=3)){
		println("juga bien!");
		humanPlays(board, mark);
		return;
	}
	Integer current = board:get(fil, col);
	if(current>0) {
		println("ese casillero esta ocupado. juga otra vez");
		humanPlays(board, mark);
		return;
	}
	board:play(fil, col, 1);
}

void endingMessage(Object board, Integer winner) {
	println("Ending board:");
	board:printBoard();

	if(winner==1){
		println("Human won!");
		return;
	}
	if(winner==2){
		println("Cpu won!");
		return;
	}
	println("Tie!");
}

main {
	Integer hval = 1;
	Integer cval = 2;
	Object board = generateBoard();
	Boolean isPlayerTurn = true;

	while(true){
		if(^cBoolean#board:gameOver()){
			endingMessage(board,0);
			return;
		}
		if(isPlayerTurn){
			humanPlays(board, hval);
			if(hasWon(board, hval)){
				endingMessage(board,hval);
				return;
			}
			isPlayerTurn=false;
		}else{
			cpuPlays(board, cval);
			if(hasWon(board, cval)){
				endingMessage(board,cval);
				return;
			}
			isPlayerTurn=true;
		}
	}
}
