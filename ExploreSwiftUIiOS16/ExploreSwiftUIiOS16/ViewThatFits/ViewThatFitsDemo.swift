//
//  ViewThatFitsDemo.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 15/01/23.
//

import SwiftUI

struct ViewThatFitsDemo: View {
    var body: some View {
        TabView {
            Example1()
                .tabItem {
                    Image(systemName: "1.circle.fill")
                    Text("Example1")
                }
            
            Example2()
                .tabItem {
                    Image(systemName: "2.circle.fill")
                    Text("Example2")
                }
            
            Example3()
                .tabItem {
                    Image(systemName: "3.circle.fill")
                    Text("Example3")
                }
            
            Example4()
                .tabItem {
                    Image(systemName: "4.circle.fill")
                    Text("Example4")
                }
        }
    }
}

fileprivate struct Example1: View {
    let startingValue = Int(("A" as UnicodeScalar).value)
    var body: some View {
        NavigationStack {
            ViewThatFits {
                HStack {
                    ForEach(0..<3, id:\.self) { i in
                        Rectangle()
                            .fill(Color.indigo)
                            .overlay {
                                Text(String([Character(UnicodeScalar(i + startingValue)!)]))
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                            }
                            .frame(width: 150, height: 150)
                    }
                }
                VStack {
                    ForEach(0..<3, id:\.self) { i in
                        Rectangle()
                            .fill(Color.indigo)
                            .overlay {
                                Text(String([Character(UnicodeScalar(i + startingValue)!)]))
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                            }
                            .frame(width: 150, height: 150)
                    }
                }
            }
            .navigationTitle("Example 1")
        }
    }
}

fileprivate struct Example2: View {
    let startingValue = Int(("A" as UnicodeScalar).value)
    @State private var numOfRectangles = 0
    var body: some View {
        NavigationStack {
            VStack {
                Text("HStack --> ScrollView ")
                    .font(.title)
                    .bold()
                
                Stepper("Rectangle \(numOfRectangles)", value: $numOfRectangles, in: 0...10)
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                
                Spacer()
                ViewThatFits {
                    HStack {
                        ForEach(0..<numOfRectangles, id:\.self) { i in
                            Rectangle()
                                .fill(Color.indigo)
                                .overlay {
                                    Text(String([Character(UnicodeScalar(i + startingValue)!)]))
                                        .foregroundColor(.white)
                                        .font(.largeTitle)
                                }
                                .frame(width: 150, height: 150)
                        }
                    }
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(0..<numOfRectangles, id:\.self) { i in
                                Rectangle()
                                    .fill(Color.red)
                                    .overlay {
                                        Text(String([Character(UnicodeScalar(i + startingValue)!)]))
                                            .foregroundColor(.white)
                                            .font(.largeTitle)
                                    }
                                    .frame(width: 150, height: 150)
                            }
                        }
                    }
                }
                
                
                Spacer()
            }
            .navigationTitle("Example 2")
        }
    }
}


fileprivate struct Example3: View {
    @State private var width: CGFloat = 300.0
    var body: some View {
        NavigationStack {
            VStack {
                Text("Avoid Truncating Text")
                    .font(.title)
                    .bold()
                
                Slider(value: $width, in: 60...300)
                    .padding()
                
                ViewThatFits {
                    Button("New Widget Kit") {}
                    Button("New") {}
                    Button {
                        
                    } label: {
                        Image(systemName: "plus.app.fill")
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .frame(width: width)
                .border(.primary)
                
                Spacer()
            }
            .tint(.teal)
            .navigationTitle("Example 3")
        }
    }
}


fileprivate struct Example4: View {
    let sampleText = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus iaculis pretium justo non accumsan. In at suscipit libero. Aenean luctus turpis vitae lectus tincidunt egestas. In mollis, ex vel facilisis blandit, sapien arcu luctus elit, at mattis elit ante id magna. Suspendisse leo purus, venenatis ac volutpat sodales, vulputate eget nulla. In hac habitasse platea dictumst. Nunc vitae tortor varius, aliquet lacus sit amet, congue urna.
    Phasellus mattis a nulla in mollis. Curabitur sed mi quis nibh tempus consectetur eget ut leo. Duis lobortis ex eget nulla laoreet, ut eleifend sem eleifend. Ut sed ante justo. Sed sit amet diam nulla. Cras semper dui quis justo gravida aliquam. Aliquam erat volutpat. Donec dictum accumsan nisi, in consequat odio euismod ut. Morbi pulvinar, purus at gravida molestie, erat felis commodo diam, nec malesuada justo nulla ut felis. Morbi hendrerit rutrum odio, eu lacinia ligula rutrum eu. Vivamus iaculis molestie dui, nec blandit urna imperdiet sit amet. In vitae tincidunt libero, eu condimentum ligula.
    """
    
    @State private var partialText = ""
    @State private var numChars = 0.0
    var body: some View {
        NavigationStack {
            VStack {
                Text("Expanding Text")
                    .font(.title)
                    .bold()
                
                Slider(value: $numChars, in: 0...Double(sampleText.count))
                
                ViewThatFits(in: .vertical) {
                    Text(partialText)
                    
                    Button("Show Full text") {
                        
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(width: 300, height: 200)
                .padding()
                .border(.red, width: 3)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Example 4")
            .onChange(of: numChars) { newValue in
                partialText = String(sampleText.prefix(Int(numChars)))
            }
        }
    }
}


struct ViewThatFitsDemo_Previews: PreviewProvider {
    static var previews: some View {
        ViewThatFitsDemo()
    }
}
