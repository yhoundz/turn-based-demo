extends Node2D
class_name enemy

enum state {attack, ability, idle, dead, damaged}

@export var hp: int = 20
@export var atk: int = 10
@export var def: int = 10
@export var speed: int = 10

var currState: state = state.idle
var returnCurrStateName: String = state.find_key(currState)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	currState = decide()
	match currState:
		state.attack:
			pass
		state.ability:
			pass
		state.idle:
			decide()
		state.dead:
			pass
		state.damaged:
			pass

func decide() -> state:
	return state.attack

func attack() -> void:
	pass

func set_state(state) -> void:
	currState = state

func receive_damage(damage: int) -> void:
	hp -= damage
	if(hp <= 0):
		hp = 0
		currState = state.dead
