import SwiftUI

struct ProductDetailView: View {

    var product: Product = .mock

    @State private var isFavorited = false
    @State private var currentImage = 0
    @State private var showChat = false
    @State private var showReview = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.rwBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    ZStack(alignment: .top) {
                        TabView(selection: $currentImage) {
                            ForEach(0..<3, id: \.self) { i in
                                ZStack {
                                    Color.rwSageTint
                                    Image(systemName: "tshirt")
                                        .font(.system(size: 60, weight: .thin))
                                        .foregroundColor(Color.rwSage)
                                }
                                .tag(i)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(height: 340)

                        // Nav overlay
                        HStack {
                            Button(action: { dismiss() }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color.rwPrimary)
                                    .padding(10)
                                    .background(Color.white.opacity(0.9))
                                    .clipShape(Circle())
                            }
                            Spacer()
                            HStack(spacing: 10) {
                                Button(action: { isFavorited.toggle() }) {
                                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(isFavorited ? Color.rwPrimary : Color.rwTextSecondary)
                                        .padding(10)
                                        .background(Color.white.opacity(0.9))
                                        .clipShape(Circle())
                                        .scaleEffect(isFavorited ? 1.1 : 1.0)
                                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isFavorited)
                                }
                                Button(action: {}) {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(Color.rwTextSecondary)
                                        .padding(10)
                                        .background(Color.white.opacity(0.9))
                                        .clipShape(Circle())
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 52)

                        // Page dots
                        HStack(spacing: 6) {
                            ForEach(0..<3, id: \.self) { i in
                                Circle()
                                    .fill(currentImage == i ? Color.rwPrimary : Color.rwSage.opacity(0.4))
                                    .frame(
                                        width: currentImage == i ? 8 : 5,
                                        height: currentImage == i ? 8 : 5
                                    )
                                    .animation(.easeInOut(duration: 0.2), value: currentImage)
                            }
                        }
                        .padding(.top, 306)
                    }

                    VStack(alignment: .leading, spacing: 20) {

                        // ── Title + price ────────────────────────────────
                        VStack(alignment: .leading, spacing: 6) {
                            Text(product.title)
                                .font(.rwTitle)
                                .foregroundColor(Color.rwTextPrimary)

                            HStack(alignment: .center) {
                                Text(product.formattedPrice)
                                    .font(.rwDisplay)
                                    .foregroundColor(Color.rwPrimary)
                                Spacer()
                                RWStarRating(rating: product.rating, size: 13)
                                Text(String(format: "%.1f", product.rating))
                                    .font(.rwCaptionBold)
                                    .foregroundColor(Color.rwTextSecondary)
                                Text("(\(product.reviewCount))")
                                    .font(.rwMicro)
                                    .foregroundColor(Color.rwTextSecondary)
                            }
                        }

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                RWTag(label: product.condition, icon: "sparkles")
                                RWTag(label: "Size \(product.size)")
                                if !product.brand.isEmpty {
                                    RWTag(label: product.brand)
                                }
                                RWTag(label: product.category)
                                RWTag(label: product.location, icon: "mappin")
                            }
                        }

                        RWDivider()

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.rwHeading)
                                .foregroundColor(Color.rwTextPrimary)
                            Text(product.description.isEmpty
                                 ? "No description provided."
                                 : product.description)
                                .font(.rwBody)
                                .foregroundColor(Color.rwTextSecondary)
                                .lineSpacing(4)
                        }

                        RWDivider()

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Seller")
                                .font(.rwHeading)
                                .foregroundColor(Color.rwTextPrimary)

                            HStack(spacing: 14) {
                                RWAvatar(initials: String(product.sellerName.prefix(2)), size: 50)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(product.sellerName)
                                        .font(.rwBodyBold)
                                        .foregroundColor(Color.rwTextPrimary)
                                    HStack(spacing: 4) {
                                        RWStarRating(rating: product.rating, size: 11)
                                        Text("\(String(format: "%.1f", product.rating)) · \(product.reviewCount) reviews")
                                            .font(.rwMicro)
                                            .foregroundColor(Color.rwTextSecondary)
                                    }
                                    Text("Member since 2023")
                                        .font(.rwMicro)
                                        .foregroundColor(Color.rwTextSecondary)
                                }

                                Spacer()

                                NavigationLink(destination: SellerProfileView()) {
                                    Text("View profile")
                                        .font(.rwCaptionBold)
                                        .foregroundColor(Color.rwPrimary)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.rwPrimary, lineWidth: 1)
                                        )
                                }
                            }
                        }

                        RWDivider()

                        VStack(alignment: .leading, spacing: 14) {
                            RWSectionHeader(
                                title: "Reviews",
                                actionLabel: "See all"
                            )

                            ForEach(Review.mockList) { review in
                                RWReviewRow(
                                    name: review.reviewerName,
                                    text: review.comment,
                                    rating: Double(review.rating)
                                )
                            }

                            // Leave a review button
                            Button(action: { showReview = true }) {
                                HStack {
                                    Image(systemName: "star")
                                        .font(.system(size: 14))
                                    Text("Leave a Review")
                                        .font(.rwBodyBold)
                                }
                                .foregroundColor(Color.rwPrimary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.rwSageTint)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.rwSage, lineWidth: 1)
                                )
                            }
                        }

                        Spacer().frame(height: 90)
                    }
                    .padding(20)
                }
            }

            HStack(spacing: 12) {
                Button(action: { isFavorited.toggle() }) {
                    HStack(spacing: 6) {
                        Image(systemName: isFavorited ? "heart.fill" : "heart")
                            .font(.system(size: 14, weight: .semibold))
                        Text(isFavorited ? "Saved" : "Save")
                            .font(.rwBodyBold)
                    }
                    .foregroundColor(Color.rwPrimary)
                    .frame(width: 110)
                    .padding(.vertical, 15)
                    .background(Color.clear)
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.rwPrimary, lineWidth: 1.5)
                    )
                }

                NavigationLink(destination: ChatView(
                    sellerName: product.sellerName,
                    initials: String(product.sellerName.prefix(2))
                )) {
                    HStack(spacing: 6) {
                        Image(systemName: "message")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Contact Seller")
                            .font(.rwBodyBold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.rwPrimary)
                    .cornerRadius(14)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(
                Color.rwBackground
                    .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: -4)
            )
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(edges: .top)
        .sheet(isPresented: $showReview) {
            ReviewView()
        }
    }
}

#Preview { NavigationStack { ProductDetailView(product: .mock) } }
#Preview("Default") { NavigationStack { ProductDetailView() } }
