//
//  EnvVariablesBootcamp.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 16/01/23.
//

import SwiftUI

struct EnvVariablesBootcamp: View {
    
    @State private var showModal = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.layoutDirection) private var layoutDirection
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.locale) private var locale
    @Environment(\.calendar) private var calendar
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Color Scheme: \(String(describing: colorScheme))")
                Text("Horizontal Size class: \(String(describing: horizontalSizeClass))")
                Text("Layout Direction: \(String(describing: layoutDirection))")
                Text("Locale : \(String(describing: locale))")
                Text("First Day Of Week: \(String(describing: calendar.firstWeekday))")
                
                let layout: AnyLayout = horizontalSizeClass == .regular ? AnyLayout(HStackLayout()) :  AnyLayout(VStackLayout())
                layout {
                    ColoredRectangle(color: .gray)
                    ColoredRectangle(color: .gray)
                }
            }
            .padding(.leading)
            .bold()
            .navigationTitle("Environment variables")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        showModal.toggle()
                    } label: {
                        Text("Show Modal")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .sheet(isPresented: $showModal) {
                ModalScreen()
                    .preferredColorScheme(colorScheme == .light ? .dark : .light)
//                    .environment(\.colorScheme, colorScheme == .light ? .dark : .light)
            }
        }
    }
}

fileprivate struct ModalScreen: View {
//    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.dismiss) private var dismiss
    @Environment(\.sizeCategory) private var sizeCategory
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack {
                    Text("This is some text").font(.title)
                    Text("Current size is large")
                    Text("""
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse sodales dictum arcu eget iaculis. Donec neque arcu, vulputate a scelerisque a, semper laoreet tortor. Vestibulum tincidunt gravida congue. Proin ut eros odio. Maecenas maximus vel enim et dictum. Donec dictum pharetra nisl a placerat. In sollicitudin urna quis dolor pharetra, vel tincidunt magna consequat. Aliquam scelerisque eros enim, in imperdiet ligula pellentesque ut. Morbi leo odio, fermentum vel libero vel, auctor semper libero. Mauris semper dui felis, sed vulputate est aliquet a. Fusce tincidunt, nisl convallis semper egestas, ipsum ex tempus odio, eu dapibus ipsum orci ut elit.
                    """)
                }
                .padding()
                HStack(spacing: 20.0) {
                    Button {
                        
                    } label: {
                        Image(systemName: "minus.magnifyingglass")
                            .padding(5)
                            .background(Color.accentColor)
                            .foregroundColor(Color(uiColor: UIColor.systemBackground))
                            .cornerRadius(8)
                    }
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "plus.magnifyingglass")
                            .padding(5)
                            .background(Color.accentColor)
                            .foregroundColor(Color(uiColor: UIColor.systemBackground))
                            .cornerRadius(8)
                    }
                }
            }
            .navigationTitle("Modal Screen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "cross.circle.fill")
                    }
                }
            }
        }
    }
}

fileprivate struct ColoredRectangle: View {
    let color: Color
    var body: some View {
        Rectangle()
            .fill(color)
            .padding()
    }
}

struct EnvVariablesBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        EnvVariablesBootcamp()
    }
}
