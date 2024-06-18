import Foundation
import RxSwift

class ViewModel {
    private let tvNetwork: TVNetwork
    private let disposeBag = DisposeBag()
    
    init() {
        let provider = NetworkProvider()
        tvNetwork = provider.makeTVNetwork()
    }
    
    struct Input {
        let tvTrigger: Observable<Void>
        let searchQuery: Observable<String>
    }
    
    struct Output {
        let tvList: Observable<[TV]>
    }
    
    func transform(input: Input) -> Output {
        // 검색어 입력에 따라 TV 데이터를 필터링하는 Observable
        let filteredTVData = input.searchQuery.distinctUntilChanged()
            .flatMapLatest { query -> Observable<[TV]> in
                if query.isEmpty {
                    // 검색어가 비어 있으면 모든 TV 데이터를 가져옴
                    return self.getAllTVData()
                } else {
                    // 검색어가 있는 경우 검색하여 필터링된 TV 데이터 가져옴
                    return self.searchTV(query: query)
                }
            }
        
        return Output(tvList: filteredTVData)
    }
    
    private func getAllTVData() -> Observable<[TV]> {
        // 최상위 평점 리스트와 인기 리스트를 결합하여 모든 TV 데이터 가져오기
        return Observable.zip(getTopRatedList(), getPopularList())
            .map { topRated, popular in
                return topRated + popular
            }
    }
    
    private func getTopRatedList() -> Observable<[TV]> {
        // 최상위 평점 TV 리스트 가져오기
        return tvNetwork.getTopRatedList().map { $0.results }
    }
    
    private func getPopularList() -> Observable<[TV]> {
        // 인기 TV 리스트 가져오기
        return tvNetwork.getPopularList().map { $0.results }
    }
    
    private func searchTV(query: String) -> Observable<[TV]> {
        // 검색어로 TV 검색하기
        return tvNetwork.searchTV(query: query).map { $0.results }
    }
}
