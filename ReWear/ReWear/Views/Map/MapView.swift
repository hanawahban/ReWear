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
        MapPin(name: "Linen Blazer", price: "BHD 8.5", coordinate: CLLocationCoordinate2D(latitude: 26.068, longitude: 50.558)),
        MapPin(name: "Floral Dress", price: "BHD 5.0", coordinate: CLLocationCoordinate2D(latitude: 26.065, longitude: 50.562)),
        MapPin(name: "Leather Bag", price: "BHD 12.0", coordinate: CLLocationCoordinate2D(latitude: 26.070, longitude: 50.555)),
    ]

    let nearbyItems: [(String, String, String)] = [
        ("Linen Blazer", "BHD 8.500", "0.3 km"),
        ("Floral Dress", "BHD 5.000", "0.6 km"),
        ("Leather Bag", "BHD 12.000", "1.1 km"),
        ("Wool Coat", "BHD 18.000", "1.8 km"),
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.rwBackground.ignoresSafeArea()

                VStack(spacing: 0) {

                    HStack {
                        Text("Nearby")
                            .font(.rwTitle)
                            .foregroundColor(Color.rwTextPrimary)
                        Spacer()
                        Button(action: {}) {
                            HStack(spacing: 6) {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 12))
                                Text("Manama")
                                    .font(.rwCaptionBold)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(Color.rwPrimary)
                            .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 12)

                    Map(position: $position) {
                        ForEach(mockPins) { pin in
                            Annotation(pin.name, coordinate: pin.coordinate) {
                                VStack(spacing: 0) {
                                    VStack(spacing: 2) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.rwPrimary)
                                                .frame(width: 44, height: 44)
                                            Image(systemName: "tshirt")
                                                .font(.system(size: 18, weight: .thin))
                                                .foregroundColor(.white)
                                        }
                                        Text(pin.price)
                                            .font(.rwMicro)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color.rwPrimary)
                                            .cornerRadius(4)
                                    }
                                    Image(systemName: "arrowtriangle.down.fill")
                                        .font(.system(size: 8))
                                        .foregroundColor(Color.rwPrimary)
                                        .offset(y: -2)
                                }
                            }
                        }
                        UserAnnotation()
                    }
                    .mapStyle(.standard(elevation: .flat))
                    .frame(height: 300)
                    .cornerRadius(0)

                    HStack(spacing: 12) {
                        Image(systemName: "location.circle.fill")
                            .foregroundColor(Color.rwPrimary)
                            .font(.system(size: 16))
                        Slider(value: $selectedRadius, in: 1...50, step: 1)
                            .tint(Color.rwPrimary)
                        Text("\(Int(selectedRadius)) km")
                            .font(.rwCaptionBold)
                            .foregroundColor(Color.rwPrimary)
                            .frame(width: 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.rwSurface)
                    .overlay(alignment: .bottom) { RWDivider() }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Nearby pieces")
                            .font(.rwHeading)
                            .foregroundColor(Color.rwTextPrimary)
                            .padding(.horizontal, 20)
                            .padding(.top, 14)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(nearbyItems, id: \.0) { item in
                                    NavigationLink(destination: ProductDetailView()) {
                                        RWNearbyCard(title: item.0, price: item.1, distance: item.2)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)
                        }
                    }
                    .background(Color.rwBackground)

                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct RWNearbyCard: View {
    var title: String
    var price: String
    var distance: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.rwSageTint)
                .frame(width: 130, height: 110)
                .overlay(
                    Image(systemName: "tshirt")
                        .font(.system(size: 24, weight: .thin))
                        .foregroundColor(Color.rwSage)
                )

            Text(title)
                .font(.rwCaptionBold)
                .foregroundColor(Color.rwTextPrimary)
                .lineLimit(1)

            Text(price)
                .font(.rwBodyBold)
                .foregroundColor(Color.rwPrimary)

            HStack(spacing: 3) {
                Image(systemName: "mappin")
                    .font(.system(size: 9))
                    .foregroundColor(Color.rwSage)
                Text(distance)
                    .font(.rwMicro)
                    .foregroundColor(Color.rwTextSecondary)
            }
        }
        .padding(10)
        .background(Color.rwSurface)
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.rwBorder, lineWidth: 1))
    }
}

struct MapPin: Identifiable {
    let id = UUID()
    let name: String
    let price: String
    let coordinate: CLLocationCoordinate2D
}

#Preview { MapView() }
