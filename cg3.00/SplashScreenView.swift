
import SwiftUI

struct SplashScreenView: View {
    @State private var IsActive = false
    @State private var Size = 0.8
    @State private var Opacity = 1.0
    var body: some View {
        if IsActive {
            ContentView()
        }
        else {
            ZStack{
                Image("PreviewImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .opacity(0.95)
                    .padding(.top, 16)
                VStack{
                    Spacer()
                    Text("CG Visualiser")
                        .font(.custom("Montserrat Alternates", size: 24))
                        .foregroundColor(.purple.opacity(0.9))
                        .foregroundColor(.black.opacity(0.9))
                }
            }
            
            .scaleEffect(Size)
            .opacity(Opacity)
            .edgesIgnoringSafeArea(.all)
            .onAppear{
                withAnimation(.easeIn(duration: 3.0)){
//                    self.Size = 0.9
//                    self.Opacity = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    withAnimation{
                        self.IsActive = true

                        
                    }
                }

            }
        }

    }
}

#Preview {
    SplashScreenView()
}
