extends Node2D
class_name enemy

enum state {attack, ability, idle, dead, damaged}

var currState: state = state.idle

@export var hp: int = 20
@export var atk: int = 10
@export var def: int = 10
@export var speed: int = 10

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	match state:
		state.attack:
			pass
		state.ability:
			pass
		state.idle:
			pass
		state.dead:
			pass
		state.damaged:
			pass

func attack() -> void:
	pass

func receive_damage() -> void:
	if(hp <= 0):
		hp = 0
		currState = state.dead
