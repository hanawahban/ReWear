import SwiftUI
import PhotosUI
import CoreLocation

struct AddListingView: View {

    @EnvironmentObject var productViewModel: ProductViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss

    @State private var newlyCreatedProduct: Product? = nil
    @State private var navigateToDetail = false

    @State private var title = ""
    @State private var description = ""
    @State private var price = ""
    @State private var selectedCategory = ""
    @State private var selectedCondition = ""
    @State private var selectedSize = ""
    @State private var brand = ""

    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []

    @State private var isPosting = false
    @State private var showError = false
    @State private var errorMessage = ""

    let categories = ["Tops", "Dresses", "Outerwear", "Bottoms", "Shoes", "Bags", "Accessories"]
    let conditions = ["New with tags", "Like New", "Good", "Fair", "Poor"]
    let sizes = ["XS", "S", "M", "L", "XL", "XXL", "One Size"]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.rwBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Photos")
                                .font(.rwHeading)
                                .foregroundColor(Color.rwTextPrimary)
                            Text("Add up to 8 photos. First photo is the cover.")
                                .font(.rwCaption)
                                .foregroundColor(Color.rwTextSecondary)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {

                                    PhotosPicker(
                                        selection: $selectedPhotoItems,
                                        maxSelectionCount: 8,
                                        matching: .images
                                    ) {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.rwSageTint)
                                            .frame(width: 88, height: 88)
                                            .overlay(
                                                VStack(spacing: 6) {
                                                    Image(systemName: "plus")
                                                        .font(.system(size: 20, weight: .medium))
                                                        .foregroundColor(Color.rwPrimary)
                                                    Text("Add")
                                                        .font(.rwMicro)
                                                        .foregroundColor(Color.rwPrimary)
                                                }
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [5, 3]))
                                                    .foregroundColor(Color.rwSage)
                                            )
                                    }
                                    .onChange(of: selectedPhotoItems) { items in
                                        Task {
                                            var loaded: [UIImage] = []
                                            for item in items {
                                                if let data = try? await item.loadTransferable(type: Data.self),
                                                   let img = UIImage(data: data) {
                                                    loaded.append(img)
                                                }
                                            }
                                            await MainActor.run { selectedImages = loaded }
                                        }
                                    }

                                    if selectedImages.isEmpty {
                                        ForEach(0..<4, id: \.self) { _ in
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.rwSageTint)
                                                .frame(width: 88, height: 88)
                                                .overlay(
                                                    Image(systemName: "tshirt")
                                                        .font(.system(size: 24, weight: .thin))
                                                        .foregroundColor(Color.rwSage.opacity(0.5))
                                                )
                                        }
                                    } else {
                                        ForEach(Array(selectedImages.enumerated()), id: \.offset) { index, img in
                                            ZStack(alignment: .topTrailing) {
                                                Image(uiImage: img)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 88, height: 88)
                                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                                // Remove button
                                                Button(action: {
                                                    selectedImages.remove(at: index)
                                                    if index < selectedPhotoItems.count {
                                                        selectedPhotoItems.remove(at: index)
                                                    }
                                                }) {
                                                    ZStack {
                                                        Circle().fill(Color.black.opacity(0.6)).frame(width: 22, height: 22)
                                                        Image(systemName: "xmark")
                                                            .font(.system(size: 10, weight: .bold))
                                                            .foregroundColor(.white)
                                                    }
                                                }
                                                .padding(4)
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        RWDivider()

                        VStack(alignment: .leading, spacing: 14) {
                            Text("Item details")
                                .font(.rwHeading)
                                .foregroundColor(Color.rwTextPrimary)

                            RWTextField(placeholder: "Title e.g. Zara linen blazer", text: $title)

                            RWTextField(placeholder: "Brand (optional)", text: $brand, icon: "tag")

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Description")
                                    .font(.rwCaption)
                                    .foregroundColor(Color.rwTextSecondary)
                                TextEditor(text: $description)
                                    .font(.rwBody)
                                    .foregroundColor(Color.rwTextPrimary)
                                    .frame(height: 100)
                                    .padding(10)
                                    .background(Color.rwSageTint)
                                    .cornerRadius(12)
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.rwBorder, lineWidth: 1))
                                    .overlay(alignment: .topLeading) {
                                        if description.isEmpty {
                                            Text("Describe the item, its condition, measurements...")
                                                .font(.rwBody)
                                                .foregroundColor(Color.rwTextSecondary.opacity(0.6))
                                                .padding(14)
                                                .allowsHitTesting(false)
                                        }
                                    }
                            }

                            // Category picker
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Category")
                                    .font(.rwCaption)
                                    .foregroundColor(Color.rwTextSecondary)
                                Menu {
                                    ForEach(categories, id: \.self) { cat in
                                        Button(cat) { selectedCategory = cat }
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedCategory.isEmpty ? "Select category" : selectedCategory)
                                            .font(.rwBody)
                                            .foregroundColor(selectedCategory.isEmpty ? Color.rwTextSecondary : Color.rwTextPrimary)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color.rwTextSecondary)
                                    }
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 14)
                                    .background(Color.rwSageTint)
                                    .cornerRadius(12)
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.rwBorder, lineWidth: 1))
                                }
                            }

                            // Condition chips
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Condition")
                                    .font(.rwCaption)
                                    .foregroundColor(Color.rwTextSecondary)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(conditions, id: \.self) { cond in
                                            let selected = selectedCondition == cond
                                            Button(action: { selectedCondition = cond }) {
                                                Text(cond)
                                                    .font(.rwCaption)
                                                    .foregroundColor(selected ? .white : Color.rwTextPrimary)
                                                    .padding(.horizontal, 14)
                                                    .padding(.vertical, 8)
                                                    .background(selected ? Color.rwPrimary : Color.rwSurface)
                                                    .cornerRadius(20)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 20)
                                                            .stroke(selected ? Color.clear : Color.rwBorder, lineWidth: 1)
                                                    )
                                            }
                                        }
                                    }
                                }
                            }

                            // Size chips
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Size")
                                    .font(.rwCaption)
                                    .foregroundColor(Color.rwTextSecondary)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(sizes, id: \.self) { size in
                                            let selected = selectedSize == size
                                            Button(action: { selectedSize = size }) {
                                                Text(size)
                                                    .font(.rwCaption)
                                                    .foregroundColor(selected ? .white : Color.rwTextPrimary)
                                                    .padding(.horizontal, 14)
                                                    .padding(.vertical, 8)
                                                    .background(selected ? Color.rwPrimary : Color.rwSurface)
                                                    .cornerRadius(20)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 20)
                                                            .stroke(selected ? Color.clear : Color.rwBorder, lineWidth: 1)
                                                    )
                                            }
                                        }
                                    }
                                }
                            }

                            RWTextField(placeholder: "Price (BHD)", text: $price)
                                .keyboardType(.decimalPad)
                        }

                        RWDivider()

                        // ── Location ──────────────────────────────────────
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Location")
                                .font(.rwHeading)
                                .foregroundColor(Color.rwTextPrimary)
                            HStack(spacing: 6) {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color.rwPrimary)
                                Text("Use my current location")
                                    .font(.rwBodyBold)
                                    .foregroundColor(Color.rwPrimary)
                            }
                        }

                        RWDivider()

                        // ── Post Button ───────────────────────────────────
                        if isPosting {
                            HStack {
                                Spacer()
                                VStack(spacing: 8) {
                                    ProgressView()
                                    Text("Uploading photos and posting...")
                                        .font(.rwCaption)
                                        .foregroundColor(Color.rwTextSecondary)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 8)
                        } else {
                            RWPrimaryButton(label: "Post Listing") {
                                postListing()
                            }
                        }
                    }
                    .padding(20)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Sell a piece")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.rwBackground, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        // Reset all fields
                        title = ""
                        description = ""
                        brand = ""
                        price = ""
                        selectedCategory = ""
                        selectedCondition = ""
                        selectedSize = ""
                        selectedImages = []
                        dismiss()
                    }
                    .font(.rwBody)
                    .foregroundColor(Color.rwTextSecondary)
                }
            }
            .navigationDestination(isPresented: $navigateToDetail) {
                if let product = newlyCreatedProduct {
                    ProductDetailView(product: product)
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }

    func postListing() {
        // Validate required fields
        guard !title.isEmpty else {
            errorMessage = "Please enter a title."
            showError = true
            return
        }
        guard !selectedCategory.isEmpty else {
            errorMessage = "Please select a category."
            showError = true
            return
        }
        guard !selectedCondition.isEmpty else {
            errorMessage = "Please select a condition."
            showError = true
            return
        }
        guard let priceValue = Double(price), priceValue > 0 else {
            errorMessage = "Please enter a valid price."
            showError = true
            return
        }

        isPosting = true

        productViewModel.postProduct(
            title: title,
            description: description,
            price: priceValue,
            category: selectedCategory,
            condition: selectedCondition,
            size: selectedSize,
            brand: brand,
            location: "Manama",
            coord: (26.0667, 50.5577),
            images: selectedImages
            
        ) { success in
            isPosting = false
            if success {
                if let created = productViewModel.products.first(where: { $0.title == title }) {
                    newlyCreatedProduct = created
                    navigateToDetail = true
                } else if let created = productViewModel.products.first {
                    newlyCreatedProduct = created
                    navigateToDetail = true
                }
            } else {
                errorMessage = "Failed to post listing. Please try again."
                showError = true
            }
        }
    }
}

struct RWPickerRow: View {
    var label: String
    var value: String
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.rwCaption)
                .foregroundColor(Color.rwTextSecondary)
            HStack {
                Text(value)
                    .font(.rwBody)
                    .foregroundColor(value.contains("Select") ? Color.rwTextSecondary : Color.rwTextPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(Color.rwTextSecondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(Color.rwSageTint)
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.rwBorder, lineWidth: 1))
        }
    }
}

#Preview { AddListingView() }
