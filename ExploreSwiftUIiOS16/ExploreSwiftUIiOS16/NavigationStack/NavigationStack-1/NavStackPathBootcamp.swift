//
//  NavStackPathBootcamp.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 07/01/23.
//

import SwiftUI

fileprivate class ViewModel: ObservableObject {
    @Published var colors: [Color] = [
        .indigo,
        .green,
        .orange,
        .blue,
        .brown,
        .cyan,
        .gray
    ]
    @Published var path = [Color]()
    
    func navigateToSomeScreen() {
        path.append(contentsOf: [.green, .gray])
    }
    
    func navigateToRoot() {
        path = []
    }
}

struct NavStackPathBootcamp: View {
    
    @StateObject private var vm = ViewModel()
    
    var body: some View {
        NavigationStack(path: $vm.path) {
            List {
                ForEach(vm.colors, id: \.self) { color in
                    NavigationLink(value: color) {
                        Text(color.description.capitalized)
                    }
                }
            }
            .navigationDestination(for: Color.self) { color in
                VStack {
                    Text("\(vm.path.count), \(vm.path.description)")
                        .font(.headline)
                    HStack(spacing: 0) {
                        ForEach(vm.colors, id: \.self) { color in
                            color
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    List {
                        ForEach(vm.colors, id: \.self) { color in
                            NavigationLink(value: color) {
                                Text(color.description.capitalized)
                            }
                        }
                    }
                    .listStyle(.plain)
                    
                    Button {
                        vm.navigateToRoot()
                    } label: {
                        Text("Main Screen")
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
            }
            .onAppear {
                // Facing issue while navigating to root
                vm.navigateToSomeScreen()
            }
            .navigationTitle("Nav Path Bootcamp")
        }
    }
}

struct NavStackPathBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        NavStackPathBootcamp()
    }
}
