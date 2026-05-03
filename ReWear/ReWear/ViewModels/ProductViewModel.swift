import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import Combine

@MainActor
class ProductViewModel: ObservableObject {

    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var favoriteProducts: [Product] = []
    @Published var myListings: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText: String = "" {
        didSet { applyFilters() }
    }
    @Published var selectedCategory: String = "All" {
        didSet { applyFilters() }
    }

    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    init() {
        fetchProducts()
    }

    func fetchProducts() {
        isLoading = true
        db.collection("listings")
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                }

                if let error = error {
                    print("Error fetching listings: \(error.localizedDescription)")
                    return
                }
                guard let documents = snapshot?.documents else { return }

                let fetched = documents.compactMap { doc -> Product? in
                    try? doc.data(as: Product.self)
                }

                DispatchQueue.main.async {
                    self.products = fetched
                    self.applyFilters()
                }
            }
    }

    func fetchProduct(id: String, completion: @escaping (Product?) -> Void) {
        db.collection("listings").document(id).getDocument { snap, error in
            if let error = error {
                print("Error fetching listing: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let snap = snap, let product = try? snap.data(as: Product.self) else {
                completion(nil)
                return
            }
            completion(product)
        }
    }

    func fetchMyListings(sellerID: String) {
        db.collection("listings")
            .whereField("sellerID", isEqualTo: sellerID)
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching user listings: \(error.localizedDescription)")
                    return
                }
                guard let documents = snapshot?.documents else { return }

                let fetched = documents.compactMap { doc -> Product? in
                    try? doc.data(as: Product.self)
                }

                DispatchQueue.main.async {
                    self.myListings = fetched
                }
            }
    }

    func postProduct(
        title: String,
        description: String,
        price: Double,
        category: String,
        condition: String,
        size: String,
        brand: String,
        location: String,
        coord: (Double, Double)?,
        images: [UIImage],
        completion: @escaping (Bool) -> Void
    ) {
        guard let user = Auth.auth().currentUser else {
            print("No logged-in user")
            completion(false)
            return
        }

        isLoading = true
        let id = UUID().uuidString

        Task {
            var imageURLs: [String] = []

            for (index, image) in images.enumerated() {
                guard let data = image.jpegData(compressionQuality: 0.8) else { continue }
                let ref = storage.reference().child("listingImages/\(id)_\(index).jpg")
                do {
                    _ = try await ref.putDataAsync(data)
                    let url = try await ref.downloadURL()
                    imageURLs.append(url.absoluteString)
                } catch {
                    print("Error uploading image \(index): \(error.localizedDescription)")
                }
            }

            let product = Product(
                id: id,
                title: title,
                description: description,
                price: price,
                category: category,
                condition: condition,
                size: size,
                brand: brand,
                imageURLs: imageURLs,
                sellerID: user.uid,
                sellerName: user.email ?? "Unknown User",
                latitude: coord?.0 ?? 0.0,
                longitude: coord?.1 ?? 0.0,
                location: location,
                rating: 0.0,
                reviewCount: 0,
                isSold: false,
                createdAt: Date()
            )

            do {
                try db.collection("listings").document(id).setData(from: product)
                DispatchQueue.main.async {
                    self.products.insert(product, at: 0)
                    self.applyFilters()
                    self.isLoading = false
                    completion(true)
                }
            } catch {
                print("Error writing listing to Firestore: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isLoading = false
                    completion(false)
                }
            }
        }
    }

    func deleteProduct(id: String) {
        db.collection("listings").document(id).delete { error in
            if let error = error {
                print("Error deleting listing: \(error.localizedDescription)")
            }
        }
        products.removeAll { $0.id == id }
        applyFilters()
    }

    func toggleFavorite(product: Product, userID: String) {
        if favoriteProducts.contains(where: { $0.id == product.id }) {
            favoriteProducts.removeAll { $0.id == product.id }
        } else {
            favoriteProducts.append(product)
        }
    }

    func isFavorited(_ product: Product) -> Bool {
        favoriteProducts.contains { $0.id == product.id }
    }

    func fetchFavorites(userID: String) {
        favoriteProducts = Array(Product.mockList.prefix(3))
    }

    func applyFilters() {
        var result = products

        if selectedCategory != "All" {
            result = result.filter { $0.category == selectedCategory }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.brand.localizedCaseInsensitiveContains(searchText) ||
                $0.category.localizedCaseInsensitiveContains(searchText)
            }
        }

        filteredProducts = result
    }
}
