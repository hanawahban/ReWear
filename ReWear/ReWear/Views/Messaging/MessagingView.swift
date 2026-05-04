import SwiftUI
import FirebaseAuth

struct InboxView: View {

    @StateObject private var chatVM = ChatViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var searchText = ""

    var filteredConversations: [Conversation] {
        if searchText.isEmpty { return chatVM.conversations }
        return chatVM.conversations.filter {
            $0.otherUserName.localizedCaseInsensitiveContains(searchText)
        }
    }

    var unreadCount: Int {
        chatVM.conversations.filter { $0.hasUnread }.count
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.rwBackground.ignoresSafeArea()

                VStack(spacing: 0) {

                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Messages")
                                .font(.rwTitle)
                                .foregroundColor(Color.rwTextPrimary)
                            if unreadCount > 0 {
                                Text("\(unreadCount) unread")
                                    .font(.rwMicro)
                                    .foregroundColor(Color.rwSage)
                            }
                        }
                        Spacer()
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 18))
                            .foregroundColor(Color.rwPrimary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 14)

                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.rwTextSecondary)
                            .font(.system(size: 14))
                        TextField("Search messages...", text: $searchText)
                            .font(.rwBody)
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(Color.rwTextSecondary)
                                    .font(.system(size: 14))
                            }
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color.rwSurface)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.rwBorder, lineWidth: 1))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)

                    RWDivider()

                    if chatVM.isLoading {
                        Spacer()
                        ProgressView()
                        Spacer()
                    } else if filteredConversations.isEmpty {
                        VStack(spacing: 16) {
                            Spacer()
                            ZStack {
                                Circle().fill(Color.rwSageTint).frame(width: 80, height: 80)
                                Image(systemName: searchText.isEmpty ? "message" : "magnifyingglass")
                                    .font(.system(size: 32, weight: .thin))
                                    .foregroundColor(Color.rwSage)
                            }
                            Text(searchText.isEmpty ? "No messages yet" : "No conversations found")
                                .font(.rwHeading)
                                .foregroundColor(Color.rwTextPrimary)
                            Text(searchText.isEmpty ? "Start a conversation from any listing" : "Try a different name")
                                .font(.rwBody)
                                .foregroundColor(Color.rwTextSecondary)
                            Spacer()
                        }
                    } else {
                        List {
                            ForEach(filteredConversations) { conv in
                                NavigationLink(destination: ChatView(
                                    conversation: conv,
                                    currentUserID: authViewModel.currentUser?.id ?? ""
                                )) {
                                    HStack(spacing: 14) {
                                        ZStack(alignment: .bottomTrailing) {
                                            RWAvatar(initials: conv.otherUserInitials, size: 50)
                                            if conv.hasUnread {
                                                Circle()
                                                    .fill(Color.rwPrimary)
                                                    .frame(width: 12, height: 12)
                                                    .overlay(Circle().stroke(Color.rwBackground, lineWidth: 2))
                                            }
                                        }
                                        VStack(alignment: .leading, spacing: 4) {
                                            HStack {
                                                Text(conv.otherUserName)
                                                    .font(conv.hasUnread ? .rwBodyBold : .rwBody)
                                                    .foregroundColor(Color.rwTextPrimary)
                                                Spacer()
                                                Text(relativeTime(conv.lastMessageDate))
                                                    .font(.rwMicro)
                                                    .foregroundColor(Color.rwTextSecondary)
                                            }
                                            Text(conv.lastMessage)
                                                .font(.rwCaption)
                                                .foregroundColor(conv.hasUnread ? Color.rwTextPrimary : Color.rwTextSecondary)
                                                .lineLimit(1)
                                                .fontWeight(conv.hasUnread ? .semibold : .regular)
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
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            if let userID = authViewModel.currentUser?.id {
                chatVM.fetchConversations(userID: userID)
            }
        }
    }

    func relativeTime(_ date: Date) -> String {
        let diff = Date().timeIntervalSince(date)
        if diff < 60 { return "Just now" }
        if diff < 3600 { return "\(Int(diff/60))m" }
        if diff < 86400 { return "\(Int(diff/3600))h" }
        let days = Int(diff/86400)
        if days == 1 { return "Yesterday" }
        if days < 7 { return "\(days)d" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

struct ChatView: View {

    let conversation: Conversation
    let currentUserID: String

    @StateObject private var chatVM = ChatViewModel()
    @State private var messageText = ""
    @Environment(\.dismiss) var dismiss
    @FocusState private var isInputFocused: Bool

    var body: some View {
        VStack(spacing: 0) {

            HStack(spacing: 12) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.rwPrimary)
                }
                RWAvatar(initials: conversation.otherUserInitials, size: 38)
                VStack(alignment: .leading, spacing: 2) {
                    Text(conversation.otherUserName)
                        .font(.rwBodyBold)
                        .foregroundColor(Color.rwTextPrimary)
                    Text(conversation.productTitle)
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

            // ── Messages ──────────────────────────────────────────────────
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(Array(chatVM.messages.enumerated()), id: \.element.id) { index, msg in
                            HStack {
                                if msg.isMine { Spacer(minLength: 60) }
                                if !msg.isMine {
                                    RWAvatar(initials: conversation.otherUserInitials, size: 28)
                                }
                                Text(msg.text)
                                    .font(.rwBody)
                                    .foregroundColor(msg.isMine ? .white : Color.rwTextPrimary)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 10)
                                    .background(msg.isMine ? Color.rwPrimary : Color.rwSurface)
                                    .cornerRadius(18)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 18)
                                            .stroke(msg.isMine ? Color.clear : Color.rwBorder, lineWidth: 1)
                                    )
                                    .id(index)
                                if !msg.isMine { Spacer(minLength: 60) }
                            }
                        }
                    }
                    .padding(16)
                }
                .background(Color.rwBackground)
                .onChange(of: chatVM.messages.count) { _, _ in
                    withAnimation {
                        proxy.scrollTo(chatVM.messages.count - 1, anchor: .bottom)
                    }
                }
            }

            RWDivider()

            HStack(spacing: 10) {
                Image(systemName: "camera")
                    .font(.system(size: 18))
                    .foregroundColor(Color.rwTextSecondary)

                TextField("Message...", text: $messageText)
                    .font(.rwBody)
                    .focused($isInputFocused)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color.rwSageTint)
                    .cornerRadius(22)
                    .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.rwBorder, lineWidth: 1))

                Button(action: sendMessage) {
                    ZStack {
                        Circle()
                            .fill(messageText.isEmpty ? Color.rwSage.opacity(0.4) : Color.rwPrimary)
                            .frame(width: 36, height: 36)
                        Image(systemName: "arrow.up")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .disabled(messageText.isEmpty)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.rwBackground)
        }
        .navigationBarHidden(true)
        .background(Color.rwBackground)
        .onAppear {
            chatVM.fetchMessages(conversationID: conversation.id, currentUserID: currentUserID)
            chatVM.markAsRead(conversationID: conversation.id, userID: currentUserID)
        }
    }

    func sendMessage() {
        guard !messageText.isEmpty else { return }
        let text = messageText
        messageText = ""
        chatVM.sendMessage(
            text: text,
            senderID: currentUserID,
            receiverID: conversation.otherUserID,
            productID: conversation.productID,
            conversationID: conversation.id
        )
    }
}

#Preview("Inbox") {
    InboxView().environmentObject(AuthViewModel(autoLoginEnabled: false))
}
