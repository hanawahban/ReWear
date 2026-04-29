import SwiftUI

struct HomeView: View {

    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var selectedCondition = "Any"
    @State private var selectedSize = "Any"
    @State private var minPrice = 0.0
    @State private var maxPrice = 100.0
    @State private var showFilterSheet = false

    let categories = ["All", "Tops", "Dresses", "Outerwear", "Bottoms", "Shoes", "Bags", "Accessories"]

    let allProducts = Product.mockList

    var filteredProducts: [Product] {
        allProducts.filter { product in

            let categoryMatch = selectedCategory == "All" || product.category == selectedCategory

            let searchMatch = searchText.isEmpty ||
                product.title.localizedCaseInsensitiveContains(searchText) ||
                product.brand.localizedCaseInsensitiveContains(searchText) ||
                product.category.localizedCaseInsensitiveContains(searchText)

            // Condition filter
            let conditionMatch = selectedCondition == "Any" || product.condition == selectedCondition

            // Size filter
            let sizeMatch = selectedSize == "Any" || product.size == selectedSize

            // Price filter
            let priceMatch = product.price >= minPrice && product.price <= maxPrice

            return categoryMatch && searchMatch && conditionMatch && sizeMatch && priceMatch
        }
    }

    var activeFilterCount: Int {
        var count = 0
        if selectedCategory != "All" { count += 1 }
        if selectedCondition != "Any" { count += 1 }
        if selectedSize != "Any" { count += 1 }
        if minPrice > 0 || maxPrice < 100 { count += 1 }
        return count
    }

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

                        TextField("Search for pieces...", text: $searchText)
                            .font(.rwBody)
                            .foregroundColor(Color.rwTextPrimary)

                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(Color.rwTextSecondary)
                                    .font(.system(size: 15))
                            }
                        }

                        Button(action: { showFilterSheet = true }) {
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: "slider.horizontal.3")
                                    .foregroundColor(activeFilterCount > 0 ? Color.rwPrimary : Color.rwTextSecondary)
                                    .font(.system(size: 15))

                                if activeFilterCount > 0 {
                                    ZStack {
                                        Circle()
                                            .fill(Color.rwPrimary)
                                            .frame(width: 14, height: 14)
                                        Text("\(activeFilterCount)")
                                            .font(.system(size: 8, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    .offset(x: 6, y: -6)
                                }
                            }
                        }
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
                                    action: {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            selectedCategory = cat
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 16)

                    if searchText.isEmpty && activeFilterCount == 0 {
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
                        .transition(.opacity)
                    }

                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {

                            HStack {
                                if searchText.isEmpty && activeFilterCount == 0 {
                                    RWSectionHeader(title: "Recent listings", actionLabel: "See all")
                                } else {
                                    Text("\(filteredProducts.count) result\(filteredProducts.count == 1 ? "" : "s")")
                                        .font(.rwCaption)
                                        .foregroundColor(Color.rwTextSecondary)

                                    Spacer()

                                    if activeFilterCount > 0 {
                                        Button(action: clearFilters) {
                                            Text("Clear filters")
                                                .font(.rwCaptionBold)
                                                .foregroundColor(Color.rwPrimary)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)

                            if filteredProducts.isEmpty {
                                VStack(spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.rwSageTint)
                                            .frame(width: 90, height: 90)
                                        Image(systemName: "magnifyingglass")
                                            .font(.system(size: 36, weight: .thin))
                                            .foregroundColor(Color.rwSage)
                                    }
                                    Text("No pieces found")
                                        .font(.rwHeading)
                                        .foregroundColor(Color.rwTextPrimary)
                                    Text("Try adjusting your search\nor clearing your filters.")
                                        .font(.rwBody)
                                        .foregroundColor(Color.rwTextSecondary)
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(4)
                                    RWOutlineButton(label: "Clear filters", action: clearFilters)
                                        .frame(width: 160)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, 40)
                            } else {
                                LazyVGrid(
                                    columns: [GridItem(.flexible()), GridItem(.flexible())],
                                    spacing: 14
                                ) {
                                    ForEach(filteredProducts) { product in
                                        NavigationLink(destination: ProductDetailView()) {
                                            RWProductCard(
                                                title: product.title,
                                                price: product.formattedPrice,
                                                location: product.location,
                                                condition: product.condition,
                                                rating: product.rating
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
            .sheet(isPresented: $showFilterSheet) {
                SearchFilterView(
                    selectedCategory: $selectedCategory,
                    selectedCondition: $selectedCondition,
                    selectedSize: $selectedSize,
                    minPrice: $minPrice,
                    maxPrice: $maxPrice
                )
            }
        }
    }

    func clearFilters() {
        withAnimation {
            searchText = ""
            selectedCategory = "All"
            selectedCondition = "Any"
            selectedSize = "Any"
            minPrice = 0
            maxPrice = 100
        }
    }
}

#Preview { HomeView() }
