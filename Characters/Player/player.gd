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
var returnCurrStateName: String = state.find_key(currState)
var lastMove: state

func _ready() -> void:
	currState = state.idle
	lastMove = currState

func _process(delta: float) -> void:
	pass

func attack(target: Node) -> void:
	if(target.is_in_group("enemy")):
		target.receive_damage(round(randf_range(0.85, 1.15) * atk))
		print(target.hp, target)

func ability() -> void:
	pass

func defend() -> void:
	var originalDef = def
	def *= defMult

func useItem() -> void:
	pass

func receive_damage() -> void:
	if(hp <= 0):
		hp = 0
		currState = state.dead

func set_state(setState) -> void:
	currState = setState
