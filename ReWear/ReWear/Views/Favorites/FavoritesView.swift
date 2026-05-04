import SwiftUI

struct FavoritesView: View {

    @EnvironmentObject var productViewModel: ProductViewModel

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
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 14)

                    RWDivider()

                    if productViewModel.favoriteProducts.isEmpty {
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
                            Spacer()
                        }
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 16) {
                                HStack {
                                    Text("\(productViewModel.favoriteProducts.count) saved pieces")
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
                                    ForEach(productViewModel.favoriteProducts) { item in
                                        NavigationLink(destination: ProductDetailView(product: item)) {
                                            RWProductCard(
                                                title: item.title,
                                                price: item.formattedPrice,
                                                location: item.location,
                                                condition: item.condition,
                                                rating: item.rating,
                                                isFavorited: true,
                                                imageURL: item.imageURLs.first ?? ""
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

#Preview {
    FavoritesView()
        .environmentObject(ProductViewModel())
}
