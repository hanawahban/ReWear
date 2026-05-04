import Foundation
import SwiftUI
import Combine
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import GoogleSignIn

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
            
            let changeRequest = result?.user.createProfileChangeRequest()
            changeRequest?.displayName = name
            changeRequest!.commitChanges { _ in }

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

    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            self.errorMessage = "Missing Firebase client ID"
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            self.errorMessage = "Cannot find root view controller"
            return
        }

        isLoading = true

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
                return
            }

            guard
                let user = result?.user,
                let idToken = user.idToken?.tokenString
            else {
                DispatchQueue.main.async { self.isLoading = false }
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                        self.isLoading = false
                    }
                    return
                }

                guard let uid = authResult?.user.uid else {
                    DispatchQueue.main.async { self.isLoading = false }
                    return
                }

                let db = Firestore.firestore()
                db.collection("users").document(uid).getDocument { snap, _ in
                    DispatchQueue.main.async {
                        if let snap = snap, snap.exists {
                            // Existing user — just fetch
                            self.fetchUser(id: uid)
                            self.isLoggedIn = true
                            self.isLoading = false
                        } else {
                            // New Google user — create profile
                            let userData: [String: Any] = [
                                "uid": uid,
                                "userName": user.profile?.name ?? "User",
                                "email": user.profile?.email ?? "",
                                "pfpURL": user.profile?.imageURL(withDimension: 200)?.absoluteString ?? "",
                                "location": "[0° N, 0° E]",
                                "rating": 1.0,
                                "reviewCount": 0,
                                "listingCount": 0,
                                "joinDate": Timestamp(),
                                "bio": ""
                            ]
                            db.collection("users").document(uid).setData(userData) { error in
                                DispatchQueue.main.async {
                                    if let error = error {
                                        self.errorMessage = error.localizedDescription
                                    } else {
                                        self.fetchUser(id: uid)
                                        self.isLoggedIn = true
                                    }
                                    self.isLoading = false
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func logOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            self.currentUser = nil
            self.isLoggedIn = false
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
    
    func updateProfile(name: String, bio: String, image: UIImage?, completion: @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { completion(false); return }
        let db = Firestore.firestore()
        isLoading = true

        func saveTextFields(pfpURL: String) {
            let updates: [String: Any] = [
                "userName": name,
                "bio": bio,
                "pfpURL": pfpURL
            ]
            db.collection("users").document(uid).updateData(updates) { error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let error = error {
                        print("Profile update error: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        self.fetchUser(id: uid)
                        completion(true)
                    }
                }
            }
        }

        if let image = image, let imageData = image.jpegData(compressionQuality: 0.7) {
            let storageRef = Storage.storage().reference().child("profileImages/\(uid).jpg")
            storageRef.putData(imageData, metadata: nil) { _, error in
                if let error = error {
                    print("Image upload error: \(error.localizedDescription)")
                    DispatchQueue.main.async { self.isLoading = false }
                    completion(false)
                    return
                }
                storageRef.downloadURL { url, _ in
                    saveTextFields(pfpURL: url?.absoluteString ?? self.currentUser?.profileImageURL ?? "")
                }
            }
        } else {
            saveTextFields(pfpURL: currentUser?.profileImageURL ?? "")
        }
    }
}
