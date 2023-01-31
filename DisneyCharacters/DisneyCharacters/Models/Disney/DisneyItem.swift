protocol DisneyItemable {
    var name: String { get }
    var url: String { get }
    var imageUrl: String? { get }
    var films: [String] { get }
    var shortFilms: [String] { get }
    var tvShows: [String] { get }
}

struct DisneyItem: DisneyItemable, Decodable {
    let name: String
    let url: String
    let imageUrl: String?
    let films: [String]
    let shortFilms: [String]
    let tvShows: [String]
}
