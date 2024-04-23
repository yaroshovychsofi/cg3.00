

import SwiftUI


struct Item {
    var backgroundImage: String
    var nameOfItem: String
}

struct FractalsView: View {
    
    
    // Індекс поточної сторінки для каруселі
    @State private var currentIndex: Int = 0
    
    
    
    let items: [Item] = [
        Item(backgroundImage: "AlgebraicFractal", nameOfItem: "AlgebraicFractal"),
        Item(backgroundImage: "GeometricFractal", nameOfItem: "GeometricFractal")
    ]
    
    var body: some View {
        ZStack{
            NavigationView {
                TabView(selection: $currentIndex) {
                    ForEach(items.indices, id: \.self) { index in
                        GeometryReader { geometry in
                            NavigationLink(destination: destinationView(for: items[index])) {
                                VStack(spacing: 30) {
                                    Image(items[index].backgroundImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 300, height: 500)
                                        .background(Color.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .padding()
                                        .shadow(radius: 5)
                                    Text(items[index].nameOfItem)
                                }
                                
                                .frame(width: geometry.size.width)
                                .cornerRadius(20)
                                .tag(index)
                            }
                        }
                    }
                    .padding()
                    .shadow(radius: 10)
                    
                    
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .animation(.easeInOut, value: currentIndex)
                .onReceive(Timer.publish(every: 10, on: .main, in: .common).autoconnect()) { _ in
                    withAnimation {
                        currentIndex = (currentIndex + 1) % items.count
                    }
                }
                
            }
            .navigationViewStyle(StackNavigationViewStyle()) // Стилізація NavigationView для стеку
            .navigationBarHidden(true) // Приховування навігаційного бару
            .edgesIgnoringSafeArea(.all)
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)

        
        
    }
    
    @ViewBuilder
    private func destinationView(for item: Item) -> some View {
        switch item.nameOfItem {
        case "AlgebraicFractal":
            FractalSettingsView() // Замініть на вашу власну відповідну View
        case "GeometricFractal":
            IceFractalView() // Замініть на вашу власну відповідну View
        default:
            Text("Не знайдено відповідного виду для \(item.nameOfItem)")
        }
    }
}



struct FractalsView_Previews: PreviewProvider {
    static var previews: some View {
        
        FractalsView()
            
    }
}

