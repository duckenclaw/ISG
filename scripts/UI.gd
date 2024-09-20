extends Control

var playerObject
var enemyObject
@export var scaleIncrease = 1

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
	$Enemy/EnemyHealth.max_value = enemyObject.hp

func update_ui():
	$configurationPanel/attackConfigurationHbox/amountSpinnerContainer/diceAmountDisplay.text = str(playerObject.weaponPP)
	$configurationPanel/attackConfigurationHbox/diceSpinnerContainer/diceCategoryDisplay.text = str(playerObject.weaponDiceCategory)
	$configurationPanel/defenseConfigurationHbox/amountSpinnerContainer/diceAmountDisplay.text = str(playerObject.defensePP)
	$configurationPanel/defenseConfigurationHbox/diceSpinnerContainer/diceCategoryDisplay.text = str(playerObject.defenseDiceCategory)
	$configurationPanel/particlePointsDisplay.text = str(playerObject.particlePoints)
	$Player/Health.text = str(playerObject.hp)
	$Player/PlayerHealth.value = playerObject.hp
	
	$Enemy/Health.text = str(enemyObject.hp)
	$Enemy/EnemyHealth.value = enemyObject.hp
	
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
		print("dealt " + str(result) + " damage to " + target.name)
		print(target.name + "HP: " + str(target.hp))
		
func delete_dice(attackDiceContainer, defenseDiceContainer, attackDice, defenseDice):
	attackDiceContainer[attackDice].scale.x += scaleIncrease
	attackDiceContainer[attackDice].scale.y += scaleIncrease
	defenseDiceContainer[defenseDice].scale.x += scaleIncrease
	defenseDiceContainer[defenseDice].scale.y += scaleIncrease
	await get_tree().create_timer(1.0).timeout
	attackDiceContainer[attackDice].scale.x -= scaleIncrease
	attackDiceContainer[attackDice].scale.y -= scaleIncrease
	defenseDiceContainer[defenseDice].scale.x -= scaleIncrease
	defenseDiceContainer[defenseDice].scale.y -= scaleIncrease
	await get_tree().create_timer(0.5).timeout
	attackDiceContainer[attackDice].visible = !attackDiceContainer[attackDice].visible
	defenseDiceContainer[defenseDice].visible = !defenseDiceContainer[defenseDice].visible

func _end_turn_pressed():
	var playerAttackResults = playerObject.roll_damage()
	var playerDefenseResults = playerObject.roll_defense()
	var enemyAttackResults = enemyObject.roll_damage()
	var enemyDefenseResults = enemyObject.roll_defense()
	var newPlayerAttackResults = []
	var newEnemyAttackResults = []
	render_results(playerAttackResults, true, true)
	render_results(playerDefenseResults, false, true)
	render_results(enemyAttackResults, true, false)
	render_results(enemyDefenseResults, false, false)
	
	# Match and remove attack and defense rolls for the player
	var usedDefenseIndices = []  # Track defense rolls that have been used
	for i in range(playerAttackResults.size()):
		var attack = playerAttackResults[i]
		var defenseIndex = -1
		
		# Find a matching defense roll that hasn't already been used
		for j in range(enemyDefenseResults.size()):
			if attack == enemyDefenseResults[j] and not j in usedDefenseIndices:
				defenseIndex = j
				break

		if defenseIndex != -1:
			usedDefenseIndices.append(defenseIndex)  # Mark this defense roll as used
			enemyDefenseResults.erase(defenseIndex)  # Remove matched defense roll
			delete_dice($configurationPanel/attackDiceImagesContainer.get_children(), $EnemyPanel/defenseDiceImagesContainer.get_children(), i, defenseIndex)  # Remove dice visuals
		else:
			newPlayerAttackResults.append(attack)  # Unmatched attack goes into newPlayerAttackResults

	# Match and remove attack and defense rolls for the enemy
	var usedPlayerDefenseIndices = []  # Track player's defense rolls that have been used
	for i in range(enemyAttackResults.size()):
		var attack = enemyAttackResults[i]
		var defenseIndex = -1
		
		# Find a matching defense roll that hasn't already been used
		for j in range(playerDefenseResults.size()):
			if attack == playerDefenseResults[j] and not j in usedPlayerDefenseIndices:
				defenseIndex = j
				break
		
		if defenseIndex != -1:
			usedPlayerDefenseIndices.append(defenseIndex)  # Mark this defense roll as used
			playerDefenseResults.erase(defenseIndex)  # Remove matched defense roll
			delete_dice($EnemyPanel/attackDiceImagesContainer.get_children(), $configurationPanel/defenseDiceImagesContainer.get_children(), i, defenseIndex)  # Remove dice visuals
		else:
			newEnemyAttackResults.append(attack)  # Unmatched attack goes into newEnemyAttackResults

	
	#for playerDice in len(playerAttackResults):
		#var playerResult = playerAttackResults[playerDice]
		#var enemyDice = enemyDefenseResults.find(playerResult)
		#print("enemyDice: " + str(enemyDice))
		#if playerResult in enemyDefenseResults:
			#playerAttackResults.erase(playerDice)
			#enemyAttackResults.erase(enemyDice)
			#delete_dice($configurationPanel/attackDiceImagesContainer.get_children(), $EnemyPanel/defenseDiceImagesContainer.get_children(), playerDice, enemyDice)
		#else:
			#newPlayerAttackResults.append(playerResult)
	#
	#for enemyDice in len(enemyAttackResults):
		#var enemyResult = enemyAttackResults[enemyDice]
		#var playerDice = playerDefenseResults.find(enemyResult)
		#print("playerDice: " + str(playerDice))
		#if enemyResult in playerDefenseResults:
			#enemyAttackResults.erase(enemyDice)
			#playerAttackResults.erase(playerDice)
			#delete_dice($EnemyPanel/attackDiceImagesContainer.get_children(), $configurationPanel/defenseDiceImagesContainer.get_children(), enemyDice, playerDice)
		#else:
			#newEnemyAttackResults.append(enemyResult)
				
	print("player's final rolls")
	print(newPlayerAttackResults)
	print("enemy's final rolls")
	print(newEnemyAttackResults)
	deal_damage(newPlayerAttackResults, enemyObject)
	deal_damage(newEnemyAttackResults, playerObject)
	await get_tree().create_timer(2.0).timeout
	update_ui()
