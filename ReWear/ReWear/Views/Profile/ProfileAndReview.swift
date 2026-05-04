import SwiftUI
import PhotosUI

struct ProfileView: View {

    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var productViewModel: ProductViewModel
    @StateObject private var reviewVM = ReviewViewModel()

    @State private var selectedTab = 0
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var profileImage: UIImage? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Color.rwBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {

                        VStack(spacing: 14) {

                            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                ZStack(alignment: .bottomTrailing) {
                                    if let profileImage {
                                        Image(uiImage: profileImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 84, height: 84)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.rwBorder, lineWidth: 1))
                                    } else if let imageURL = authViewModel.currentUser?.profileImageURL,
                                              !imageURL.isEmpty,
                                              let url = URL(string: imageURL) {
                                        AsyncImage(url: url) { image in
                                            image.resizable().scaledToFill()
                                        } placeholder: {
                                            RWAvatar(initials: String(authViewModel.currentUser?.name.prefix(2) ?? ""), size: 84)
                                        }
                                        .frame(width: 84, height: 84)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.rwBorder, lineWidth: 1))
                                    } else {
                                        RWAvatar(initials: String(authViewModel.currentUser?.name.prefix(2) ?? ""), size: 84)
                                    }

                                    ZStack {
                                        Circle().fill(Color.rwPrimary).frame(width: 26, height: 26)
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 11))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .onChange(of: selectedPhoto) { _, newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                                       let image = UIImage(data: data) {
                                        profileImage = image
                                    }
                                }
                            }

                            if let user = authViewModel.currentUser {
                                VStack(spacing: 4) {
                                    Text(user.name.isEmpty ? "Unnamed User" : user.name)
                                        .font(.rwTitle)
                                        .foregroundColor(Color.rwTextPrimary)
                                    Text("@\(user.name.replacingOccurrences(of: " ", with: "")) · \(user.location.isEmpty ? "Unknown" : user.location)")
                                        .font(.rwCaption)
                                        .foregroundColor(Color.rwTextSecondary)
                                    HStack(spacing: 4) {
                                        RWStarRating(rating: user.rating, size: 13)
                                        Text(String(format: "%.1f · %d reviews", user.rating, user.reviewCount))
                                            .font(.rwCaption)
                                            .foregroundColor(Color.rwTextSecondary)
                                    }
                                }

                                HStack(spacing: 0) {
                                    RWStatCell(value: "\(user.listingCount)", label: "Listings")
                                    Rectangle().fill(Color.rwBorder).frame(width: 1, height: 32)
                                    RWStatCell(value: "\(user.reviewCount)", label: "Reviews")
                                    Rectangle().fill(Color.rwBorder).frame(width: 1, height: 32)
                                    RWStatCell(value: formattedJoinDate(user.joinedDate), label: "Joined")
                                }
                                .background(Color.rwSurface)
                                .cornerRadius(14)
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.rwBorder, lineWidth: 1))
                            } else {
                                Text("Loading user data...")
                                    .font(.rwBody)
                                    .foregroundColor(Color.rwTextSecondary)
                            }

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
                                RWProfileLink(icon: "heart", label: "Saved Items", count: "\(productViewModel.favoriteProducts.count)")
                            }
                            .buttonStyle(.plain)

                            NavigationLink(destination: SettingsView()) {
                                RWProfileLink(icon: "gearshape", label: "Settings")
                            }
                            .buttonStyle(.plain)

                            Button {
                                authViewModel.logOut()
                            } label: {
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
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.rwBorder, lineWidth: 1)
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)

                        RWDivider()

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
                            if productViewModel.myListings.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "tshirt")
                                        .font(.system(size: 36, weight: .thin))
                                        .foregroundColor(Color.rwSage)
                                    Text("No listings yet")
                                        .font(.rwHeading)
                                        .foregroundColor(Color.rwTextPrimary)
                                    Text("Items you post for sale will appear here")
                                        .font(.rwCaption)
                                        .foregroundColor(Color.rwTextSecondary)
                                }
                                .padding(.vertical, 40)
                            } else {
                                LazyVGrid(
                                    columns: [GridItem(.flexible()), GridItem(.flexible())],
                                    spacing: 14
                                ) {
                                    ForEach(productViewModel.myListings) { item in
                                        NavigationLink(destination: ProductDetailView(product: item)) {
                                            RWProductCard(
                                                title: item.title,
                                                price: item.formattedPrice,
                                                location: item.location,
                                                condition: item.condition,
                                                rating: item.rating
                                            )
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 20)
                            }
                        } else {
                            if reviewVM.reviews.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "star")
                                        .font(.system(size: 36, weight: .thin))
                                        .foregroundColor(Color.rwSage)
                                    Text("No reviews yet")
                                        .font(.rwHeading)
                                        .foregroundColor(Color.rwTextPrimary)
                                    Text("Reviews from buyers will appear here")
                                        .font(.rwCaption)
                                        .foregroundColor(Color.rwTextSecondary)
                                }
                                .padding(.vertical, 40)
                            } else {
                                VStack(spacing: 0) {
                                    ForEach(reviewVM.reviews) { r in
                                        RWReviewRow(name: r.reviewerName, text: r.comment, rating: Double(r.rating))
                                        RWDivider().padding(.leading, 56)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 20)
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                if let uid = authViewModel.currentUser?.id {
                    productViewModel.fetchMyListings(sellerID: uid)
                    reviewVM.fetchReviews(sellerID: uid)
                }
            }
        }
    }

    private func formattedJoinDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yy"
        return formatter.string(from: date)
    }
}


struct SellerProfileView: View {

    @State private var selectedTab = 0
    @StateObject private var productVM = ProductViewModel()
    @StateObject private var reviewVM = ReviewViewModel()
    @Environment(\.dismiss) var dismiss

    var sellerID: String = ""
    var sellerName: String = "Seller"

    var body: some View {
        ZStack {
            Color.rwBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    HStack(spacing: 12) {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color.rwPrimary)
                        }
                        Spacer()
                        Text(sellerName)
                            .font(.rwBodyBold)
                            .foregroundColor(Color.rwTextPrimary)
                        Spacer()
                        Image(systemName: "ellipsis")
                            .foregroundColor(Color.rwTextSecondary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)

                    RWDivider()

                    VStack(spacing: 14) {
                        RWAvatar(initials: String(sellerName.prefix(2)), size: 72)

                        VStack(spacing: 4) {
                            Text(sellerName)
                                .font(.rwTitle)
                                .foregroundColor(Color.rwTextPrimary)
                            HStack(spacing: 4) {
                                RWStarRating(rating: reviewVM.averageRating(), size: 13)
                                Text(String(format: "%.1f · %d reviews", reviewVM.averageRating(), reviewVM.reviews.count))
                                    .font(.rwCaption)
                                    .foregroundColor(Color.rwTextSecondary)
                            }
                        }

                        HStack(spacing: 0) {
                            RWStatCell(value: "\(productVM.myListings.count)", label: "Listings")
                            Rectangle().fill(Color.rwBorder).frame(width: 1, height: 32)
                            RWStatCell(value: "\(reviewVM.reviews.count)", label: "Reviews")
                        }
                        .background(Color.rwSurface)
                        .cornerRadius(14)
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.rwBorder, lineWidth: 1))

                        HStack(spacing: 10) {
                            NavigationLink(destination: InboxView()) {
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
                            ForEach(productVM.myListings) { item in
                                NavigationLink(destination: ProductDetailView(product: item)) {
                                    RWProductCard(title: item.title, price: item.formattedPrice, location: item.location, condition: item.condition, rating: item.rating)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    } else {
                        VStack(spacing: 0) {
                            ForEach(reviewVM.reviews) { r in
                                RWReviewRow(name: r.reviewerName, text: r.comment, rating: Double(r.rating))
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
        .onAppear {
            if !sellerID.isEmpty {
                productVM.fetchMyListings(sellerID: sellerID)
                reviewVM.fetchReviews(sellerID: sellerID)
            }
        }
    }
}

struct ReviewView: View {

    @State private var selectedRating = 0
    @State private var reviewText = ""
    @State private var isSubmitting = false
    @State private var showThankYou = false
    @Environment(\.dismiss) var dismiss

    var sellerID: String = ""
    var productID: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.rwBackground.ignoresSafeArea()

                if showThankYou {
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
                            Text("Thank you for your feedback.")
                                .font(.rwBody)
                                .foregroundColor(Color.rwTextSecondary)
                        }
                        Spacer()
                        RWPrimaryButton(label: "Done") { dismiss() }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 40)
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 24) {

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Your Rating")
                                    .font(.rwHeading)
                                    .foregroundColor(Color.rwTextPrimary)
                                HStack(spacing: 10) {
                                    ForEach(1...5, id: \.self) { star in
                                        Image(systemName: star <= selectedRating ? "star.fill" : "star")
                                            .font(.system(size: 32))
                                            .foregroundColor(star <= selectedRating ? Color.rwGold : Color.rwSage.opacity(0.4))
                                            .onTapGesture { selectedRating = star }
                                    }
                                }
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Your Review")
                                    .font(.rwHeading)
                                    .foregroundColor(Color.rwTextPrimary)
                                TextEditor(text: $reviewText)
                                    .font(.rwBody)
                                    .frame(height: 120)
                                    .padding(10)
                                    .background(Color.rwSageTint)
                                    .cornerRadius(12)
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.rwBorder, lineWidth: 1))
                                    .overlay(alignment: .topLeading) {
                                        if reviewText.isEmpty {
                                            Text("Share your experience with this seller...")
                                                .font(.rwBody)
                                                .foregroundColor(Color.rwTextSecondary.opacity(0.6))
                                                .padding(14)
                                                .allowsHitTesting(false)
                                        }
                                    }
                            }

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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isSubmitting = false
            withAnimation(.easeInOut(duration: 0.3)) {
                showThankYou = true
            }
        }
    }
}

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

#Preview("My Profile") {
    ProfileView()
        .environmentObject(AuthViewModel(autoLoginEnabled: false))
        .environmentObject(ProductViewModel())
}
#Preview("Seller Profile") { SellerProfileView() }
#Preview("Review") { ReviewView() }
