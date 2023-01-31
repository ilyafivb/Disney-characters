protocol KinopoiskItemable: Decodable {
    var nameEn: String? { get }
    var nameOriginal: String? { get }
    var posterUrl: String? { get }
    var webUrl: String? { get }
}

struct KinopoiskItem: KinopoiskItemable, Decodable {
    var nameEn: String?
    var nameOriginal: String?
    var posterUrl: String?
    var webUrl: String?
}
