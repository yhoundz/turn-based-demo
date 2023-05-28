extends TextureButton

@export var id: String = "default"
@onready var battlefield: Node = self.get_parent().get_parent()

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_pressed():
	if battlefield.get_active_state() == "player":
		match id:
			"attack":
				battlefield.set_player_state(battlefield.get_curr_char(), "attack")
				print("pressed attack")
			"ability":
				pass
			"item":
				pass
			"defend":
				pass
