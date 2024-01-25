//
//  InstagramProfileStickyHeader.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 06/09/23.
//

import SwiftUI

fileprivate enum Tab: CaseIterable {
    case album
    case reel
    case tag
    
    var icon: String {
        switch self {
        case .album:
            return "square.grid.3x3"
        case .reel:
            return "video.square.fill"
        case .tag:
            return "person.crop.square"
        }
    }
}

struct InstagramProfileStickyHeader: View {
    
    @State private var selectedTab: Tab = .album
    @Namespace private var tabSelection
    @Environment(\.colorScheme) private var colorScheme
    
    private var navBar: some View {
        HStack(spacing: 15) {
            Button {
                
            } label: {
                Text("abhilash_palem")
                    .font(.title2.bold())
            }
            
            Spacer(minLength: 0)
            
            Button {
                
            } label: {
                Image(systemName: "plus.app")
                    .font(.title)
            }
            
            Button {
                
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.title)
            }
        }
        .tint(.primary)
        .padding([.top, .horizontal])

    }
    
    private var topRow: some View {
        HStack {
            Button {
                
            } label: {
                Text("A")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(30)
                    .background(Circle().fill(.purple))
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: "plus")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Circle().fill(.blue))
                            .padding(2)
                            .background(Circle().fill(.white))
                            .offset(x: 5, y: -2)
                    }
            }
            
            ForEach([["299", "Posts"], ["1,139", "Followers"], ["13", "Following"]], id: \.self) { item in
                VStack {
                    Text(item[0])
                        .font(.title2.bold())
                    
                    Text(item[1])
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var introView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Abhilash. iOS & SwiftUi Dev")
                .fontWeight(.bold)
            
            Text("SSE-iOS")
                .fontWeight(.semibold)
                .foregroundColor(.secondary)

            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
            
            Link("www.google.com", destination: URL(string: "https://www.google.com/")!)
        }
        
    }
    
    private var profileOptionsView: some View {
        HStack(spacing: 10) {
            ForEach(["Edit Profile", "Promotions"], id: \.self) { option in
                Text(option)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(4)
                    .background(Rectangle().stroke(.primary.opacity(0.4), lineWidth: 2))
            }
        }
    }
    
    private var storiesView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Button {
                    
                } label: {
                    VStack(spacing: 15) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.primary)
                            .padding(18)
                            .background(Circle().stroke(.primary))
                        
                        Text("New")
                    }
                    .tint(.primary)
                }
            }
            .padding([.horizontal, .top])
        }
    }
    
    private func tabItem(_ tab: Tab) -> some View {
        Button {
            withAnimation(.easeInOut) {
                selectedTab = tab
            }
        } label: {
            VStack {
                Image(systemName: tab.icon)
                    .font(.title)
            }
            .foregroundColor(selectedTab == tab ? .primary : .gray)
            .padding(.top, 15)
            .padding(.bottom, 10)
            .contentShape(Rectangle())
            .frame(maxWidth: .infinity)
            .overlay(alignment: .bottom) {
                if selectedTab == tab {
                    RoundedRectangle(cornerRadius: 2.0)
                        .foregroundColor(.primary)
                        .frame(height: 3)
                        .offset(y: 2)
                        .matchedGeometryEffect(id: "selectedTab", in: tabSelection)
                }
            }
        }
    }
    
    private var tabs: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { tab in
                tabItem(tab)
            }
        }
        .background(colorScheme == .dark ? .black : .white)
    }
    
    @ViewBuilder
    private var tabContentView: some View {
        switch selectedTab {
        case .album:
            albumView
        case .reel:
            Text("Reels")
        case .tag:
            Text("Tag")
        }
    }
    
    @ViewBuilder
    private var albumView: some View {
        let columns: [GridItem] = [GridItem(.flexible(), spacing: 4), GridItem(.flexible(), spacing: 4), GridItem(.flexible(), spacing: 4)]
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(1..<30) { _ in
                let size = UIScreen.main.bounds.width/3 - 4
                
                AsyncImage(url: URL(string: "https://picsum.photos/100/100")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: size, height: size)
                            .cornerRadius(0)
                    case .failure:
                        Image(systemName: "photo.artframe")
                            .resizable()
                            .scaledToFit()
                            .frame(width: size, height: size)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
    }
    
    private var photos: some View {
        tabContentView
    }
    
    private var content: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(pinnedViews: .sectionHeaders) {
                Divider()
                Group {
                    topRow
                    introView
                    profileOptionsView
                }
                .padding(.horizontal)
                storiesView
                
                Section {
                    photos
                } header: {
                    tabs
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            navBar
            content
        }
    }
}

struct InstagramProfileStickyHeader_Previews: PreviewProvider {
    static var previews: some View {
        InstagramProfileStickyHeader()
    }
}
