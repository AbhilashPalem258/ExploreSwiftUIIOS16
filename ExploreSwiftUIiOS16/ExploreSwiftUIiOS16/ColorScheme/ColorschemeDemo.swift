//
//  ColorschemeDemo.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 16/01/23.
//

import SwiftUI

/*
 link:
 Stewart Lynch : https://www.youtube.com/watch?v=PbryeZmJRmA
 
 Definition:
 
 Notes:
 
 */

fileprivate enum ColorAppearance: Int, Identifiable, Hashable, CaseIterable {
    
    var id: Int {
        self.rawValue
    }
    
    case unspecified = 0
    case light
    case dark
    
    var label: String {
        switch self {
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        case .unspecified:
            return "System"
        }
    }
}

import UIKit
fileprivate class ABColorSchemeManager: ObservableObject {
    
    @AppStorage("ABColorScheme") var colorAppearance = ColorAppearance.unspecified {
        didSet {
            applyColorScheme()
        }
    }

    func applyColorScheme() {
        window?.overrideUserInterfaceStyle = UIUserInterfaceStyle(rawValue: colorAppearance.rawValue)!
    }
    
    private var window: UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let sceneDelegate = scene.delegate as? UIWindowSceneDelegate,
              let keyWindow = sceneDelegate.window else {
            return nil
        }
        return keyWindow
    }
}

struct ColorschemeDemo: View {
    @StateObject private var schemeManager = ABColorSchemeManager()
    @State private var showModal = false
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Select Color Scheme", selection: $schemeManager.colorAppearance) {
                    ForEach(ColorAppearance.allCases) { appearance in
                        Text(appearance.label)
                            .tag(appearance)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Spacer()
                Text("Color Scheme: \(String(describing: colorScheme))")
                Button {
                    showModal.toggle()
                } label: {
                    Text("Show Modal")
                }
                .bold()
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
                NavigationLink {
                    Text("Navigation Stack")
                        .font(.largeTitle)
                        .bold()
                } label: {
                    Text("Go Next")
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                Spacer()
            }
            .padding()
            .sheet(isPresented: $showModal) {
                ModalScreen()
            }
            .navigationTitle("Color Scheme")
        }
    }
}

fileprivate struct ModalScreen: View {
    var body: some View {
        Text("Modal Screen")
    }
}
struct ColorschemeDemo_Previews: PreviewProvider {
    static var previews: some View {
        ColorschemeDemo()
    }
}
