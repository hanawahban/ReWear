import Foundation

//user data
struct RWUser: Identifiable, Codable {
    var id: String
    var name: String
    var email: String
    var profileImageURL: String
    var location: String
    var rating: Double
    var reviewCount: Int
    var listingCount: Int
    var joinedDate: Date
    var bio: String

    var initials: String {
        let parts = name.split(separator: " ")
        let first = parts.first?.prefix(1) ?? ""
        let last = parts.last?.prefix(1) ?? ""
        return "\(first)\(last)".uppercased()
    }

    //mock data
    static let mock = RWUser(
        id: "user_001",
        name: "Sara Mohammed",
        email: "sara@example.com",
        profileImageURL: "",
        location: "Manama, Bahrain",
        rating: 4.8,
        reviewCount: 31,
        listingCount: 12,
        joinedDate: Date(),
        bio: "Fashion lover, sustainable shopper."
    )
}

struct Message: Identifiable, Codable {
    var id: String
    var senderID: String
    var receiverID: String
    var productID: String
    var text: String
    var timestamp: Date
    var isRead: Bool

    var isMine: Bool = false // set at runtime based on current user

    //Mock data
    static let mockThread: [Message] = [
        Message(id: "m1", senderID: "user_001", receiverID: "seller_001", productID: "1", text: "Hi! Is the linen blazer still available?", timestamp: Date(), isRead: true),
        Message(id: "m2", senderID: "seller_001", receiverID: "user_001", productID: "1", text: "Yes it is! Are you interested?", timestamp: Date(), isRead: true),
        Message(id: "m3", senderID: "user_001", receiverID: "seller_001", productID: "1", text: "Yes, what's the condition like?", timestamp: Date(), isRead: true),
        Message(id: "m4", senderID: "seller_001", receiverID: "user_001", productID: "1", text: "It's like new, barely worn. No stains.", timestamp: Date(), isRead: false),
    ]
}


// inbox thread

struct Conversation: Identifiable, Codable {
    var id: String
    var otherUserID: String
    var otherUserName: String
    var otherUserInitials: String
    var productID: String
    var productTitle: String
    var lastMessage: String
    var lastMessageDate: Date
    var hasUnread: Bool

    // Mock data
    static let mockList: [Conversation] = [
        Conversation(id: "c1", otherUserID: "s1", otherUserName: "Sara M.", otherUserInitials: "SM", productID: "1", productTitle: "Linen Blazer", lastMessage: "Is this still available?", lastMessageDate: Date(), hasUnread: true),
        Conversation(id: "c2", otherUserID: "s2", otherUserName: "Lena K.", otherUserInitials: "LK", productID: "2", productTitle: "Floral Dress", lastMessage: "Sure, come pick it up!", lastMessageDate: Date(), hasUnread: false),
        Conversation(id: "c3", otherUserID: "s3", otherUserName: "Nour A.", otherUserInitials: "NA", productID: "3", productTitle: "Leather Tote", lastMessage: "What's your best price?", lastMessageDate: Date(), hasUnread: false),
    ]
}

// Reviews

struct Review: Identifiable, Codable {
    var id: String
    var reviewerID: String
    var reviewerName: String
    var reviewerInitials: String
    var sellerID: String
    var productID: String
    var rating: Int        // 1–5
    var comment: String
    var date: Date

    // Mock data
    static let mockList: [Review] = [
        Review(id: "r1", reviewerID: "u1", reviewerName: "Lena K.", reviewerInitials: "LK", sellerID: "s1", productID: "1", rating: 5, comment: "Great seller, super fast response. Item exactly as described!", date: Date()),
        Review(id: "r2", reviewerID: "u2", reviewerName: "Nour A.", reviewerInitials: "NA", sellerID: "s1", productID: "2", rating: 4, comment: "Lovely piece, arrived well packaged.", date: Date()),
        Review(id: "r3", reviewerID: "u3", reviewerName: "Farah S.", reviewerInitials: "FS", sellerID: "s1", productID: "3", rating: 5, comment: "Would definitely buy from again.", date: Date()),
    ]
}
