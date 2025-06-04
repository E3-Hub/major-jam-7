class_name CardLibrary
static var stats = ["movement_speed", "damage", "looting", "health", "max_health", "EXP_gain", "                                                    "]
static var card_rarity = [
    [1.0/21,"Mythic",[["increase","percent"],["increase","percent"]]],
    [2.0/21,"Legendary",[["increase","percent"],["increase","amount"]]],
    [3.0/21,"Epic",[["increase","amount"],["increase","amount"]]],
    [4.0/21,"Rare",[["increase","percent"],["decrease","amount"]]],
    [5.0/21,"Uncommon",[["increase","amount"],["decrease","amount"]]],
    [6.0/21,"Common",[["increase","amount"],["decrease","percent"]]],

]
static var card_valuse ={
    "movement_speed":{
        "amount_range": [5,90],
        "percent_range": [2, 22],
    },
    "damage":{
        "amount_range": [5,90],
        "percent_range": [2, 22],
    },
    "looting":{
        "amount_range": [5,90],
        "percent_range": [2, 22],
    },
    "health":{
        "amount_range": [5,90],
        "percent_range": [2, 22],
    },
    "max_health":{
        "amount_range": [5,90],
        "percent_range": [2, 22],
    },
    "EXP_gain":{
        "amount_range": [5,90],
        "percent_range": [2, 22],
    },
    "fire_rate":{
        "amount_range": [5,90],
        "percent_range": [2, 22],
    },
}

static var descriptions = {
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
    "increase_fire_rate": [
        "Your hands move with incredible speed.",
        "You fire with blinding precision.",
        "Your rhythm becomes a blur.",
        "There’s no pause between strikes."
    ],
    "decrease_fire_rate": [
        "Your actions feel sluggish and delayed.",
        "You hesitate before every attack.",
        "Each movement is labored.",
        "You feel jammed up inside."
    ]
}

static var all_cards: Array[Card] = [
        Card.new(
            0.1,
            " looting +(1) \n health +(5)",
            "The god of greed takes pity on you.",
            {
                "increase_looting": 1,
                "increase_health": 5,
            }
        ),
        Card.new(
            0.05,
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
            0.05,
            " looting +(1) \n health +(5)",
            "The god of greed takes pity on you.",
            {
                "increase_looting": 1,
                "increase_health": 5,
            }
        ),
]