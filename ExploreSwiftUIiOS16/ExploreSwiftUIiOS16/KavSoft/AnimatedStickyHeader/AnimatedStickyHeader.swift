//
//  AnimatedStickyHeader.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 20/02/23.
//

import SwiftUI

fileprivate enum ProductCategory: String, CaseIterable {
    case fruits = "Fruits"
    case vegetables = "Vegetables"
    case phones = "Phones"
    case clothing = "Clothing"
    
    var tabID: Int {
        switch self {
        case .fruits:
            return 0
        case .vegetables:
            return 1
        case .phones:
            return 2
        case .clothing:
            return 3
        }
    }
}

fileprivate struct Product: Identifiable, Hashable {
    let id = UUID()
    let type: ProductCategory
    let title: String
    let subtitle: String
    let price: String
    let systemIcon: String
}

fileprivate extension [Product] {
    var type: ProductCategory {
        self.first?.type ?? .fruits
    }
}

fileprivate class ViewModel: ObservableObject {
    let products: [Product] = [
        .init(type: .fruits, title: "Apple", subtitle: "Organic Apple", price: "120 / kg", systemIcon: "apple.logo"),
        .init(type: .fruits, title: "Orange", subtitle: "Kashmiri Orange", price: "130 / kg", systemIcon: "apple.logo"),
        .init(type: .fruits, title: "Kiwi", subtitle: "Kiwi Description", price: "150 / kg", systemIcon: "apple.logo"),
        .init(type: .fruits, title: "Papaya", subtitle: "Papaya Description", price: "100 / kg", systemIcon: "apple.logo"),
        .init(type: .vegetables, title: "Spinach", subtitle: "Spinach description", price: "30 / kg", systemIcon: "carrot.fill"),
        .init(type: .vegetables, title: "Cucumber", subtitle: "Cucumber description", price: "130 / kg", systemIcon: "carrot.fill"),
        .init(type: .vegetables, title: "Cauliflower", subtitle: "Cauliflower description", price: "150 / kg", systemIcon: "carrot.fill"),
        .init(type: .vegetables, title: "Beans", subtitle: "Beans description", price: "100 / kg", systemIcon: "carrot.fill"),
        .init(type: .phones, title: "iPhone 12 mini", subtitle: "iPhone 12 mini description", price: "30k", systemIcon: "iphone.gen1"),
        .init(type: .phones, title: "iPhone 12", subtitle: "iPhone 12 description", price: "25k", systemIcon: "iphone.gen1"),
        .init(type: .phones, title: "iPhone 13", subtitle: "iPhone 13 description", price: "75k", systemIcon: "iphone.gen1"),
        .init(type: .phones, title: "iPhone 13 pro max", subtitle: "iPhone 13 Pro max description", price: "310k", systemIcon: "iphone.gen1"),
        .init(type: .clothing, title: "Men's Short", subtitle: "Men's short description", price: "500", systemIcon: "figure.dress.line.vertical.figure"),
        .init(type: .clothing, title: "Men's Shirt", subtitle: "Men's Shirt description", price: "1500", systemIcon: "figure.dress.line.vertical.figure"),
        .init(type: .clothing, title: "Men's Jeans", subtitle: "Men's Jeans description", price: "2500", systemIcon: "figure.dress.line.vertical.figure"),
        .init(type: .clothing, title: "Men's Casual wear", subtitle: "Men's Jeans description", price: "2800", systemIcon: "figure.dress.line.vertical.figure")
    ]
    
    lazy var productsByCategoryType: [[Product]] = {
        var productsByCategory = [[Product]]()
        ProductCategory.allCases.forEach { category in
            let products = products.filter{$0.type == category}
            productsByCategory.append(products)
        }
        return productsByCategory
    }()
}

struct AnimatedStickyHeader: View {
    
    let colors = [Color.red, Color.cyan, Color.indigo, Color.mint]
    
    @StateObject private var vm = ViewModel()
    
    @State private var selectedCategory: ProductCategory = .fruits
    @State private var productsByCategoryType = [[Product]]()
    @Namespace private var namespace
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollProxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                        Section {
                            ForEach(vm.productsByCategoryType, id: \.self) { products in
                                productSectionview(products: products)
                            }
                        } header: {
                            scrollableTabs(scrollProxy)
                        }
                    }
                }
                .background {
                    Color.gray.opacity(0.2)
                }
            }
            .navigationTitle("Shopping List")
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.indigo, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .ignoresSafeArea(edges: [.bottom])
        }
        .preferredColorScheme(.light)
    }
    
    private func productSectionview(products: [Product]) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            if let firstItem = products.first {
                Text(firstItem.type.rawValue)
                    .font(.title)
                    .fontWeight(.semibold)
            }
            
            ForEach(products) { product in
                productRowView(product)
            }
        }
        .padding(10)
        .id(products.type)
        .offset("CONTENT_VIEW") { rect in
            let minY = rect.minY

            if minY < 30 && -minY < (rect.midY / 2) && selectedCategory != products.type {
                withAnimation(.easeInOut(duration: 0.3)) {
                    selectedCategory = products.type
                }
            }
        }
    }
    
    private func productRowView(_ product: Product) -> some View {
        HStack(spacing: 15) {
            Image(systemName: product.systemIcon)
                .resizable()
                .scaledToFit()
                .symbolRenderingMode(.multicolor)
                .foregroundColor(colors.randomElement())
                .frame(width: 100, height: 100)
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white)
                }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product.title)
                    .font(.title3)
                
                Text(product.subtitle)
                    .font(.callout)
                    .foregroundColor(.gray)
                
                Text(product.price)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.indigo)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func scrollableTabs(_ proxy: ScrollViewProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(ProductCategory.allCases, id: \.rawValue) { type in
                    Text(type.rawValue)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .background(alignment: .bottom) {
                            if selectedCategory == type {
                                Capsule()
                                    .fill(.white)
                                    .frame(height: 5)
                                    .padding(.horizontal, -5)
                                    .offset(y: 15)
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: namespace)
                            }
                        }
                        .padding(.horizontal, 15)
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                selectedCategory = type
                                DispatchQueue.main.async {
                                    proxy.scrollTo(type, anchor: .center)
                                }
                            }
                        }
                        .id(type.tabID)
                }
            }
            .padding(.vertical, 15)
            .onChange(of: selectedCategory) { newValue in
                withAnimation(.easeInOut(duration: 0.3)) {
                    proxy.scrollTo(newValue.tabID, anchor: .center)
                }
            }
        }
        .background {
            Rectangle()
                .fill(Color.indigo)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 0)
        }
    }
}

struct AnimatedStickyHeader_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedStickyHeader()
    }
}

fileprivate extension View {
    func offset(_ coordinateSpace: String, completion: @escaping (CGRect) -> Void) -> some View {
        self.overlay {
            GeometryReader { proxy in
                let rect = proxy.frame(in: .named(coordinateSpace))
                
                Color.clear
                    .preference(key: OffsetX.self, value: rect)
                    .onPreferenceChange(OffsetX.self, perform: completion)
            }
        }
    }
}

fileprivate struct OffsetX: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
