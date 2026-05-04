import SwiftUI

struct HomeView: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var selectedCondition = "Any"
    @State private var selectedSize = "Any"
    @State private var minPrice = 0.0
    @State private var maxPrice = 100.0
    @State private var showFilterSheet = false

    let categories = ["All", "Tops", "Dresses", "Outerwear", "Bottoms", "Shoes", "Bags", "Accessories"]

    var filteredProducts: [Product] {
        var list = productViewModel.products

        let categoryMatch: (Product) -> Bool = { selectedCategory == "All" || $0.category == selectedCategory }
        let searchMatch: (Product) -> Bool = {
            searchText.isEmpty ||
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.brand.localizedCaseInsensitiveContains(searchText) ||
            $0.category.localizedCaseInsensitiveContains(searchText)
        }
        let conditionMatch: (Product) -> Bool = { selectedCondition == "Any" || $0.condition == selectedCondition }
        let sizeMatch: (Product) -> Bool = { selectedSize == "Any" || $0.size == selectedSize }
        let priceMatch: (Product) -> Bool = { $0.price >= minPrice && $0.price <= maxPrice }

        list = list.filter { categoryMatch($0) && searchMatch($0) && conditionMatch($0) && sizeMatch($0) && priceMatch($0) }
        return list
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

                    // Header
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

                    // Search
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

                    // Categories
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

                    // Listings grid
                    if productViewModel.isLoading {
                        ProgressView("Loading listings...")
                            .padding(.top, 50)
                    } else if filteredProducts.isEmpty {
                        VStack(spacing: 16) {
                            ZStack {
                                Circle().fill(Color.rwSageTint).frame(width: 90, height: 90)
                                Image(systemName: "tshirt")
                                    .font(.system(size: 36, weight: .thin))
                                    .foregroundColor(Color.rwSage)
                            }
                            Text("No listings found")
                                .font(.rwHeading)
                                .foregroundColor(Color.rwTextPrimary)
                            Text("Try adjusting your filters.")
                                .font(.rwBody)
                                .foregroundColor(Color.rwTextSecondary)
                        }
                        .padding(.top, 80)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                                ForEach(filteredProducts) { product in
                                    NavigationLink(destination: ProductDetailView(product: product)) {
                                        RWProductCard(
                                            title: product.title,
                                            price: product.formattedPrice,
                                            location: product.location,
                                            condition: product.condition,
                                            rating: product.rating,
                                            imageURL: product.imageURLs.first ?? ""
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
            .onAppear {
                productViewModel.fetchProducts()
                if let uid = authViewModel.currentUser?.id {
                    productViewModel.fetchFavorites(userID: uid)
                }
            }

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
}

#Preview {
    HomeView()
        .environmentObject(ProductViewModel())
}
