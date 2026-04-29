import SwiftUI

struct FavoritesView: View {

    @State private var showEmpty = false

    let savedItems: [(String, String, String, String, Double)] = [
        ("Linen Blazer", "BHD 8.500", "Manama", "Like New", 4.8),
        ("Floral Midi Dress", "BHD 5.000", "Riffa", "Good", 4.5),
        ("Leather Tote Bag", "BHD 12.000", "Juffair", "Like New", 5.0),
        ("Denim Jacket", "BHD 7.500", "Muharraq", "Good", 4.2),
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.rwBackground.ignoresSafeArea()

                VStack(spacing: 0) {

                    HStack {
                        Text("Saved")
                            .font(.rwTitle)
                            .foregroundColor(Color.rwTextPrimary)
                        Spacer()
                        Button(action: { showEmpty.toggle() }) {
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.system(size: 16))
                                .foregroundColor(Color.rwPrimary)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 14)

                    RWDivider()

                    if showEmpty {
                        VStack(spacing: 20) {
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(Color.rwSageTint)
                                    .frame(width: 100, height: 100)
                                Image(systemName: "heart.slash")
                                    .font(.system(size: 40, weight: .thin))
                                    .foregroundColor(Color.rwSage)
                            }
                            VStack(spacing: 8) {
                                Text("Nothing saved yet")
                                    .font(.rwHeading)
                                    .foregroundColor(Color.rwTextPrimary)
                                Text("Tap the heart on any listing\nto save it for later.")
                                    .font(.rwBody)
                                    .foregroundColor(Color.rwTextSecondary)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                            }
                            RWPrimaryButton(label: "Browse listings")
                                .padding(.horizontal, 60)
                            Spacer()
                        }
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 16) {
                                HStack {
                                    Text("\(savedItems.count) saved pieces")
                                        .font(.rwCaption)
                                        .foregroundColor(Color.rwTextSecondary)
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 14)

                                LazyVGrid(
                                    columns: [GridItem(.flexible()), GridItem(.flexible())],
                                    spacing: 14
                                ) {
                                    ForEach(savedItems, id: \.0) { item in
                                        NavigationLink(destination: ProductDetailView()) {
                                            RWProductCard(
                                                title: item.0,
                                                price: item.1,
                                                location: item.2,
                                                condition: item.3,
                                                rating: item.4,
                                                isFavorited: true
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
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview { FavoritesView() }
