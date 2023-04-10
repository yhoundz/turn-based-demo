extends Node2D

enum battleState {playerTurn, enemyTurn, victory, defeat}

signal player_attacked(target:Node)

var turnOrder: Array[Node]
var playerList: Array[Node]
var enemyList: Array[Node]
var currPlayer: int = 0 #currently selected player
var currEnemy: int = 0 #currently acting enemy
var targetPlayer: int = 0 #currently targeted player - enemy attacking
var targetEnemy: int = 0 #currently targeted enemy - player attacking
var turnCounter: int = 0
var turnNum: int = set_turn_num()
var currState: battleState

func _ready() -> void:
	turn_sort()
	currState = set_curr_state()
	children_to_array("Players", playerList)
	children_to_array("Enemies", enemyList)
	print(turnOrder)

func _process(delta: float) -> void:
	currState = set_curr_state()
	match currState:
		battleState.playerTurn:
			player_turn()
		battleState.enemyTurn:
			enemy_turn()
	player_turn()
	turnNum = set_turn_num()

func turn_sort() -> void:
	#adds active players and enemies to the scene
	var chars = [get_node("Players"), get_node("Enemies")]
	for node in chars:
		for character in node.get_children():
			turnOrder.append(character);

	#sort by speed (fast -> slow)
	for i in range(1, len(turnOrder)):
		var temp = turnOrder[i]
		var j:int = i - 1
		while j >= 0 and turnOrder[j].speed < temp.speed:
			turnOrder[j + 1] = turnOrder[j]
			j -= 1
		turnOrder[j + 1] = temp

	#in the event that player speed = enemy speed, player goes first
	for i in range(len(turnOrder) - 1):
		if(turnOrder[i].speed == turnOrder[i + 1].speed):
			if(turnOrder[i] is enemy and turnOrder[i + 1] is player):
				var temp = turnOrder[i]
				turnOrder[i] = turnOrder[i + 1]
				turnOrder[i + 1] = temp

#why is gdscript like this
func children_to_array(node: String, array: Array) -> void:
	for i in get_node(node).get_children():
		array.append(i)

func player_turn() -> void:
	currPlayer = get_curr_char(playerList)
	var selectedPlayer: Node = get_node(turnOrder[turnNum].get_path())
	if(selectedPlayer.returnCurrStateName == "dead"):
		skip_turn()
	
	selectedPlayer.set_state(selectedPlayer.state.attack)
	if(selectedPlayer.get_state_name(selectedPlayer.currState) == selectedPlayer.get_state_name(selectedPlayer.state.attack)):
		player_attacked.emit(get_node(enemyList[targetEnemy].get_path()))

func enemy_turn() -> void:
	currEnemy = get_curr_char(enemyList)

func skip_turn() -> void:
	turnCounter += 1
	turnNum = set_turn_num()

func get_curr_char(arr: Array) -> int:
	for i in range(len(arr)):
		if get_node(turnOrder[turnNum].get_path()) == arr[i]:
			return i
	return -1

func set_turn_num() -> int:
	return 0 if turnCounter == 0 else turnCounter % len(turnOrder)

func set_curr_state() -> battleState:
	return battleState.playerTurn if turnOrder[turnNum].get_class() == "player" else battleState.enemyTurn

