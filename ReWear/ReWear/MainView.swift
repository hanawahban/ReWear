import SwiftUI

struct MainView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var productViewModel: ProductViewModel

    var body: some View {
        Group {
            if authViewModel.isLoggedIn {
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
            } else {
                LoginView()
            }
        }
        .animation(.easeInOut, value: authViewModel.isLoggedIn)
    }
}

#Preview {
    MainView()
        .environmentObject(AuthViewModel())
        .environmentObject(ProductViewModel())
}
