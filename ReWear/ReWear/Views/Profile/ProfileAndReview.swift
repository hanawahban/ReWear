import SwiftUI

struct ProfileView: View {

    @State private var selectedTab = 0
    let mockItems = Array(0..<4)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {

                    VStack(spacing: 10) {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 80, height: 80)
                            .overlay(Image(systemName: "person.fill").font(.title).foregroundColor(.gray))

                        WirePlaceholderBar(width: 140, height: 16)
                        WirePlaceholderBar(width: 100, height: 12)

                        HStack(spacing: 3) {
                            ForEach(0..<5) { _ in
                                Image(systemName: "star.fill").font(.caption).foregroundColor(.gray)
                            }
                            Text("4.8  (31 reviews)")
                                .font(.caption).foregroundColor(.secondary)
                        }

                        HStack(spacing: 0) {
                            WireStatCell(value: "12", label: "Listings")
                            Divider().frame(height: 32)
                            WireStatCell(value: "31", label: "Reviews")
                            Divider().frame(height: 32)
                            WireStatCell(value: "Mar 2024", label: "Joined")
                        }
                        .padding(.top, 6)

                        WireframeButton(label: "Edit Profile", style: .outline)
                            .frame(width: 160)
                    }
                    .padding(20)

                    Divider()

                    Picker("Tab", selection: $selectedTab) {
                        Text("My Listings").tag(0)
                        Text("Reviews").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                    if selectedTab == 0 {
                        LazyVGrid(
                            columns: [GridItem(.flexible()), GridItem(.flexible())],
                            spacing: 14
                        ) {
                            ForEach(mockItems, id: \.self) { i in
                                WireframeProductCard(index: i)
                            }
                        }
                        .padding(.horizontal, 16)
                    } else {
                        // Reviews list
                        VStack(spacing: 0) {
                            ForEach(0..<3, id: \.self) { _ in
                                WireReviewRow()
                                Divider().padding(.leading, 56)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
            .navigationTitle("My Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "gearshape").foregroundColor(.gray)
                }
            }
        }
    }
}

struct SellerProfileView: View {

    @State private var selectedTab = 0
    let mockItems = Array(0..<4)

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                VStack(spacing: 10) {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 72, height: 72)
                        .overlay(Image(systemName: "person.fill").font(.title2).foregroundColor(.gray))

                    WirePlaceholderBar(width: 130, height: 15)
                    WirePlaceholderBar(width: 90, height: 11)

                    HStack(spacing: 3) {
                        ForEach(0..<5) { _ in
                            Image(systemName: "star.fill").font(.caption).foregroundColor(.gray)
                        }
                        Text("4.8  (31 reviews)").font(.caption).foregroundColor(.secondary)
                    }

                    HStack(spacing: 10) {
                        WireframeButton(label: "Message Seller")
                        WireframeButton(label: "Follow", style: .outline)
                    }
                }
                .padding(20)

                Divider()

                Picker("Tab", selection: $selectedTab) {
                    Text("Listings").tag(0)
                    Text("Reviews").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

                if selectedTab == 0 {
                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible())],
                        spacing: 14
                    ) {
                        ForEach(mockItems, id: \.self) { i in
                            WireframeProductCard(index: i)
                        }
                    }
                    .padding(.horizontal, 16)
                } else {
                    VStack(spacing: 0) {
                        ForEach(0..<3, id: \.self) { _ in
                            WireReviewRow()
                            Divider().padding(.leading, 56)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .navigationTitle("Seller Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ReviewView: View {

    @State private var selectedRating = 0
    @State private var reviewText = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    // ── Transaction summary ──────────────────────────────
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray5))
                            .frame(width: 60, height: 60)
                            .overlay(Image(systemName: "photo").foregroundColor(.gray))

                        VStack(alignment: .leading, spacing: 4) {
                            WirePlaceholderBar(width: 150, height: 13)
                            WirePlaceholderBar(width: 80, height: 11)
                        }
                        Spacer()
                    }
                    .padding(14)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)

                    // ── Star selector ────────────────────────────────────
                    VStack(spacing: 10) {
                        Text("Rate your experience")
                            .font(.subheadline).bold()

                        HStack(spacing: 12) {
                            ForEach(1..<6) { star in
                                Image(systemName: selectedRating >= star ? "star.fill" : "star")
                                    .font(.title)
                                    .foregroundColor(.gray)
                                    .onTapGesture { selectedRating = star }
                            }
                        }

                        Text(selectedRating == 0 ? "Tap to rate" : "\(selectedRating) star\(selectedRating > 1 ? "s" : "")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Write a review (optional)")
                            .font(.subheadline).bold()

                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6))
                            .frame(height: 120)
                            .overlay(
                                Text("Share your experience with this seller...")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(14),
                                alignment: .topLeading
                            )
                    }

                    WireframeButton(label: "Submit Review")
                }
                .padding(16)
            }
            .navigationTitle("Rate Seller")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Cancel").foregroundColor(.gray)
                }
            }
        }
    }
}

struct WireStatCell: View {
    var value: String
    var label: String
    var body: some View {
        VStack(spacing: 2) {
            Text(value).font(.subheadline).bold()
            Text(label).font(.caption2).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct WireReviewRow: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color(.systemGray5))
                .frame(width: 36, height: 36)
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    WirePlaceholderBar(width: 90, height: 12)
                    Spacer()
                    HStack(spacing: 2) {
                        ForEach(0..<5) { _ in
                            Image(systemName: "star.fill").font(.system(size: 9)).foregroundColor(.gray)
                        }
                    }
                }
                WirePlaceholderBar(width: .infinity, height: 11)
                WirePlaceholderBar(width: 180, height: 11)
            }
        }
        .padding(.vertical, 12)
    }
}

#Preview("My Profile") { ProfileView() }
#Preview("Seller Profile") { NavigationStack { SellerProfileView() } }
#Preview("Review") { ReviewView() }
