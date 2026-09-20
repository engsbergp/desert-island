extends Camera2D

func set_camera_boundaries(p: Vector2i, s: Vector2i) -> void:
	limit_left = p.x
	limit_right = s.x-abs(p.x)
	limit_top = p.y
	limit_bottom = s.y-abs(p.y)
