//
//  CustomModifiersForView.swift
//  cg3.00
//
//  Created by  Sofia Yaroshovych on 02.04.2024.
//

import SwiftUI



struct DefaultCarouselItemModifier: ViewModifier{
    func body(content: Content) -> some View{
        content
            .frame(width: 300, height: 500)
            .padding()
            .padding(.top, 10)
            .cornerRadius(5)
            .shadow(color: Color.black.opacity(0.5), radius: 15, x: 0, y: 0)
            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 0)

        
    }
}

extension View{
    func withDefaultCarouselItemFormatting() -> some View{
        self.modifier(DefaultCarouselItemModifier())
    }
}


struct DefaultTextModifier: ViewModifier{
    func body(content: Content) -> some View{
        content
            .font(.custom("Montserrat Alternates", size: 32))
            .foregroundColor(.white)
            .shadow(color: Color.black.opacity(0.8), radius: 4, x: 0, y: 0)
            .shadow(color: Color.black.opacity(0.8), radius: 2, x: 0, y: 0)
            .multilineTextAlignment(.center)
        
    }
}

extension View{
    func withDefaultTextFormatting() -> some View{
        self.modifier(DefaultTextModifier())
    }
}


struct DefaultSliderModifier: ViewModifier{
    func body(content: Content) -> some View{
        content
            .accentColor(.purple)
//            .shadow(color: Color.white.opacity(0.8), radius: 4, x: 0, y: 0)

        
    }
}

extension View{
    func withDefaultSlider() -> some View{
        self.modifier(DefaultSliderModifier())
    }
}

struct DefaultSettingItemModifier: ViewModifier{
    func body(content: Content) -> some View{
        content
            .frame(maxWidth: .infinity)
            .font(.custom("Montserrat Alternates", size:16))
            .padding()
            .background( Color .purple.opacity(0.5))
            .cornerRadius(15.0)
//            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .foregroundColor(.white)




        
    }
}

extension View{
    func withDefaultSettingItem() -> some View{
        self.modifier(DefaultSettingItemModifier())
    }
}
