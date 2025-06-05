class_name CardLibrary

static var stats = ["movement_speed", "damage", "looting", "health", "max_health", "EXP_gain", "fire_rate_rpm"]
static var all_rarity_combination: Array[RarityCombination] = [
    RarityCombination.new(
        1.0/21,"Mythic",["increase","increase"]
    ),
    RarityCombination.new(
        2.0/21,"Legendary",["increase","increase"]
    ),
    RarityCombination.new(
        3.0/21,"Epic",["increase","increase"]
    ),
    RarityCombination.new(
        4.0/21,"Rare",["increase","decrease"]
    ),
    RarityCombination.new(
        5.0/21,"Uncommon",["increase","decrease"]
    ),
    RarityCombination.new(
        6.0/21,"Common",["increase","decrease"]
    ),
]
static var invert_rarity_line: float = 1.0/all_rarity_combination.size()   # at midle rarity (between rare and epic)
static var looting_to_rarity_factor: float = (2.0/13.0)/(21.0)
static func get_total_weight_rarity() -> float:
	var total = 0.0
	for r in all_rarity_combination:
		total += r.rarity
	return total
static var total_weight_rarity = get_total_weight_rarity()

static var values_type = ["amount","percent"]
static var values_increase_boundary_ratio_factor = {"Mythic":6,"Legendary":5,"Epic":4,"Rare":3,"Uncommon":2,"Common":1}
static var values_decrease_boundary_ratio_factor = {"Rare":1,"Uncommon":2,"Common":3}
static var card_values_range ={
    "movement_speed":{
        "amount_range": [5, 30],
        "percent_range": [1, 10],
    },
    "damage":{
        "amount_range": [5, 47],
        "percent_range": [5, 470],
    },
    "looting":{
        "amount_range": [1, 13],
        "percent_range": [2, 30],
    },
    "health":{
        "amount_range": [5,90],
        "percent_range": [5, 90],
    },
    "max_health":{
        "amount_range": [5,50],
        "percent_range": [5, 50],
    },
    "EXP_gain":{
        "amount_range": [1,20],
        "percent_range": [5, 100],
    },
    "fire_rate_rpm":{
        "amount_range": [100, 1000],
        "percent_range": [30, 300],
    },
}
# test data
static var all_cards: Array[Card] = [
        Card.new(
            6.0/21,
            "Common",
            " looting +(1) \n health +(5)",
            "The god of greed takes pity on you.",
            {
                "increase_looting": 1,
                "increase_health": 5,
            }
        ),
        Card.new(
            5.0/21,
            "Uncommon",
            " looting +(4) \n health +(5)",
            "The god of greed shows mercy upon you.",
            {
                "increase_looting": 4,
                "increase_health": 5,
            }
        ),
]

static var boss_cards: Array[Card] = [
        Card.new(
            2.0/21,
            "Boss",
            " looting +(1) \n health +(5)",
            "The god of greed takes pity on you.",
            {
                "increase_looting": 1,
                "increase_health": 5,
            }
        ),
]

static var descriptions: Dictionary[String, Array]= {
    "increase_movement_speed": [
        "You feel wind at your back.",
        "Your feet barely touch the ground.",
        "The world slows down around you.",
        "Speed becomes your second nature."
    ],
    "decrease_movement_speed": [
        "Your legs feel like stone.",
        "Each step is a struggle.",
        "Time catches up with you.",
        "Slowness creeps into your bones."
    ],
    "increase_damage": [
        "A surge of power flows through your arms.",
        "You strike with overwhelming force.",
        "Your enemies tremble before your might.",
        "You feel unstoppable fury."
    ],
    "decrease_damage": [
        "Your blows lack force.",
        "You can barely dent a wall.",
        "Your strength falters.",
        "You feel your power draining away."
    ],
    "increase_looting": [
        "Greed sharpens your senses.",
        "You spot treasure more easily than before.",
        "You feel guided to riches.",
        "Even crumbs of gold catch your eye."
    ],
    "decrease_looting": [
        "Your pockets feel unusually empty.",
        "Opportunities slip through your fingers.",
        "The world hides its wealth from you.",
        "You overlook valuable loot."
    ],
    "increase_health": [
        "Vitality surges within you.",
        "You feel rejuvenated.",
        "Your wounds seal faster than ever.",
        "Life returns to your limbs."
    ],
    "decrease_health": [
        "You feel weaker with each breath.",
        "Every hit hurts more than it should.",
        "Fatigue sets in quickly.",
        "You feel the fragility in your body."
    ],
    "increase_max_health": [
        "Your body grows more resilient.",
        "You can endure more than before.",
        "You feel fortified.",
        "You're harder to bring down."
    ],
    "decrease_max_health": [
        "You feel more fragile than before.",
        "Your limits shrink.",
        "You can not take as much punishment.",
        "Your resilience fades."
    ],
    "increase_EXP_gain": [
        "Your mind absorbs knowledge like a sponge.",
        "Lessons stick faster than ever.",
        "Every action teaches you more.",
        "Your learning accelerates."
    ],
    "decrease_EXP_gain": [
        "You struggle to learn from your actions.",
        "Knowledge slips through your mind.",
        "You retain little from experience.",
        "Your progress slows to a crawl."
    ],
    "increase_fire_rate_rpm": [
        "Your hands move with incredible speed.",
        "You fire with blinding precision.",
        "Your rhythm becomes a blur.",
        "There is no pause between strikes."
    ],
    "decrease_fire_rate_rpm": [
        "Your actions feel sluggish and delayed.",
        "You hesitate before every attack.",
        "Each movement is labored.",
        "You feel jammed up inside."
    ]
}