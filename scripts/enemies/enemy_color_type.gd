class_name EnemyColorType
enum {
    RED,
    GREEN,
    BLUE,
}

static func get_color(color: int) -> Color:
    match color:
        RED:
            return Color(0.9, 0.15, 0.15)
        GREEN:
            return Color(0.15, 0.9, 0.15)
        BLUE:
            return Color(0.1, 0.7, 1.0)
    return Color(1.0, 1.0, 1.0)

static func get_ghost_color(color: int) -> Color:
    match color:
        RED:
            return Color(0.8, 0.6, 0.6, 0.6)
        GREEN:
            return Color(0.6, 0.8, 0.6, 0.6)
        BLUE:
            return Color(0.2, 0.8, 0.9, 0.6)
    return Color(1.0, 1.0, 1.0, 0.6)