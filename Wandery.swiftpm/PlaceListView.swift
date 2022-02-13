import SwiftUI
import MapKit

struct PlaceListView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: PlaceListViewModel
    
    init(list: PlaceList) {
        vm = PlaceListViewModel(list: list)
    }
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
            
            VStack(alignment: .leading, spacing: 8) {
//                Print LatLong + Deltas for debug
//                Text("LatDelta: \(vm.region.span.latitudeDelta)")
//                Text("LongDelta: \(vm.region.span.longitudeDelta)")
//                Text("Lat: \(vm.region.center.latitude)")
//                Text("Long: \(vm.region.center.longitude)")
                
                Group {
                    Map(coordinateRegion: $vm.region, interactionModes: [.all], annotationItems: vm.list.places) { item in 
                        MapMarker(coordinate: item.address.coordinates, tint: item.status.color)
                    }
                    .frame(height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.top, 8)
                    
                    HStack {
                        Text(vm.list.title)
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                        
                        Spacer()
                        
                        Button {
                            vm.showEditView = true
                        } label: {
                            Label("Edit Details", systemImage: "pencil.circle")
                                .font(.system(.title2, design: .rounded))
                                .labelStyle(.iconOnly)
                        }
                        .padding(.trailing, 8)
                    }
                    .padding(.horizontal, 2)
                }
                .padding(.horizontal, 8)
                
                ScrollView {
                    ForEach($vm.list.places) { $place in
                        HStack {
                            Text(place.title)
                                .font(.system(.headline, design: .rounded))
                                .padding(.leading, 4)
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                            Spacer()
                            StatusView(status: $place.status)   
                                .labelStyle(.iconOnly)
                        }
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color(uiColor: UIColor.tertiarySystemBackground)))
                        .onTapGesture {
                            vm.selectedPlace = place
                        }
                        .padding(.horizontal, 8)
                    }
                }
                .listStyle(.automatic)
            }
        }
        .popover(isPresented: $vm.showNewView) { 
            NewPlaceView()
        }
        .popover(isPresented: $vm.showEditView) { 
            EditPlaceListView(placeList: $vm.list)
        }
        .popover(item: $vm.selectedPlace) {place in 
                PlaceDetailView(place: place)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                vm.showNewView = true
            } label: {
                Label("Add Place", systemImage: "plus")
                    .labelStyle(.titleAndIcon)
            }
        }
    }
}

class PlaceListViewModel: ObservableObject {
    @Published var list: PlaceList
    @Published var region: MKCoordinateRegion
    @Published var selectedPlace: Place?
    @Published var showEditView = false
    @Published var showNewView = false
    
    init(list: PlaceList) {
        
        self.list = list
        
        let coordinates = list.places.first?.address.coordinates ?? CLLocationCoordinate2D(latitude: 37.34, longitude: -122.009163) // TODO calculate the center of the list and the span
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)) // TODO: calculate center
    }
}

struct EditPlaceListView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var placeList: PlaceList
    
    var body: some View {
        NavigationView {
            VStack {
                Form { 
                    Section {
                        TextField("Title", text: $placeList.title)
                        TextField("Icon", text: $placeList.icon)
                        ColorPicker("Color", selection: $placeList.color)
                    }
                }
            }
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Label("Done", systemImage: "checkmark")
                        .labelStyle(.titleAndIcon)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct NewPlaceListView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var title = ""
    @State var icon = "mappin.ellipse"
    @State var color = Color.indigo
    
    var body: some View {
        NavigationView {
            VStack {
                Form { 
                    Section {
                        TextField("Title", text: $title)
                        TextField("Icon", text: $icon)
                        ColorPicker("Color", selection: $color)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { 
                    Button {
                        dismiss()
                    } label: {
                        Label("Cancel", systemImage: "xmark")
                            .labelStyle(.titleOnly)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) { 
                    Button {
                        // add to main list
                    } label: {
                        Label("Done", systemImage: "checkmark")
                            .labelStyle(.titleAndIcon)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
