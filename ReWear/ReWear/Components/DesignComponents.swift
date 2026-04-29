import SwiftUI

extension Color {
    static let rwPrimary        = Color(hex: "#1B4332")   //
    static let rwSage           = Color(hex: "#7BAE8A")   //
    static let rwSageTint       = Color(hex: "#EEF4F0")   //
    static let rwBackground     = Color(hex: "#F8F6F1")   //
    static let rwSurface        = Color(hex: "#FFFFFF")   //
    static let rwTextPrimary    = Color(hex: "#1A1A18")
    static let rwTextSecondary  = Color(hex: "#6B6B64")
    static let rwBorder         = Color(hex: "#E2DED6")
    static let rwGold           = Color(hex: "#B5915A")
    static let rwDanger         = Color(hex: "#C0392B")

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}



extension Font {
    static let rwDisplay    = Font.custom("Palatino", size: 28).weight(.semibold)
    static let rwTitle      = Font.custom("Palatino", size: 22).weight(.semibold)
    static let rwHeading    = Font.custom("Palatino", size: 18).weight(.semibold)

    static let rwBodyLarge  = Font.system(size: 16, weight: .regular, design: .default)
    static let rwBody       = Font.system(size: 14, weight: .regular, design: .default)
    static let rwBodyBold   = Font.system(size: 14, weight: .semibold, design: .default)
    static let rwCaption    = Font.system(size: 12, weight: .regular, design: .default)
    static let rwCaptionBold = Font.system(size: 12, weight: .semibold, design: .default)
    static let rwMicro      = Font.system(size: 11, weight: .regular, design: .default)
}

struct RWPrimaryButton: View {
    var label: String
    var icon: String? = nil
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon { Image(systemName: icon).font(.system(size: 14, weight: .semibold)) }
                Text(label).font(.rwBodyBold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(Color.rwPrimary)
            .cornerRadius(14)
        }
    }
}

struct RWOutlineButton: View {
    var label: String
    var icon: String? = nil
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon { Image(systemName: icon).font(.system(size: 14, weight: .semibold)) }
                Text(label).font(.rwBodyBold)
            }
            .foregroundColor(Color.rwPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(Color.clear)
            .cornerRadius(14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.rwPrimary, lineWidth: 1.5))
        }
    }
}


struct RWTextField: View {
    var placeholder: String
    @Binding var text: String
    var icon: String? = nil
    var isSecure: Bool = false

    var body: some View {
        HStack(spacing: 10) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundColor(Color.rwTextSecondary)
            }
            if isSecure {
                SecureField(placeholder, text: $text)
                    .font(.rwBody)
            } else {
                TextField(placeholder, text: $text)
                    .font(.rwBody)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(Color.rwSageTint)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.rwBorder, lineWidth: 1))
    }
}

struct RWCategoryChip: View {
    var label: String
    var isSelected: Bool
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.rwCaptionBold)
                .foregroundColor(isSelected ? .white : Color.rwPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.rwPrimary : Color.rwSageTint)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.clear : Color.rwSage, lineWidth: 1)
                )
        }
    }
}

struct RWTag: View {
    var label: String
    var icon: String? = nil

    var body: some View {
        HStack(spacing: 4) {
            if let icon { Image(systemName: icon).font(.system(size: 10)) }
            Text(label).font(.rwMicro)
        }
        .foregroundColor(Color.rwPrimary)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color.rwSageTint)
        .cornerRadius(8)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.rwSage.opacity(0.5), lineWidth: 1))
    }
}

struct RWStarRating: View {
    var rating: Double
    var maxStars: Int = 5
    var size: CGFloat = 12

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<maxStars, id: \.self) { i in
                Image(systemName: i < Int(rating.rounded()) ? "star.fill" : "star")
                    .font(.system(size: size))
                    .foregroundColor(Color.rwGold)
            }
        }
    }
}

struct RWAvatar: View {
    var initials: String = "?"
    var size: CGFloat = 44

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.rwSageTint)
                .overlay(Circle().stroke(Color.rwBorder, lineWidth: 1))
                .frame(width: size, height: size)
            Text(initials)
                .font(.system(size: size * 0.35, weight: .semibold))
                .foregroundColor(Color.rwPrimary)
        }
    }
}

struct RWSectionHeader: View {
    var title: String
    var actionLabel: String? = nil
    var action: () -> Void = {}

    var body: some View {
        HStack {
            Text(title)
                .font(.rwHeading)
                .foregroundColor(Color.rwTextPrimary)
            Spacer()
            if let label = actionLabel {
                Button(action: action) {
                    Text(label)
                        .font(.rwCaption)
                        .foregroundColor(Color.rwSage)
                }
            }
        }
    }
}

struct RWDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.rwBorder)
            .frame(height: 1)
    }
}

struct RWImagePlaceholder: View {
    var height: CGFloat = 200
    var icon: String = "tshirt"

    var body: some View {
        RoundedRectangle(cornerRadius: 14)
            .fill(Color.rwSageTint)
            .frame(height: height)
            .overlay(
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(Color.rwSage)
            )
    }
}

struct RWProductCard: View {
    var title: String = "Item Name"
    var price: String = "BHD 0.000"
    var location: String = "Manama"
    var condition: String = "Like New"
    var rating: Double = 4.5
    var isFavorited: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            // Image
            ZStack(alignment: .topTrailing) {
                RWImagePlaceholder(height: 160, icon: "tshirt")

                // Favorite button
                Image(systemName: isFavorited ? "heart.fill" : "heart")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(isFavorited ? Color.rwPrimary : Color.rwTextSecondary)
                    .padding(8)
                    .background(Color.white.opacity(0.9))
                    .clipShape(Circle())
                    .padding(8)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.rwBodyBold)
                    .foregroundColor(Color.rwTextPrimary)
                    .lineLimit(1)

                Text(price)
                    .font(.rwHeading)
                    .foregroundColor(Color.rwPrimary)

                HStack(spacing: 6) {
                    RWTag(label: condition)
                    Spacer()
                    RWStarRating(rating: rating, size: 10)
                }

                HStack(spacing: 3) {
                    Image(systemName: "mappin")
                        .font(.system(size: 10))
                        .foregroundColor(Color.rwTextSecondary)
                    Text(location)
                        .font(.rwMicro)
                        .foregroundColor(Color.rwTextSecondary)
                }
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 6)
        }
        .background(Color.rwSurface)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.rwBorder, lineWidth: 1))
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
}

#Preview("Design System") {
    ScrollView {
        VStack(spacing: 20) {

            HStack(spacing: 8) {
                ForEach([Color.rwPrimary, Color.rwSage, Color.rwSageTint, Color.rwGold, Color.rwBackground], id: \.self) { c in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(c)
                        .frame(width: 50, height: 50)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.rwBorder))
                }
            }

            Text("R E W E A R")
                .font(.rwDisplay)
                .foregroundColor(Color.rwPrimary)
                .kerning(6)

            Text("Give Your Clothes a ReWear")
                .font(.rwBody)
                .foregroundColor(Color.rwTextSecondary)

            RWPrimaryButton(label: "Shop Now", icon: "arrow.right")
            RWOutlineButton(label: "Sell an Item", icon: "plus")

            HStack(spacing: 8) {
                RWCategoryChip(label: "Tops", isSelected: true)
                RWCategoryChip(label: "Dresses", isSelected: false)
                RWCategoryChip(label: "Shoes", isSelected: false)
            }

            HStack(spacing: 8) {
                RWTag(label: "Like New", icon: "sparkles")
                RWTag(label: "Size M")
                RWTag(label: "Zara")
            }

            RWStarRating(rating: 4.5, size: 16)

            RWProductCard(title: "Linen Blazer", price: "BHD 8.500", condition: "Like New", rating: 4.8)
                .frame(width: 180)

        }
        .padding(20)
        .background(Color.rwBackground)
    }
    .background(Color.rwBackground)
}
