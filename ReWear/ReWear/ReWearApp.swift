import SwiftUI
import FirebaseCore
import GoogleSignIn

@main
struct ReWearApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var productViewModel = ProductViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(authViewModel)
                .environmentObject(productViewModel)
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
