extends Area2D


var screen_size

func _ready():
    screen_size = get_viewport_rect().size

func _start():
    init_ground()
    show()
    $CollisionShape2D.disabled = false

func process(delta):
