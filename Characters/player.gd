extends Node2D
class_name player

enum state {attack, ability, defend, item, idle, dead, damaged}

@export var hp: int = 20
@export var atk: int = 10
@export var critChance: float = 0.05
@export var critMult: float = 1.5
@export var def: int = 10
@export var defMult: float = 2.0
@export var speed: int = 10

var currState: state

func _ready() -> void:
	currState = state.idle

func _process(delta: float) -> void:
	match currState:
		state.attack:
			attack("", round(randf_range(1 - 0.15, 1 + 0.15) * atk))
		state.ability:
			ability()
		state.defend:
			defend()
		state.item:
			useItem()
		state.idle:
			turn()
		state.dead:
			dead()
		state.damaged:
			receiveDamage()

func attack(target: String, damage: int) -> void:
	pass

func ability() -> void:
	pass

func defend() -> void:
	var originalDef = def
	def *= defMult

func useItem() -> void:
	pass

func turn() -> void:
	pass

func dead() -> void:
	pass

func receiveDamage() -> void:
	if(hp <= 0):
		hp = 0
		state.dead
