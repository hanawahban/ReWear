import SwiftUI

struct InboxView: View {

    let mockConversations = [
        ("Seller A", "Is this still available?", "2m ago"),
        ("Seller B", "Sure, come pick it up", "1h ago"),
        ("Seller C", "What's your best price?", "Yesterday"),
        ("Buyer D",  "I'll take it!", "Mon"),
        ("Seller E", "Already sold, sorry.", "Sun"),
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(mockConversations, id: \.0) { conv in
                    NavigationLink(destination: ChatView(sellerName: conv.0)) {
                        HStack(spacing: 12) {

                            Circle()
                                .fill(Color(.systemGray5))
                                .frame(width: 48, height: 48)
                                .overlay(Image(systemName: "person").foregroundColor(.gray))

                            VStack(alignment: .leading, spacing: 3) {
                                HStack {
                                    Text(conv.0)
                                        .font(.subheadline).bold()
                                    Spacer()
                                    Text(conv.2)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                Text(conv.1)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)

                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(.systemGray6))
                                    .frame(width: 36, height: 36)
                                    .overlay(Image(systemName: "photo").font(.caption2).foregroundColor(.gray))
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ChatView: View {

    var sellerName: String = "Seller A"
    @State private var messageText = ""

    let mockMessages: [(String, Bool)] = [
        ("Hi, is this item still available?", true),
        ("Yes it is! Are you interested?", false),
        ("Yes, what's the condition?", true),
        ("It's in great condition, barely used.", false),
        ("Can you do a lower price?", true),
        ("Best I can do is BHD 15. Final offer.", false),
    ]

    var body: some View {
        VStack(spacing: 0) {

            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(.systemGray5))
                    .frame(width: 40, height: 40)
                    .overlay(Image(systemName: "photo").font(.caption2).foregroundColor(.gray))

                VStack(alignment: .leading, spacing: 2) {
                    Text("Item Name Placeholder")
                        .font(.caption).bold()
                    Text("BHD 00.000")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Text("View Item")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color(.systemGray4)))
            }
            .padding(10)
            .background(Color(.systemGray6))

            Divider()

            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(Array(mockMessages.enumerated()), id: \.offset) { _, msg in
                        HStack {
                            if msg.1 { Spacer(minLength: 60) }

                            Text(msg.0)
                                .font(.subheadline)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(
                                    msg.1
                                    ? Color(.systemGray3)
                                    : Color(.systemGray5)
                                )
                                .cornerRadius(18)

                            if !msg.1 { Spacer(minLength: 60) }
                        }
                    }
                }
                .padding(16)
            }

            Divider()

            HStack(spacing: 10) {
                Image(systemName: "camera")
                    .foregroundColor(.gray)
                    .padding(.leading, 4)

                HStack {
                    Text("Type a message...")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .cornerRadius(20)

                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(.systemBackground))
        }
        .navigationTitle(sellerName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview { InboxView() }
#Preview("Chat") { NavigationStack { ChatView() } }
