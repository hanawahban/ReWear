//import Foundation
//import SwiftUI
//
//
//class ProductViewModel: ObservableObject {
//
//    @Published var products: [Product] = []
//    @Published var filteredProducts: [Product] = []
//    @Published var favoriteProducts: [Product] = []
//    @Published var myListings: [Product] = []
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String? = nil
//    @Published var searchText: String = "" {
//        didSet { applyFilters() }
//    }
//    @Published var selectedCategory: String = "All" {
//        didSet { applyFilters() }
//    }
//
//    init() {
//        fetchProducts()
//    }
//
//    func fetchProducts() {
//        isLoading = true
//
//        // fetch here
//
//       // Mock
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.products = Product.mockList
//            self.applyFilters()
//            self.isLoading = false
//        }
//    }
//
//    func fetchProduct(id: String, completion: @escaping (Product?) -> Void) {
//        // backend code to fetch product here
//
//        completion(products.first { $0.id == id })
//    }
//    //Fetch products by seller
//    func fetchMyListings(sellerID: String) {
//        //connect to db
//
//        myListings = Product.mockList.filter { $0.sellerID == sellerID }
//    }
//
//    func postProduct(product: Product, images: [UIImage], completion: @escaping (Bool) -> Void) {
//        isLoading = true
//
//        // firestore stuff here
//
//        // Mock implementation
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.products.insert(product, at: 0)
//            self.applyFilters()
//            self.isLoading = false
//            completion(true)
//        }
//    }
//
//    func deleteProduct(id: String) {
//        // need function to ac delete
//
//        products.removeAll { $0.id == id }
//        applyFilters()
//    }
//
//    func toggleFavorite(product: Product, userID: String) {
//        let isFav = favoriteProducts.contains { $0.id == product.id }
//
//        // backend here
//
//        if isFav {
//            favoriteProducts.removeAll { $0.id == product.id }
//        } else {
//            favoriteProducts.append(product)
//        }
//    }
//
//    func isFavorited(_ product: Product) -> Bool {
//        favoriteProducts.contains { $0.id == product.id }
//    }
//
//    func fetchFavorites(userID: String) {
//        // fetch favs here
//
//        favoriteProducts = Array(Product.mockList.prefix(3))
//    }
//
//    func applyFilters() {
//        var result = products
//
//        if selectedCategory != "All" {
//            result = result.filter { $0.category == selectedCategory }
//        }
//
//        if !searchText.isEmpty {
//            result = result.filter {
//                $0.title.localizedCaseInsensitiveContains(searchText) ||
//                $0.brand.localizedCaseInsensitiveContains(searchText) ||
//                $0.category.localizedCaseInsensitiveContains(searchText)
//            }
//        }
//
//        filteredProducts = result
//    }
//}
