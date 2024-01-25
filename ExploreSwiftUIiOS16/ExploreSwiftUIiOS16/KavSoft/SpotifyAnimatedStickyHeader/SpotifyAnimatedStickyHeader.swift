//
//  SpotifyAnimatedStickyHeader.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 25/02/23.
//

import SwiftUI

fileprivate struct Album: Identifiable {
    let id: Int
    let name: String
    let description: String
}

fileprivate class ViewModel: ObservableObject {
    @Published var albums: [Album] = {
        var result = [Album]()
        for i in 1..<11 {
            result.append(.init(id: i, name: "Album #\(i)", description: "Album #\(i) description"))
        }
        return result
    }()
}

struct SpotifyAnimatedStickyHeader: View {
    
    @StateObject private var vm = ViewModel()
    
    var body: some View {
        GeometryReader {
            let safeArea = $0.safeAreaInsets
            let size = $0.size
            
            contentView(safeArea: safeArea, size: size)
            //https://swiftwithmajid.com/2021/11/03/managing-safe-area-in-swiftui/
                .ignoresSafeArea(.container, edges: .top)
                .preferredColorScheme(.dark)
        }
    }
    
    private func contentView(safeArea: EdgeInsets, size: CGSize) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                artwork(safeArea: safeArea, size: size)
                shuffleBtn
//                    .offset(y: -35)
                    .padding(.top, -35)
                albumsView
            }
            .overlay(alignment: .top) {
                headerView(safeArea: safeArea)
            }
        }
        .coordinateSpace(name: "ScrollView")
    }
    
    private func headerView(safeArea: EdgeInsets) -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("ScrollView")).minY
            
            HStack(spacing: 15) {
                Button {
                    
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.white)
                }
                
                Spacer(minLength: 0)
                
                Text("Following".uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .border(Color.white, width: 2)
                
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title3)
                        .foregroundColor(.white)
                }
            }
            .offset(y: -minY)
            .padding([.horizontal], 15)
            .padding(.top, safeArea.top + 10)
        }
    }
    
    @ViewBuilder
    private func artwork(safeArea: EdgeInsets, size: CGSize) -> some View {
        let height = (size.height * 0.45)
        GeometryReader { proxy in
            let minY = proxy.frame(in: CoordinateSpace.named("ScrollView")).minY
            let progress = minY / (height * 0.5)
            
            Image("ARRahman")
                .resizable()
                .scaledToFill()
                .clipped()
                .overlay(alignment: .bottom) {
                    ZStack(alignment: .bottom) {
                        Rectangle()
                            .fill(
                                .linearGradient(
                                    colors: [
                                        .black.opacity(0 - progress),
                                        .black.opacity(0.3 - progress),
                                        .black.opacity(0.6 - progress),
                                        .black.opacity(0.8 - progress),
                                        .black.opacity(1)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        VStack(spacing: 0) {
                            Text("AR Rahman")
                                .font(.system(size: 45))
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            
                            Text(formattedStr(num: Int.random(in: 1000..<500000)) + " Monthly subscribers")
                                .font(.callout)
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                        }
                        .offset(y: minY)
                        .padding(.bottom, 55)
                    }
                }
                .offset(y: -minY)
        }
        .frame(height: height + safeArea.top)
    }
    
    private var shuffleBtn: some View {
        Button {
            
        } label: {
            Text("SHUFFLE PLAY")
                .font(.callout)
                .foregroundColor(.white)
                .fontWeight(.semibold)
                .padding(.horizontal, 45)
                .padding(.vertical, 12)
                .background {
                    Capsule()
                        .fill(Color("Green").gradient)
                }
        }
//        .frame(maxWidth: .infinity)
    }
    
    private var albumsView: some View {
        VStack(spacing: 25) {
            Text("Popular")
                .fontWeight(.heavy)
            
            ForEach(vm.albums) { album in
                HStack(spacing: 25) {
                    Text(album.id.description)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(album.name)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text("2,283,987")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
//                    Spacer(minLength: 0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button {

                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding(15)
    }
    
    fileprivate func formattedStr(num: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: num))!
    }
}

struct SpotifyAnimatedStickyHeader_Previews: PreviewProvider {
    static var previews: some View {
        SpotifyAnimatedStickyHeader()
    }
}
