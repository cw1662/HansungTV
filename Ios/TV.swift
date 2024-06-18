import Foundation

struct TVListModel: Decodable {
    let page: Int
    let results: [TV]
}

struct TV: Decodable, Hashable {
    let name: String
    let overview: String
    let posterURL: String?
    let vote: String
    let firstAirDate: String
    let voteCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case name
        case overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case firstAirDate = "first_air_date"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        overview = try container.decode(String.self, forKey: .overview)
        
        // Handle optional poster path
        if let path = try container.decodeIfPresent(String.self, forKey: .posterPath) {
            posterURL = "https://image.tmdb.org/t/p/w500\(path)"
        } else {
            posterURL = nil
        }
        
        let voteAverage = try container.decode(Float.self, forKey: .voteAverage)
        vote = String(format: "%.1f", voteAverage) // Format voteAverage to one decimal place
        
        voteCount = try container.decode(Int.self, forKey: .voteCount)  // Decode voteCount if available
                
        firstAirDate = try container.decode(String.self, forKey: .firstAirDate)
    }

}
