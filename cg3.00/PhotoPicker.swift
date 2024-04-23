import SwiftUI
import PhotosUI

@MainActor
final class PhotoPickerViewModel: ObservableObject {
    @Published private(set) var selectedImage: UIImage?
    @Published private(set) var convertedImage: UIImage?
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            setImage(from: imageSelection)
        }
    }
    
    private var imageProcessor = ImageProcessor()

    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        Task {
            do {
                let data = try await selection.loadTransferable(type: Data.self)
                guard let data, let uiImage = UIImage(data: data) else {
                    throw URLError(.badServerResponse)
                }
                selectedImage = uiImage
                // Process the image to convert it to HSV
                imageProcessor.originalImageView = UIImageView(image: uiImage)  // Use dummy UIImageViews to handle processing
                imageProcessor.convertedImageView = UIImageView()
                imageProcessor.loadImage(from: URL(string: "data:image/jpg;base64,\(data.base64EncodedString())")!) // Convert the UIImage to a data URL
                
                // After processing, update the convertedImage
                DispatchQueue.main.async {
                    self.convertedImage = self.imageProcessor.convertedImageView.image
                }
            }
            catch {
                print(error)
            }
        }
    }
}

struct PhotoPicker: View {
    @StateObject private var viewModel = PhotoPickerViewModel()

    var body: some View {
        VStack(spacing: 40) {
            VStack(spacing: 20) {
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .cornerRadius(10)
                }
                if let converted = viewModel.convertedImage {
                    Image(uiImage: converted)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .cornerRadius(10)
                }
            }
            PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
                Text("Open the photo picker")
                    .foregroundColor(.red)
            }
        }
    }
}

// Preview
struct PhotoPicker_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPicker()
    }
}
