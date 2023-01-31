protocol KinopoiskSearchItemable {
    var nameEn: String? { get }
    var filmId: Int { get }
}

struct KinopoiskSearchItem: KinopoiskSearchItemable, Decodable {
    let nameEn: String?
    let filmId: Int
}
