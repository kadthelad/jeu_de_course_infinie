extends CanvasLayer

@onready var slot_1_button: Button = %Slot1Button
@onready var slot_2_button: Button = %Slot2Button
@onready var slot_3_button: Button = %Slot3Button

@onready var player_inventory_item_list: ItemList = %PlayerInventoryItemList

var selected_item: GameItem = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_ui()
	
	# Setup slot buttons
	slot_1_button.pressed.connect(set_slot_button.bind(0))
	slot_2_button.pressed.connect(set_slot_button.bind(1))
	slot_3_button.pressed.connect(set_slot_button.bind(2))

func update_ui() -> void:
	# Update inventory
	player_inventory_item_list.clear()
	for item: GameItem in GameManager.player_inventory:
		player_inventory_item_list.add_item("%s [%s]" % [item.i_name, GameManager.player_inventory[item]], item.icon)
		player_inventory_item_list.set_item_metadata(player_inventory_item_list.item_count-1, item)
	
	# Update equipped items
	update_slot_button(slot_1_button, 0)
	update_slot_button(slot_2_button, 1)
	update_slot_button(slot_3_button, 2)

func update_slot_button(slot_button: Button, slot_number: int) -> void:
	var equipped_item: GameItem = GameManager.player_hotbar[slot_number]
	if equipped_item != null:
		slot_button.text = "%s %s\n[%s] (%s)" % [tr("inventory_equip"), str(slot_number+1), equipped_item.i_name,
		GameManager.player_inventory[equipped_item]]
	else:
		slot_button.text = "%s %s" % [tr("inventory_equip"), str(slot_number+1)]


func _on_player_inventory_item_list_item_selected(index: int) -> void:
	selected_item = player_inventory_item_list.get_item_metadata(index)

func set_slot_button(slot_number: int) -> void:
	if selected_item == null:
		return
	if GameManager.player_hotbar.has(selected_item): # Check if item already equipped
		# If item already equipped, switch the slots
		GameManager.player_hotbar[GameManager.player_hotbar.find(selected_item)] = GameManager.player_hotbar[slot_number]
	GameManager.player_hotbar[slot_number] = selected_item
	
	# Save changes
	DataUtils.save_player_data()
	update_ui()

func _on_back_button_pressed() -> void:
	queue_free()
