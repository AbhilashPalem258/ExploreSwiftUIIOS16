//
//  EmailAdaptiveDesign.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 26/02/23.
//

import SwiftUI

struct EmailAdaptiveDesign: View {
    var body: some View {
        ResponsiveView { props in
            HStack(spacing: 0) {
//                if props.isLandscape {
                SideBarView(props: props)
//                } else {
//
//                }
            }
        }
        .preferredColorScheme(.light)
    }
}

fileprivate struct ResponsiveView<Content: View>: View {
    var content: (Properties) -> Content
    var body: some View {
        GeometryReader {
            let size = $0.size
            let isLandscape = size.width > size.height
            let isPad = UIDevice.current.userInterfaceIdiom == .pad
            
            content(.init(size: size, isLandscape: isLandscape, isPad: isPad))
                .frame(width: size.width, height: size.height, alignment: .center)
        }
    }
}

fileprivate struct SideBarView: View {
    let props: Properties
    @State private var selectedTab = Tab.inbox
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                Image("gmail")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45)
                    .padding(.bottom, 20)
                
                ForEach(Tab.allCases, id: \.self) { tab in
                    SideBarItem(tab: tab)
                }
            }
            .padding()
        }
        .frame(width: props.size.width / 2.5 > 300 ? 300 : props.size.width / 2.5)
        .background {
            Color("LightWhite")
                .ignoresSafeArea()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func SideBarItem(tab: Tab) -> some View {
        Button {
            withAnimation(.easeInOut) {
                selectedTab = tab
            }
        } label: {
            VStack {
                HStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                    .opacity(selectedTab == tab ? 1.0 : 0.0)
                    
                    Image(systemName: tab.icon)
                        .font(.callout)
                        .foregroundColor(tab == selectedTab ? .blue : .gray)
                    
                    Text(tab.rawValue.capitalized)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(tab == selectedTab ? .black : .gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
            }
        }
    }
}

fileprivate enum Tab: String, CaseIterable {
    case inbox
    case sent
    case draft
    case deleted
    
    var icon: String {
        switch self {
        case .inbox:
            return "tray.and.arrow.down.fill"
        case .sent:
            return "paperplane"
        case .draft:
            return "newspaper"
        case .deleted:
            return "trash"
        }
    }
}

fileprivate struct Properties {
    let size: CGSize
    let isLandscape: Bool
    let isPad: Bool
}

struct EmailAdaptiveDesign_Previews: PreviewProvider {
    static var previews: some View {
        EmailAdaptiveDesign()
    }
}
