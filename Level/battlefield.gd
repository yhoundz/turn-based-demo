extends Node2D

enum battleState {playerTurn, enemyTurn, victory, defeat}

var turnOrder: Array[Node]
var playerList: Array[Node]
var alivePlayers: Array[Node]
var aliveEnemies: Array[Node]
var enemyList: Array[Node]
var currPlayer: int = 0 #currently selected player
var currEnemy: int = 0 #currently acting enemy
var targetPlayer: int = 0 #currently targeted player - enemy attacking
var targetEnemy: int = 0 #currently targeted enemy - player attacking
var turnCounter: int = 0
var turnNum: int = set_turn_num()
var currState: battleState
var lastTurn: battleState
var advanceGame: bool = false

func _ready() -> void:
	turn_sort()
	set_curr_state()
	children_to_array("Players", playerList)
	children_to_array("Enemies", enemyList)
	children_to_array("Players", alivePlayers)
	children_to_array("Enemies", aliveEnemies)
	print(turnOrder, turnNum)
	update()
	print(currState)

func update() -> void:
	set_curr_state()
	match currState:
		battleState.playerTurn:
			player_turn()
		battleState.enemyTurn:
			enemy_turn()
	turnNum = set_turn_num()
	advanceGame = false

func _process(delta: float) -> void:
	if(advanceGame):
		update()

func turn_sort() -> void:
	#adds active players and enemies to the scene
	var chars = [get_node("Players"), get_node("Enemies")]
	for node in chars:
		for character in node.get_children():
			turnOrder.append(character);

	#sort by speed (fast -> slow)
	for i in range(1, len(turnOrder)):
		var temp:Node = turnOrder[i]
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

func children_to_array(node: String, array: Array) -> void:
	for i in get_node(node).get_children():
		array.append(i)

func player_turn() -> void:
	var selectedPlayer: Node = get_node(turnOrder[turnNum].get_path()) if return_is_player(get_node(turnOrder[turnNum].get_path())) else null
	if(selectedPlayer.isDead):
		end_turn()
	else:
		selectedPlayer.set_state(selectedPlayer.state.idle)
	
	
	
	match selectedPlayer.currState:
		selectedPlayer.state.attack:
			selectedPlayer.attack(aliveEnemies[targetEnemy])
			pass
		selectedPlayer.state.ability:
			pass
		selectedPlayer.state.defend:
			selectedPlayer.defend()
		selectedPlayer.state.item:
			pass
		selectedPlayer.state.dead:
			selectedPlayer.isDead = true
			alivePlayers = alivePlayers.filter(check_alive(selectedPlayer))

	lastTurn = battleState.playerTurn
	end_turn()

func enemy_turn() -> void:
	var selectedEnemy: Node = get_node(turnOrder[turnNum].get_path()) if not return_is_player(get_node(turnOrder[turnNum].get_path())) else null
	targetPlayer = selectedEnemy.roll_player(alivePlayers)
	if selectedEnemy.isDead:
		end_turn()
	else:
		selectedEnemy.set_state(selectedEnemy.decide())
	
	match selectedEnemy.currState:
		selectedEnemy.state.attack:
			print("sd")
			selectedEnemy.attack(alivePlayers[targetPlayer])
			pass
		selectedEnemy.state.ability:
			pass
		selectedEnemy.state.dead:
			selectedEnemy.isDead = true
			aliveEnemies = aliveEnemies.filter(check_alive(selectedEnemy))
	
	lastTurn = battleState.enemyTurn
	end_turn()

func end_turn() -> void:
	turnCounter += 1
	turnNum = set_turn_num()
	advanceGame = true

func get_curr_char() -> Node:
	return turnOrder[turnNum]

func set_turn_num() -> int:
	return 0 if turnCounter == 0 else turnCounter % len(turnOrder)

func set_curr_state() -> void:
	currState = battleState.playerTurn if turnOrder[turnNum] is player else battleState.enemyTurn

func return_is_player(inNode: Node) -> bool:
	return inNode is player

#why tf cant callables have typed returns
func check_alive(char: Node): #-> bool
	return char.is_alive()

func set_player_state(char: Node, state: String) -> void:
	if char is player:
		char.set_state(char.return_state_from_string(state))

func get_active_state() -> String:
	return "player" if turnOrder[turnNum] is player else "enemy"
