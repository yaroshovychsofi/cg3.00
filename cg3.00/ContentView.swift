
import SwiftUI


struct ContentView: View {
    // Припустимо, у нас є структура для елементів
    struct Option: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
        let subtitle: String
    }
    
    // Демонстраційні дані
    let options = [
        Option(icon: "sun.max.fill", title: "Daily calm", subtitle: "30m - Deep sleep"),
        Option(icon: "star.fill", title: "Travel to the stars", subtitle: "10m - Story for sleep"),
        Option(icon: "face.smiling", title: "How do you feel?", subtitle: "1m - Test")
    ]
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .top){
                
                Image("BackgroundImage")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                Text("Computer Graphic")
                    .font(.largeTitle)
                    .padding()
                    .background(Color .pink.opacity(0.3))
                    .background(Color .white.opacity(0.3))
                    .background(Color .blue.opacity(0.4))
                    .cornerRadius(5.0)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.top, 50)
                ZStack(alignment: .bottom){
                    ScrollView{
                        Spacer()
                            .padding(.bottom,300)
                        VStack{
                            VStack{
                                Rectangle()
                                       .fill(Color.gray.opacity(0.5))
                                       .frame(width: 100, height: 5)
                                       .cornerRadius(3.0)
                                       .padding(10)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                        }
                        .frame(height: 800)
                        .background(Color.white)
                        .cornerRadius(30)
                        .edgesIgnoringSafeArea(.bottom)
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    VStack{
                        Text("Scroll")
                            .font(.caption)
                            .foregroundColor(.gray.opacity(0.8))
                            .fontWeight(.bold)
                            
                    }
                    .padding(.top, 200)
                    .frame( height: 200)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    
                    
                    
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
            
        }
    }
}

#Preview {
    ContentView()
}
