import SwiftUI

struct HomeView: View {

    let categories = ["All", "Electronics", "Clothing", "Furniture", "Books", "Vehicles", "Other"]
    @State private var selectedCategory = "All"
    @State private var searchText = ""

    // Mock product count for wireframe layout
    let mockItems = Array(0..<8)

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    Text("Search products...")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    Spacer()
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.gray)
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat)
                                .font(.caption)
                                .fontWeight(selectedCategory == cat ? .semibold : .regular)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(
                                    selectedCategory == cat
                                    ? Color(.systemGray2)
                                    : Color(.systemGray6)
                                )
                                .cornerRadius(20)
                                .onTapGesture { selectedCategory = cat }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 8)

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        ForEach(mockItems, id: \.self) { i in
                            NavigationLink(destination: ProductDetailView()) {
                                WireframeProductCard(index: i)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("ReWear")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "location.fill")
                        .foregroundColor(.gray)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "bell")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct WireframeProductCard: View {
    let index: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            // Image placeholder
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray5))
                .frame(height: 140)
                .overlay(Image(systemName: "photo").foregroundColor(.gray))

            // Title placeholder
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.systemGray4))
                .frame(height: 12)

            // Price placeholder
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.systemGray4))
                .frame(width: 60, height: 12)

            // Location + rating row
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text("Location")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Spacer()
                Image(systemName: "star.fill")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text("4.5")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding(10)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
}

#Preview { HomeView() }
