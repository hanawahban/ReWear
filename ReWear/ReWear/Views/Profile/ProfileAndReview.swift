import SwiftUI

struct ProfileView: View {

    @State private var selectedTab = 0

    let myListings: [(String, String, String, String, Double)] = [
        ("Linen Blazer", "BHD 8.500", "Manama", "Like New", 4.8),
        ("Floral Dress", "BHD 5.000", "Manama", "Good", 4.5),
        ("Leather Tote", "BHD 12.000", "Manama", "Like New", 5.0),
        ("Denim Jacket", "BHD 7.500", "Manama", "Good", 4.2),
    ]

    let reviews = [
        ("Lena K.", "Super fast, item as described. Would buy again!", 5.0),
        ("Nour A.", "Lovely seller, very communicative.", 4.0),
        ("Farah S.", "Great experience overall.", 5.0),
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.rwBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {

                        VStack(spacing: 14) {
                            ZStack(alignment: .bottomTrailing) {
                                RWAvatar(initials: "HW", size: 84)
                                ZStack {
                                    Circle().fill(Color.rwPrimary).frame(width: 26, height: 26)
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 11))
                                        .foregroundColor(.white)
                                }
                            }

                            VStack(spacing: 4) {
                                Text("Hana Wahban")
                                    .font(.rwTitle)
                                    .foregroundColor(Color.rwTextPrimary)
                                Text("@HanaW · Manama, Bahrain")
                                    .font(.rwCaption)
                                    .foregroundColor(Color.rwTextSecondary)
                                HStack(spacing: 4) {
                                    RWStarRating(rating: 4.8, size: 13)
                                    Text("4.8 · 31 reviews")
                                        .font(.rwCaption)
                                        .foregroundColor(Color.rwTextSecondary)
                                }
                            }

                            HStack(spacing: 0) {
                                RWStatCell(value: "12", label: "Listings")
                                Rectangle().fill(Color.rwBorder).frame(width: 1, height: 32)
                                RWStatCell(value: "31", label: "Reviews")
                                Rectangle().fill(Color.rwBorder).frame(width: 1, height: 32)
                                RWStatCell(value: "Mar 24", label: "Joined")
                            }
                            .background(Color.rwSurface)
                            .cornerRadius(14)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.rwBorder, lineWidth: 1))

                            HStack(spacing: 10) {
                                RWOutlineButton(label: "Edit Profile")
                                RWOutlineButton(label: "Share", icon: "square.and.arrow.up")
                                    .frame(width: 100)
                            }
                        }
                        .padding(20)

                        RWDivider()

                        VStack(spacing: 10) {
                            NavigationLink(destination: FavoritesView()) {
                                RWProfileLink(icon: "heart", label: "Saved Items", count: "4")
                            }
                            .buttonStyle(.plain)

                            NavigationLink(destination: SettingsView()) {
                                RWProfileLink(icon: "gearshape", label: "Settings")
                            }
                            .buttonStyle(.plain)

                            Button(action: {}) {
                                HStack {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .font(.system(size: 15))
                                        .foregroundColor(Color.rwDanger)
                                    Text("Log Out")
                                        .font(.rwBodyBold)
                                        .foregroundColor(Color.rwDanger)
                                    Spacer()
                                }
                                .padding(14)
                                .background(Color.rwSurface)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.rwBorder, lineWidth: 1))
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)

                        RWDivider()

                        // ── Tabs ─────────────────────────────────────────
                        HStack(spacing: 0) {
                            ForEach(["My Listings", "Reviews"], id: \.self) { tab in
                                let selected = (tab == "My Listings") ? selectedTab == 0 : selectedTab == 1
                                Button(action: { selectedTab = tab == "My Listings" ? 0 : 1 }) {
                                    VStack(spacing: 8) {
                                        Text(tab)
                                            .font(.rwBodyBold)
                                            .foregroundColor(selected ? Color.rwPrimary : Color.rwTextSecondary)
                                        Rectangle()
                                            .fill(selected ? Color.rwPrimary : Color.clear)
                                            .frame(height: 2)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.horizontal, 20)
                        .overlay(alignment: .bottom) { RWDivider() }
                        .padding(.bottom, 16)

                        if selectedTab == 0 {
                            LazyVGrid(
                                columns: [GridItem(.flexible()), GridItem(.flexible())],
                                spacing: 14
                            ) {
                                ForEach(myListings, id: \.0) { item in
                                    NavigationLink(destination: ProductDetailView()) {
                                        RWProductCard(
                                            title: item.0, price: item.1,
                                            location: item.2, condition: item.3, rating: item.4
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        } else {
                            VStack(spacing: 0) {
                                ForEach(reviews, id: \.0) { r in
                                    RWReviewRow(name: r.0, text: r.1, rating: r.2)
                                    RWDivider().padding(.leading, 56)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct SellerProfileView: View {

    @State private var selectedTab = 0
    @Environment(\.dismiss) var dismiss

    let listings: [(String, String, String, String, Double)] = [
        ("Linen Blazer", "BHD 8.500", "Manama", "Like New", 4.8),
        ("Floral Dress", "BHD 5.000", "Manama", "Good", 4.5),
        ("Leather Tote", "BHD 12.000", "Manama", "Like New", 5.0),
        ("Denim Jacket", "BHD 7.500", "Manama", "Good", 4.2),
    ]

    let reviews = [
        ("Lena K.", "Lovely seller, very communicative.", 5.0),
        ("Nour A.", "Item exactly as described.", 4.0),
    ]

    var body: some View {
        ZStack {
            Color.rwBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color.rwPrimary)
                        }
                        Spacer()
                        Image(systemName: "ellipsis")
                            .foregroundColor(Color.rwTextSecondary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 12)

                    VStack(spacing: 12) {
                        RWAvatar(initials: "LK", size: 72)
                        VStack(spacing: 4) {
                            Text("Lena K.")
                                .font(.rwTitle)
                                .foregroundColor(Color.rwTextPrimary)
                            Text("@lenak · Riffa, Bahrain")
                                .font(.rwCaption)
                                .foregroundColor(Color.rwTextSecondary)
                            HStack(spacing: 4) {
                                RWStarRating(rating: 4.6, size: 13)
                                Text("4.6 · 18 reviews")
                                    .font(.rwCaption)
                                    .foregroundColor(Color.rwTextSecondary)
                            }
                        }

                        HStack(spacing: 0) {
                            RWStatCell(value: "8", label: "Listings")
                            Rectangle().fill(Color.rwBorder).frame(width: 1, height: 32)
                            RWStatCell(value: "18", label: "Reviews")
                            Rectangle().fill(Color.rwBorder).frame(width: 1, height: 32)
                            RWStatCell(value: "Jan 24", label: "Joined")
                        }
                        .background(Color.rwSurface)
                        .cornerRadius(14)
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.rwBorder, lineWidth: 1))

                        HStack(spacing: 10) {
                            NavigationLink(destination: ChatView(sellerName: "Lena K.", initials: "LK")) {
                                HStack(spacing: 6) {
                                    Image(systemName: "message")
                                        .font(.system(size: 13, weight: .semibold))
                                    Text("Message")
                                        .font(.rwBodyBold)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(Color.rwPrimary)
                                .cornerRadius(14)
                            }
                            RWOutlineButton(label: "Follow")
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)

                    RWDivider()

                    HStack(spacing: 0) {
                        ForEach(["Listings", "Reviews"], id: \.self) { tab in
                            let selected = (tab == "Listings") ? selectedTab == 0 : selectedTab == 1
                            Button(action: { selectedTab = tab == "Listings" ? 0 : 1 }) {
                                VStack(spacing: 8) {
                                    Text(tab).font(.rwBodyBold)
                                        .foregroundColor(selected ? Color.rwPrimary : Color.rwTextSecondary)
                                    Rectangle().fill(selected ? Color.rwPrimary : Color.clear).frame(height: 2)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, 20)
                    .overlay(alignment: .bottom) { RWDivider() }
                    .padding(.bottom, 16)

                    if selectedTab == 0 {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                            ForEach(listings, id: \.0) { item in
                                NavigationLink(destination: ProductDetailView()) {
                                    RWProductCard(title: item.0, price: item.1, location: item.2, condition: item.3, rating: item.4)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    } else {
                        VStack(spacing: 0) {
                            ForEach(reviews, id: \.0) { r in
                                RWReviewRow(name: r.0, text: r.1, rating: r.2)
                                RWDivider().padding(.leading, 56)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct ReviewView: View {

    @State private var selectedRating = 0
    @State private var reviewText = ""
    @State private var isSubmitting = false
    @State private var showThankYou = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.rwBackground.ignoresSafeArea()

                if showThankYou {
                    // ── Thank you screen ─────────────────────────────────
                    VStack(spacing: 28) {
                        Spacer()

                        ZStack {
                            Circle()
                                .fill(Color.rwSageTint)
                                .frame(width: 110, height: 110)
                            Image(systemName: "star.fill")
                                .font(.system(size: 50))
                                .foregroundColor(Color.rwGold)
                        }

                        VStack(spacing: 10) {
                            Text("Review Submitted!")
                                .font(.rwTitle)
                                .foregroundColor(Color.rwTextPrimary)
                            Text("Thank you for your feedback.\nIt helps the ReWear community.")
                                .font(.rwBody)
                                .foregroundColor(Color.rwTextSecondary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                        }

                        // Rating summary
                        HStack(spacing: 8) {
                            RWStarRating(rating: Double(selectedRating), size: 20)
                            Text("\(selectedRating) star\(selectedRating > 1 ? "s" : "")")
                                .font(.rwBodyBold)
                                .foregroundColor(Color.rwTextPrimary)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                        .background(Color.rwSurface)
                        .cornerRadius(14)
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.rwBorder, lineWidth: 1))

                        RWPrimaryButton(label: "Done") { dismiss() }
                            .padding(.horizontal, 40)

                        Spacer()
                    }
                    .transition(.opacity.combined(with: .scale))

                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {

                            // Transaction summary
                            HStack(spacing: 14) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.rwSageTint)
                                    .frame(width: 64, height: 64)
                                    .overlay(
                                        Image(systemName: "tshirt")
                                            .font(.system(size: 22, weight: .thin))
                                            .foregroundColor(Color.rwSage)
                                    )
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Linen Blazer — Beige")
                                        .font(.rwBodyBold)
                                        .foregroundColor(Color.rwTextPrimary)
                                    Text("BHD 8.500")
                                        .font(.rwCaption)
                                        .foregroundColor(Color.rwPrimary)
                                    Text("Sold by Sara M.")
                                        .font(.rwMicro)
                                        .foregroundColor(Color.rwTextSecondary)
                                }
                                Spacer()
                            }
                            .padding(14)
                            .background(Color.rwSurface)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.rwBorder, lineWidth: 1))

                            RWDivider()

                            // Star selector
                            VStack(spacing: 14) {
                                Text("How was your experience?")
                                    .font(.rwHeading)
                                    .foregroundColor(Color.rwTextPrimary)

                                HStack(spacing: 16) {
                                    ForEach(1..<6) { star in
                                        Button(action: {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                                selectedRating = star
                                            }
                                        }) {
                                            Image(systemName: selectedRating >= star ? "star.fill" : "star")
                                                .font(.system(size: 34))
                                                .foregroundColor(selectedRating >= star ? Color.rwGold : Color.rwBorder)
                                                .scaleEffect(selectedRating == star ? 1.2 : 1.0)
                                                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: selectedRating)
                                        }
                                    }
                                }

                                let labels = ["", "Poor", "Fair", "Good", "Great", "Excellent!"]
                                if selectedRating > 0 {
                                    Text(labels[selectedRating])
                                        .font(.rwBodyBold)
                                        .foregroundColor(Color.rwPrimary)
                                        .transition(.opacity)
                                }
                            }

                            RWDivider()

                            // Written review
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Leave a comment (optional)")
                                    .font(.rwHeading)
                                    .foregroundColor(Color.rwTextPrimary)

                                ZStack(alignment: .topLeading) {
                                    TextEditor(text: $reviewText)
                                        .font(.rwBody)
                                        .frame(height: 130)
                                        .padding(10)
                                        .background(Color.rwSageTint)
                                        .cornerRadius(14)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(Color.rwBorder, lineWidth: 1)
                                        )
                                    if reviewText.isEmpty {
                                        Text("Share your experience with this seller...")
                                            .font(.rwBody)
                                            .foregroundColor(Color.rwTextSecondary)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 18)
                                            .allowsHitTesting(false)
                                    }
                                }

                                Text("\(reviewText.count)/200")
                                    .font(.rwMicro)
                                    .foregroundColor(Color.rwTextSecondary)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }

                            // Submit button
                            RWPrimaryButton(
                                label: isSubmitting ? "Submitting..." : "Submit Review",
                                action: handleSubmit
                            )
                            .opacity(selectedRating == 0 ? 0.5 : 1.0)
                            .disabled(selectedRating == 0)
                            .padding(.bottom, 30)
                        }
                        .padding(20)
                    }
                }
            }
            .navigationTitle(showThankYou ? "" : "Rate your experience")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.rwBackground, for: .navigationBar)
            .toolbar {
                if !showThankYou {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") { dismiss() }
                            .font(.rwBody)
                            .foregroundColor(Color.rwTextSecondary)
                    }
                }
            }
        }
    }

    func handleSubmit() {
        guard selectedRating > 0 else { return }
        isSubmitting = true
        // TEAMMATE: Replace with ReviewViewModel.submitReview()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isSubmitting = false
            withAnimation(.easeInOut(duration: 0.3)) {
                showThankYou = true
            }
        }
    }
}

// ── Shared helpers ────────────────────────────────────────────────────────────
struct RWStatCell: View {
    var value: String
    var label: String
    var body: some View {
        VStack(spacing: 2) {
            Text(value).font(.rwBodyBold).foregroundColor(Color.rwTextPrimary)
            Text(label).font(.rwMicro).foregroundColor(Color.rwTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }
}

struct RWReviewRow: View {
    var name: String
    var text: String
    var rating: Double
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            RWAvatar(initials: String(name.prefix(2)), size: 38)
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(name).font(.rwCaptionBold).foregroundColor(Color.rwTextPrimary)
                    Spacer()
                    RWStarRating(rating: rating, size: 11)
                }
                Text(text).font(.rwCaption).foregroundColor(Color.rwTextSecondary).lineSpacing(3)
            }
        }
        .padding(.vertical, 14)
    }
}

struct RWProfileLink: View {
    var icon: String
    var label: String
    var count: String? = nil
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 15))
                .foregroundColor(Color.rwPrimary)
                .frame(width: 24)
            Text(label)
                .font(.rwBodyBold)
                .foregroundColor(Color.rwTextPrimary)
            Spacer()
            if let count {
                Text(count)
                    .font(.rwCaption)
                    .foregroundColor(Color.rwTextSecondary)
            }
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(Color.rwTextSecondary)
        }
        .padding(14)
        .background(Color.rwSurface)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.rwBorder, lineWidth: 1))
    }
}

#Preview("My Profile") { ProfileView() }
#Preview("Seller Profile") { SellerProfileView() }
#Preview("Review") { ReviewView() }
