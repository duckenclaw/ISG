extends Control

var diceCategory = 4
var diceAmount = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	render_dice()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func render_dice():
	for dice in $configurationPanel/diceImagesContainer.get_children():
		$configurationPanel/diceImagesContainer.remove_child(dice)
	for dice in diceAmount:
		create_dice_image()

func create_dice_image():
	print("display dice")
	
	var diceAmountDisplay = $configurationPanel/configurationHbox/amountSpinnerContainer/diceAmountDisplay
	var diceCategoryDisplay = $configurationPanel/configurationHbox/diceSpinnerContainer/diceCategoryDisplay
	diceAmountDisplay.text = str(diceAmount)
	diceCategoryDisplay.text = "d" + str(diceCategory)
	
	var diceImagePath = "res://art/d" + str(diceCategory) + ".png"
	var diceImage = TextureRect.new()
	diceImage.texture = load(diceImagePath)
	
	var diceLabel = Label.new()
	diceLabel.text = str(randi_range(1, diceCategory))
	diceLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	diceLabel.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	diceImage.add_child(diceLabel)
		
	diceImage.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	diceImage.custom_minimum_size = Vector2(64,64)
		
	var texture_size = diceImage.get_size()
	diceLabel.custom_minimum_size = Vector2(64, 64)
	$configurationPanel/diceImagesContainer.add_child(diceImage)
	
	

func _amount_up():
	diceAmount += 1
	render_dice()


func _amount_down():
	diceAmount -= 1
	render_dice()


func _dice_up():
	if diceCategory < 8:
		diceCategory += 2
	render_dice()


func _dice_down():
	if diceCategory > 4:
		diceCategory -= 2
	render_dice()
