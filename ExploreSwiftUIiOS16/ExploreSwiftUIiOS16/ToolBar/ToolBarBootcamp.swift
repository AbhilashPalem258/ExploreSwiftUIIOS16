//
//  ToolBarBootcamp.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 23/01/23.
//

import Combine
import SwiftUI

/*
 Links:
 - https://www.youtube.com/watch?v=Gw2IU_Sm2cg&list=PLBn01m5Vbs4C8jeAmLZxk9kZ59lYtxnHW&index=32
 https://www.hackingwithswift.com/books/ios-swiftui/manually-publishing-observableobject-changes
 https://www.hackingwithswift.com/quick-start/swiftui/how-to-send-state-updates-manually-using-objectwillchange
 Definition:
 
 Notes:
 */

fileprivate struct Fruit: Identifiable {
    var id = UUID()
    let name: String
    let emoji: String

    static let fruit = [
        Fruit.init(name: "Apple", emoji: "🍎"),
        Fruit.init(name: "Orange", emoji: "🟠"),
        Fruit.init(name: "Lemon", emoji: "🍋"),
        Fruit.init(name: "Kiwi", emoji: "🥝"),
        Fruit.init(name: "Banana", emoji: "🍌"),
        Fruit.init(name: "Pear", emoji: "🍐"),
        Fruit.init(name: "Cherry", emoji: "🍒")
    ]
}


fileprivate class ViewModel: ObservableObject {
    @Published var isAscending: Bool = false
    @Published var fruits: [Fruit] = Fruit.fruit
    
    fileprivate var cancellables = Set<AnyCancellable>()
    
    init() {
        self.$isAscending.sink { isAscending in
            self.fruits.sort {
                if isAscending {
                    return $0.name < $1.name
                } else {
                    return $0.name > $1.name
                }
            }
        }
        .store(in: &cancellables)
    }
    
    func addFruit(name: String, emoji: String) {
        let new = Fruit(name: name, emoji: emoji)
        self.fruits.append(new)
    }
}

struct ToolBarBootcamp: View {
    
    @StateObject private var vm = ViewModel()
    @State private var isAdding = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                List {
                    ForEach(vm.fruits) { fruit in
                        Text(fruit.emoji + " " + fruit.name)
                    }
                }
                .navigationTitle("Fruits")
                .toolbar {
                    
                    // in case of using placement as .pricipal, it override default nav title
                    ToolbarItem(placement: .principal) {
                        Text("Fruits")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.red)
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            vm.isAscending.toggle()
                        } label: {
                            Image(systemName: "arrow.up.arrow.down.circle.fill")
                                .font(.title2)
                                .foregroundColor(.red)
                        }
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isAdding.toggle()
                        } label: {
                            Image(systemName: "plus.app.fill")
                                .font(.title2)
                                .foregroundColor(.red)
                        }
                    }
                }
//                .toolbar(.hidden, for: .navigationBar)
//                .toolbarBackground(.hidden, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.black.opacity(0.4))
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbarTitleMenu {
                    Button {
                        
                    } label: {
                        Text("Item #1")
                    }
                    
                    Button {
                        
                    } label: {
                        Text("Item #2")
                    }
                    
                    Button {
                        
                    } label: {
                        Text("Item #3")
                    }
                }
            }
            .blur(radius: isAdding ? 10 : 0)
            if isAdding {
                NewFruitView(vm: vm, isAdding: $isAdding)
            }
        }
    }
}

fileprivate struct NewFruitView: View {
    
    @ObservedObject var vm: ViewModel
    @Binding var isAdding: Bool
    
    @State private var name: String = ""
    @State private var emoji: String = ""
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.1)
            VStack {
                Spacer()
                    .frame(height: 100)
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 10.0)
                    .frame(width: 300, height: 200)
                    .overlay {
                        VStack(alignment: .leading) {
                            TextField("Add Fruit Name", text: $name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Emoji", text: $emoji)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
//                                .frame(width: 75)
                            Text("Add a new fruit")
                                .foregroundColor(.gray)
                            Spacer()
                            HStack {
                                Button {
                                    withAnimation {
                                        isAdding.toggle()
                                    }
                                } label: {
                                    Text("Cancel")
                                }
                                
                                Spacer()
                                
                                Button {
                                    withAnimation {
                                        isAdding.toggle()
                                        vm.addFruit(name: name, emoji: emoji)
                                    }
                                } label: {
                                    Text("Add")
                                }
                                .disabled(name.isEmpty || emoji.isEmpty)
                            }
                            .bold()
                            .tint(.red)
                            .buttonStyle(.borderedProminent)
//                            .buttonStyle(.borderless)
                        }
                        .padding()
                    }
                Spacer()
            }
        }
    }
}

struct ToolBarBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ToolBarBootcamp()
    }
}
