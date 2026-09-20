extends Node2D

var level: int = 1
var current_level_root: Node = null
var hour: int = 800

@onready var canvas_modulate = $CanvasModulate

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_level_root = get_node("LevelRoot")
	_setup_level(current_level_root)
	#canvas_modulate.time_tick.connect(self.set_daytime)

# ----------------
# LEVEL MANAGEMENT
# ----------------

func _load_level() -> void:
#	unbind current level
	if current_level_root:
		current_level_root.queue_free()
#	change level
	var level_path = "res://scenes/beach1.tscn"
	current_level_root = load(level_path).instantiate()
	add_child(current_level_root)
	current_level_root.name = "LevelRoot"
	_setup_level(current_level_root)
	
func _setup_level(level_root: Node) -> void:
	var exit = level_root.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)
	
# ----------------
# SIGNAL HANDLERS
# ----------------
func _on_exit_body_entered(body:Node2D) -> void:
	if body.name.begins_with("Player"):
		call_deferred("_load_level")
