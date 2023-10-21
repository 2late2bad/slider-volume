//
//  ContentView.swift
//  SliderVolume
//
//  Created by Alexander V. on 20.10.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var volumeConfig: Config = .init()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.pink, .blue],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            
            interactiveSlider()
                .frame(width: 80, height: 180)            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func interactiveSlider() -> some View {
        CustomSlider(config: $volumeConfig)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
