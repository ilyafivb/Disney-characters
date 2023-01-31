import Alamofire

protocol DisneyNetworkable {
    var isPaginating: Bool { get set }
    var baseUrl: String { get }
    func getItems(completion: @escaping (Result<[DisneyItemable], Error>) -> Void)
    func getSearchItems(name: String, completion: @escaping (Result<[DisneyItemable], Error>) -> Void)
}

class DisneyNetwork: DisneyNetworkable {
    let baseUrl = "https://api.disneyapi.dev/"
    private var page = 1
    private var searchItemsRequest: DataRequest?
    var isPaginating = false
    
    func getItems(completion: @escaping (Result<[DisneyItemable], Error>) -> Void) {
        isPaginating = true
        AF.request(baseUrl + "characters?page=\(page)")
            .responseDecodable(of: DisneyItemsArray.self, completionHandler: { response in
                switch response.result {
                case .success(let result):
                    completion(.success(result.data))
                    self.page += 1
                    self.isPaginating = false
                case .failure(let error):
                    completion(.failure(error))
                    self.isPaginating = false
                }
            })
    }
    
    func getSearchItems(name: String, completion: @escaping (Result<[DisneyItemable], Error>) -> Void) {
        searchItemsRequest?.cancel()
        searchItemsRequest = AF.request(baseUrl + "character?name=\(name)")
            .responseDecodable(of: DisneyItemsArray.self, completionHandler: { response in
                switch response.result {
                case .success(let result):
                    completion(.success(result.data))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
    }
}
