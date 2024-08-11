extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var attacking: bool = false
var crouching: bool = false
var is_in_knight_area: bool = false
var has_a_sword: bool = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if not attacking:
		if direction:
			velocity.x = direction * SPEED
			$AnimatedSprite2D.play("walk")
			if direction > 0:
				$AnimatedSprite2D.flip_h = false
			else:
				$AnimatedSprite2D.flip_h = true
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			$AnimatedSprite2D.play("idle")

	if Input.is_action_just_pressed("attack") and has_a_sword:
		attacking = true
		$AttackTimer.start()
		$AnimatedSprite2D.play("attack")

	if Input.is_action_pressed("crouch"):
		crouching = true
		$AnimatedSprite2D.modulate = Color(1, 1, 1, 0.502)
	else:
		crouching = false
		$AnimatedSprite2D.modulate = Color(1, 1, 1)

	if Input.is_action_just_pressed("pickpocket") and is_in_knight_area and crouching and not has_a_sword:
		$PickpocketTimer.start()

	if Input.is_action_pressed("pickpocket") and is_in_knight_area and crouching and not has_a_sword:
		$PickpocketCounter.visible = true
		$Label.text = str(int($PickpocketTimer.time_left) + 1)
	else:
		$PickpocketCounter.visible = false
		$PickpocketTimer.stop()

	move_and_slide()

func _on_attack_timer_timeout():
	attacking = false


func _on_pickpocket_timer_timeout():
	$PickpocketTimer.stop()
	$PickpocketCounter.visible = false
	has_a_sword = RandomNumberGenerator.new().randi_range(0,1)
	$Sword.visible = has_a_sword
