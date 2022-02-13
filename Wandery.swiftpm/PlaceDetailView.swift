import SwiftUI
import MapKit

struct PlaceDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: PlaceDetailViewModel
    
    init(place: Place) {
        vm = PlaceDetailViewModel(place: place)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        Map(coordinateRegion: $vm.region, interactionModes: [], annotationItems: [vm.place]) { item in    
                            MapMarker(coordinate: item.address.coordinates, tint: vm.place.status.color)
                        }
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        Text(vm.place.title)
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                        
                        Button {
                            // https://stackoverflow.com/questions/33787653/open-apple-maps-programmatically
                            // UIApplication.sharedApplication().openURL(NSURL(string: "http://maps.apple.com/?address=\(vm.place.address.street1),\(vm.place.address.zip)")!)
                        } label: {
                            Text(vm.place.address.description)
                                .multilineTextAlignment(.leading)
                        }
                        .tint(.blue)
                        
                        StatusView(status: $vm.place.status)
                        
                        Divider()
                        
                        ZStack {
                            TextEditor(text: $vm.place.description)
                                .font(.body)
                                .background (Color.clear)
                            
                            if vm.place.description.isEmpty {
                                Text("Tap to add notes...")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .allowsHitTesting(false)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 7)
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { 
                ToolbarItem (placement: .navigationBarLeading) {
                    Button {
                        vm.showEditView = true
                    } label: {
                        Label("Edit", systemImage: "pencil")     
                            .labelStyle(.titleAndIcon)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) { 
                    Button {
                        dismiss()
                    } label: {
                        Label("Done", systemImage: "checkmark")
                            .labelStyle(.titleAndIcon)
                    }
                }
            }
            .popover(isPresented: $vm.showEditView) { 
                EditPlaceView(place: $vm.place)
            }
        }
    }
}

class PlaceDetailViewModel: ObservableObject {
    @Published var place: Place
    @Published var region: MKCoordinateRegion
    @Published var showEditView = false
    
    init(place: Place) {
        self.place = place
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: place.address.coordinates.latitude, longitude: place.address.coordinates.longitude), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
    }
}

struct EditPlaceView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var place: Place
    
    var body: some View {
        NavigationView {
            VStack {
                Form { 
                    Section("Title") {
                        TextField("Title", text: $place.title)
                    }
                    
                    StatusView(status: $place.status)
                    
                    Section("Address") {
                        TextField("Street 1", text: $place.address.street1)
                        TextField("Street 2", text: $place.address.street2)
                        TextField("City", text: $place.address.city)
                        TextField("State", text: $place.address.state)
                        TextField("Zip", text: $place.address.zip)
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

struct NewPlaceView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var title = ""
    @State var status: VisitStatus = .to_visit
    @State var street1 = ""
    @State var street2 = ""
    @State var city = ""
    @State var state = ""
    @State var zip = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Form { 
                    Section("Title") {
                        TextField("Title", text: $title)
                    }
                    
                    StatusView(status: $status)
                    
                    Section("Address") {
                        TextField("Street 1", text: $street1)
                        TextField("Street 2", text: $street2)
                        TextField("City", text: $city)
                        TextField("State", text: $state)
                        TextField("Zip", text: $zip)
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

struct StatusView: View {
    @Binding var status: VisitStatus
    let fillable: [VisitStatus] = [.to_visit, .liked, .loved]
    
    var body: some View {
        Menu { 
            Button {
                status = .unmarked
            } label: {
                Label(VisitStatus.unmarked.description, systemImage: VisitStatus.unmarked.icon)
                    .labelStyle(.titleAndIcon)
            }
            
            Button {
                status = .to_visit
            } label: {
                Label(VisitStatus.to_visit.description, systemImage: "\(VisitStatus.to_visit.icon)\(status == .to_visit ? ".fill" : "")")
                    .labelStyle(.titleAndIcon)
            }
            
            Divider()
            
            Button {
                status = .visited
            } label: {
                Label(VisitStatus.visited.description, systemImage: VisitStatus.visited.icon)
                    .labelStyle(.titleAndIcon)
            }
            
            Button {
                status = .liked
            } label: {
                Label(VisitStatus.liked.description, systemImage: "\(VisitStatus.liked.icon)\(status == .liked ? ".fill" : "")")
                    .labelStyle(.titleAndIcon)
            }
            
            Button {
                status = .loved
            } label: {
                Label(VisitStatus.loved.description, systemImage: "\(VisitStatus.loved.icon)\(status == .loved ? ".fill" : "")")
                    .labelStyle(.titleAndIcon)
            }
            
        } label: { 
            Button { 
                //
            } label: { 
                Label(status.description, systemImage: "\(status.icon)\(fillable.contains(status) ? ".fill" : "")")
                    .font(.system(.body, design: .rounded))
            }
            .buttonStyle(.bordered)
            .tint(status.color)
            .foregroundColor(status.color)
        }
    }
}
