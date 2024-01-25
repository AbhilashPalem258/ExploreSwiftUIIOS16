//
//  ExploreSwiftUIiOS16App.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 07/01/23.
//

import SwiftUI

@main
struct ExploreSwiftUIiOS16App: App {
    var body: some Scene {
        WindowGroup {
            if #available(iOS 17.0, *) {
                ObservationBootcampObjc()
            } else {
                AnyLayoutBasic()
            }
        }
    }
}
