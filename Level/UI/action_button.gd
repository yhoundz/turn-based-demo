extends TextureButton

signal alertPlayerInput

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
				emit_signal("alertPlayerInput", id)
			"ability":
				emit_signal("alertPlayerInput", id)
			"item":
				emit_signal("alertPlayerInput", id)
			"defend":
				emit_signal("alertPlayerInput", id)
			_:
				pass
