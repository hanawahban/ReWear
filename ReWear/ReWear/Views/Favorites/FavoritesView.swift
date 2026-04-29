import SwiftUI

struct FavoritesView: View {

    @State private var isEmpty = false
    let mockItems = Array(0..<6)

    var body: some View {
        NavigationStack {
            Group {
                if isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 52))
                            .foregroundColor(.gray)
                        Text("No saved items yet")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Tap the heart on any listing\nto save it here.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        WireframeButton(label: "Browse Listings", style: .outline)
                            .frame(width: 180)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: [GridItem(.flexible()), GridItem(.flexible())],
                            spacing: 14
                        ) {
                            ForEach(mockItems, id: \.self) { i in
                                NavigationLink(destination: ProductDetailView()) {
                                    ZStack(alignment: .topTrailing) {
                                        WireframeProductCard(index: i)

                                        Image(systemName: "heart.fill")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(8)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .navigationTitle("Saved Items")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isEmpty.toggle() }) {
                        Text(isEmpty ? "Show items" : "Show empty")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

#Preview { FavoritesView() }
