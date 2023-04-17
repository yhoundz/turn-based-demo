extends Node2D
class_name enemy

enum state {attack, ability, idle, dead}

@export var hp: int = 20
@export var atk: int = 10
@export var def: int = 10
@export var speed: int = 10

var currState: state = state.idle
var returnCurrStateName: String = state.find_key(currState)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func decide() -> state:
	return state.attack

func attack(target: Node) -> void:
	if target.is_in_group("player"):
		target.receive_damage(round(randf_range(0.85, 1.15) * atk))
		print(target.hp, target)

func set_state(state) -> void:
	currState = state

func receive_damage(damage: int) -> void:
	hp -= damage
	if(hp <= 0):
		hp = 0
		currState = state.dead
