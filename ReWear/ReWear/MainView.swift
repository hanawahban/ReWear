import SwiftUI

struct MainView: View {
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

            InboxView()
                .tabItem {
                    Label("Inbox", systemImage: "message")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .tint(Color.rwPrimary)
        .tint(Color.rwPrimary)
    }
}

#Preview { MainView() }
