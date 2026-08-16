extends CharacterBody2D

const SPEED = 125.0
var last_direction: Vector2 = Vector2.RIGHT
var is_action: bool = false
var hitbox_offset: Vector2

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var perform_action: AudioStreamPlayer2D = $PerformAction
@onready var hitbox: Area2D = $Hitbox

func _ready() -> void:
#	Initialize hitbox offset
	hitbox_offset = hitbox.position

func _physics_process(_delta: float) -> void:
	
#	Disable hitbox until action is triggered
	hitbox.monitoring = false
	
	if Input.is_action_just_pressed("action") and not is_action:
		action()
		return
		
	if is_action:
		velocity = Vector2.ZERO	
		return
		
	process_movement()
	process_animation()
	move_and_slide()

# ------------------------------------------------
# MOVEMENT AND ANIMATION
# ------------------------------------------------

func process_movement() -> void:
		# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		last_direction = direction
		update_hitbox_offset()
	else:
		velocity = Vector2.ZERO
	
func process_animation() -> void:
	if is_action: 
		return
	if velocity != Vector2.ZERO:
		play_animation("walk", last_direction)
	else: 
		play_animation("idle", last_direction) 
	
func play_animation(prefix:String , dir:Vector2) -> void:
	if dir.x > 0:
		animated_sprite_2d.play(prefix + "_right")
	elif dir.x < 0:
		animated_sprite_2d.play(prefix + "_left")
	elif dir.y < 0:
		animated_sprite_2d.play(prefix + "_up")
	elif dir.y > 0:
		animated_sprite_2d.play(prefix + "_down")

# ----------------------	
# ACTION	
# -----------------------

func action() -> void:
	is_action = true
	hitbox.monitoring = true
	perform_action.play()
	play_animation("action", last_direction)


func _on_animated_sprite_2d_animation_finished() -> void:
	if is_action:
		is_action = false
# -------------------
# HITBOX
# ------------------
func update_hitbox_offset() -> void:
	var x := hitbox_offset.x
	var y := hitbox_offset.y
	
	match last_direction:
		Vector2.DOWN:
			hitbox.position = Vector2(-y,x)
		Vector2.UP:
			hitbox.position = Vector2(y,-x)
		Vector2.LEFT:
			hitbox.position = Vector2(-x,y)
		Vector2.RIGHT:
			hitbox.position = Vector2(x, y)


func _on_hitbox_body_entered(body: Node2D) -> void:
	if is_action and body.name.begins_with("PC"):
		print(body.name)
		print('action')
