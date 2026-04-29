import SwiftUI

struct ProductDetailView: View {

    @State private var isFavorited = false
    @State private var currentImage = 0
    @Environment(\.dismiss) var dismiss

    let mockReviews = [
        ("Hana W.", "Great seller, super fast response. Item exactly as described!", 5.0),
        ("Lena K.", "Lovely piece, arrived well packaged.", 4.0),
        ("Nour A.", "Would definitely buy from again.", 5.0),
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.rwBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    // ── Image carousel ───────────────────────────────────
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
                            Button(action: { isFavorited.toggle() }) {
                                Image(systemName: isFavorited ? "heart.fill" : "heart")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(isFavorited ? Color.rwPrimary : Color.rwTextSecondary)
                                    .padding(10)
                                    .background(Color.white.opacity(0.9))
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 52)

                        HStack(spacing: 6) {
                            ForEach(0..<3, id: \.self) { i in
                                Circle()
                                    .fill(currentImage == i ? Color.rwPrimary : Color.rwSage.opacity(0.4))
                                    .frame(width: currentImage == i ? 8 : 5, height: currentImage == i ? 8 : 5)
                            }
                        }
                        .padding(.top, 306)
                    }

                    VStack(alignment: .leading, spacing: 20) {

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Linen Blazer — Beige")
                                .font(.rwTitle)
                                .foregroundColor(Color.rwTextPrimary)

                            HStack(alignment: .center) {
                                Text("BHD 8.500")
                                    .font(.rwDisplay)
                                    .foregroundColor(Color.rwPrimary)
                                Spacer()
                                RWStarRating(rating: 4.8, size: 13)
                                Text("4.8")
                                    .font(.rwCaptionBold)
                                    .foregroundColor(Color.rwTextSecondary)
                            }
                        }

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                RWTag(label: "Like New", icon: "sparkles")
                                RWTag(label: "Size M")
                                RWTag(label: "Zara")
                                RWTag(label: "Tops")
                                RWTag(label: "Manama", icon: "mappin")
                            }
                        }

                        RWDivider()

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.rwHeading)
                                .foregroundColor(Color.rwTextPrimary)
                            Text("Beautiful linen blazer in a warm beige tone. Barely worn, no stains or damage. Great for layering over a dress or with trousers. From a smoke-free home.")
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
                                RWAvatar(initials: "SM", size: 50)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Sara M.")
                                        .font(.rwBodyBold)
                                        .foregroundColor(Color.rwTextPrimary)
                                    HStack(spacing: 4) {
                                        RWStarRating(rating: 4.8, size: 11)
                                        Text("4.8 · 31 reviews")
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
                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.rwPrimary, lineWidth: 1))
                                }
                            }
                        }

                        RWDivider()

                        VStack(alignment: .leading, spacing: 14) {
                            RWSectionHeader(title: "Reviews", actionLabel: "See all")

                            ForEach(mockReviews, id: \.0) { review in
                                HStack(alignment: .top, spacing: 12) {
                                    RWAvatar(initials: String(review.0.prefix(2)), size: 36)
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text(review.0)
                                                .font(.rwCaptionBold)
                                                .foregroundColor(Color.rwTextPrimary)
                                            Spacer()
                                            RWStarRating(rating: review.2, size: 10)
                                        }
                                        Text(review.1)
                                            .font(.rwCaption)
                                            .foregroundColor(Color.rwTextSecondary)
                                            .lineSpacing(3)
                                    }
                                }
                            }
                        }

                        Spacer().frame(height: 90)
                    }
                    .padding(20)
                }
            }

            HStack(spacing: 12) {
                RWOutlineButton(label: "Save", icon: "heart")
                    .frame(width: 110)
                RWPrimaryButton(label: "Contact Seller", icon: "message")
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
    }
}

#Preview { NavigationStack { ProductDetailView() } }
