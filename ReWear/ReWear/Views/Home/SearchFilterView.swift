import SwiftUI

struct SearchFilterView: View {

    @Environment(\.dismiss) var dismiss

    @Binding var selectedCategory: String
    @Binding var selectedCondition: String
    @Binding var selectedSize: String
    @Binding var minPrice: Double
    @Binding var maxPrice: Double

    @State private var tempCategory: String
    @State private var tempCondition: String
    @State private var tempSize: String
    @State private var tempMinPrice: Double
    @State private var tempMaxPrice: Double

    let categories = ["All", "Tops", "Dresses", "Outerwear", "Bottoms", "Shoes", "Bags", "Accessories"]
    let conditions = ["Any", "New with tags", "Like New", "Good", "Fair", "Poor"]
    let sizes = ["Any", "XS", "S", "M", "L", "XL", "XXL", "One Size"]

    init(
        selectedCategory: Binding<String>,
        selectedCondition: Binding<String>,
        selectedSize: Binding<String>,
        minPrice: Binding<Double>,
        maxPrice: Binding<Double>
    ) {
        self._selectedCategory = selectedCategory
        self._selectedCondition = selectedCondition
        self._selectedSize = selectedSize
        self._minPrice = minPrice
        self._maxPrice = maxPrice

        self._tempCategory = State(initialValue: selectedCategory.wrappedValue)
        self._tempCondition = State(initialValue: selectedCondition.wrappedValue)
        self._tempSize = State(initialValue: selectedSize.wrappedValue)
        self._tempMinPrice = State(initialValue: minPrice.wrappedValue)
        self._tempMaxPrice = State(initialValue: maxPrice.wrappedValue)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.rwBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {

                        VStack(alignment: .leading, spacing: 14) {
                            Text("Price Range")
                                .font(.rwHeading)
                                .foregroundColor(Color.rwTextPrimary)

                            // Price display
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Min")
                                        .font(.rwMicro)
                                        .foregroundColor(Color.rwTextSecondary)
                                    Text(String(format: "BHD %.1f", tempMinPrice))
                                        .font(.rwBodyBold)
                                        .foregroundColor(Color.rwPrimary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(Color.rwSageTint)
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.rwBorder, lineWidth: 1))

                                Text("—")
                                    .foregroundColor(Color.rwTextSecondary)
                                    .padding(.horizontal, 8)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Max")
                                        .font(.rwMicro)
                                        .foregroundColor(Color.rwTextSecondary)
                                    Text(String(format: "BHD %.1f", tempMaxPrice))
                                        .font(.rwBodyBold)
                                        .foregroundColor(Color.rwPrimary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(Color.rwSageTint)
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.rwBorder, lineWidth: 1))
                            }

                            // Min slider
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Minimum")
                                    .font(.rwMicro)
                                    .foregroundColor(Color.rwTextSecondary)
                                Slider(value: $tempMinPrice, in: 0...max(tempMaxPrice - 0.5, 0.5), step: 0.5)

                                    .tint(Color.rwPrimary)
                            }
                            //max slider
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Maximum")
                                    .font(.rwMicro)
                                    .foregroundColor(Color.rwTextSecondary)
                                Slider(value: $tempMaxPrice, in: min(tempMinPrice + 0.5, 99.5)...100, step: 0.5)
                                    .tint(Color.rwPrimary)
                            }
                        }

                        RWDivider()

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Category")
                                .font(.rwHeading)
                                .foregroundColor(Color.rwTextPrimary)

                            LazyVGrid(
                                columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                                spacing: 8
                            ) {
                                ForEach(categories, id: \.self) { cat in
                                    RWCategoryChip(
                                        label: cat,
                                        isSelected: tempCategory == cat,
                                        action: { tempCategory = cat }
                                    )
                                }
                            }
                        }

                        RWDivider()

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Condition")
                                .font(.rwHeading)
                                .foregroundColor(Color.rwTextPrimary)

                            LazyVGrid(
                                columns: [GridItem(.flexible()), GridItem(.flexible())],
                                spacing: 8
                            ) {
                                ForEach(conditions, id: \.self) { c in
                                    RWCategoryChip(
                                        label: c,
                                        isSelected: tempCondition == c,
                                        action: { tempCondition = c }
                                    )
                                }
                            }
                        }

                        RWDivider()

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Size")
                                .font(.rwHeading)
                                .foregroundColor(Color.rwTextPrimary)

                            LazyVGrid(
                                columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                                spacing: 8
                            ) {
                                ForEach(sizes, id: \.self) { s in
                                    Button(action: { tempSize = s }) {
                                        Text(s)
                                            .font(.rwCaptionBold)
                                            .foregroundColor(tempSize == s ? .white : Color.rwPrimary)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                            .background(tempSize == s ? Color.rwPrimary : Color.rwSageTint)
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(tempSize == s ? Color.clear : Color.rwSage, lineWidth: 1)
                                            )
                                    }
                                }
                            }
                        }

                        // Bottom padding for buttons
                        Spacer().frame(height: 80)
                    }
                    .padding(20)
                }

                // ── Sticky bottom buttons ────────────────────────────────
                VStack {
                    Spacer()
                    HStack(spacing: 12) {
                        RWOutlineButton(label: "Clear All") {
                            tempCategory = "All"
                            tempCondition = "Any"
                            tempSize = "Any"
                            tempMinPrice = 0
                            tempMaxPrice = 100
                        }
                        .frame(width: 120)

                        RWPrimaryButton(label: "Apply Filters") {
                            selectedCategory = tempCategory
                            selectedCondition = tempCondition
                            selectedSize = tempSize
                            minPrice = tempMinPrice
                            maxPrice = tempMaxPrice
                            dismiss()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(
                        Color.rwBackground
                            .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: -4)
                    )
                }
            }
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.rwBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .font(.rwBody)
                        .foregroundColor(Color.rwTextSecondary)
                }
            }
        }
    }
}

#Preview {
    SearchFilterView(
        selectedCategory: .constant("All"),
        selectedCondition: .constant("Any"),
        selectedSize: .constant("Any"),
        minPrice: .constant(0),
        maxPrice: .constant(100)
    )
}
