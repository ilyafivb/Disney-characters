import Alamofire

class NetworkService {
    func getCharacters(completion: @escaping (Result<[Character], Error>) -> Void) {
        let request = AF.request("https://www.breakingbadapi.com/api/characters")
        request.responseDecodable(of: [Character].self, completionHandler: { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
