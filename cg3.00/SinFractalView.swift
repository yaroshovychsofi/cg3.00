import SwiftUI
import UIKit


struct FractalSettingsView: View {
    @State private var maxIterations: Double = 100
    @State private var boundsSize: Double = 5.0
    @State private var scale: Double = 1.0 // Ініціалізація змінної масштабу
    @State private var colors: [Color] = [.black, .white]
    @State private var newColor: Color = .pink
    
    var body: some View {
        ZStack{
            Image("BackgroundImage")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 5)
            VStack(spacing:10) {
                //                    Text("Налаштування фракталу")
                //                        .font(.custom("Montserrat Alternates", size:22))
                //                        .fontWeight(.bold)
                //                        .multilineTextAlignment(.center)
                //                        .foregroundColor(.black)
                //
                //
                SinFractalView(maxIterations: Int(maxIterations), boundsSize: boundsSize/scale, colors: colors)
                    .frame(maxWidth: .infinity)
                    .frame(height: 350)
                    .cornerRadius(20.0)
                Spacer()
                Text("Вкажіть кількість ітерацій: \(Int(maxIterations))")
                    .withDefaultSettingItem()
                Slider(value: $maxIterations, in: 1...100, step: 1)
                    .withDefaultSlider()
                Text("Константа С: \(boundsSize, specifier: "%.2f")")
                    .withDefaultSettingItem()
                Slider(value: $boundsSize, in: 0.1...10)
                    .withDefaultSlider()
                Text("Масштаб: \(scale, specifier: "%.1f")")
                    .withDefaultSettingItem()
                Slider(value: $scale, in: 0.5...5.0, step: 0.1) // Слайдер для масштабу
                    .withDefaultSlider()
                HStack(alignment:.center){
                    Button("Додати колір") {
                        colors.append(newColor)
                        printAllFonts()
                        
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
                        .padding(.horizontal,20)
                    Spacer()
                }
                .padding(.horizontal)
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
