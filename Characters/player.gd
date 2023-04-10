extends Node2D
class_name player

enum state {attack, ability, defend, item, idle, dead, damaged}

var currState: state = state.idle
var returnCurrStateName: String = get_state_name(currState)

@export var hp: int = 20
@export var atk: int = 10
@export var critChance: float = 0.05
@export var critMult: float = 1.5
@export var def: int = 10
@export var defMult: float = 2.0
@export var speed: int = 10

func _ready() -> void:
	currState = state.idle
	var callable = Callable(self, "deff")
	#get_node(self).connect(self.name, callable)
	
func deff():
	pass

func _process(delta: float) -> void:
	match currState:
		state.attack:
			attack()
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
			receive_damage()

func attack() -> void:
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

func receive_damage() -> void:
	if(hp <= 0):
		hp = 0
		currState = state.dead

func get_state_name(stateName) -> String:
	return state.find_key(stateName)

func set_state(state) -> void:
	currState = state
	

