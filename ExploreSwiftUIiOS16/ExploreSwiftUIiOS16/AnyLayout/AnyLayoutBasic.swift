//
//  AnyLayoutBasic.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 11/01/23.
//

import SwiftUI

/*
 link: https://www.youtube.com/watch?v=WD7ebJZ7PaI&list=PLBn01m5Vbs4DJyxwFZEM4-AIs7jzHrb60&index=16
 */

struct MyColor {
    let color: Color
    let width: CGFloat
    let height: CGFloat
    
    static var all: [MyColor] = [
        .init(color: .red, width: 60, height: 75),
        .init(color: .teal, width: 100, height: 100),
        .init(color: .purple, width: 40, height: 80),
        .init(color: .indigo, width: 120, height: 100),
    ]
}

struct AnyLayoutBasic: View {
    
//    @State private var changeLayout = false
    @State private var layoutType = LayoutType.zStack
    
    var body: some View {
//        let layout: AnyLayout = changeLayout ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())
        let layout: AnyLayout = AnyLayout(layoutType.layout)
        NavigationStack {
            layout {
                ForEach(MyColor.all, id: \.color) { currentColor in
                    currentColor.color
                        .frame(width: currentColor.width, height: currentColor.height)
                        .cornerRadius(10)
                }
            }
            .background(.brown)
//            .animation(.default, value: changeLayout)
            .animation(.default, value: layoutType)
            .navigationTitle("AnyLayout")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
//                        withAnimation {
//                            changeLayout.toggle()
//                        }
                        var nextIndex = layoutType.rawValue
                        if layoutType.rawValue == LayoutType.endIndex {
                            nextIndex = 0
                        } else {
                            nextIndex += 1
                        }
                        withAnimation {
                            layoutType = LayoutType(rawValue: nextIndex)!
                        }
                    } label: {
                        Image(systemName: "circle.grid.3x3.circle.fill")
                            .imageScale(.large)
                    }
                }
            }
        }
    }
}

fileprivate enum LayoutType: Int, CaseIterable {
    case zStack = 0, hStack, vStack, aStack
    
    static let endIndex = 3
    
    var layout: any Layout {
        switch self {
        case .hStack:
            return HStackLayout(alignment: .top, spacing: 0)
        case .vStack:
            return VStackLayout()
        case .zStack:
            return ZStackLayout()
        case .aStack:
            return AlternateLayout()
        }
    }
}

fileprivate struct AlternateLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard !subviews.isEmpty else {
            return .zero
        }
        
        var evenMaxWidth: CGFloat = 0
        var oddMaxWidth: CGFloat = 0
        var totalHeight: CGFloat = 0
        
        for (index, subview) in subviews.enumerated(){
            let subviewSize = subview.sizeThatFits(.unspecified)
            
            if index % 2 == 0 {
                evenMaxWidth = max(evenMaxWidth, subviewSize.width)
            } else {
                oddMaxWidth = max(oddMaxWidth, subviewSize.width)
            }
            
            totalHeight += subviewSize.height
        }
        return CGSize(width: evenMaxWidth + oddMaxWidth, height: totalHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        
        var evenMaxWidth: CGFloat = 0
        
        for (index, subview) in subviews.enumerated(){
            let subviewSize = subview.sizeThatFits(.unspecified)
            
            if index % 2 == 0 {
                evenMaxWidth = max(evenMaxWidth, subviewSize.width)
            }
        }
        
        let evenX = bounds.minX
        let oddX = bounds.minX + evenMaxWidth
        var y = bounds.minY
        
        for (index, subview) in subviews.enumerated() {
            let subviewSize = subview.sizeThatFits(.unspecified)
            let proposedSize = ProposedViewSize(width: subviewSize.width, height: subviewSize.height)
            if index % 2 == 0 {
                subview.place(at: .init(x: evenX, y: y), proposal: proposedSize)
            } else {
                subview.place(at: .init(x: oddX, y: y), proposal: proposedSize)
            }
            
            y += subviewSize.height
        }
    }
    
    func explicitAlignment(of guide: HorizontalAlignment, in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGFloat? {
        if guide == .leading {
            return bounds.minX + 30
        }
        return nil
    }
    
    func explicitAlignment(of guide: VerticalAlignment, in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGFloat? {
        if guide == .bottom {
            return bounds.minY + 30
        }
        return nil
    }
    
    func spacing(subviews: Subviews, cache: inout ()) -> ViewSpacing {
        ViewSpacing()
    }
}

struct AnyLayoutBasic_Previews: PreviewProvider {
    static var previews: some View {
        AnyLayoutBasic()
    }
}
