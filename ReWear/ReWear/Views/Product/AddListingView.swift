import SwiftUI

struct AddListingView: View {

    @State private var title = ""
    @State private var description = ""
    @State private var price = ""
    @State private var selectedCategory = "Select category"
    @State private var condition = "Select condition"

    let categories = ["Electronics", "Clothing", "Furniture", "Books", "Vehicles", "Sports", "Other"]
    let conditions = ["New", "Like New", "Good", "Fair", "Poor"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    Text("Photos")
                        .font(.subheadline).bold()

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {

                            // Add photo button
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                                .frame(width: 90, height: 90)
                                .overlay(
                                    VStack(spacing: 4) {
                                        Image(systemName: "plus")
                                            .font(.title2)
                                            .foregroundColor(.gray)
                                        Text("Add Photo")
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                )

                            ForEach(0..<4, id: \.self) { _ in
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray5))
                                    .frame(width: 90, height: 90)
                                    .overlay(Image(systemName: "photo").foregroundColor(.gray))
                            }
                        }
                    }

                    Divider()

                    Text("Item Details")
                        .font(.subheadline).bold()

                    VStack(spacing: 14) {

                        WireFormField(label: "Title", placeholder: "What are you selling?")

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Description")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                                .frame(height: 90)
                                .overlay(
                                    Text("Describe your item...")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .padding(12),
                                    alignment: .topLeading
                                )
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Category")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            HStack {
                                Text(selectedCategory)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Condition")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            HStack {
                                Text(condition)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }

                        WireFormField(label: "Price (BHD)", placeholder: "0.000")
                    }

                    Divider()

                    Text("Location")
                        .font(.subheadline).bold()

                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray5))
                        .frame(height: 130)
                        .overlay(
                            VStack(spacing: 6) {
                                Image(systemName: "map")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                Text("Tap to set location")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        )

                    HStack {
                        Image(systemName: "location.fill").foregroundColor(.gray)
                        Text("Use current location")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                    Divider()

                    WireframeButton(label: "Post Listing")
                        .padding(.bottom, 20)
                }
                .padding(16)
            }
            .navigationTitle("Sell an Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Cancel").foregroundColor(.gray)
                }
            }
        }
    }
}

struct WireFormField: View {
    var label: String
    var placeholder: String
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            HStack {
                Text(placeholder)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
}

#Preview { AddListingView() }
