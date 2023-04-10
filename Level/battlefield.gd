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
	print(turnOrder, turnNum)

func _process(delta: float) -> void:
	currState = set_curr_state()
	match currState:
		battleState.playerTurn:
			player_turn()
		battleState.enemyTurn:
			enemy_turn()
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
	var selectedPlayer: Node = get_node(turnOrder[turnNum].get_path()) if return_is_player(get_node(turnOrder[turnNum].get_path())) else null
	selectedPlayer.set_state(selectedPlayer.state.attack)
	match selectedPlayer.state.find_key(selectedPlayer.currState):
		"attack":
			player_attacked.emit(get_node(enemyList[targetEnemy].get_path()))
			selectedPlayer.set_state(selectedPlayer.state.idle)
			print("player attacked")
		"ability":
			selectedPlayer.set_state(selectedPlayer.state.ability)
		"defend":
			selectedPlayer.defend()
			selectedPlayer.set_state(selectedPlayer.state.idle)
			print("player defended")
		"item":
			selectedPlayer.set_state(selectedPlayer.state.item)
		"idle":
			selectedPlayer.set_state(selectedPlayer.state.idle)
		"dead":
			pass
		"damaged":
			selectedPlayer.set_state(selectedPlayer.state.damaged)
	selectedPlayer.lastMove = selectedPlayer.currState
	end_turn()

func enemy_turn() -> void:
	var selectedEnemy: Node = get_node(turnOrder[turnNum].get_path()) if not return_is_player(get_node(turnOrder[turnNum].get_path())) else null
	selectedEnemy.set_state(selectedEnemy.state.idle)
	match selectedEnemy.state.find_key(selectedEnemy.currState):
		"attack":
			player_attacked.emit(get_node(playerList[targetPlayer].get_path()))
			selectedEnemy.set_state(selectedEnemy.state.idle)
			print("enemy attacked")
			end_turn()
		"ability":
			selectedEnemy.set_state(selectedEnemy.state.ability)
		"idle":
			selectedEnemy.set_state(selectedEnemy.state.idle)
		"dead":
			end_turn()
		"damaged":
			selectedEnemy.set_state(selectedEnemy.state.damaged)

func end_turn() -> void:
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
	return battleState.playerTurn if turnOrder[turnNum] is player else battleState.enemyTurn

func return_is_player(inNode: Node) -> bool:
	return inNode is player
