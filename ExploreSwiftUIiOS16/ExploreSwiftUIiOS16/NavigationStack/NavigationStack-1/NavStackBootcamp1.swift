//
//  NavStackBootcamp1.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 07/01/23.
//

import SwiftUI

/*
 Links:
 - https://www.youtube.com/watch?v=6-OeaFfDXXw&list=PLBn01m5Vbs4DJyxwFZEM4-AIs7jzHrb60&index=7
 
 Definition:
 - NavigationStack
 - NavigationLink
 - .navigationdestination
 - NavigationPath()
 
 Notes:
 - issue with NavigationView is there is no proper way to configure Button with Navigationlink
 - Workaround:
    NavigationLink(destination: ChooseFruitView(fruit: fruits[7]), isActive: $isPreferredTapped) {
                     EmptyView()
     }
 - One more issue with NavigationView is that we have specifically code navigation style as stack
 
 */
struct NavStackBootcamp1: View {
    var body: some View {
        TabView {
            IntroView()
                .tabItem {
                    Label("Introduction", systemImage: "1.circle.fill")
                }
            Intro2View()
                .tabItem {
                    Label("Navigationlinks", systemImage: "2.circle.fill")
                }
        }
        .accentColor(.orange)
    }
}

struct NavStackBootcamp1_Previews: PreviewProvider {
    static var previews: some View {
        NavStackBootcamp1()
    }
}


fileprivate struct IntroView: View {
    
    @State private var fruits: [String] = [
        "🍌", "🍎", "🍉", "🍊", "🥭", "🍇", "🫐", "🥥"
    ]
    
    @State private var isPreferredTapped: Bool = false
    
    
    var usingNavView: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(fruits, id: \.self) { fruit in
                        NavigationLink {
                            ChooseFruitView(fruit: fruit)
                        } label: {
                            Text("I choose \(fruit)")
                                .foregroundColor(.black)
                                .font(.headline)
                        }
                    }
                }
                NavigationLink(destination: ChooseFruitView(fruit: fruits[7]), isActive: $isPreferredTapped) {
                    EmptyView()
                }
                
                Button {
                    isPreferredTapped.toggle()
                } label: {
                    Text("Tap to show preferred")
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.bottom)
            }
            .navigationTitle("Fruit of the day")
        }
    }
    
    var usingNavStack: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(fruits, id:\.self) { fruit in
                        NavigationLink("I choose \(fruit)", value: fruit)
                    }
                }
                
                HStack {
                    NavigationLink("Tap to show preferred fruit", value: fruits[7])
                    NavigationLink("Others") {
                        ChooseFruitView(fruit: "Others")
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .navigationDestination(for: String.self) {fruit in
                ChooseFruitView(fruit: fruit)
            }
        }
    }
    
    var body: some View {
        usingNavStack
    }
}

fileprivate struct Intro2View: View {
    var body: some View {
        Text("Intro2View")
    }
}

fileprivate struct ChooseFruitView: View {
    let fruit: String
    var body: some View {
        Text("You Choose" + fruit)
            .font(.system(size: 30, weight: .bold, design: .rounded))
    }
}
