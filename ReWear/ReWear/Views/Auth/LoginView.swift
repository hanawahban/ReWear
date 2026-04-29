import SwiftUI

struct LoginView: View {

    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false

    var body: some View {
        VStack(spacing: 0) {

            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray5))
                .frame(width: 90, height: 90)
                .overlay(Text("LOGO").font(.caption).foregroundColor(.gray))
                .padding(.top, 60)

            Text("ReWear")
                .font(.title2).bold()
                .padding(.top, 12)

            Text("Give Your Clothes a ReWear")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 36)

            Picker("Mode", selection: $isSignUp) {
                Text("Log In").tag(false)
                Text("Sign Up").tag(true)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)

            VStack(spacing: 14) {

                if isSignUp {
                    WireframeTextField(placeholder: "Full name")
                }

                WireframeTextField(placeholder: "Email address")
                WireframeTextField(placeholder: "Password", isSecure: true)

                if isSignUp {
                    WireframeTextField(placeholder: "Confirm password", isSecure: true)
                }
            }
            .padding(.horizontal, 24)

            WireframeButton(label: isSignUp ? "Create Account" : "Log In")
                .padding(.horizontal, 24)
                .padding(.top, 24)

            HStack {
                Rectangle().fill(Color(.systemGray4)).frame(height: 1)
                Text("or").font(.caption).foregroundColor(.secondary).padding(.horizontal, 8)
                Rectangle().fill(Color(.systemGray4)).frame(height: 1)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 18)

            WireframeButton(label: "Continue with Apple", style: .outline)
                .padding(.horizontal, 24)

            WireframeButton(label: "Continue with Google", style: .outline)
                .padding(.horizontal, 24)
                .padding(.top, 10)

            Spacer()

            Button(action: { isSignUp.toggle() }) {
                Text(isSignUp ? "Already have an account? Log In" : "Don't have an account? Sign Up")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 32)
        }
    }
}

#Preview { LoginView() }
