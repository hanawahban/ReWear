import SwiftUI

struct SettingsView: View {

    @State private var pushNotifications = true
    @State private var messageNotifications = true
    @State private var newListingAlerts = false
    @State private var locationEnabled = true
    @State private var showDeleteAlert = false

    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.rwBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {

                    RWSettingsSection(title: "Notifications") {
                        RWToggleRow(
                            icon: "bell",
                            label: "Push Notifications",
                            subtitle: "Offers, updates, and reminders",
                            isOn: $pushNotifications
                        )
                        RWDivider().padding(.leading, 44)
                        RWToggleRow(
                            icon: "message",
                            label: "Message Alerts",
                            subtitle: "When a buyer or seller messages you",
                            isOn: $messageNotifications
                        )
                        RWDivider().padding(.leading, 44)
                        RWToggleRow(
                            icon: "tag",
                            label: "New Listing Alerts",
                            subtitle: "Items matching your saved searches",
                            isOn: $newListingAlerts
                        )
                    }

                    RWSettingsSection(title: "Privacy & Location") {
                        RWToggleRow(
                            icon: "location",
                            label: "Location Services",
                            subtitle: "Used to show nearby listings",
                            isOn: $locationEnabled
                        )
                        RWDivider().padding(.leading, 44)
                        RWSettingsLinkRow(icon: "hand.raised", label: "Privacy Policy")
                        RWDivider().padding(.leading, 44)
                        RWSettingsLinkRow(icon: "doc.text", label: "Terms of Service")
                    }

                    RWSettingsSection(title: "Account") {
                        RWSettingsLinkRow(icon: "person.circle", label: "Edit Profile")
                        RWDivider().padding(.leading, 44)
                        RWSettingsLinkRow(icon: "lock", label: "Change Password")
                        RWDivider().padding(.leading, 44)
                        RWSettingsLinkRow(icon: "envelope", label: "Change Email")
                    }

                    RWSettingsSection(title: "Support") {
                        RWSettingsLinkRow(icon: "questionmark.circle", label: "Help Center")
                        RWDivider().padding(.leading, 44)
                        RWSettingsLinkRow(icon: "flag", label: "Report a Problem")
                        RWDivider().padding(.leading, 44)
                        RWSettingsLinkRow(icon: "star", label: "Rate ReWear")
                    }

                    RWSettingsSection(title: "About") {
                        HStack {
                            Image(systemName: "info.circle")
                                .font(.system(size: 16))
                                .foregroundColor(Color.rwPrimary)
                                .frame(width: 28)
                            Text("Version")
                                .font(.rwBody)
                                .foregroundColor(Color.rwTextPrimary)
                            Spacer()
                            Text("1.0.0")
                                .font(.rwBody)
                                .foregroundColor(Color.rwTextSecondary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                    }

                    VStack(spacing: 10) {
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color.rwDanger)
                                Text("Log Out")
                                    .font(.rwBodyBold)
                                    .foregroundColor(Color.rwDanger)
                                Spacer()
                            }
                            .padding(16)
                            .background(Color.rwSurface)
                            .cornerRadius(14)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.rwBorder, lineWidth: 1))
                        }

                        Button(action: { showDeleteAlert = true }) {
                            HStack {
                                Image(systemName: "trash")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color.rwDanger)
                                Text("Delete Account")
                                    .font(.rwBodyBold)
                                    .foregroundColor(Color.rwDanger)
                                Spacer()
                            }
                            .padding(16)
                            .background(Color.rwDanger.opacity(0.06))
                            .cornerRadius(14)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.rwDanger.opacity(0.3), lineWidth: 1))
                        }
                    }

                    // Footer
                    Text("ReWear © 2026")
                        .font(.rwMicro)
                        .foregroundColor(Color.rwTextSecondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 30)
                }
                .padding(20)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.rwBackground, for: .navigationBar)
        .alert("Delete Account", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {}
        } message: {
            Text("Are you sure? This will permanently delete your account and all your listings.")
        }
    }
}

struct RWSettingsSection<Content: View>: View {
    var title: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title.uppercased())
                .font(.rwMicro)
                .foregroundColor(Color.rwTextSecondary)
                .kerning(0.5)
                .padding(.leading, 4)

            VStack(spacing: 0) {
                content
            }
            .background(Color.rwSurface)
            .cornerRadius(14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.rwBorder, lineWidth: 1))
        }
    }
}

struct RWToggleRow: View {
    var icon: String
    var label: String
    var subtitle: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(Color.rwPrimary)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.rwBody)
                    .foregroundColor(Color.rwTextPrimary)
                Text(subtitle)
                    .font(.rwMicro)
                    .foregroundColor(Color.rwTextSecondary)
            }

            Spacer()

            Toggle("", isOn: $isOn)
                .tint(Color.rwPrimary)
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

struct RWSettingsLinkRow: View {
    var icon: String
    var label: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(Color.rwPrimary)
                .frame(width: 28)
            Text(label)
                .font(.rwBody)
                .foregroundColor(Color.rwTextPrimary)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(Color.rwTextSecondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

#Preview { NavigationStack { SettingsView() } }
