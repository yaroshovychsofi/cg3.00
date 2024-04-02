import SwiftUI



struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                BackgroundImageView()
                TitleTextView()
                MainContentView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct BackgroundImageView: View {
    var body: some View {
        Image("BackgroundImage")
            .resizable()
            .edgesIgnoringSafeArea(.all)
    }
}

struct TitleTextView: View {
    var body: some View {
        Text("Computer Graphic\nVisualiser")
            .font(.custom("Montserrat Alternates", size: 34))
            .padding()
            .background(VisualEffectView())
            .cornerRadius(5.0)
            .foregroundColor(.white.opacity(0.7))
            .padding(.top, 30)
            .multilineTextAlignment(.center)
    }
}

struct VisualEffectView: View {
    var body: some View {
        Color.pink.opacity(0.5)
            .overlay(Color.white.opacity(0.3))
            .overlay(Color.blue.opacity(0.3))
    }
}

struct MainContentView: View {
    var body: some View {
        ScrollView {
            Spacer().padding(.bottom, 350)
            MenuContentView()
                
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct MenuContentView: View {
    var body: some View {
        VStack {
            DrawerHandleView()
            NavigationLinkView(destination: BezierCurveView(), iconName: "point.topleft.down.to.point.bottomright.curvepath", title: "Bezier Curve", subtitle: "With 4 and more points")
               
            NavigationLinkView(destination: FractalSettingsView(), iconName: "wand.and.stars", title: "Fractal", subtitle: "Drawing fractus")
              
            Spacer()
        }
        .frame(minHeight: 1000)
        .background(Color.white)
        .cornerRadius(45)
        .edgesIgnoringSafeArea(.bottom)
        .overlay(MainPageImageView(), alignment: .top)
    }
}

struct DrawerHandleView: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.5))
            .frame(width: 100, height: 5)
            .cornerRadius(3.0)
            .padding(10)
        
    }
}

struct NavigationLinkView<Destination: View>: View {
    var destination: Destination
    var iconName: String
    var title: String
    var subtitle: String
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                IconBackgroundView(systemName: iconName)
                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundColor(Color.purple.opacity(0.8))
                        .fontWeight(.bold)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.leading, 10)
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 40).fill(Color.white).shadow(radius: 4))
            
        }
        .padding(.horizontal, 20)
    }
}

struct IconBackgroundView: View {
    var systemName: String
    
    var body: some View {
        Image(systemName: systemName)
            .foregroundColor(.white)
            .padding()
            .background(Circle().fill(LinearGradient(gradient: Gradient(colors: [Color.pink.opacity(0.5), Color.blue.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing)))
    }
}

struct MainPageImageView: View {
    var body: some View {
        Image("MainPagePic")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 150)
            .opacity(0.8)
            .offset(x: 0, y: -145) // Using offset for better positioning
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
