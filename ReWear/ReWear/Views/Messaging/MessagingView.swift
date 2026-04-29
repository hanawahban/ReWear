import SwiftUI


struct InboxView: View {

    let conversations: [(String, String, String, String, Bool)] = [
        ("Sara M.", "Is this still available?", "2m", "SM", true),
        ("Lena K.", "Sure, come pick it up anytime!", "1h", "LK", false),
        ("Nour A.", "What's your best price?", "Yesterday", "NA", false),
        ("Farah S.", "I'll take it!", "Mon", "FS", true),
        ("Hana J.", "Already sold, sorry.", "Sun", "HJ", false),
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.rwBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Messages")
                            .font(.rwTitle)
                            .foregroundColor(Color.rwTextPrimary)
                        Spacer()
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 18))
                            .foregroundColor(Color.rwPrimary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 14)

                    RWDivider()

                    List {
                        ForEach(conversations, id: \.0) { conv in
                            NavigationLink(destination: ChatView(sellerName: conv.0, initials: conv.3)) {
                                HStack(spacing: 14) {
                                    ZStack(alignment: .bottomTrailing) {
                                        RWAvatar(initials: conv.3, size: 50)
                                        if conv.4 {
                                            Circle()
                                                .fill(Color.rwPrimary)
                                                .frame(width: 12, height: 12)
                                                .overlay(Circle().stroke(Color.rwBackground, lineWidth: 2))
                                        }
                                    }

                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text(conv.0)
                                                .font(.rwBodyBold)
                                                .foregroundColor(Color.rwTextPrimary)
                                            Spacer()
                                            Text(conv.2)
                                                .font(.rwMicro)
                                                .foregroundColor(Color.rwTextSecondary)
                                        }
                                        Text(conv.1)
                                            .font(.rwCaption)
                                            .foregroundColor(conv.4 ? Color.rwTextPrimary : Color.rwTextSecondary)
                                            .lineLimit(1)
                                            .fontWeight(conv.4 ? .semibold : .regular)
                                    }
                                }
                                .padding(.vertical, 6)
                            }
                            .listRowBackground(Color.rwBackground)
                            .listRowSeparatorTint(Color.rwBorder)
                        }
                    }
                    .listStyle(.plain)
                    .background(Color.rwBackground)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

//Chat
struct ChatView: View {

    var sellerName: String = "Sara M."
    var initials: String = "SM"
    @State private var messageText = ""
    @Environment(\.dismiss) var dismiss

    let messages: [(String, Bool)] = [
        ("Hi! Is the linen blazer still available?", true),
        ("Yes it is! Are you interested?", false),
        ("Yes for sure. What's the condition like?", true),
        ("It's like new, barely worn. No stains.", false),
        ("Can you do BHD 7?", true),
        ("Best I can do is BHD 8. It's a great piece!", false),
        ("Deal! When can I pick it up?", true),
    ]

    var body: some View {
        VStack(spacing: 0) {

            HStack(spacing: 12) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.rwPrimary)
                }
                RWAvatar(initials: initials, size: 38)
                VStack(alignment: .leading, spacing: 2) {
                    Text(sellerName)
                        .font(.rwBodyBold)
                        .foregroundColor(Color.rwTextPrimary)
                    Text("Usually replies within an hour")
                        .font(.rwMicro)
                        .foregroundColor(Color.rwTextSecondary)
                }
                Spacer()
                Image(systemName: "ellipsis")
                    .foregroundColor(Color.rwTextSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.rwBackground)
            .overlay(alignment: .bottom) { RWDivider() }

            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.rwSageTint)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "tshirt")
                            .font(.system(size: 16, weight: .thin))
                            .foregroundColor(Color.rwSage)
                    )
                VStack(alignment: .leading, spacing: 2) {
                    Text("Linen Blazer — Beige")
                        .font(.rwCaptionBold)
                        .foregroundColor(Color.rwTextPrimary)
                    Text("BHD 8.500")
                        .font(.rwCaption)
                        .foregroundColor(Color.rwPrimary)
                }
                Spacer()
                Text("View item")
                    .font(.rwMicro)
                    .foregroundColor(Color.rwPrimary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.rwPrimary, lineWidth: 1))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.rwSurface)
            .overlay(alignment: .bottom) { RWDivider() }

            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(Array(messages.enumerated()), id: \.offset) { _, msg in
                        HStack(alignment: .bottom, spacing: 8) {
                            if msg.1 {
                                Spacer(minLength: 60)
                            } else {
                                RWAvatar(initials: initials, size: 28)
                            }

                            Text(msg.0)
                                .font(.rwBody)
                                .foregroundColor(msg.1 ? .white : Color.rwTextPrimary)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(msg.1 ? Color.rwPrimary : Color.rwSurface)
                                .cornerRadius(msg.1 ? 18 : 18)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(msg.1 ? Color.clear : Color.rwBorder, lineWidth: 1)
                                )

                            if !msg.1 {
                                Spacer(minLength: 60)
                            }
                        }
                    }
                }
                .padding(16)
            }
            .background(Color.rwBackground)

            RWDivider()

            HStack(spacing: 10) {
                Image(systemName: "camera")
                    .font(.system(size: 18))
                    .foregroundColor(Color.rwTextSecondary)

                HStack {
                    Text("Message...")
                        .font(.rwBody)
                        .foregroundColor(Color.rwTextSecondary)
                    Spacer()
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.rwSageTint)
                .cornerRadius(22)
                .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.rwBorder, lineWidth: 1))

                ZStack {
                    Circle()
                        .fill(Color.rwPrimary)
                        .frame(width: 36, height: 36)
                    Image(systemName: "arrow.up")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.rwBackground)
        }
        .navigationBarHidden(true)
        .background(Color.rwBackground)
    }
}

#Preview("Inbox") { InboxView() }
#Preview("Chat") { ChatView() }
