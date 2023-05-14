extends Label

@export var labelText: String = "default"

func _ready() -> void:
	set_text(labelText)

func _process(delta: float) -> void:
	pass
