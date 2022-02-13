import SwiftUI
import MapKit

extension Color {
    static let darkGreen = Color(red: 0.241, green: 0.808, blue: 0.209, opacity: 1.000)
}

enum VisitStatus: CustomStringConvertible {
    
    case unmarked, to_visit, visited, liked, loved
    
    var description: String {
        switch self {
            case .unmarked: return "Unmarked"
            case .to_visit: return "To Visit"
            case .visited: return "Visited"
            case .liked: return "Liked"
            case .loved: return "Loved"
        }
    }
    
    var color: Color {
        switch self {
        case .unmarked: return .secondary
        case .to_visit: return .orange
        case .visited: return .darkGreen
        case .liked: return .mint
        case .loved: return .red
        }
    }
    
    var icon: String {
        switch self {
            case .unmarked: return "magnifyingglass"
        case .to_visit: return "map"
        case .visited: return "mappin.and.ellipse"
        case .liked: return "hand.thumbsup"
        case .loved: return "heart"
        }
    }
}

struct Address: CustomStringConvertible { // Only works for US Addresses
    static var preview1 = Address(street1: "220 Dorchester Avenue", street2: "", city: "Boston", state: "MA", zip: "02127", coordinates: CLLocationCoordinate2D(latitude: 42.340110, longitude: -71.056780)) // Doughboy
    static var preview2 = Address(street1: "130 Dartmouth St", street2: "", city: "Boston", state: "MA", zip: "02116", coordinates: CLLocationCoordinate2D(latitude: 42.3468805, longitude: -71.0761207)) // Salty Pig
    static var preview3 = Address(street1: "237 Newbury St", street2: "", city: "Boston", state: "MA", zip: "02116", coordinates: CLLocationCoordinate2D(latitude: 42.349910, longitude: -71.081990)) // Serafina
    
    var street1: String = ""
    var street2: String = ""
    var city: String = ""
    var state: String = ""
    var zip: String = ""
    
    var coordinates: CLLocationCoordinate2D
    
    var description: String {
        var output = street1
        if !street2.isEmpty { output += "\n" + street2 }
        if !city.isEmpty { output += "\n" + city }
        if !state.isEmpty { output += ", " + state }
        if !zip.isEmpty { output += " " + zip }
        return output
    }
}

struct Place: Identifiable {
    static var preview1 = Place(id: UUID(), title: "Doughboy Doughnuts", description: "Doughnuts, drinks, and sandwiches. Nearby Rock Spot.", status: .liked, address: Address.preview1, list_id: Set()) // Doughboy
    static var preview2 = Place(id: UUID(), title: "The Salty Pig", description: "Great atmosphere. Everything was delicious, but better for meat eaters than vegetarians.", status: .loved, address: Address.preview2, list_id: Set()) // Salty Pig
    static var preview3 = Place(id: UUID(), title: "Serafina", description: "Hits the spot for pasta and very affordable for a place that serves sit-down dinner on Newbury.", status: .to_visit, address: Address.preview3, list_id: Set()) // Serafina
    
    var id: UUID
    var place_id: UUID { return id }
    
    var title: String
    var description: String
    var status: VisitStatus
    
    var address: Address
    
    var list_id: Set<UUID>
}

struct PlaceList: Identifiable {
    static let preview1 = PlaceList(title: "Northeast", description: "Places to visit while I live in Boston", icon: "graduationcap.fill", color: Color(red: 0.941, green: 0.439, blue: 0.365, opacity: 1.000), places: [Place.preview1, Place.preview2, Place.preview3])
    
    var id: UUID = UUID()
    
    var title: String
    var description: String?
    
    var icon: String
    var color: Color
    
    var places: [Place]
}
