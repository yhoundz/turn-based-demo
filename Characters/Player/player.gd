extends Node2D
class_name player

enum state {attack, ability, defend, item, idle, dead}

@export var hp: int = 20
@export var atk: int = 10
@export var critChance: float = 0.05
@export var critMult: float = 1.5
@export var def: int = 10
@export var defMult: float = 2.0
@export var speed: int = 10

var currState: state = state.idle
var defendActive: bool = false
var isDead: bool = false

func _ready() -> void:
	currState = state.idle

func _process(delta: float) -> void:
	pass

func attack(target: Node) -> void:
	if(target.is_in_group("enemy")):
		target.receive_damage(round(randf_range(0.85, 1.15) * atk))
		print(target.hp, target)

func ability() -> void:
	pass

func defend() -> int:
	var originalDef = def
	def *= defMult
	defendActive = true
	return originalDef

func useItem() -> void:
	pass

func receive_damage(damage: int) -> void:
	hp -= (damage - def) if (damage - def) >= 0 else 0
	if(hp <= 0):
		hp = 0
		set_state(state.dead)
	if(defendActive):
		def = defend()
		defendActive = false
	get_node("characterInfo").set_info()

func set_state(setState) -> void:
	currState = setState

func is_alive() -> bool:
	return !isDead

func return_curr_state_name() -> String:
	return state.find_key(currState)

func return_state_from_string(str: String) -> int:
	for i in state.keys():
		if state.find_key(i) == str:
			return i
	return -1
