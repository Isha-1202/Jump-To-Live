extends CharacterBody2D

@export var movement_data : PlayerMovementData

@export var animator : AnimatedSprite2D

@export var winning_tools_data : Winning_Tools_Data


var air_jump = false#空中二段跳

func _physics_process(delta: float) -> void:
	_is_change_game_over()
	if get_tree().current_scene.is_game_over == false:
		_jump_and_fall(delta)
		_handle_jump()
		var direction := Input.get_axis("left", "right")
		_handle_air_acceleration(direction, delta)
		_axis_move(direction,delta)
		_animator_flip(direction)
		#设置土狼时间
		#当角色移动时满足：移动前（move_and_slide()) 在地板上，移动后不位于地板上且向下落时。触发土狼时间
		var was_on_floor = is_on_floor()
		move_and_slide()
		var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
		#if just_left_ledge:
			#$CoyoteTime.start()

#处理跳跃过程
func _jump_and_fall(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y < 0:
			animator.play("jump")
		else:
			animator.play("fall")

#跳跃触发条件
func _handle_jump():
	# Handle jump.
	if is_on_floor():
		air_jump = true
	
	if is_on_floor() : #or $CoyoteTime.time_left > 0.0:
		if Input.is_action_just_pressed("jump"):
			velocity.y = movement_data.jump_velocity
	
	if not is_on_floor():
		if Input.is_action_just_pressed("jump") and velocity.y < movement_data.jump_velocity/2:
			velocity.y = movement_data.jump_velocity/2
			#空中二段跳
		if Input.is_action_just_pressed("jump") and air_jump:
			velocity.y = movement_data.jump_velocity * 0.8
			air_jump = false

#水平移动
func _axis_move(direction,delta):
	if direction:
		velocity.x = direction * movement_data.speed
		#velocity.x = move_toward(velocity.x,movement_data.speed * direction,movement_data.acceleration * delta)
		#水平移动时会有加速/减速过程，由于本游戏单个平板长度较小，故不加入
	else:
		velocity.x = move_toward(velocity.x, 0, movement_data.speed)

#动画翻转
func _animator_flip(direction):
	if direction != 0:
		animator.flip_h = direction < 0
		animator.play("run")
	else:
		animator.play("idle")
	
func _handle_air_acceleration(direction, delta):
	if is_on_floor(): return 
	if direction != 0:
		velocity.x = move_toward(velocity.x,movement_data.speed * direction,movement_data.air_acceleration * delta)

func _is_change_game_over() -> void:
	if position.y <= -280 || position.y > 550:
		get_tree().current_scene.is_game_over = true
	

	
	
