import Foundation
import SwiftUI
import CoreLocation
import FirebaseFirestore
import FirebaseAuth
import Combine

@MainActor
class ChatViewModel: ObservableObject {
    @Published var conversations: [Conversation] = []
    @Published var messages: [Message] = []
    @Published var isLoading: Bool = false
    
    private let db = Firestore.firestore()

    func fetchConversations(userID: String) {
        isLoading = true
        db.collection("conversations")
            .whereField("participants", arrayContains: userID)
            .addSnapshotListener { snapshot, error in
                Task { @MainActor in
                    if let documents = snapshot?.documents {
                        self.conversations = documents.compactMap { doc -> Conversation? in
                            guard var conv = try? doc.data(as: Conversation.self) else { return nil }
                            if conv.buyerID == userID {
                                conv.otherUserName = conv.sellerName
                                conv.otherUserID = conv.sellerID
                                conv.otherUserInitials = String(conv.sellerName.prefix(2)).uppercased()
                            } else {
                                conv.otherUserName = conv.buyerName
                                conv.otherUserID = conv.buyerID
                                conv.otherUserInitials = String(conv.buyerName.prefix(2)).uppercased()
                            }
                            return conv
                        }
                    }
                    self.isLoading = false
                }
            }
    }

    func fetchMessages(conversationID: String, currentUserID: String) {
        isLoading = true
        db.collection("conversations").document(conversationID).collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                Task { @MainActor in
                    if let documents = snapshot?.documents {
                        self.messages = documents.compactMap { doc in
                            if var m = try? doc.data(as: Message.self) {
                                m.isMine = (m.senderID == currentUserID)
                                return m
                            }
                            return nil
                        }
                    }
                    self.isLoading = false
                }
            }
    }

    func sendMessage(text: String, senderID: String, receiverID: String, productID: String, conversationID: String) {
        let message = Message(
            id: UUID().uuidString,
            senderID: senderID,
            receiverID: receiverID,
            productID: productID,
            text: text,
            timestamp: Date(),
            isRead: false,
            isMine: true
        )

        do {
            try db.collection("conversations").document(conversationID).collection("messages").document(message.id).setData(from: message)
            db.collection("conversations").document(conversationID).updateData([
                "lastMessage": text,
                "lastMessageTimestamp": FieldValue.serverTimestamp()
            ])
        } catch {
            print(error.localizedDescription)
        }
    }

    func markAsRead(conversationID: String, userID: String) {
        db.collection("conversations").document(conversationID).updateData([
            "isRead": true
        ])
    }

    func getOrCreateConversation(
        buyerID: String,
        buyerName: String,
        sellerID: String,
        sellerName: String,
        productID: String,
        productTitle: String,
        completion: @escaping (Conversation) -> Void
    ) {
        db.collection("conversations")
            .whereField("participants", arrayContains: buyerID)
            .getDocuments { snapshot, _ in
                if let existing = snapshot?.documents
                    .compactMap({ try? $0.data(as: Conversation.self) })
                    .first(where: { $0.sellerID == sellerID && $0.productID == productID }) {
                    completion(existing)
                    return
                }

                // Create a new conversation
                let id = UUID().uuidString
                let conversation = Conversation(
                    id: id,
                    otherUserID: sellerID,
                    otherUserName: sellerName,
                    otherUserInitials: String(sellerName.prefix(2)).uppercased(),
                    productID: productID,
                    productTitle: productTitle,
                    lastMessage: "",
                    lastMessageDate: Date(),
                    hasUnread: false,
                    buyerID: buyerID,
                    buyerName: buyerName,
                    sellerID: sellerID,
                    sellerName: sellerName
                )

                let data: [String: Any] = [
                    "id": id,
                    "participants": [buyerID, sellerID],
                    "otherUserID": sellerID,
                    "otherUserName": sellerName,
                    "otherUserInitials": String(sellerName.prefix(2)).uppercased(),
                    "productID": productID,
                    "productTitle": productTitle,
                    "lastMessage": "",
                    "lastMessageDate": Timestamp(),
                    "hasUnread": false,
                    "buyerID": buyerID,
                    "buyerName": buyerName,
                    "sellerID": sellerID,
                    "sellerName": sellerName
                ]

                self.db.collection("conversations").document(id).setData(data) { _ in
                    completion(conversation)
                }
            }
    }
}

@MainActor
class ReviewViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let db = Firestore.firestore()

    func fetchReviews(sellerID: String) {
        isLoading = true
        db.collection("reviews")
            .whereField("sellerID", isEqualTo: sellerID)
            .getDocuments { snapshot, error in
                Task { @MainActor in
                    if let documents = snapshot?.documents {
                        self.reviews = documents.compactMap { try? $0.data(as: Review.self) }
                    }
                    self.isLoading = false
                }
            }
    }

    func submitReview(review: Review, completion: @escaping (Bool) -> Void) {
        isLoading = true
        do {
            try db.collection("reviews").document(review.id).setData(from: review)
            self.reviews.insert(review, at: 0)
            self.updateSellerRating(sellerID: review.sellerID)
            self.isLoading = false
            completion(true)
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            completion(false)
        }
    }

    func averageRating() -> Double {
        guard !reviews.isEmpty else { return 0 }
        let total = reviews.reduce(0) { $0 + Double($1.rating) }
        return (total / Double(reviews.count) * 10).rounded() / 10
    }

    func updateSellerRating(sellerID: String) {
        let newRating = averageRating()
        db.collection("users").document(sellerID).updateData([
            "rating": newRating
        ])
    }
}

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocationCoordinate2D? = nil
    @Published var locationAuthorized: Bool = false
    @Published var currentCity: String = "Manama"

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters

        #if targetEnvironment(simulator)
        let simLocation = CLLocation(latitude: 26.2167, longitude: 50.4833)
        self.userLocation = simLocation.coordinate
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(simLocation) { placemarks, error in
            guard let placemark = placemarks?.first else { return }
            DispatchQueue.main.async {
                self.currentCity = placemark.subLocality ?? placemark.locality ?? placemark.administrativeArea ?? "Bahrain"
            }
        }
        #endif

        if locationManager.authorizationStatus == .authorizedWhenInUse ||
           locationManager.authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }

    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdating() {
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        Task { @MainActor in
            self.userLocation = location.coordinate
        }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first else { return }
            DispatchQueue.main.async {
                self.currentCity = placemark.subLocality ?? placemark.locality ?? placemark.administrativeArea ?? "Bahrain"
            }
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        Task { @MainActor in
            self.locationAuthorized = status == .authorizedWhenInUse || status == .authorizedAlways
            if self.locationAuthorized { self.startUpdating() }
        }
    }

    func distance(to product: Product) -> String {
        guard let userLoc = userLocation else { return "" }
        let productLoc = CLLocation(latitude: product.latitude, longitude: product.longitude)
        let userCLLoc = CLLocation(latitude: userLoc.latitude, longitude: userLoc.longitude)
        let distanceKm = productLoc.distance(from: userCLLoc) / 1000
        return String(format: "%.1f km", distanceKm)
    }
}
