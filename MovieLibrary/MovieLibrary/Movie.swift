import Foundation
import SwiftUI

struct Movie: Identifiable, Codable {
    let id: UUID
    var title: String
    var releaseYear: String
    var rating: Int
    var description: String
    var posterData: Data?
    var posterURL: String?
    
    init(
        id: UUID = UUID(),
        title: String,
        releaseYear: String,
        rating: Int,
        description: String,
        posterData: Data? = nil,
        posterURL: String? = nil
    ) {
        self.id = id
        self.title = title
        self.releaseYear = releaseYear
        self.rating = rating
        self.description = description
        self.posterData = posterData
        self.posterURL = posterURL
    }
}
