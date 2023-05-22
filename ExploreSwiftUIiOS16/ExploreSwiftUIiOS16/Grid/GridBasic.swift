//
//  GridBasic.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 08/01/23.
//

import SwiftUI

struct GridBasic: View {
    var body: some View {
        Grid {
            
            Text("SwiftUI 4 Grid Introduction")
                .font(.title2)
                .bold()
            
            GridRow {
                Rect()
                    .gridCellColumns(2)
                Rect()
                    .gridCellColumns(1)
            }
            GridRow {
                Rect()
                Rect()
                    .gridCellColumns(2)
            }
            GridRow {
                Rect()
                    .gridCellColumns(2)
                Rect()
            }
        }
        .padding()
    }
}

struct Rect: View {
    var body: some View {
        Rectangle()
            .fill(Color.indigo)
    }
}

struct GridBasic_Previews: PreviewProvider {
    static var previews: some View {
        GridBasic()
    }
}
