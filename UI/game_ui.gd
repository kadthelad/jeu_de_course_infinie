class_name GameUI
extends CanvasLayer

const INVENTORY_SLOT_SCENE := preload("res://UI/inventory_slot.tscn")

@onready var coin_label: Label = %CoinLabel
@onready var speed_label: Label = %SpeedLabel
@onready var equipped_items: HBoxContainer = %EquippedItems
@onready var player: Player = GameManager.player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.player_input_component.use_item.connect(update_hotbar_progress)
	
	GameManager._update_game_ui.connect(update_ui)
	update_ui()
	update_ui_one_shot()

func update_ui() -> void:
	coin_label.text = "%s: %s" % [tr("game_coins"), str(GameManager.current_coins)]
	speed_label.text = "%s: %s" % [tr("game_speed"), str(int(GameManager.game_speed))]

# This is for UI elements that require being updated only once during the gameplay
func update_ui_one_shot() -> void:
	# Player's hotbar
	if equipped_items.get_children().size() > 0:
		for inventory_slot in equipped_items.get_children():
			inventory_slot.queue_free()
	for item: GameItem in GameManager.player_hotbar:
		if item != null:
			var instantiated_inventory_slot: InventorySlot = INVENTORY_SLOT_SCENE.instantiate()
			equipped_items.add_child(instantiated_inventory_slot)
			instantiated_inventory_slot.image_texture_rect.texture = item.icon
			instantiated_inventory_slot.number_label.text = str(GameManager.player_hotbar.find(item)+1)
			instantiated_inventory_slot.quantity_label.text = str(GameManager.player_inventory[item])
			instantiated_inventory_slot.set_meta("item_effect_duration", item.effect.effect_duration)
			instantiated_inventory_slot.set_meta("hotbar_number", GameManager.player_hotbar.find(item))

func update_hotbar_progress(hotbar_nb) -> void:
	if equipped_items.get_children().size() > 0:
		for inventory_slot: InventorySlot in equipped_items.get_children():
			if inventory_slot.get_meta("hotbar_number") == hotbar_nb and inventory_slot.player_effect_timer.is_stopped():
				inventory_slot.player_effect_timer.wait_time = inventory_slot.get_meta("item_effect_duration")
				inventory_slot.player_effect_timer.start()
				return
		#PrintUtils.print_dbg("No item found with hotbar number " + str(hotbar_nb))
