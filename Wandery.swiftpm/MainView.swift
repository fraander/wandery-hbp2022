import SwiftUI

// TODOs
// - Add place needs to be more robust
// - Auto-centering and spanning map view
// - Lists and all navigation properly working with persistence and updating
// - Icon picker needs upgrades
// - Discover addresses OR choose from moving map around and then coordinates convert to address which can be edited later (and divorced from map coordinates)

struct MainView: View {
    
    @ObservedObject var vm: MainViewModel
    
    init() {
        vm = MainViewModel()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                
                ScrollView {
                    VStack(spacing: 8) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
                            LargeNavLinkView(placeList: vm.all_places)
                            LargeNavLinkView(placeList: vm.all_to_visit)
                            LargeNavLinkView(placeList: vm.all_visited)
                            LargeNavLinkView(placeList: vm.all_favorites)
                        }
                        
                        HStack {
                            Text("My Lists")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .padding(.leading, 8)
                            
                            Spacer()
                        }
                        .padding(.top, 12)
                        
                        ForEach(vm.lists) {list in
                            NavigationLink(destination: PlaceListView(list: list)) {
                                HStack(spacing: 4) {
                                    Image(systemName: list.icon)
                                        .padding(6)
                                        .foregroundColor(.white)
                                        .background(Circle().fill(list.color))
                                    
                                    Text(list.title)
                                        .font(.system(.body, design: .rounded))
                                        .padding(.leading, 4)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.6)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    
                                    Text("\(list.places.count)")
                                        .font(.system(.body, design: .rounded))
                                        .foregroundColor(.secondary)
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, design: .rounded))
                                        .foregroundColor(.secondary)
                                }
                                .padding(.trailing, 12)
                                .padding(8)
                                .background(RoundedRectangle(cornerRadius: 8).fill(Color(uiColor: UIColor.tertiarySystemBackground)))
                                .padding(.horizontal, 8)
                            }
                        }
                        
                    }
                    .padding(8)
                }
            }
            .popover(isPresented: $vm.showNewView) { 
                NewPlaceListView()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Wandery")
            .toolbar { 
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) { 
                    Button {
                        vm.showNewView = true
                    } label: {
                        Label("Add List", systemImage: "plus")
                    }
                }
            }
        }
    }
}

struct LargeNavLinkView: View {
    @Environment(\.colorScheme) var colorScheme
    let placeList: PlaceList
    
    var body: some View {
        NavigationLink(destination: PlaceListView(list: placeList)) {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: placeList.icon)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(
                            Circle().fill(placeList.color)
                        )
                    Spacer()
                    Text("\(placeList.places.count)")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)
                }
                Text(placeList.title)
                    .foregroundColor(.secondary)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(uiColor: colorScheme == .light ? .white : .tertiarySystemBackground))
            )
        }
    }
}

class MainViewModel: ObservableObject {
    
    @Published var lists: [PlaceList] // TODO: reload arrays on change of data
    @Published var showNewView = false
    
    var all_places_array: [Place] {
        return [Place.preview1, Place.preview2, Place.preview3]
    }
    
    var all_places: PlaceList {
        return PlaceList(title: "All Places", icon: "tray.fill", color: .secondary, places: all_places_array)
    }
    
    var all_to_visit: PlaceList {
        let places = all_places_array.filter{$0.status == .to_visit}
        return PlaceList(title: VisitStatus.to_visit.description, icon: "\(VisitStatus.to_visit.icon).fill", color: VisitStatus.to_visit.color, places: places)
    }
    
    var all_visited: PlaceList {
        let visited_tags: Set<VisitStatus> = [.visited, .liked, .loved]
        let places = all_places_array.filter { place in
            visited_tags.contains(place.status)
        }
        return PlaceList(title: VisitStatus.visited.description, icon: VisitStatus.visited.icon, color: VisitStatus.visited.color, places: places)
    }
    
    var all_favorites: PlaceList {
        let places = all_places_array.filter{$0.status == .loved}
        return PlaceList(title: "Favorites", icon: "\(VisitStatus.loved.icon).fill", color: VisitStatus.loved.color, places: places)
    }
    
    init() {
        lists = [PlaceList.preview1]
    }
}
