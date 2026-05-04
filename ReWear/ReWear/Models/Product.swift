import Foundation
import CoreLocation

struct Product: Identifiable, Codable{
    var id: String
    var title: String
    var description: String
    var price: Double
    var category: String
    var condition: String
    var size: String
    var brand: String
    var imageURLs: [String]
    var sellerID: String
    var sellerName: String
    var latitude: Double
    var longitude: Double
    var location: String
    var rating: Double
    var reviewCount: Int
    var isSold: Bool
    var createdAt: Date

    var formattedPrice: String {
        String(format: "BHD %.3f", price)
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    static let mock = Product(
        id: "mock_001",
        title: "Linen Blazer — Beige",
        description: "Beautiful linen blazer in a warm beige tone. Barely worn, no stains or damage.",
        price: 8.500,
        category: "Tops",
        condition: "Like New",
        size: "M",
        brand: "Zara",
        imageURLs: [],
        sellerID: "seller_001",
        sellerName: "Sara M.",
        latitude: 26.0667,
        longitude: 50.5577,
        location: "Manama",
        rating: 4.8,
        reviewCount: 12,
        isSold: false,
        createdAt: Date()
    )

    static let mockList: [Product] = [
        Product(id: "1", title: "Linen Blazer", description: "", price: 8.500, category: "Tops", condition: "Like New", size: "M", brand: "Zara", imageURLs: [], sellerID: "s1", sellerName: "Sara M.", latitude: 26.068, longitude: 50.558, location: "Manama", rating: 4.8, reviewCount: 12, isSold: false, createdAt: Date()),
        Product(id: "2", title: "Floral Midi Dress", description: "", price: 5.000, category: "Dresses", condition: "Good", size: "S", brand: "H&M", imageURLs: [], sellerID: "s2", sellerName: "Lena K.", latitude: 26.065, longitude: 50.562, location: "Riffa", rating: 4.5, reviewCount: 8, isSold: false, createdAt: Date()),
        Product(id: "3", title: "Leather Tote Bag", description: "", price: 12.000, category: "Bags", condition: "Like New", size: "One Size", brand: "Mango", imageURLs: [], sellerID: "s3", sellerName: "Nour A.", latitude: 26.070, longitude: 50.555, location: "Juffair", rating: 5.0, reviewCount: 20, isSold: false, createdAt: Date()),
        Product(id: "4", title: "Denim Jacket", description: "", price: 7.500, category: "Outerwear", condition: "Good", size: "L", brand: "Levi's", imageURLs: [], sellerID: "s1", sellerName: "Sara M.", latitude: 26.062, longitude: 50.560, location: "Muharraq", rating: 4.2, reviewCount: 5, isSold: false, createdAt: Date()),
        Product(id: "5", title: "Silk Blouse", description: "", price: 4.000, category: "Tops", condition: "Fair", size: "S", brand: "Massimo Dutti", imageURLs: [], sellerID: "s2", sellerName: "Lena K.", latitude: 26.066, longitude: 50.556, location: "Manama", rating: 3.9, reviewCount: 3, isSold: false, createdAt: Date()),
        Product(id: "6", title: "Wool Coat", description: "", price: 18.000, category: "Outerwear", condition: "Like New", size: "M", brand: "Zara", imageURLs: [], sellerID: "s3", sellerName: "Nour A.", latitude: 26.071, longitude: 50.563, location: "Saar", rating: 4.9, reviewCount: 15, isSold: false, createdAt: Date()),
    ]
}
