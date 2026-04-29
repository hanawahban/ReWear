import SwiftUI

struct OnboardingView: View {

    @State private var currentPage = 0
    @Binding var hasSeenOnboarding: Bool

    let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "arrow.3.trianglepath",
            title: "Shop Sustainably",
            subtitle: "Give pre-loved pieces a second life. Browse thousands of quality items from sellers near you.",
            background: Color(hex: "#1B4332")
        ),
        OnboardingPage(
            icon: "tshirt",
            title: "Sell Your Closet",
            subtitle: "Turn clothes you no longer wear into cash. List an item in under 2 minutes.",
            background: Color(hex: "#2D6A4F")
        ),
        OnboardingPage(
            icon: "mappin.and.ellipse",
            title: "Find Pieces Nearby",
            subtitle: "Discover fashion from your neighbourhood. Less shipping, more connection.",
            background: Color(hex: "#40916C")
        ),
    ]

    var body: some View {
        ZStack {
            pages[currentPage].background
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.4), value: currentPage)

            VStack(spacing: 0) {

                HStack {
                    Spacer()
                    Button(action: { hasSeenOnboarding = true }) {
                        Text("Skip")
                            .font(.rwBody)
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                    }
                }
                .padding(.top, 16)

                Spacer()

                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        VStack(spacing: 32) {

                            ZStack {
                                Circle()
                                    .fill(.white.opacity(0.15))
                                    .frame(width: 140, height: 140)
                                Circle()
                                    .fill(.white.opacity(0.1))
                                    .frame(width: 110, height: 110)
                                Image(systemName: page.icon)
                                    .font(.system(size: 50, weight: .thin))
                                    .foregroundColor(.white)
                            }

                            VStack(spacing: 14) {
                                Text(page.title)
                                    .font(.rwDisplay)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)

                                Text(page.subtitle)
                                    .font(.rwBody)
                                    .foregroundColor(.white.opacity(0.8))
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(5)
                                    .padding(.horizontal, 32)
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 420)

                Spacer()

                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { i in
                        Capsule()
                            .fill(.white.opacity(currentPage == i ? 1.0 : 0.4))
                            .frame(width: currentPage == i ? 24 : 8, height: 8)
                            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentPage)
                    }
                }
                .padding(.bottom, 40)

                VStack(spacing: 12) {
                    if currentPage < pages.count - 1 {
                        Button(action: {
                            withAnimation { currentPage += 1 }
                        }) {
                            Text("Next")
                                .font(.rwBodyBold)
                                .foregroundColor(pages[currentPage].background)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(.white)
                                .cornerRadius(14)
                        }

                        Button(action: { hasSeenOnboarding = true }) {
                            Text("Already have an account? Log In")
                                .font(.rwCaption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    } else {
                        Button(action: { hasSeenOnboarding = true }) {
                            Text("Get Started")
                                .font(.rwBodyBold)
                                .foregroundColor(pages[currentPage].background)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(.white)
                                .cornerRadius(14)
                        }

                        Button(action: { hasSeenOnboarding = true }) {
                            Text("Log in to existing account")
                                .font(.rwCaption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 48)
            }
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let subtitle: String
    let background: Color
}

struct SplashCoordinatorView: View {

    @State private var showSplash = true
    @State private var hasSeenOnboarding = false

    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .transition(.opacity)
            } else if !hasSeenOnboarding {
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                    .transition(.opacity)
            } else {
                LoginView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: showSplash)
        .animation(.easeInOut(duration: 0.4), value: hasSeenOnboarding)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation { showSplash = false }
            }
        }
    }
}

struct SplashView: View {

    @State private var scale = 0.7
    @State private var opacity = 0.0

    var body: some View {
        ZStack {
            Color.rwPrimary.ignoresSafeArea()

            VStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.white.opacity(0.15))
                        .frame(width: 100, height: 100)
                    Image(systemName: "arrow.3.trianglepath")
                        .font(.system(size: 44, weight: .thin))
                        .foregroundColor(.white)
                }

                Text("R E W E A R")
                    .font(.rwDisplay)
                    .foregroundColor(.white)
                    .kerning(6)

                Text("Chic. Conscious. Circular.")
                    .font(.rwCaption)
                    .foregroundColor(.white.opacity(0.6))
            }
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    scale = 1.0
                    opacity = 1.0
                }
            }
        }
    }
}

#Preview("Splash") { SplashView() }
#Preview("Onboarding") {
    OnboardingView(hasSeenOnboarding: .constant(false))
}
#Preview("Full Flow") { SplashCoordinatorView() }
