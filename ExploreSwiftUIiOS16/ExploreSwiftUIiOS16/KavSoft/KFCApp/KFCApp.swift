//
//  CoffeeApp.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 27/02/23.
//

import SwiftUI

fileprivate struct Toy: Identifiable {
    let id: UUID = UUID()
    let price: Int
    let name: String
    let image: String
    let description: String = "Lorem ipsum dolor sit amet"
    
    static var all: [Toy] = [
        .init(price: 220, name: "Combo", image: "Combo"),
        .init(price: 320, name: "French Fries", image: "French Fries"),
        .init(price: 220, name: "Rice Meal", image: "Rice Meal"),
        .init(price: 220, name: "Roasted Chicken", image: "Roasted Chicken"),
        .init(price: 320, name: "Twister Box", image: "Twister Box"),
        .init(price: 220, name: "Zinger Tower", image: "Zinger Tower"),
    ]
}

struct KFCApp: View {
    
    @State private var toys = Toy.all
    @State private var offsetY: CGFloat = 0.0
    @State private var currentIndex = 0
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let cardSize = size.width
            
            LinearGradient(colors: [
                .clear,
                .red.opacity(0.25),
                .red.opacity(0.55),
                .red
            ], startPoint: .top, endPoint: .bottom)
            .frame(height: 300)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea(edges: .bottom)
            
            VStack {
                headerView
                detailsView
            }
            
            VStack(spacing: 0) {
                ForEach(toys) { toy in
                    ToyItem(toy: toy, size: size)
                }
            }
            .frame(width: size.width)
            .padding(.top, size.height - cardSize)
            .offset(y: offsetY)
            .offset(y: -CGFloat(currentIndex) * cardSize)
            //https://www.hackingwithswift.com/quick-start/swiftui/how-to-control-the-tappable-area-of-a-view-using-contentshape
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let translation = value.translation.height
                        offsetY = translation
                    }
                    .onEnded { value in
                        let translation = value.translation.height
                        debugPrint("*****Translation Height - \(translation)")
                        
                        withAnimation(.easeInOut) {
                            if translation > 0 {
                                if currentIndex > 0 && translation > 250 {
                                    currentIndex -= 1
                                }
                            } else {
                                if currentIndex < (toys.count - 1) && translation < -250 {
                                    currentIndex += 1
                                }
                            }
                            
                            offsetY = .zero
                        }
                    }
            )
        }
        .coordinateSpace(name: "SCROLLVIEW")
        .preferredColorScheme(.dark)
    }
    
    private var headerView: some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2.bold())
            }
            
            Spacer(minLength: 0)
            
            Button {
                
            } label: {
                Image(systemName: "cart.fill")
                    .font(.title2.bold())
            }
        }
        .tint(.primary)
        .padding(15)
    }
    
    private var detailsView: some View {
        GeometryReader {
            let size = $0.size
            
            HStack(spacing: 0) {
                ForEach(toys) { toy in
                    VStack(spacing: 10) {
                        Text(toy.name)
                            .font(.title.bold())
                            .multilineTextAlignment(.center)
                        
                        Text("$ \(toy.price)")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .frame(width: size.width)
                }
            }
            .padding(.top, -30)
            .offset(x: -CGFloat(currentIndex) * size.width)
            .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8), value: currentIndex)
        }
    }
}

fileprivate struct ToyItem: View {
    var toy: Toy
    let size: CGSize
    var body: some View {
        let cardSize = size.width
        let maxCardsDisplaySize = cardSize * 3
        GeometryReader { proxy in
            let _size = proxy.size
            let offset = proxy.frame(in: .named("SCROLLVIEW")).minY - (size.height - cardSize)
            let _ = print("""
                MinY: \(proxy.frame(in: .named("SCROLLVIEW")).minY)
            """)
            let scale = offset <= 0 ? (offset / maxCardsDisplaySize) : 0
            let reducedScale = 1 + scale
            let currentCardScale = offset / cardSize
            
            Image(toy.image)
                .resizable()
                .scaledToFit()
                .frame(width: _size.width, height: _size.height)
                .scaleEffect(reducedScale < 0 ? 0.001 : reducedScale, anchor: UnitPoint(x: 0.5, y: 1 - currentCardScale))
                .scaleEffect(offset > 0 ? 1 + currentCardScale : 1, anchor: .top)
//                .offset(y: offset > 0 ? currentCardScale * 200 : 0)
//                .offset(y: currentCardScale * -130.0)
        }
        .frame(height: size.width)
    }
}

struct TeddyApp_Previews: PreviewProvider {
    static var previews: some View {
        KFCApp()
    }
}
