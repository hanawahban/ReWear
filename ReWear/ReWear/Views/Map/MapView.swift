import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {

    @EnvironmentObject var productViewModel: ProductViewModel
    @StateObject private var locationVM = LocationViewModel()

    @State private var selectedRadius: Double = 5.0
    @State private var mapLoaded = false
    @State private var filteredProducts: [Product] = []

    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 26.0667, longitude: 50.5577),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )

    private var userCoordinate: CLLocationCoordinate2D {
        locationVM.userLocation ?? CLLocationCoordinate2D(latitude: 26.0667, longitude: 50.5577)
    }

    private func updateFilteredProducts() {
        filteredProducts = productViewModel.products.filter { product in
            let productLoc = CLLocation(latitude: product.latitude, longitude: product.longitude)
            let userLoc = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
            let distanceKm = productLoc.distance(from: userLoc) / 1000
            return distanceKm <= selectedRadius
        }
    }

    var body: some View {
        ZStack {
            Color.rwBackground.ignoresSafeArea()
            VStack(spacing: 0) {
                headerView
                mapSection
                sliderSection
                nearbySection
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            locationVM.requestPermission()
            productViewModel.fetchProducts()
            updateFilteredProducts()
        }
        .onChange(of: selectedRadius) { oldValue, newValue in
            updateFilteredProducts()
            let delta = (newValue / 111.0) * 2.5
            withAnimation {
                position = .region(MKCoordinateRegion(
                    center: userCoordinate,
                    span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
                ))
            }
        }
        .onChange(of: productViewModel.products.count) { oldValue, newValue in
            updateFilteredProducts()
        }
    }

    private var headerView: some View {
        HStack {
            Text("Nearby")
                .font(.rwTitle)
                .foregroundColor(Color.rwTextPrimary)
            Spacer()
            Button(action: {
                locationVM.requestPermission()
                position = .region(MKCoordinateRegion(
                    center: userCoordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                ))
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 12))
                    Text(locationVM.currentCity)
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
    }

    private var mapSection: some View {
        Group {
            if mapLoaded {
                Map(position: $position) {
                    ForEach(filteredProducts) { product in
                        Annotation(product.title, coordinate: CLLocationCoordinate2D(
                            latitude: product.latitude,
                            longitude: product.longitude
                        )) {
                            VStack(spacing: 0) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.rwPrimary)
                                        .frame(width: 70, height: 36)
                                    VStack(spacing: 1) {
                                        Image(systemName: "tshirt")
                                            .font(.system(size: 9, weight: .medium))
                                            .foregroundColor(.white)
                                        Text(product.formattedPrice)
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                }
                                Triangle()
                                    .fill(Color.rwPrimary)
                                    .frame(width: 10, height: 6)
                                    .offset(y: -2)
                            }
                        }
                    }
                    UserAnnotation()
                }
                .mapStyle(.standard(elevation: .flat))
                .frame(height: 300)
            } else {
                Color.rwSageTint
                    .frame(height: 300)
                    .overlay(ProgressView())
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            mapLoaded = true
                        }
                    }
            }
        }
    }

    private var sliderSection: some View {
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
    }

    private var nearbySection: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Nearby pieces")
                    .font(.rwHeading)
                    .foregroundColor(Color.rwTextPrimary)
                    .padding(.horizontal, 20)
                    .padding(.top, 14)

                if filteredProducts.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "mappin.slash")
                            .font(.system(size: 28, weight: .thin))
                            .foregroundColor(Color.rwSage)
                        Text("No items within \(Int(selectedRadius)) km")
                            .font(.rwCaption)
                            .foregroundColor(Color.rwTextSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(filteredProducts) { product in
                                NavigationLink(destination: ProductDetailView(product: product)) {
                                    RWNearbyCard(
                                        title: product.title,
                                        price: product.formattedPrice,
                                        distance: locationVM.distance(to: product),
                                        imageURL: product.imageURLs.first ?? ""
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 16)
                    }
                }
            }
        }
        .background(Color.rwBackground)
    }
} // ← MapView ends here

struct RWNearbyCard: View {
    var title: String
    var price: String
    var distance: String
    var imageURL: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Group {
                if imageURL.isEmpty {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.rwSageTint)
                        .overlay(
                            Image(systemName: "tshirt")
                                .font(.system(size: 24, weight: .thin))
                                .foregroundColor(Color.rwSage)
                        )
                } else {
                    AsyncImage(url: URL(string: imageURL)) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.rwSageTint)
                            .overlay(ProgressView())
                    }
                    .clipped()
                }
            }
            .frame(width: 130, height: 110)
            .cornerRadius(10)

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

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

#Preview { MapView() }
