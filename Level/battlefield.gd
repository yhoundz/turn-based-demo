extends Node2D

enum state {playerTurn, enemyTurn, victory, defeat}

var turnOrder: Array[Node]
var playerList: Array[Node]
var enemyList: Array[Node]
var turnCounter: int = 0
var turnNum: int = 0 if turnCounter == 0 else turnCounter % len(turnOrder)
var currState: state

func _ready() -> void:
	turnSort()
	currState = state.playerTurn if turnOrder[turnNum].get_class() == "player" else state.enemyTurn
	children_to_array("Players", playerList)
	children_to_array("Enemies", enemyList)
	print(turnOrder, playerList, enemyList)
	turnCounter += 2
	print(turnNum)

func _process(delta: float) -> void:
	currState = state.playerTurn if turnOrder[turnNum].get_class() == "player" else state.enemyTurn
	match currState:
		state.playerTurn:
			player_turn()
		state.enemyTurn:
			enemy_turn()

func turnSort() -> void:
	#adds active players and enemies to the scene
	var chars = [get_node("Players"), get_node("Enemies")]
	for node in chars:
		for character in node.get_children():
			turnOrder.append(character);

	#sort by speed (fast -> slow)
	#using selection sort rn but could be improved
	for i in range(len(turnOrder)):
		var ind = i
		for j in range(i + 1, len(turnOrder)):
			if(turnOrder[j].speed > turnOrder[ind].speed):
				ind = j
		var temp = turnOrder[ind]
		turnOrder[ind] = turnOrder[i]
		turnOrder[i] = temp

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
	get_node(turnOrder[turnNum].get_path()).call("attack")

func enemy_turn() -> void:
	pass
