extends CharacterBody2D

@export var movement_data : PlayerMovementData

@export var animator : AnimatedSprite2D

func _physics_process(delta: float) -> void:
	_jump_and_fall(delta)
	_handle_jump()
	var direction := Input.get_axis("left", "right")
	_axis_move(direction)
	_animator_flip(direction)
	#设置土狼时间
	#当角色移动时满足：移动前（move_and_slide()) 在地板上，移动后不位于地板上且向下落时。触发土狼时间
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		$CoyoteTime.start()
	

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
	if is_on_floor() or $CoyoteTime.time_left > 0.0:
		if Input.is_action_just_pressed("jump"):
			velocity.y = movement_data.jump_velocity
	
	#if not is_on_floor():
		#if Input.is_action_just_pressed("jump") and velocity.y < movement_data.jump_velocity/2:
			#velocity.y = movement_data.jump_velocity/2
		

#水平移动
func _axis_move(direction):
	if direction:
		velocity.x = direction * movement_data.speed
		#velocity.x = move_toward(velocity.x,SPEED * direction,ACCELERATION * delta)
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
	
