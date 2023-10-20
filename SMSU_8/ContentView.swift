//
//  ContentView.swift
//  SMSU_8
//
//  Created by Andrei Kovryzhenko on 20.10.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var currentVolume: CGFloat = 0
    @State private var selectedVolume: CGFloat = 0
    @State private var wedthScale = 1.0
    @State private var heightScale = 1.0
    @State private var offset: CGFloat = 0
    
    private let colors: [Color] = [.cyan, .brown, .orange, .green, .indigo]
    private let width: CGFloat = 90
    private let height: CGFloat = 200
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            ZStack {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .frame(maxWidth: width, maxHeight: height * heightScale)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(.white)
                            .frame(width: width, height: height * currentVolume )
                    }
                    .clipShape(RoundedRectangle(
                        cornerRadius: 25
                    ))
                    .scaleEffect(x: wedthScale, y: heightScale)
                    .offset(y:offset )
                    .gesture(
                        withAnimation {
                            DragGesture()
                                .onChanged { value in
                                    let startLocation = value.startLocation.y
                                    let currentLocation = value.location.y
                                    var tempProgress = ((startLocation - currentLocation) / height) + selectedVolume
                                    tempProgress = max(-0.2, tempProgress)
                                    tempProgress = min (1.2, tempProgress)
                                    
                                    if tempProgress > 1.0  {
                                        heightScale = sqrt(tempProgress)
                                        wedthScale = 1 / sqrt(tempProgress)
                                        offset = height * -(1 - 1/sqrt(tempProgress))
                                    } else if tempProgress < 0.0 {
                                        heightScale = sqrt(1 - tempProgress)
                                        wedthScale = 1 / sqrt(1 - tempProgress)
                                        offset = height * (1 - 1/sqrt(1 - tempProgress))
                                    }
                                    tempProgress = max(0, tempProgress)
                                    tempProgress = min (1, tempProgress)
                                    currentVolume = tempProgress
                                }
                                .onEnded { value in
                                    withAnimation {
                                        selectedVolume = currentVolume
                                        heightScale = 1.0
                                        wedthScale = 1.0
                                        offset = 0.0
                                    }
                                }
                        }
                    )
            }
            .frame(width: width, height: height)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
