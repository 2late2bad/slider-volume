//
//  CustomSlider.swift
//  SliderVolume
//
//  Created by Alexander V. on 20.10.2023.
//

import SwiftUI

struct CustomSlider: View {
    
    enum Status {
        case none, over, down
    }
    
    var cornerRadius: CGFloat = 18
    @Binding var config: Config
    @State private var scaleX: CGFloat = 1
    @State private var scaleY: CGFloat = 1
    @State private var offsetY: CGFloat = 0
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ZStack {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(.white)
                            .scaleEffect(y: config.progress, anchor: .bottom)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    .scaleEffect(x: scaleX, y: scaleY)
                    .offset(y: offsetY)
                    .animation(.easeInOut, value: scaleX)
                    .animation(.easeInOut, value: scaleY)
                    .animation(.easeInOut, value: offsetY)
            }
            .gesture(
                SpatialTapGesture(count: 1, coordinateSpace: .local).onEnded({ value in
                    let currentLocation = value.location.y
                    var progress = (currentLocation / size.height)
                    progress = max(0, progress)
                    progress = min(1, progress)
                    config.progress = 1 - progress
                }).simultaneously(with: DragGesture().onChanged({ value in
                    let startLocation = value.startLocation.y
                    let currentLocation = value.location.y
                    let offset = startLocation - currentLocation

                    var progress = (offset / size.height) + config.lastProgress
                                        
                    if progress > 1.0 {
                        recalculation(with: .over, progress: progress)
                    } else if progress < 0 {
                        recalculation(with: .down, progress: progress)
                    } else {
                        recalculation(with: .none)
                    }
                    
                    progress = max(0, progress)
                    progress = min(1, progress)
                    config.progress = progress
                }).onEnded({ value in
                    config.lastProgress = config.progress
                    recalculation(with: .none, progress: 0)
                }))
            )
        }
    }
    
    private func recalculation(with status: Status, progress: CGFloat = 0) {
        switch status {
        case .none:
            scaleX = 1
            scaleY = 1
            offsetY = 0
        case .over:
            scaleX = 1 - progress / 80
            scaleY = 1 + progress / 50
            offsetY = (9 - progress * 10)
        case .down:
            scaleX = 1 - (-progress / 60)
            scaleY = 1 - progress / 20
            offsetY = -progress * 10
        }
    }
}
