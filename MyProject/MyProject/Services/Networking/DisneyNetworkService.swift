import Alamofire

class DisneyNetworkService {
    let baseUrl = "https://api.disneyapi.dev/"
    var page = 1
    private var searchItemsRequest: DataRequest?
    
    func getItems(completion: @escaping (Result<[DisneyItem], Error>) -> Void) {
        AF.request(baseUrl + "characters?page=\(page)")
            .responseDecodable(of: DisneyItemsArray.self, completionHandler: { response in
                switch response.result {
                case .success(let result):
                    completion(.success(result.data))
                    self.page += 1
                case .failure(let error):
                    completion(.failure(error))
                }
            })
    }
    
    func getSearchItems(name: String, completion: @escaping (Result<[DisneyItem], Error>) -> Void) {
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
