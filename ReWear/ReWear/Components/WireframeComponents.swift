import SwiftUI
import MapKit

enum WireframeButtonStyle { case filled, outline }

struct WireframeButton: View {

    var label: String
    var style: WireframeButtonStyle = .filled
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(style == .filled ? .white : .primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    style == .filled
                    ? Color(.systemGray2)
                    : Color.clear
                )
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.systemGray3), lineWidth: style == .outline ? 1 : 0)
                )
        }
    }
}

struct WireframeTextField: View {

    var placeholder: String
    var isSecure: Bool = false

    var body: some View {
        HStack {
            if isSecure {
                Image(systemName: "lock").foregroundColor(.gray).font(.subheadline)
            }
            Text(placeholder)
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
            if isSecure {
                Image(systemName: "eye.slash").foregroundColor(.gray).font(.subheadline)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }

            AddListingView()
                .tabItem {
                    Label("Sell", systemImage: "plus.circle.fill")
                }

            FavoritesView()
                .tabItem {
                    Label("Saved", systemImage: "heart")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}

#Preview("Full App") { ContentView() }
#Preview("Button — Filled") {
    WireframeButton(label: "Primary Action").padding()
}
#Preview("Button — Outline") {
    WireframeButton(label: "Secondary Action", style: .outline).padding()
}
#Preview("Text Field") {
    WireframeTextField(placeholder: "Email address").padding()
}
