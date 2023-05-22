//
//  PhotosPickerBootcamp.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 08/01/23.
//

import SwiftUI
import Photos
import PhotosUI

struct PhotosPickerBootcamp: View {
    var body: some View {
        TabView {
            SinglePhotoSelection()
                .tabItem {
                    Image(systemName: "photo.fill")
                    Text("Single Selection")
                }
            
            MultiplePhotoSelection()
                .tabItem {
                    Image(systemName: "photo.fill.on.rectangle.fill")
                    Text("Single Selection")
                }
        }
        .navigationTitle("Photo Picker Demo")
    }
}

struct PhotosPickerBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        PhotosPickerBootcamp()
    }
}

fileprivate struct SinglePhotoSelection: View {
    
    @StateObject private var singleImagePicker = SingleImagePicker()
    
    var body: some View {
        NavigationStack {
            VStack {
                if let image = singleImagePicker.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("Please import a image to appear here.")
                }
            }
            .navigationTitle("Single Selection")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    PhotosPicker(selection: $singleImagePicker.singleImageSelection, matching: .images, photoLibrary: .shared()) {
                        Image(systemName: "photo")
                            .imageScale(.large)
                    }
                }
            }
        }
    }
}

fileprivate struct MultiplePhotoSelection: View {
    
    @StateObject private var multipleSelectionPicker = MultipleImagePicker()
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                if !multipleSelectionPicker.imagesData.isEmpty {
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(0..<$multipleSelectionPicker.imagesData.count, id: \.self) { imageIndex in
                                if let uiImage = UIImage(data: multipleSelectionPicker.imagesData[imageIndex]) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                }
                            }
                        }
                    }
                } else {
                    Text("Please import images to show here.")
                }
            }
            .navigationTitle("Multiple Selection")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    PhotosPicker(selection: $multipleSelectionPicker.multipleImageSelection, matching: .images, photoLibrary: .shared()) {
                        Image(systemName: "photo")
                            .imageScale(.large)
                    }
                }
            }
        }
    }
}

fileprivate class SingleImagePicker: ObservableObject {
    
    @Published var image: Image?
    
    @Published var singleImageSelection: PhotosPickerItem? {
        didSet {
            if let singleImageSelection {
                Task {
                    try await loadTransferrable(from: singleImageSelection)
                }
            }
        }
    }
    
    func loadTransferrable(from selection: PhotosPickerItem) async throws {
        do {
            if let data = try await selection.loadTransferable(type: Data.self) {
                if let uiimage = UIImage(data: data) {
                    let image = Image(uiImage: uiimage)
                    await MainActor.run {
                        self.image = image
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
            self.image = nil
        }
    }
}

fileprivate class MultipleImagePicker: ObservableObject {
    @Published var imagesData: [Data] = []
    
    @Published var multipleImageSelection: [PhotosPickerItem] = [] {
        didSet {
            Task {
                if !multipleImageSelection.isEmpty {
                    try await loadTransferrable(from: multipleImageSelection)
                    await MainActor.run {
                        multipleImageSelection = []
                    }
                }
            }
        }
    }
    
    
    func loadTransferrable(from selections: [PhotosPickerItem]) async throws {
        do {
            for selection in selections {
                if let data = try await selection.loadTransferable(type: Data.self) {
                    await MainActor.run {
                        self.imagesData.append(data)
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
