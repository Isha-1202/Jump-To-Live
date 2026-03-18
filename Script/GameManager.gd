extends Node2D

@export var score : int = 0
@export var block_scene : PackedScene
@export var score_label : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	score_label.text = ("Score: ") + str(score)
	
	



func _spawn_blocks_timeout() -> void:
	var block_node = block_scene.instantiate()
	block_node.position = Vector2(randf_range(200,800),672)
	get_tree().current_scene.add_child(block_node)
