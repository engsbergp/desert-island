extends Node2D

@onready var player: CharacterBody2D = $Player_lv1
@onready var tile_map: TileMapLayer = $Base
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var camera = player.get_node("Camera2D")
	
	# assuming that the tileset is a square
	var tile_map_scale = tile_map.tile_set.tile_size.x * tile_map.scale.x
	var tile_map_position = tile_map.get_used_rect().position*tile_map_scale
	var tile_map_size = tile_map.get_used_rect().size*tile_map_scale
	print(tile_map_position)
	print(tile_map_size)
	camera.set_camera_boundaries(tile_map_position, tile_map_size)
