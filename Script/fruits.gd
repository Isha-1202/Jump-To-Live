extends Area2D
	
#播放水果动画
func _start_all_fruits_animation() -> void:
	#获取所有水果节点
	var fruits = get_tree().get_nodes_in_group("fruits")
	for fruit in fruits:
		fruit.play("apple")

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		queue_free()
		get_tree().current_scene.score += 1
