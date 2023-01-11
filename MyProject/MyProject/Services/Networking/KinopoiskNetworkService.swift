import Alamofire

class KinopoiskNetworkService {
    let baseUrl = "https://kinopoiskapiunofficial.tech/api/v2.1/films/"
    private var searchItemsRequest: DataRequest?
    
    func getSearchItems(name: String, completion: @escaping (Result<[KinopoiskSearchItem], Error>) -> Void) {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "X-API-KEY": "b74d9e39-d1b8-4000-8d92-7bd750086814"
        ]
        var newName = ""
        name.forEach { char in
            if char == " " {
                newName.append("%")
                newName.append("2")
                newName.append("0")
            } else if char == ":" {
                newName.append("%")
                newName.append("3")
                newName.append("A")
            } else {
                newName.append(char)
            }
        }
        
        AF.request(baseUrl + "search-by-keyword?keyword=\(newName)&page=1", headers: headers)
            .responseDecodable(of: KinopoiskItemsArray.self, completionHandler: { response in
                switch response.result {
                case .success(let result):
                    completion(.success(result.films))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
    }
    
    func getItem(id: Int, completion: @escaping (Result<KinopoiskItem, Error>) -> Void) {
        let baseUrl = "https://kinopoiskapiunofficial.tech/api/v2.2/films/"
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "X-API-KEY": "b74d9e39-d1b8-4000-8d92-7bd750086814"
        ]
        AF.request(baseUrl + "\(id)", headers: headers)
            .responseDecodable(of: KinopoiskItem.self, completionHandler: { response in
                switch response.result {
                case .success(let result):
                    completion(.success(result))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
    }
}
