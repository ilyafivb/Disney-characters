struct DisneyItem: Decodable {
    let name: String
    let url: String
    let imageUrl: String?
    let films: [String]
    let shortFilms: [String]
    let tvShows: [String]
    let sourceUrl: String?
}
