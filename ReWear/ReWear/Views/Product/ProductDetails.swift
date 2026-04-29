import SwiftUI

struct ProductDetailView: View {

    @State private var isFavorited = false
    @State private var currentImage = 0

    let mockReviews = ["Great seller, fast response!", "Item exactly as described.", "Would buy again."]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                ZStack(alignment: .bottomTrailing) {
                    TabView(selection: $currentImage) {
                        ForEach(0..<3, id: \.self) { i in
                            RoundedRectangle(cornerRadius: 0)
                                .fill(Color(.systemGray5))
                                .overlay(Image(systemName: "photo").font(.largeTitle).foregroundColor(.gray))
                                .tag(i)
                        }
                    }
                    .tabViewStyle(.page)
                    .frame(height: 280)

                    Button(action: { isFavorited.toggle() }) {
                        Image(systemName: isFavorited ? "heart.fill" : "heart")
                            .font(.title3)
                            .padding(10)
                            .background(Color(.systemBackground).opacity(0.85))
                            .clipShape(Circle())
                    }
                    .padding(14)
                }

                VStack(alignment: .leading, spacing: 16) {

                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            WirePlaceholderBar(width: 200, height: 16)
                            WirePlaceholderBar(width: 120, height: 13)
                        }
                        Spacer()
                        Text("BHD 00.000")
                            .font(.title3).bold()
                            .foregroundColor(.primary)
                    }

                    HStack(spacing: 8) {
                        WireTag(icon: "tag", label: "Category")
                        WireTag(icon: "mappin", label: "Manama, Bahrain")
                    }

                    Divider()

                    Text("Description")
                        .font(.subheadline).bold()

                    VStack(spacing: 6) {
                        WirePlaceholderBar(width: .infinity, height: 12)
                        WirePlaceholderBar(width: .infinity, height: 12)
                        WirePlaceholderBar(width: 180, height: 12)
                    }

                    Divider()

                    Text("Seller")
                        .font(.subheadline).bold()

                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 48, height: 48)
                            .overlay(Image(systemName: "person").foregroundColor(.gray))

                        VStack(alignment: .leading, spacing: 3) {
                            WirePlaceholderBar(width: 120, height: 13)
                            HStack(spacing: 3) {
                                ForEach(0..<5) { _ in
                                    Image(systemName: "star.fill")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                                Text("(24 reviews)")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }

                        Spacer()

                        Text("View Profile")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.systemGray4)))
                    }

                    Divider()

                    Text("Reviews")
                        .font(.subheadline).bold()

                    ForEach(mockReviews, id: \.self) { review in
                        HStack(alignment: .top, spacing: 10) {
                            Circle()
                                .fill(Color(.systemGray5))
                                .frame(width: 32, height: 32)
                            VStack(alignment: .leading, spacing: 2) {
                                WirePlaceholderBar(width: 80, height: 11)
                                Text(review)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }

                }
                .padding(16)
            }
        }
        .navigationTitle("Item Details")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {

            HStack(spacing: 12) {
                WireframeButton(label: "Add to Favorites", style: .outline)
                WireframeButton(label: "Contact Seller")
            }
            .padding(16)
            .background(Color(.systemBackground))
        }
    }
}

struct WirePlaceholderBar: View {
    var width: CGFloat
    var height: CGFloat
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color(.systemGray4))
            .frame(maxWidth: width == .infinity ? .infinity : width)
            .frame(height: height)
    }
}

struct WireTag: View {
    var icon: String
    var label: String
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon).font(.caption2)
            Text(label).font(.caption)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .foregroundColor(.secondary)
    }
}

#Preview { NavigationStack { ProductDetailView() } }
