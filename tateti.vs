Object generateBoard() {
	return {
		Integer[] values = Integer[9];

		function Integer something() {
			return 5;
		}
	};
}

Boolean isOver(Object board) {
	return true;
}

main {
	Object board = generateBoard();
	Boolean isPlayerTurn = false;
	Integer r = rand#5;
	println(r);
}
