//
//  EnumBasedNavigation.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 12/01/23.
//

import SwiftUI

fileprivate enum HomeNavigation: String, CaseIterable, Identifiable {
    case greenView = "Green View"
    case domImage = "Damini Tiled Image"
    case colorsStack = "Colors Stack"
    case domSingleImage = "Single Image"
    
    var id: String {
        self.rawValue
    }
    
    @ViewBuilder var view: some View {
        switch self {
        case .greenView:
            GreenView(title: self.rawValue)
        case .colorsStack:
            ColorsView(title: self.rawValue, colors: [.red, .teal, .indigo, . blue])
        case .domImage:
            DOMImageView(title: self.rawValue)
        case .domSingleImage:
            SingleImgView(title: self.rawValue)
        }
    }
}

fileprivate struct GreenView: View {
    let title: String
    var body: some View {
        Rectangle()
            .fill(Color.green.gradient)
            .ignoresSafeArea()
            .navigationTitle(title)
    }
}

fileprivate struct DOMImageView: View {
    let title: String
    var body: some View {
        Image("Damini")
            .resizable()
            .scaledToFit()
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle(title)
    }
}

fileprivate struct ColorsView: View {
    let title: String
    let colors: [Color]
    var body: some View {
        VStack {
            ForEach(colors, id: \.self) {
                Rectangle()
                    .fill($0)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle(title)
    }
}

fileprivate struct SingleImgView: View {
    let title: String
    var body: some View {
        Image("Quotation")
            .resizable()
            .scaledToFit()
            .padding()
            .shadow(radius: 5)
            .navigationTitle(title)
    }
}

struct EnumBasedNavigation: View {
    var body: some View {
        NavigationStack {
            VStack {
                ForEach(HomeNavigation.allCases) { navType in
                    NavigationLink(value: navType) {
                        Text(navType.rawValue)
                    }
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .navigationDestination(for: HomeNavigation.self) { navType in
                    navType.view
                };
            }
            .navigationTitle("Enum Navigation")
        }
    }
}

struct EnumBasedNavigation_Previews: PreviewProvider {
    static var previews: some View {
        EnumBasedNavigation()
    }
}
