//
//  SharedSnapchatTransitions.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 22/02/23.
//

import AVKit
import SwiftUI

fileprivate struct Video: Identifiable {
    let id = UUID()
    var fileURL: URL
    var thumbnail: UIImage?
    var player: AVPlayer
    var offset: CGSize = .zero
    var playVideo: Bool = false
}

fileprivate extension Binding<[Video]> {
    func video(id: String) -> Binding<Video> {
        let index = self.wrappedValue.firstIndex { video in
            video.id.uuidString == id
        }
        return self[index ?? 0]
    }
}

fileprivate struct DataManager {
    
    let videoModels: [Video] = {
        let videoURLs = [
            URL(filePath: Bundle.main.path(forResource: "Reels1", ofType: "mov") ?? ""),
            URL(filePath: Bundle.main.path(forResource: "Reels2", ofType: "mov") ?? ""),
            URL(filePath: Bundle.main.path(forResource: "Reels3", ofType: "mov") ?? ""),
            URL(filePath: Bundle.main.path(forResource: "Reels4", ofType: "mov") ?? ""),
            URL(filePath: Bundle.main.path(forResource: "Reels5", ofType: "mov") ?? ""),
            URL(filePath: Bundle.main.path(forResource: "Reels6", ofType: "mov") ?? ""),
        ]
        
        return [
            .init(fileURL: videoURLs[0], player: AVPlayer(url: videoURLs[0])),
            .init(fileURL: videoURLs[1], player: AVPlayer(url: videoURLs[1])),
            .init(fileURL: videoURLs[2], player: AVPlayer(url: videoURLs[2])),
            .init(fileURL: videoURLs[3], player: AVPlayer(url: videoURLs[3])),
            .init(fileURL: videoURLs[4], player: AVPlayer(url: videoURLs[4])),
            .init(fileURL: videoURLs[5], player: AVPlayer(url: videoURLs[5])),
        ]
    }()
}

struct SharedSnapchatTransitions: View {
    
    @State private var videos = DataManager().videoModels
    @State private var isExpanded = false
    @State private var expandedID: String?
    @Namespace var animation
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            contentView
        }
        .overlay {
            detailView
        }
        .preferredColorScheme(.light)
    }
    
    private var headerView: some View {
        HStack(spacing: 12) {
            Image("snapchat")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .headerIconBG()
            
            Button {
                
            } label: {
                Image(systemName: "magnifyingglass")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .headerIconBG()
            }
            
            Spacer(minLength: 0)
            
            Button {
                
            } label: {
                Image(systemName: "person.badge.plus")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .headerIconBG()
            }
            
            Button {
                
            } label: {
                Image(systemName: "ellipsis")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .headerIconBG()
            }
        }
        .overlay {
            Text("Stories")
                .font(.title3)
                .fontWeight(.black)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
    }
    
    private var contentView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: Array.init(repeating: .init(.flexible(), spacing: 10), count: 2), spacing: 10) {
                ForEach($videos) { $video in
                    if isExpanded && expandedID == video.id.uuidString {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 300)
                    } else {
                        CardView(video: $video, isExpanded: $isExpanded, animation: animation) {

                        }
                        .frame(height: 300)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.8)) {
                                expandedID = video.id.uuidString
                                isExpanded = true
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 15)
    }
    
    @ViewBuilder
    private var detailView: some View {
        if isExpanded, let expandedID {
            DetailView(video: $videos.video(id: expandedID), isExpanded: $isExpanded, animationID: animation)
                .transition(.asymmetric(insertion: .identity, removal: .offset(y: 5)))
        }
    }
}

fileprivate extension View {
    
    var screenSize: CGSize {
        guard let size = ((UIApplication.shared.connectedScenes.first) as? UIWindowScene)?.windows.first?.screen.bounds.size else {
            return .zero
        }
        return size
    }
    
    func headerIconBG() -> some View {
        self.modifier(HeaderIconBG())
    }
}

fileprivate struct HeaderIconBG: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 40, height: 40)
            .background {
                Circle()
                    .fill(Color.gray.opacity(0.2))
            }
    }
}

fileprivate struct DetailView: View {
    @Binding var video: Video
    @Binding var isExpanded: Bool
    var animationID: Namespace.ID
    
    @GestureState private var isDragging = false
    
    private var reelSummaryView: some View {
        VStack {
            HStack {
                Image("Damini")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Palem Damini")
                        .font(.callout)
                        .fontWeight(.bold)
                    
                    Text("4 hrs ago")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "bookmark")
                    .font(.title3)
                
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .rotationEffect(.init(degrees: -90))
            }
            .foregroundColor(.white)
            .frame(maxHeight: .infinity, alignment: .top)
            .opacity(isDragging ? 0 : 1)
            
            Button {
                
            } label: {
                Text("View More Episodes")
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background {
                        Capsule()
                            .fill(.white)
                    }
            }
            .frame(maxWidth: .infinity)
            .overlay(alignment: .trailing) {
                Button {
                    
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background {
                            Circle()
                                .fill(.ultraThinMaterial)
                        }
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .opacity(video.playVideo && isExpanded ? 1 : 0)
    }
    
    var body: some View {
        GeometryReader {
            let safeArea = $0.safeAreaInsets
            
            CardView(video: $video, isExpanded: $isExpanded, animation: animationID, isDetailView: true) {
                reelSummaryView
                    .padding(.top, safeArea.top)
                    .padding(.bottom, safeArea.bottom)
            }
            .ignoresSafeArea()
        }
        .gesture(
            DragGesture()
                .updating($isDragging) { _, isDragging, _ in
                    isDragging = true
                }
                .onChanged { value in
                    var translation = value.translation
                    translation = isDragging ? translation : .zero
                    video.offset = translation
                }
                .onEnded { value in
                    if value.translation.height > 200 {
                        video.player.pause()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            video.player.seek(to: .zero)
                            video.playVideo = false
                        }
                        
                        withAnimation(Animation.interactiveSpring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.8)) {
                            video.offset = .zero
                            isExpanded = false
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            video.offset = .zero
                        }
                    }
                }
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.easeInOut) {
                    video.player.play()
                    video.playVideo = true
                }
            }
        }
    }
}

fileprivate struct CardView<Overlay: View>: View {
    
    @Binding var video: Video
    @Binding var isExpanded: Bool
    var animation: Namespace.ID
    var isDetailView: Bool = false
    var overlay: Overlay
    
    init(video: Binding<Video>, isExpanded: Binding<Bool>, animation: Namespace.ID, isDetailView: Bool = false, @ViewBuilder overlay: () -> Overlay) {
        self._video = video
        self._isExpanded = isExpanded
        self.animation = animation
        self.isDetailView = isDetailView
        self.overlay = overlay()
    }
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            if let thumbnail = video.thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .scaledToFill()
                    .opacity(video.playVideo ? 0 : 1)
                    .frame(width: size.width, height: size.height)
                    .overlay {
                        if video.playVideo && isDetailView {
                            CustomVideoPlayer(player: video.player)
                                .transition(.identity)
                        }
                    }
                    .overlay {
                        overlay
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .scaleEffect(scale)
            } else {
                ProgressView()
                    .onAppear {
                        extractThumbnailImage(time: .zero, size: screenSize) { image in
                            video.thumbnail = image
                        }
                    }
            }
        }
            .matchedGeometryEffect(id: video.id.uuidString, in: animation)
            .offset(video.offset)
            .offset(y: video.offset.height * -0.7)
    }
    
    var scale: CGFloat {
        var progress = video.offset.height / screenSize.height
        progress = 1 - (progress > 0.4 ? 0.4 : progress)
        return isExpanded ? progress : 1
    }
    
    func extractThumbnailImage(time: CMTime, size: CGSize, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            let asset = AVAsset(url: video.fileURL)
            let imagegenerator = AVAssetImageGenerator(asset: asset)
            imagegenerator.appliesPreferredTrackTransform = true
            imagegenerator.maximumSize = size
            
            Task {
                do {
                    let image: CGImage = try await imagegenerator.image(at: time).image
                    guard let colorCorrectedImage = image.copy(colorSpace: CGColorSpaceCreateDeviceRGB()) else {
                        return
                    }
                    await MainActor.run {
                        completion(UIImage(cgImage: colorCorrectedImage))
                    }
                } catch {
                    print("Failed to fetch thumbnail image for url: \(video.fileURL)")
                }
            }
        }
    }
}


fileprivate struct CustomVideoPlayer: UIViewControllerRepresentable {
    var player: AVPlayer
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        controller.view.backgroundColor = .clear
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = player
    }
}

struct SharedSnapchatTransitions_Previews: PreviewProvider {
    static var previews: some View {
        SharedSnapchatTransitions()
    }
}
