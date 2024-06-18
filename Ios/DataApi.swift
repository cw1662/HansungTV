import Foundation
import RxSwift
import RxAlamofire

// MARK: - Constants

let APIKEY = "07681767904c4fc92e1f040e298d38e7"

// MARK: - Network

class Network<T: Decodable> {

    internal let endpoint: String
    internal let apiKey: String
    internal let language: String
    internal let queue: ConcurrentDispatchQueueScheduler
    
    init(_ endpoint: String, apiKey: String, language: String) {
        self.endpoint = endpoint
        self.apiKey = apiKey
        self.language = language
        self.queue = ConcurrentDispatchQueueScheduler(qos: .background)
    }
    
    func getItemList(path: String) -> Observable<T> {
        let fullPath = "\(endpoint)\(path)?api_key=\(apiKey)&language=\(language)"
        return RxAlamofire.data(.get, fullPath)
            .observe(on: queue)
            .debug()
            .map { data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }
    }
}

// MARK: - TVNetwork

final class TVNetwork {
    private let network: Network<TVListModel>
    
    init(network: Network<TVListModel>) {
        self.network = network
    }
    
    func getTopRatedList() -> Observable<TVListModel> {
        return network.getItemList(path: "/tv/top_rated")
    }
    
    func getPopularList() -> Observable<TVListModel> {
        return network.getItemList(path: "/tv/popular")
    }

    func searchTV(query: String) -> Observable<TVListModel> {
        let path = "/search/tv"
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let fullPath = "\(network.endpoint)\(path)?api_key=\(network.apiKey)&language=\(network.language)&query=\(encodedQuery)"
        return RxAlamofire.data(.get, fullPath)
            .observe(on: network.queue)
            .debug()
            .map { data -> TVListModel in
                return try JSONDecoder().decode(TVListModel.self, from: data)
            }
    }
}

// MARK: - NetworkProvider

final class NetworkProvider {
    private let endpoint: String
    private let apiKey: String
    private let language: String
    
    init() {
        self.endpoint = "https://api.themoviedb.org/3"
        self.apiKey = APIKEY
        self.language = "ko" // Set your desired language here
    }

    func makeTVNetwork() -> TVNetwork {
        let network = Network<TVListModel>(endpoint, apiKey: apiKey, language: language)
        return TVNetwork(network: network)
    }
}
