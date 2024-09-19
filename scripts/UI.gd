extends Control

var playerObject
var enemyObject

func _ready():
	playerObject = $Player
	enemyObject = $Enemy
	prepare_enemy()
	update_ui()

func _process(delta):
	if Input.is_action_just_pressed("Weapon Up"):
		_attack_amount_up()
	if Input.is_action_just_pressed("Weapon Down"):
		_attack_amount_down()
	if Input.is_action_just_pressed("Weapon Dice Category Up"):
		_attack_dice_up()
	if Input.is_action_just_pressed("Weapon Dice Category Down"):
		_attack_dice_down()
	if Input.is_action_just_pressed("Defense Up"):
		_defense_amount_up()
	if Input.is_action_just_pressed("Defense Down"):
		_defense_amount_down()
	if Input.is_action_just_pressed("Defense Dice Category Up"):
		_defense_dice_up()
	if Input.is_action_just_pressed("Defense Dice Category Down"):
		_defense_dice_down()
	if Input.is_action_just_pressed("ui_accept"):
		_end_turn_pressed()

func prepare_enemy():
	var enemies = ["Voltex", "Bithrexian"]
	var enemy = enemies[randi_range(0, len(enemies) - 1)]
	var enemyScriptPath = "res://scripts/enemies/" + enemy + ".gd"
	var enemyTexturePath = "res://art/" + enemy + ".png"
	enemyObject.set_script(load(enemyScriptPath))
	enemyObject.get_children()[0].texture = load(enemyTexturePath)

func update_ui():
	$configurationPanel/attackConfigurationHbox/amountSpinnerContainer/diceAmountDisplay.text = str(playerObject.weaponPP)
	$configurationPanel/attackConfigurationHbox/diceSpinnerContainer/diceCategoryDisplay.text = str(playerObject.weaponDiceCategory)
	$configurationPanel/defenseConfigurationHbox/amountSpinnerContainer/diceAmountDisplay.text = str(playerObject.defensePP)
	$configurationPanel/defenseConfigurationHbox/diceSpinnerContainer/diceCategoryDisplay.text = str(playerObject.defenseDiceCategory)
	$configurationPanel/particlePointsDisplay.text = str(playerObject.particlePoints)
	$Player/Health.text = str(playerObject.hp)
	
	$Enemy/Health.text = str(enemyObject.hp)
	render_dice(true, true)
	render_dice(false, true)
	render_dice(true, false)
	render_dice(false, false)

func render_dice(isAttack, isPlayer):
	var diceImagesContainer
	var diceImagePath
	var dices
	
	if isAttack:
		if isPlayer:
			diceImagesContainer = $configurationPanel/attackDiceImagesContainer
			diceImagePath = "res://art/d" + str(playerObject.weaponDiceCategory) + ".png"
			dices = playerObject.weaponDices
		else:
			diceImagesContainer = $EnemyPanel/attackDiceImagesContainer
			diceImagePath = "res://art/d" + str(enemyObject.weaponDiceCategory) + ".png"
			dices = enemyObject.weaponDices
	else:
		if isPlayer:
			diceImagesContainer = $configurationPanel/defenseDiceImagesContainer
			diceImagePath = "res://art/d" + str(playerObject.defenseDiceCategory) + ".png"
			dices = playerObject.defenseDices
		else:
			diceImagesContainer = $EnemyPanel/defenseDiceImagesContainer
			diceImagePath = "res://art/d" + str(enemyObject.defenseDiceCategory) + ".png"
			dices = enemyObject.defenseDices
	for dice in diceImagesContainer.get_children():
		diceImagesContainer.remove_child(dice)
	for dice in dices:
		create_dice_image(diceImagesContainer, diceImagePath, isAttack)
		
func render_results(dices, isAttack, isPlayer):
	var diceImagesContainer
	if isAttack:
		if isPlayer:
			diceImagesContainer = $configurationPanel/attackDiceImagesContainer
		else:
			diceImagesContainer = $EnemyPanel/attackDiceImagesContainer
	else:
		if isPlayer:
			diceImagesContainer = $configurationPanel/defenseDiceImagesContainer
		else:
			diceImagesContainer = $EnemyPanel/defenseDiceImagesContainer
	var i = 0
	for dice in diceImagesContainer.get_children():
		dice.get_children()[0].text = str(dices[i])
		i += 1

func create_dice_image(diceImagesContainer, diceImagePath, isAttack):
	var diceImage = TextureRect.new()
	diceImage.texture = load(diceImagePath)
	
	var diceLabel = Label.new()
	diceLabel.text = "?"
	diceLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	diceLabel.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	diceImage.add_child(diceLabel)
		
	diceImage.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	diceImage.custom_minimum_size = Vector2(64,64)
		
	var texture_size = diceImage.get_size()
	diceLabel.custom_minimum_size = Vector2(64, 64)
	diceImagesContainer.add_child(diceImage)


func _attack_amount_up():
	if playerObject.particlePoints > 0:
		playerObject.particlePoints -= 1
		playerObject.weaponPP += 1
	playerObject.recalculate_attack()
	update_ui()


func _attack_amount_down():
	if playerObject.weaponPP > 1:
		playerObject.particlePoints += 1
		playerObject.weaponPP -= 1
	playerObject.recalculate_attack()
	update_ui()


func _attack_dice_up():
	if playerObject.weaponDiceCategory < 12:
		playerObject.weaponDiceCategory += 2
	playerObject.recalculate_attack()
	update_ui()


func _attack_dice_down():
	if playerObject.weaponDiceCategory > 4:
		playerObject.weaponDiceCategory -= 2
	playerObject.recalculate_attack()
	update_ui()


func _defense_amount_up():
	if playerObject.particlePoints > 0:
		playerObject.particlePoints -= 1
		playerObject.defensePP += 1
	playerObject.recalculate_defense()
	update_ui()


func _defense_amount_down():
	if playerObject.defensePP > 0:
		playerObject.particlePoints += 1
		playerObject.defensePP -= 1
	playerObject.recalculate_defense()
	update_ui()


func _defense_dice_up():
	if playerObject.defenseDiceCategory < 12:
		playerObject.defenseDiceCategory += 2
	playerObject.recalculate_defense()
	update_ui()


func _defense_dice_down():
	if playerObject.defenseDiceCategory > 4:
		playerObject.defenseDiceCategory -= 2
	playerObject.recalculate_defense()
	update_ui()
	
func deal_damage(damageResults, target):
	for result in damageResults:
		target.hp -= result
		print("dealt " + str(result) + " damage to " + str(target))
		print(str(target.hp))

func _end_turn_pressed():
	var playerAttackResults = playerObject.roll_damage()
	var playerDefenseResults = playerObject.roll_defense()
	var enemyAttackResults = enemyObject.roll_damage()
	var enemyDefenseResults = enemyObject.roll_defense()
	var newPlayerAttackResults = []
	var newEnemyAttackResults = []
	var scaleIncrease = 1
	render_results(playerAttackResults, true, true)
	render_results(playerDefenseResults, false, true)
	render_results(enemyAttackResults, true, false)
	render_results(enemyDefenseResults, false, false)
	for playerDice in len(playerAttackResults):
		var playerResult = playerAttackResults[playerDice]
		var enemyDice = enemyDefenseResults.find(playerResult)
		if playerResult in enemyDefenseResults:
			await get_tree().create_timer(1.0).timeout
			$configurationPanel/attackDiceImagesContainer.get_children()[playerDice].scale.x += scaleIncrease
			$configurationPanel/attackDiceImagesContainer.get_children()[playerDice].scale.y += scaleIncrease
			$EnemyPanel/defenseDiceImagesContainer.get_children()[enemyDice].scale.x += scaleIncrease
			$EnemyPanel/defenseDiceImagesContainer.get_children()[enemyDice].scale.y += scaleIncrease
			await get_tree().create_timer(1.0).timeout
			$configurationPanel/attackDiceImagesContainer.get_children()[playerDice].scale.x -= scaleIncrease
			$configurationPanel/attackDiceImagesContainer.get_children()[playerDice].scale.y -= scaleIncrease
			$EnemyPanel/defenseDiceImagesContainer.get_children()[enemyDice].scale.x -= scaleIncrease
			$EnemyPanel/defenseDiceImagesContainer.get_children()[enemyDice].scale.y -= scaleIncrease
			await get_tree().create_timer(0.5).timeout
			$configurationPanel/attackDiceImagesContainer.get_children()[playerDice].queue_free()
			$EnemyPanel/defenseDiceImagesContainer.get_children()[enemyDice].queue_free()
		else:
			newPlayerAttackResults.append(playerResult)
	
	for enemyDice in len(enemyAttackResults):
		var enemyResult = enemyAttackResults[enemyDice]
		var playerDice = enemyDefenseResults.find(enemyResult)
		if enemyResult in playerDefenseResults:
			await get_tree().create_timer(1.0).timeout
			$EnemyPanel/defenseDiceImagesContainer.get_children()[enemyDice].scale.x += scaleIncrease
			$EnemyPanel/defenseDiceImagesContainer.get_children()[enemyDice].scale.y += scaleIncrease
			$configurationPanel/attackDiceImagesContainer.get_children()[playerDice].scale.x += scaleIncrease
			$configurationPanel/attackDiceImagesContainer.get_children()[playerDice].scale.y += scaleIncrease
			await get_tree().create_timer(1.0).timeout
			$EnemyPanel/defenseDiceImagesContainer.get_children()[enemyDice].scale.x -= scaleIncrease
			$EnemyPanel/defenseDiceImagesContainer.get_children()[enemyDice].scale.y -= scaleIncrease
			$configurationPanel/attackDiceImagesContainer.get_children()[playerDice].scale.x -= scaleIncrease
			$configurationPanel/attackDiceImagesContainer.get_children()[playerDice].scale.y -= scaleIncrease
			await get_tree().create_timer(0.5).timeout
			$EnemyPanel/defenseDiceImagesContainer.get_children()[enemyDice].queue_free()
			$configurationPanel/attackDiceImagesContainer.get_children()[playerDice].queue_free()
		else:
			newEnemyAttackResults.append(enemyResult)
				
	print("player's final rolls")
	print(newPlayerAttackResults)
	print("enemy's final rolls")
	print(newEnemyAttackResults)
	deal_damage(newPlayerAttackResults, enemyObject)
	deal_damage(newEnemyAttackResults, playerObject)
