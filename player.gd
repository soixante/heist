extends Area2D

signal hit

@export var speed = 400 
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _start(pos):
	position = pos
	show()
	$CollisionPlayerShape2D.disabled = false

func _process(delta):
	var velocity = Vector2.ZERO
	var rotation_angle = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		rotation_angle.x = 0.5
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		rotation_angle.x = 1.5
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		rotation_angle.y = 0
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		rotation_angle.y = 1
		velocity.y += 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedPlayerSprite2D.animation = "forward"
		$AnimatedPlayerSprite2D.play()
	else:
		$AnimatedPlayerSprite2D.stop()

	position += velocity * delta 
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if Input.is_anything_pressed():
		$DebugWindow.set_text("rotation:" + str(rotation_angle.x + rotation_angle.y))
		$AnimatedPlayerSprite2D.rotation = (rotation_angle.x + rotation_angle.y) * PI 



"""
func _on_body_entered(body):
   hide()
   hit.emit()
   $CollisionPlayerShape2D.set_deferred("disabled", true)

"""
