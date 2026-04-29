import SwiftUI

struct AddListingView: View {

    @State private var title = ""
    @State private var description = ""
    @State private var price = ""
    @State private var selectedCategory = ""
    @State private var selectedCondition = ""
    @State private var selectedSize = ""
    @State private var brand = ""
    @State private var showCategoryPicker = false

    let categories = ["Tops", "Dresses", "Outerwear", "Bottoms", "Shoes", "Bags", "Accessories"]
    let conditions = ["New with tags", "Like New", "Good", "Fair", "Poor"]
    let sizes = ["XS", "S", "M", "L", "XL", "XXL", "One Size"]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.rwBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Photos")
                                .font(.rwHeading)
                                .foregroundColor(Color.rwTextPrimary)
                            Text("Add up to 8 photos. First photo is the cover.")
                                .font(.rwCaption)
                                .foregroundColor(Color.rwTextSecondary)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    // Add button
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.rwSageTint)
                                        .frame(width: 88, height: 88)
                                        .overlay(
                                            VStack(spacing: 6) {
                                                Image(systemName: "plus")
                                                    .font(.system(size: 20, weight: .medium))
                                                    .foregroundColor(Color.rwPrimary)
                                                Text("Add")
                                                    .font(.rwMicro)
                                                    .foregroundColor(Color.rwPrimary)
                                            }
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [5, 3]))
                                                .foregroundColor(Color.rwSage)
                                        )

                                    ForEach(0..<4, id: \.self) { _ in
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.rwSageTint)
                                            .frame(width: 88, height: 88)
                                            .overlay(
                                                Image(systemName: "tshirt")
                                                    .font(.system(size: 24, weight: .thin))
                                                    .foregroundColor(Color.rwSage.opacity(0.5))
                                            )
                                    }
                                }
                            }
                        }

                        RWDivider()

                        VStack(alignment: .leading, spacing: 14) {
                            Text("Item details")
                                .font(.rwHeading)
                                .foregroundColor(Color.rwTextPrimary)

                            RWTextField(placeholder: "Title e.g. Zara linen blazer", text: $title)

                            RWTextField(placeholder: "Brand (optional)", text: $brand, icon: "tag")

                            // Description
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Description")
                                    .font(.rwCaption)
                                    .foregroundColor(Color.rwTextSecondary)
                                ZStack(alignment: .topLeading) {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.rwSageTint)
                                        .frame(height: 100)
                                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.rwBorder, lineWidth: 1))
                                    Text("Describe the item, its condition, measurements...")
                                        .font(.rwBody)
                                        .foregroundColor(Color.rwTextSecondary)
                                        .padding(14)
                                }
                            }

                            // Category
                            RWPickerRow(label: "Category", value: selectedCategory.isEmpty ? "Select category" : selectedCategory)

                            // Condition
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Condition")
                                    .font(.rwCaption)
                                    .foregroundColor(Color.rwTextSecondary)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(conditions, id: \.self) { c in
                                            RWCategoryChip(
                                                label: c,
                                                isSelected: selectedCondition == c,
                                                action: { selectedCondition = c }
                                            )
                                        }
                                    }
                                }
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Size")
                                    .font(.rwCaption)
                                    .foregroundColor(Color.rwTextSecondary)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(sizes, id: \.self) { s in
                                            RWCategoryChip(
                                                label: s,
                                                isSelected: selectedSize == s,
                                                action: { selectedSize = s }
                                            )
                                        }
                                    }
                                }
                            }

                            RWTextField(placeholder: "Price (BHD)", text: $price, icon: "banknote")
                        }

                        RWDivider()

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Location")
                                .font(.rwHeading)
                                .foregroundColor(Color.rwTextPrimary)

                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.rwSageTint)
                                .frame(height: 120)
                                .overlay(
                                    VStack(spacing: 8) {
                                        Image(systemName: "map")
                                            .font(.system(size: 28, weight: .thin))
                                            .foregroundColor(Color.rwSage)
                                        Text("Tap to set your location")
                                            .font(.rwCaption)
                                            .foregroundColor(Color.rwTextSecondary)
                                    }
                                )
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.rwBorder, lineWidth: 1))

                            HStack(spacing: 10) {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color.rwPrimary)
                                Text("Use my current location")
                                    .font(.rwBodyBold)
                                    .foregroundColor(Color.rwPrimary)
                            }
                        }

                        RWDivider()

                        RWPrimaryButton(label: "Post Listing")
                            .padding(.bottom, 30)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Sell a piece")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.rwBackground, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {}
                        .font(.rwBody)
                        .foregroundColor(Color.rwTextSecondary)
                }
            }
        }
    }
}

struct RWPickerRow: View {
    var label: String
    var value: String
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.rwCaption)
                .foregroundColor(Color.rwTextSecondary)
            HStack {
                Text(value)
                    .font(.rwBody)
                    .foregroundColor(value.contains("Select") ? Color.rwTextSecondary : Color.rwTextPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(Color.rwTextSecondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(Color.rwSageTint)
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.rwBorder, lineWidth: 1))
        }
    }
}

#Preview { AddListingView() }
