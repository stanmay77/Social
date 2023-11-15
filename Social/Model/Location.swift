// Data model for location in Social

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore



struct Location: Codable {
    
    @DocumentID var id: String?
    let user: String
    let POIname: String
    let coord: GeoPoint

    init(user: String, POIname: String, coord: GeoPoint) {
        self.user = user
        self.POIname = POIname
        self.coord = coord
    }
    
}
