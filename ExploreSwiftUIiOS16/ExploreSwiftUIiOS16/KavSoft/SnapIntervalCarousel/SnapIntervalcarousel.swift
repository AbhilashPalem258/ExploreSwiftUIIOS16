//
//  SnapIntervalcarousel.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 20/02/23.
//

import Combine
import SwiftUI

/*
 Links:
 https://www.youtube.com/watch?v=ZiDVbDlHDF0
 
 Definition:
 
 Notes:
 */


fileprivate struct DataManager {
    
    let urls = [
        "https://picsum.photos/300/300",
        "https://picsum.photos/300/300",
        "https://picsum.photos/300/300",
        "https://picsum.photos/300/300",
        "https://picsum.photos/300/300",
        "https://picsum.photos/300/300",
        "https://picsum.photos/300/300",
        "https://picsum.photos/300/300"
    ]
    
    func fetchGalleryImages() async throws -> [UIImage] {
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            
            var result = [UIImage]()
            
            for url in urls {
                group.addTask {
                    try? await fetchImage(url)
                }
            }
            
            for try await image in group {
                if let image {
                    result.append(image)
                }
            }
            
            return result
        }
    }
    
    func fetchImage(_ url: String) async throws -> UIImage {
        let url = URL(string: url)!
        do {
           let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data), let thumbnail = await image.byPreparingThumbnail(ofSize: .init(width: 300, height: 300)) {
                return thumbnail
           }
            throw URLError(.badURL)
        } catch {
            throw error
        }
    }
}

fileprivate class ViewModel: ObservableObject {
    @Published var images = [UIImage]()
    @Published var selectedIndex: Int = 0
    @Published var preview: UIImage?
    
    private var cancellables = Set<AnyCancellable>()
    private let dataManager = DataManager()
    
    init() {
        self.$selectedIndex.sink { newIndex in
            if newIndex >= self.images.startIndex && newIndex < self.images.endIndex {
                let image = self.images[newIndex]
                self.preview = image
            }
        }
        .store(in: &cancellables)
    }
    
    func fetchGalleryImages() async {
        let images = try? await dataManager.fetchGalleryImages()
        if let images {
            await MainActor.run {
                self.preview = images.first
                self.images = images
            }
        }
    }
}

struct SnapIntervalcarousel: View {
    
    @StateObject private var vm = ViewModel()
    @State private var selectedIndex = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Text("Gallery")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
                    .overlay(alignment: .trailing) {
                        Button {
                            
                        } label: {
                            Image(systemName: "ellipsis.circle.fill")
                                .font(.title2)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                
                GeometryReader {
                    let size = $0.size
                    
                    if let preview = vm.preview {
                        Image(uiImage: preview)
                            .resizable()
                            .scaledToFit()
                            .frame(width: size.width, height: size.height)
                            .clipped()
                            .animation(.easeInOut(duration: 0.5), value: vm.preview)
                    }
                }
                
                GeometryReader {
                    let size = $0.size
                    let pageWidth = size.width/3
                    let imageWidth: CGFloat = 100
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(vm.images, id: \.self) { image in
                                ZStack {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: imageWidth)
                                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                }
                                .frame(width: pageWidth)
                            }
                        }
                        .padding(.horizontal, pageWidth)
                        .background {
                            SnapCarouselHelper(pageWidth: pageWidth, count: vm.images.count, selectedIndex: $vm.selectedIndex)
                        }
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color.white, lineWidth: 3.5)
                            .frame(width: imageWidth)
                            .allowsTightening(false)
                    }
                }
                .frame(height: 120)
            }
            .background {
                Color.black
                LinearGradient(colors: [.black, .gray], startPoint: .center, endPoint: .bottom)
                    .opacity(0.6)
                    .ignoresSafeArea()
            }
            .task {
                await vm.fetchGalleryImages()
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct SnapIntervalcarousel_Previews: PreviewProvider {
    static var previews: some View {
        SnapIntervalcarousel()
    }
}

fileprivate struct SnapCarouselHelper: UIViewRepresentable {
    let pageWidth: CGFloat
    let count: Int
    @Binding var selectedIndex: Int
    func makeUIView(context: Context) -> UIView {
        UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            if let scrollView = uiView.superview?.superview?.superview as? UIScrollView {
                scrollView.decelerationRate = .fast
                scrollView.delegate = context.coordinator
                context.coordinator.count = count
                context.coordinator.pageWidth = pageWidth
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var pageWidth: CGFloat = 0
        var count: Int = 0
        
        let parent: SnapCarouselHelper
        init(parent: SnapCarouselHelper) {
            self.parent = parent
        }
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            let targetEnd = scrollView.contentOffset.x + (velocity.x * 60)
            let pageIndex = (targetEnd/pageWidth).rounded()
            
            parent.selectedIndex = min(max(Int(pageIndex), 0), count - 1)
            
            targetContentOffset.pointee.x = pageIndex * pageWidth
        }
    }
}
