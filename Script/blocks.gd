# blocks.gd
# 平台脚本：负责平台的移动、与 TimeManager 的交互、动态生成时的初始化
extends AnimatableBody2D

# 从外部传入的移动数据资源（PlayerMovementData 中定义了 blocks_speed）
@export var movement_data: PlayerMovementData

# 基础速度（从 movement_data 中读取）
var based_speed = 0
# 当前实际移动速度（受倍率影响）
var current_speed = 0

func _ready() -> void:
	# 从数据资源中获取平台的基础移动速度
	based_speed = movement_data.blocks_speed
	# 初始化当前速度为基础速度（稍后会被倍率覆盖）
	current_speed = based_speed

	# 连接 TimeManager 的信号，以便接收速度倍率变化通知
	connect_to_time_manager()
	# 主动获取当前倍率，确保生成时立即应用正确的速度（解决动态生成平台不减速的问题）
	apply_current_multiplier()

# 每帧移动平台
func _physics_process(delta: float) -> void:
	# 只有游戏未结束时才移动
	if get_tree().current_scene.is_game_over == false:
		# 向下移动，速度乘以帧时间
		position += Vector2(0, current_speed) * delta
		# 超出屏幕下方则销毁
		if position.y < -200:
			queue_free()

# 接收 TimeManager 的速度变化信号
func _on_speed_changed(multiplier: float):
	# 根据基础速度和倍率重新计算当前速度
	current_speed = based_speed * multiplier

# 连接 TimeManager 的信号
func connect_to_time_manager():
	# 在场景树中查找名为 "time_manager" 的节点（注意：大小写敏感）
	var time_manager = get_tree().root.find_child("time_manager", true, false)
	# 连接信号，传递本节点的 _on_speed_changed 方法
	time_manager.speed_change.connect(_on_speed_changed)

# 获取当前倍率并应用到速度上（用于新生成平台）
func apply_current_multiplier():
	var time_manager = get_tree().root.find_child("time_manager", true, false)
	var multiplier = time_manager.get_current_multiplier()
	current_speed = based_speed * multiplier
