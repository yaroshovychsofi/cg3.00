import SwiftUI
import UIKit
import PhotosUI


class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Помилка збереження: \(error.localizedDescription)")
        } else {
            print("Зображення успішно збережено.")
        }
    }
}

struct FractalSettingsView: View {
    @State private var maxIterations: Double = 50
    @State private var boundsSize: Double = 2.0
    @State private var scale: Double = 20.0
    @State private var snapshotImage: UIImage?
    @State private var colors: [Color] = [.black, .white]
    @State private var newColor: Color = .pink
    var AlgebraicFractalView: some View{
        return SinFractalView(maxIterations: Int(maxIterations), boundsSize: boundsSize, colors: colors)
    }
    
    var body: some View {
        ZStack{
            Image("BackgroundImage")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 5)
            VStack(spacing:10) {
                
                ScrollView([.horizontal, .vertical], showsIndicators: true) {
                        AlgebraicFractalView
                            .frame(width: 800)
                            .frame(height: 800)
                            .cornerRadius(20.0)
                            .scaleEffect(scale / 60)
                }
                .frame(width: 300,height: 300)
                
                
                
                Spacer()
                Text("Вкажіть кількість ітерацій: \(Int(maxIterations))")
                    .withDefaultSettingItem()
                Slider(value: $maxIterations, in: 1...100, step: 1)
                    .withDefaultSlider()
                Text("Константа С: \(boundsSize, specifier: "%.2f")")
                    .withDefaultSettingItem()
                Slider(value: $boundsSize, in: -5.0...5.0, step:0.001)
                    .withDefaultSlider()
                Text("Масштаб: \(scale, specifier: "%.1f")")
                    .withDefaultSettingItem()
                Slider(value: $scale, in: 1...100, step: 0.1) 
                    .withDefaultSlider()
                HStack(alignment:.center){
                    Button(action: {
                     }) {
                         HStack {
                             Image(systemName: "photo.badge.arrow.down")
                                 .foregroundStyle(Color .purple)
                         }
                     }
                     .padding()
                     .font(.custom("Montserrat Alternates", size:16))
                     .frame(maxWidth: .infinity)
                     .background(Color.white.opacity(0.6))
                     .cornerRadius(15.0)
                     .foregroundColor(.purple)
                     .fontWeight(.bold)
                    Button("Додати колір" ) {
                        colors.append(newColor)
                    }
                    .padding()
                    .font(.custom("Montserrat Alternates", size:16))
                    .frame(width: 200)
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(15.0)
                    .foregroundColor(.purple)
                    .fontWeight(.bold)
                    
                    ColorPicker("", selection: $newColor, supportsOpacity: false)
                        .padding(.horizontal,5)
                    Spacer()
                }
            }
            .frame(maxHeight: .infinity)
            .padding()
            .padding()
        }
    }
    
}


func printAllFonts() {
    for familyName in UIFont.familyNames.sorted() {
        print("\(familyName)")
        
        for fontName in UIFont.fontNames(forFamilyName: familyName).sorted() {
            print(" - \(fontName)")
        }
    }
}

struct SinFractalView_Previews: PreviewProvider {
    static var previews: some View {
        FractalSettingsView()
        
        
    }
}

