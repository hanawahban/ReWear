import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            MapView()
                .tabItem {
                    Label("Nearby", systemImage: "map")
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
        .tint(Color.rwPrimary)
    }
}

#Preview { ContentView() }
