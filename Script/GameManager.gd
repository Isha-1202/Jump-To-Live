# GameManager.gd
# 游戏主控制器：管理分数、游戏状态、生成平台等
extends Node2D

# 玩家得分
@export var score: int = 0
# 平台场景（用于动态生成）
@export var block_scene: PackedScene
# UI 中的得分显示标签
@export var score_label: Label

# 游戏是否结束（用于控制平台移动等）
var is_game_over = false
# 是否胜利（暂未使用）
var is_win = false

func _ready() -> void:
	# 可以在这里初始化游戏，比如启动生成平台的计时器等
	# 示例：启动一个 Timer 定时生成平台，其 timeout 信号连接到 _spawn_blocks_timeout
	pass

func _process(delta: float) -> void:
	# 每帧更新得分显示
	score_label.text = ("Score: ") + str(score)

# 定时器回调：生成新的平台
func _spawn_blocks_timeout() -> void:
	# 实例化一个平台
	var block_node = block_scene.instantiate()
	# 设置随机 X 位置（范围 200~800），Y 固定为 672（屏幕上方）
	block_node.position = Vector2(randf_range(200, 800), 672)
	# 将平台添加到当前场景中
	get_tree().current_scene.add_child(block_node)

	# 注意：平台脚本自身已经实现了连接 TimeManager 和获取当前倍率，
	# 因此不需要在这里额外处理信号连接。只需生成节点即可。
