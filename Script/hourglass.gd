# hourglass.gd
# 沙漏道具：被玩家触碰后触发减速效果
extends Area2D

# 减速持续时间（可在编辑器中调节）
@export var slow_duration: float = 5.0

# 防止重复收集的标记
var is_collected = false

# Area2D 的 body_entered 信号（在编辑器中已连接）
func _on_body_entered(body: Node2D) -> void:
	if is_collected:
		return

	# 检查触碰的是否为玩家（CharacterBody2D 节点）
	if body is CharacterBody2D:
		is_collected = true

		# 在场景树中查找 TimeManager 节点（注意节点名必须匹配）
		var time_manager = get_tree().current_scene.find_child("time_manager", true, false)
		# 调用 TimeManager 的减速方法，传入持续时间
		time_manager.start_time_slow(slow_duration)

		# 收集后销毁沙漏
		queue_free()
