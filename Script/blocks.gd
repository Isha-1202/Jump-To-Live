extends AnimatableBody2D
@export var movement_data : PlayerMovementData

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += Vector2(0,movement_data.blocks_speed) * delta
	
	if position.y < -200:
		queue_free()
		
