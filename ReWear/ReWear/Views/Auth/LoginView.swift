import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var confirmPassword = ""
    @State private var isSignUp = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {

                VStack(spacing: 6) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.rwPrimary)
                            .frame(width: 72, height: 72)
                        Image(systemName: "arrow.3.trianglepath")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 56)

                    Text("R E W E A R")
                        .font(.rwDisplay)
                        .foregroundColor(Color.rwPrimary)
                        .kerning(6)
                        .padding(.top, 10)

                    Text("Give Your Clothes a ReWear")
                        .font(.rwCaption)
                        .foregroundColor(Color.rwTextSecondary)
                        .padding(.bottom, 36)
                }


                HStack(spacing: 0) {
                    ForEach(["Log In", "Sign Up"], id: \.self) { tab in
                        let selected = (tab == "Log In") ? !isSignUp : isSignUp
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isSignUp = tab == "Sign Up"
                            }
                        }) {
                            VStack(spacing: 6) {
                                Text(tab)
                                    .font(.rwBodyBold)
                                    .foregroundColor(selected ? Color.rwPrimary : Color.rwTextSecondary)
                                Rectangle()
                                    .fill(selected ? Color.rwPrimary : Color.clear)
                                    .frame(height: 2)
                                    .cornerRadius(1)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 24)
                .overlay(alignment: .bottom) {
                    Rectangle().fill(Color.rwBorder).frame(height: 1)
                }
                .padding(.bottom, 28)

                VStack(spacing: 14) {
                    if isSignUp {
                        RWTextField(placeholder: "Full name", text: $name, icon: "person")
                    }
                    RWTextField(placeholder: "Email address", text: $email, icon: "envelope")
                    RWTextField(placeholder: "Password", text: $password, icon: "lock", isSecure: true)
                    if isSignUp {
                        RWTextField(placeholder: "Confirm password", text: $confirmPassword, icon: "lock", isSecure: true)
                    }
                }
                .padding(.horizontal, 24)


                if let error = authViewModel.errorMessage {
                    Text(error)
                        .font(.rwCaption)
                        .foregroundColor(Color.rwDanger)
                        .padding(.horizontal, 24)
                        .padding(.top, 10)
                        .multilineTextAlignment(.center)
                }

                RWPrimaryButton(label: isSignUp ? "Create Account" : "Log In") {
                    if isSignUp {
                        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else { return }
                        guard password == confirmPassword else {
                            authViewModel.errorMessage = "Passwords do not match"
                            return
                        }
                        authViewModel.signUp(name: name, email: email, password: password)
                    } else {
                        authViewModel.logIn(email: email, password: password)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 22)

                HStack {
                    Rectangle().fill(Color.rwBorder).frame(height: 1)
                    Text("or")
                        .font(.rwCaption)
                        .foregroundColor(Color.rwTextSecondary)
                        .padding(.horizontal, 12)
                    Rectangle().fill(Color.rwBorder).frame(height: 1)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)

                Button {
                    authViewModel.signInWithGoogle()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "globe")
                            .font(.system(size: 15))
                        Text("Continue with Google")
                            .font(.rwBodyBold)
                    }
                    .foregroundColor(Color.rwTextPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.rwSurface)
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.rwBorder, lineWidth: 1)
                    )
                }
                
                .padding(.horizontal, 24)
                
                if authViewModel.isLoading {
                    ProgressView()
                        .padding(.top, 16)
                }

                Text(isSignUp
                     ? "By signing up, you agree to our Terms & Privacy Policy."
                     : "Forgot your password?")
                    .font(.rwMicro)
                    .foregroundColor(Color.rwTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 24)
                    .padding(.bottom, 40)
            }
        }
        .background(Color.rwBackground.ignoresSafeArea())
    }
}

#Preview { LoginView() }
