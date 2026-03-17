extends CharacterBody2D

@export var speed:float = 100
@export var animator:AnimatedSprite2D
@export var initial_jump_velocity:float = 505 #跳跃初速度
@export var gravity:float = 980 #重力加速度

@export var BodyCollecter:Area2D
@export var FootDetecter:Area2D

var is_on_blocks:bool = false
var score:int = 0

func _on_body_collector_entered(body):
	if body.is_in_group("fruits"):
		body.queue_free()
		score +=1

#检测脚部是否在平板上
func _on_foot_entered(body):
	if body.is_in_group("blocks"):
		is_on_blocks = true

#检测脚部是否离开平板
func _on_foot_exited(body):
	if body.is_in_group("blocks"):
		is_on_blocks = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var horizantal = Input.get_axis("left","right")
	velocity.x = horizantal * speed
	
	#处理图片翻转
	if horizantal != 0:
		animator.flip_h = (horizantal < 0) #当速度向左时图片翻转向左
		
	#左右跑动
	if velocity.x == 0:
		animator.play("idle")
	elif velocity.x != 0:
		animator.play("run")
		
	#检查是否满足跳跃条件，赋值初速度
	if Input.is_action_just_pressed("jump") and is_on_blocks:
		velocity.y = -initial_jump_velocity
		is_on_blocks = false
	
	velocity.y += gravity * delta
	if is_on_floor():
		velocity.y = 0
	
	move_and_slide()
