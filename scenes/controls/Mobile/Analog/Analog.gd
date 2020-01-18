extends Node2D

const INACTIVE_IDX = -1;
export var isDynamicallyShowing = false

var ball
var bg 
var parent
var listenerNode

var centerPoint = Vector2(0,0)
var currentForce = Vector2(0,0)
var halfSize = Vector2()
var ballPos = Vector2()
var squaredHalfSizeLength = 0
var currentPointerIDX = INACTIVE_IDX

var incomingPointer

# NEEDFIX: El valor force en Y necesita ser arreglado,
# ya que esta invertido.
signal current_force_updated(force)

func _ready():
	set_process_input(true)
	
	bg = $Background
	ball = $Center
	parent = get_parent()
	halfSize = bg.texture.get_size()/2
	squaredHalfSizeLength = halfSize.x * halfSize.y

	if isDynamicallyShowing:
		modulate.a = 0

func get_force():
	return currentForce
	
func _input(event):
	incomingPointer = extractPointerIdx(event)
	
	if incomingPointer == INACTIVE_IDX or event is InputEventScreenTouch and event.get_index() != 1:
		return
	
	if need2ChangeActivePointer(event):
		if (currentPointerIDX != incomingPointer) and event.is_pressed():
			currentPointerIDX = incomingPointer
			showAtPos(Vector2(event.position.x, event.position.y))

	var theSamePointer = currentPointerIDX == incomingPointer
	if isActive() and theSamePointer:
		process_input(event)

func need2ChangeActivePointer(event): #touch down inside analog	
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if isDynamicallyShowing:
			#print(get_parent().get_global_rect())
			return get_parent().get_global_rect().has_point(Vector2(event.position.x, event.position.y))
		else:
			var length = (global_position - Vector2(event.position.x, event.position.y)).length_squared();
			return length < squaredHalfSizeLength
	else:
		return false

func isActive():
	return currentPointerIDX != INACTIVE_IDX

func extractPointerIdx(event):
	var touch = event is InputEventScreenTouch
	var drag = event is InputEventScreenDrag
	var mouseButton = event is InputEventMouseButton
	var mouseMove = event is InputEventMouseMotion
	
	if touch or drag:
		return 1
	elif mouseButton or mouseMove:
		return 0
	else:
		return INACTIVE_IDX
		
func process_input(event):
#	if not touched:
#		return
	
	calculateForce(event.position.x - global_position.x, event.position.y - global_position.y)
	updateBallPos()
	
	var isReleased = isReleased(event)
	if isReleased:
		reset()

func reset():
	currentPointerIDX = INACTIVE_IDX
	calculateForce(0, 0)

	if isDynamicallyShowing:
		hide()
	else:
		updateBallPos()

func showAtPos(pos):
	if isDynamicallyShowing:
#		animation_player.play("alpha_in", 0.2)
		global_position = pos
	
func hide():
#	animation_player.play("alpha_out", 0.2) 
	pass

func updateBallPos():
	ballPos.x = halfSize.x * currentForce.x #+ halfSize.x
	ballPos.y = halfSize.y * -currentForce.y #+ halfSize.y
	ball.position = Vector2(ballPos.x, ballPos.y)

func calculateForce(var x, var y):
	currentForce.x = (x - centerPoint.x) / halfSize.x
	currentForce.y = - (y - centerPoint.y) / halfSize.y # xd
	
	if currentForce.length_squared() > 1:
		currentForce = currentForce/currentForce.length()
	
	emit_signal("current_force_updated", currentForce)

func isPressed(event):
	if event is InputEventMouseMotion:
		return (InputEventMouse.button_mask == 1)
	elif event is InputEventScreenTouch:
		return event.is_pressed()

func isReleased(event):
	if event is InputEventScreenTouch:
		return !event.is_pressed()
	elif event is InputEventMouseButton:
		return !event.is_pressed()
