import SwiftUI
import MapKit

struct MapView: View {

    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 26.0667, longitude: 50.5577),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )

    @State private var selectedRadius = 5.0

    let mockPins = [
        MapPin(name: "Item A", coordinate: CLLocationCoordinate2D(latitude: 26.068, longitude: 50.558)),
        MapPin(name: "Item B", coordinate: CLLocationCoordinate2D(latitude: 26.065, longitude: 50.562)),
        MapPin(name: "Item C", coordinate: CLLocationCoordinate2D(latitude: 26.070, longitude: 50.555)),
    ]

    let nearbyItems = Array(0..<4)

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                Map(position: $position) {
                    ForEach(mockPins) { pin in
                        Annotation(pin.name, coordinate: pin.coordinate) {
                            VStack(spacing: 2) {
                                ZStack {
                                    Circle()
                                        .fill(Color(.systemGray3))
                                        .frame(width: 36, height: 36)
                                    Image(systemName: "tshirt")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                                Image(systemName: "arrowtriangle.down.fill")
                                    .font(.system(size: 8))
                                    .foregroundColor(.gray)
                                    .offset(y: -4)
                            }
                        }
                    }
                }
                .frame(height: 320)

                HStack(spacing: 10) {
                    Image(systemName: "location.circle")
                        .foregroundColor(.gray)
                    Text("Radius: \(Int(selectedRadius)) km")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Slider(value: $selectedRadius, in: 1...50, step: 1)
                        .tint(.gray)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color(.systemBackground))

                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Nearby Items")
                        .font(.subheadline).bold()
                        .padding(.horizontal, 16)
                        .padding(.top, 10)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(nearbyItems, id: \.self) { _ in
                                NavigationLink(destination: ProductDetailView()) {
                                    WireframeNearbyCard()
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)
                    }
                }
            }
            .navigationTitle("Nearby")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "location.fill")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct WireframeNearbyCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray5))
                .frame(width: 130, height: 100)
                .overlay(Image(systemName: "photo").foregroundColor(.gray))

            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.systemGray4))
                .frame(width: 100, height: 11)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.systemGray4))
                .frame(width: 60, height: 11)

            HStack(spacing: 3) {
                Image(systemName: "mappin").font(.caption2).foregroundColor(.gray)
                Text("0.3 km away").font(.caption2).foregroundColor(.gray)
            }
        }
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.systemGray5)))
    }
}

struct MapPin: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

#Preview { MapView() }
