class_name EnemyColorType
enum {
    RED,
    GREEN,
    BLUE,
}

static func get_color(color: int) -> Color:
    match color:
        RED:
            return Color(1.0, 0.2, 0.2)
        GREEN:
            return Color(0.2, 1.0, 0.2)
        BLUE:
            return Color(0.2, 0.2, 1.0)
    return Color(1.0, 1.0, 1.0)