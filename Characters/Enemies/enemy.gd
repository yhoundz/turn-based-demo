extends Node2D
class_name enemy

enum state {attack, ability, dead}

@export var hp: int = 20
@export var atk: int = 10
@export var def: int = 10
@export var speed: int = 10

var isDead: bool = false
var currState: state

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func decide() -> state:
	return state.attack

func attack(target: Node) -> void:
	if target.is_in_group("player"):
		target.receive_damage(round(randf_range(0.85, 1.15) * atk))
		print(target, target.hp)

func set_state(state) -> void:
	currState = state

func receive_damage(damage: int) -> void:
	hp -= (damage - def) if (damage - def) >= 0 else 0
	if(hp <= 0):
		hp = 0
		set_state(state.dead)
	get_node("characterInfo").set_info()

func roll_player(arr: Array) -> int:
	return randi() % len(arr)

func is_alive() -> bool:
	return !isDead

func return_curr_state_name() -> String:
	return state.find_key(currState)
