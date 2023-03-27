class_name Boxer
extends CharacterBody2D

@export var move_speed: float = .25 #seconds
@export var move_scale: int = 32 #units

var moving: bool = false

func move(direction: int) -> void:
    moving = true
    # @TODO : animate movement using direction
    $AnimatedSprite2D.play("walk")

    var destination: Vector2 = position + CoreConfig.moves[direction] * move_scale

    var tween = create_tween()
    tween.tween_property(self, "position", destination, move_speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
    tween.tween_callback(_on_tween_finished)

func _on_tween_finished() -> void:
    moving = false

#func _process(delta):
    # pass
