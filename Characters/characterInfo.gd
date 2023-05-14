extends Label

@onready var thisChar: Node = get_node(get_parent().get_path())

func _ready() -> void:
	set_info()

func _process(delta: float) -> void:
	pass

func set_info() -> void:
	set_text(thisChar.get_name() + " " + str(thisChar.hp))
