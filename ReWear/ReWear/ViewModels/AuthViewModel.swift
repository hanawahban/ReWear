import Foundation
import SwiftUI
import Combine
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class AuthViewModel: ObservableObject {

    @Published var currentUser: RWUser? = nil
    @Published var isLoggedIn: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    init(autoLoginEnabled: Bool = true) {
        if autoLoginEnabled {
            checkCurrentUser()
        } else {
            self.isLoggedIn = false
        }
    }


    func checkCurrentUser() {
        if let firebaseUser = Auth.auth().currentUser {
            self.fetchUser(id: firebaseUser.uid)
            self.isLoggedIn = true
        } else {
            self.isLoggedIn = false
        }
    }

    func signUp(name: String, email: String, password: String) {
        isLoading = true
        let db = Firestore.firestore()

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Authentication Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
                return
            }

            guard let user = result?.user else {
                DispatchQueue.main.async { self.isLoading = false }
                return
            }

            let userData: [String: Any] = [
                "uid": user.uid,
                "userName": name,
                "email": email,
                "pfpURL": "",
                "location": "[0° N, 0° E]",
                "rating": 1.0,
                "reviewCount": 0,
                "listingCount": 0,
                "joinDate": Timestamp(),
                "bio": ""
            ]

            db.collection("users").document(user.uid).setData(userData) { error in
                if let error = error {
                    print("Firestore save error: \(error.localizedDescription)")
                    DispatchQueue.main.async { self.isLoading = false }
                    return
                }

                DispatchQueue.main.async {
                    self.fetchUser(id: user.uid)
                    self.isLoggedIn = true
                    self.isLoading = false
                }
            }
        }
    }

    func logIn(email: String, password: String) {
        isLoading = true

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
                return
            }

            guard let user = result?.user else {
                DispatchQueue.main.async { self.isLoading = false }
                return
            }

            DispatchQueue.main.async {
                self.fetchUser(id: user.uid)
                self.isLoggedIn = true
                self.isLoading = false
            }
        }
    }

    func logOut() {
        do {
            try Auth.auth().signOut()
            self.currentUser = nil
            self.isLoggedIn = false
            print(" Logged out successfully")
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }


    func fetchUser(id: String) {
        let db = Firestore.firestore()
        db.collection("users").document(id).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
                return
            }

            guard let data = snapshot?.data() else {
                print("No user data found.")
                return
            }

            let user = RWUser(
                id: data["uid"] as? String ?? "",
                name: data["userName"] as? String ?? "",
                email: data["email"] as? String ?? "",
                profileImageURL: data["pfpURL"] as? String ?? "",
                location: "\(data["location"] ?? "")",
                rating: data["rating"] as? Double ?? 1.0,
                reviewCount: data["reviewCount"] as? Int ?? 0,
                listingCount: data["listingCount"] as? Int ?? 0,
                joinedDate: (data["joinDate"] as? Timestamp)?.dateValue() ?? Date(),
                bio: data["bio"] as? String ?? ""
            )

            DispatchQueue.main.async {
                self.currentUser = user
            }
        }
    }
}
