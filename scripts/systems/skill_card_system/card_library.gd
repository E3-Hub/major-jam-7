class_name CardLibrary

static var all_cards: Array[Card] = [
        Card.new(
            0.1,
            "looting +1",
            "The god of greed takes pity on you.",
            Callable(CardLibrary, "apply_looting_plus_one")
        ),
]

static func apply_looting_plus_one(game_manager: GameManager) -> void:
    game_manager.player.looting += 1
    print("player looting:",game_manager.player.looting)


