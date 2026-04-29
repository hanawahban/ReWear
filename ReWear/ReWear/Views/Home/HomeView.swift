import SwiftUI

struct HomeView: View {

    let categories = ["All", "Tops", "Dresses", "Outerwear", "Bottoms", "Shoes", "Bags", "Accessories"]
    @State private var selectedCategory = "All"
    @State private var searchText = ""

    let mockItems: [(String, String, String, String, Double)] = [
        ("Linen Blazer", "BHD 8.500", "Manama", "Like New", 4.8),
        ("Floral Midi Dress", "BHD 5.000", "Riffa", "Good", 4.5),
        ("Leather Tote Bag", "BHD 12.000", "Juffair", "Like New", 5.0),
        ("Denim Jacket", "BHD 7.500", "Muharraq", "Good", 4.2),
        ("Silk Blouse", "BHD 4.000", "Manama", "Fair", 3.9),
        ("Wool Coat", "BHD 18.000", "Saar", "Like New", 4.9),
    ]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.rwBackground.ignoresSafeArea()

                VStack(spacing: 0) {

                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("R E W E A R")
                                .font(.rwDisplay)
                                .foregroundColor(Color.rwPrimary)
                                .kerning(4)
                            HStack(spacing: 4) {
                                Image(systemName: "mappin.fill")
                                    .font(.system(size: 11))
                                    .foregroundColor(Color.rwSage)
                                Text("Manama, Bahrain")
                                    .font(.rwMicro)
                                    .foregroundColor(Color.rwTextSecondary)
                            }
                        }
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "bell")
                                .font(.system(size: 18))
                                .foregroundColor(Color.rwPrimary)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 14)

                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.rwTextSecondary)
                            .font(.system(size: 15))
                        Text(searchText.isEmpty ? "Search for pieces..." : searchText)
                            .font(.rwBody)
                            .foregroundColor(searchText.isEmpty ? Color.rwTextSecondary : Color.rwTextPrimary)
                        Spacer()
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(Color.rwPrimary)
                            .font(.system(size: 15))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color.rwSurface)
                    .cornerRadius(14)
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.rwBorder, lineWidth: 1))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 14)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(categories, id: \.self) { cat in
                                RWCategoryChip(
                                    label: cat,
                                    isSelected: selectedCategory == cat,
                                    action: { selectedCategory = cat }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 16)

                    ZStack(alignment: .bottomLeading) {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.rwPrimary)
                            .frame(height: 110)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("New arrivals this week")
                                .font(.rwHeading)
                                .foregroundColor(.white)
                            Text("24 fresh pieces added")
                                .font(.rwCaption)
                                .foregroundColor(Color.rwSage)
                        }
                        .padding(18)

                        HStack {
                            Spacer()
                            Image(systemName: "arrow.3.trianglepath")
                                .font(.system(size: 40, weight: .thin))
                                .foregroundColor(Color.rwSage.opacity(0.3))
                                .padding(.trailing, 20)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)

                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            RWSectionHeader(title: "Recent listings", actionLabel: "See all")
                                .padding(.horizontal, 20)

                            LazyVGrid(
                                columns: [GridItem(.flexible()), GridItem(.flexible())],
                                spacing: 14
                            ) {
                                ForEach(mockItems, id: \.0) { item in
                                    NavigationLink(destination: ProductDetailView()) {
                                        RWProductCard(
                                            title: item.0,
                                            price: item.1,
                                            location: item.2,
                                            condition: item.3,
                                            rating: item.4
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview { HomeView() }
