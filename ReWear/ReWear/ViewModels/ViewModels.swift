import Foundation
import SwiftUI
import CoreLocation


class ChatViewModel: ObservableObject {

    @Published var conversations: [Conversation] = []
    @Published var messages: [Message] = []
    @Published var isLoading: Bool = false

    //Fetch all conversations 
    func fetchConversations(userID: String) {
        isLoading = true

        //connect to db

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.conversations = Conversation.mockList
            self.isLoading = false
        }
    }

    func fetchMessages(conversationID: String, currentUserID: String) {
        isLoading = true

        // connect to db

        messages = Message.mockThread.map { msg in
            var m = msg
            m.isMine = m.senderID == "user_001"
            return m
        }
        isLoading = false
    }

    // send message
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

        // connect to db

        messages.append(message)
    }

    func markAsRead(conversationID: String, userID: String) {
        // firestore update
    }
}



class ReviewViewModel: ObservableObject {

    @Published var reviews: [Review] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    func fetchReviews(sellerID: String) {
        isLoading = true

        //db connection here

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.reviews = Review.mockList
            self.isLoading = false
        }
    }

    func submitReview(review: Review, completion: @escaping (Bool) -> Void) {
        isLoading = true

        // db connection here

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.reviews.insert(review, at: 0)
            self.isLoading = false
            completion(true)
        }
    }

    func averageRating() -> Double {
        guard !reviews.isEmpty else { return 0 }
        let total = reviews.reduce(0) { $0 + Double($1.rating) }
        return (total / Double(reviews.count) * 10).rounded() / 10
    }

    // update seller rating
    func updateSellerRating(sellerID: String) {
        //calcualte the rating
    }
}

//GPS

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {

    @Published var userLocation: CLLocationCoordinate2D? = nil
    @Published var locationAuthorized: Bool = false
    @Published var currentCity: String = "Manama"

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdating() {
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location.coordinate

        // geocoding
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationAuthorized = manager.authorizationStatus == .authorizedWhenInUse
            || manager.authorizationStatus == .authorizedAlways
        if locationAuthorized { startUpdating() }
    }

    func distance(to product: Product) -> String {
        guard let userLoc = userLocation else { return "" }
        let productLoc = CLLocation(latitude: product.latitude, longitude: product.longitude)
        let userCLLoc = CLLocation(latitude: userLoc.latitude, longitude: userLoc.longitude)
        let distanceKm = productLoc.distance(from: userCLLoc) / 1000
        return String(format: "%.1f km", distanceKm)
    }
}
