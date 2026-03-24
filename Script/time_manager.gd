# time_manager.gd
# 时间管理器：负责全局的速度倍率控制，被沙漏触发后改变所有平台的速度
# 继承自 Timer 节点，利用其计时功能实现减速效果的持续时间管理

extends Timer

# 自定义信号：当速度倍率发生变化时发出，参数为新的倍率
# 所有平台通过连接此信号来更新自己的移动速度
signal speed_change(multiplier: float)

# 是否正处于减速状态
var is_slowed = false
# 当前速度倍率（1.0 正常，0.5 减速）
var current_multiplier = 1.0

func _ready() -> void:
	# 游戏启动时，自动连接场景中已存在的所有平台
	connect_all_blocks()

# 连接所有标记为 "blocks" 组的节点
func connect_all_blocks():
	# 从场景树中获取所有属于 "blocks" 组的节点
	var blocks = get_tree().get_nodes_in_group("blocks")
	for block in blocks:
		# 检查平台是否有接收速度变化的方法
		if block.has_method("_on_speed_changed"):
			# 避免重复连接（如果已经连接过，就不再重复连接）
			if not speed_change.is_connected(block._on_speed_changed):
				speed_change.connect(block._on_speed_changed)

# 被沙漏调用，开始减速效果
func start_time_slow(duration: float):
	if is_slowed:
		# 如果已经在减速中，只需重置计时器（延长减速时间）
		stop()
	else:
		# 首次进入减速状态
		is_slowed = true
		current_multiplier = 0.5        # 速度减半
		speed_change.emit(current_multiplier)  # 立即通知所有平台减速

	# 设置 Timer 的等待时间并开始计时
	wait_time = duration
	start()

# Timer 超时回调，减速效果结束
func _on_timeout() -> void:
	is_slowed = false
	current_multiplier = 1.0
	speed_change.emit(current_multiplier)  # 通知所有平台恢复正常速度

# 供新生成的平台调用的方法，获取当前速度倍率
func get_current_multiplier():
	return current_multiplier
