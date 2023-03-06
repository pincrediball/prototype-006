extends Node2D

var activate_started_at = Time.get_ticks_msec()
var score = 0

@onready
var bg = get_node("MyBgRect")

@onready
var ball: RigidBody2D = get_node("Ball")

@onready
var ceiling: StaticBody2D = get_node("Ceiling")

@onready
var scoreText = get_node("ScoreText")

@onready
var floorY = get_node("Floor").position.y

@onready
var maxDistanceForBall = floorY - 20

func update_score(newScore: int):
	score = newScore
	scoreText.text = "SCORE: %s" % score

func _process(delta):
	var currentDistance = floorY - ball.position.y + (ball.get_node("CollisionShape2D").shape.radius)
	var newScore = int(currentDistance / maxDistanceForBall * 100)
	var isMovingUp = ball.linear_velocity.y < 0
	if newScore > score && isMovingUp:
		update_score(newScore)

func _physics_process(delta):
	var diff = Time.get_ticks_msec() - activate_started_at
	var factor = minf(diff / 2000.0, 1.0)
	
	if Input.is_action_just_pressed("activate"):
		activate_started_at = Time.get_ticks_msec()
	
	if Input.is_action_just_released("activate"):
		bg.color = Color(0, 0.1, 0.2, 0.25)
		ball.linear_velocity = Vector2(0, -2200 * factor)
	
	if Input.is_action_pressed("activate"):
		bg.color = Color(255, 0, 0, factor * 0.25)

func _on_ball_body_entered(body):
	if ceiling.get_instance_id() == body.get_instance_id():
		update_score(0)

