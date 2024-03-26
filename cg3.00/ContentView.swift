
import SwiftUI
//
//struct ContentView: View {
//
//    var body: some View {
//        NavigationView{
//            ZStack{
//                
//                Image("BackgroundImage")
//                    .resizable()
//                    .edgesIgnoringSafeArea(.all)
//                VStack {
//                    Text("Choose what you want to visualise🎨")
//                        .padding()
//                        .background(Color.pink.opacity(0.3))
//                        .background(Color.white.opacity(0.3))
//                        .background(Color.blue.opacity(0.4))
//                        .cornerRadius(10.0)
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.center)
//                        .padding()
//                    
//                    Spacer()
//                   
//                }
//                .padding(.top, 10)
//                VStack{
//                    ScrollView{
//                        Spacer()
//                        VStack(spacing: 20){
//                            NavigationLink(destination: BezierCurveView()){
//                                Text("Bezier Curve")
//                                   
//                            }
//                        }
//                        .frame(height: 300)
//                        .cornerRadius(3.0)
//                        .background(Color .white)
//                    }
//                }
//            }
//            
//        }
//
//    }
//}

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
            ZStack{
                
                
                // Background image
                Image("BackgroundImage")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Choose what you want to visualise🎨")
                        .padding()
                        .background(Color.pink.opacity(0.3))
                        .cornerRadius(10.0)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                    Spacer()
                    ScrollView {
                        VStack(spacing: 20) {
                            Spacer()
//                            ForEach(options) { option in
//                                NavigationLink(destination: Text(option.title)) {
//                                    HStack {
//                                        Image(systemName: option.icon)
//                                            .foregroundColor(.white)
//                                            .padding()
//                                            .background(Circle().fill(Color.blue))
//                                            .shadow(radius: 2)
//                                        
//                                        VStack(alignment: .leading) {
//                                            Text(option.title)
//                                                .fontWeight(.bold)
//                                            Text(option.subtitle)
//                                                .font(.caption)
//                                                .foregroundColor(.gray)
//                                        }
//                                        .padding(.leading, 10)
//                                        
//                                        Spacer()
//                                        
//                                        Toggle("", isOn: .constant(true))
//                                            .toggleStyle(SwitchToggleStyle(tint: .green))
//                                    }
//                                    .padding()
//                                    .frame(maxWidth: .infinity)
//                                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
//                                    .shadow(radius: 3)
//                                }
//                                
//                            }
                            
                        }
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity)
                    }
                    .background(Color.white)
                    .cornerRadius(15.0)
                    .edgesIgnoringSafeArea(.bottom)
                    .frame(height: 500)
                    
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
