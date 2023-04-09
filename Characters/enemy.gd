extends Node2D
class_name enemy

enum state {attack, ability, turn, dead, damaged}

@export var hp: int = 20
@export var atk: int = 10
@export var def: int = 10
@export var speed: int = 10

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func attack() -> void:
	pass
