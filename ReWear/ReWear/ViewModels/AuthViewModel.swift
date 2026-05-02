//import Foundation
//import SwiftUI
//
//class AuthViewModel: ObservableObject {
//
//
//    @Published var currentUser: RWUser? = nil
//    @Published var isLoggedIn: Bool = false
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String? = nil
//
//    init() {
//        //firebase here
//        checkCurrentUser()
//    }
//
//    //
//    func checkCurrentUser() {
//       //firebase stuff here
//        isLoggedIn = false
//    }
//
//    // Sign Up
func signUp(name: String, email: String, password: String) {
    isLoading = true
    let db = Firestore.firestore()

    Auth.auth().createUser(withEmail: email, password: password) { result, error in
        if let user = result?.user {
            db.collection("users").document(user.uid).setData([
                "id": user.uid,
                "name": name,
                "email": email,
                "rating": 1.0,
                "joinDate": Timestamp()
            ])
            self.isLoggedIn = true
        }
        self.isLoading = false
    }
}

//    // login
//    func logIn(email: String, password: String) {
//        isLoading = true
//        errorMessage = nil
//
//        // Authentication stuff here
//        
//        // Mock
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.currentUser = RWUser.mock
//            self.isLoggedIn = true
//            self.isLoading = false
//        }
//    }
//
//    func logOut() {
//        // authentication stuff
//
//        currentUser = nil
//        isLoggedIn = false
//    }
//
//    func fetchUser(id: String) {
//        // needs actual data fetching
//    }
//
//    func updateProfile(name: String, bio: String) {
//        // firestore update
//        currentUser?.name = name
//        currentUser?.bio = bio
//    }
//}
