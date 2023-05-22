//
//  AppIntroOnboarding.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 23/02/23.
//

import SwiftUI
import Lottie

fileprivate struct OnboardingItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let subTitle: String
    let lottieView: LottieAnimationView
    
    static let all: [Self] = [
        .init(title: "Order Food", subTitle: "Order your favourite food online at your favourite restaurants near by. We will make sure to deliver your happiness with in no time", lottieView: .init(name: "delivery_process", bundle: .main)),
        .init(title: "Food delivery within minutes", subTitle: "Our Captains will make sure your happiness will be delivered to you in right condition in just few minutes", lottieView: .init(name: "order_food", bundle: .main)),
        .init(title: "Rate our captain", subTitle: "Please rate our captain and his service. This helps them to gain extra incentives", lottieView: .init(name: "order_delivery", bundle: .main))

    ]
}

fileprivate class ViewModel: ObservableObject {
    @Published var items = OnboardingItem.all
    @Published var currentIndex: Int = 0
    
    func index(of item: OnboardingItem) -> Int {
        if let index = self.items.firstIndex(of: item) {
            return index
        }
        return 0
    }
}

struct AppIntroOnboarding: View {
    
    @StateObject private var vm = ViewModel()
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            HStack(spacing: 0) {
                ForEach($vm.items) { $item in
                    VStack {
                        headerView
                        VStack(spacing: 15) {
                            let offset = -CGFloat(vm.currentIndex) * size.width
                            ResizableAnimationView(item: $item)
                                .frame(height: size.width)
                                .onAppear {
                                    if vm.currentIndex == vm.index(of: item) {
                                        item.lottieView.play(toProgress: 0.7)
                                    }
                                }
                                .offset(x: offset)
                                .animation(.easeInOut, value: vm.currentIndex)
                            
                            Text(item.title)
                                .font(.title.bold())
                                .multilineTextAlignment(.center)
                                .offset(x: offset)
                                .animation(.easeInOut.delay(0.2), value: vm.currentIndex)
                            
                            Text(item.subTitle)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 14)
                                .offset(x: offset)
                                .animation(.easeInOut.delay(0.3), value: vm.currentIndex)
                        }
                        Spacer(minLength: 0)
                        bottomView
                    }
                    .padding(15)
                    .frame(width: size.width, height: size.height)
                }
            }
            .frame(width: size.width * CGFloat(vm.items.count))
        }
//        .preferredColorScheme(.light)
    }
    
    private var headerView: some View {
        HStack {
            Button {
                if vm.currentIndex > 0 {
                    vm.currentIndex -= 1
                    playAnimation()
                }
            } label: {
                Text("Back")
            }
            .opacity(vm.currentIndex == 0 ? 0 : 1)
            .animation(.easeInOut, value: vm.currentIndex)
            
            Spacer(minLength: 0)
            
            Button {
                vm.currentIndex = vm.items.count - 1
                playAnimation()
            } label: {
                Text("Skip")
            }
            .opacity(vm.currentIndex == (vm.items.count - 1) ? 0 : 1)
            .animation(.easeInOut, value: vm.currentIndex)
        }
        .tint(Color("Green"))
        .fontWeight(.bold)
    }
//
//    private func contentView(item: Binding<OnboardingItem>) -> some View {
//
//    }
    
    @ViewBuilder
    private var bottomView: some View {
        VStack(spacing: 15) {
            let islastSlide = vm.currentIndex == (vm.items.count - 1)
            Button {
                if vm.currentIndex < vm.items.count - 1 {
                    vm.items[vm.currentIndex].lottieView.pause()
                    let currentProgress = vm.items[vm.currentIndex].lottieView.currentProgress
                    vm.items[vm.currentIndex].lottieView.currentProgress = (currentProgress == 0 ? 0.7 : currentProgress)
                    vm.currentIndex += 1
                    playAnimation()
                }
                
            } label: {
                Text("Next")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, islastSlide ? 13 : 12)
                    .frame(maxWidth: .infinity)
                    .background {
                        Capsule()
                            .fill(Color("Green"))
                    }
                    .padding(.horizontal, islastSlide ? 50 : 100)
                    .animation(.easeInOut, value: islastSlide)
            }
            
            HStack {
                Text("Terms of Service")
                
                Text("Privacy Policy")
            }
            .font(.caption2)
            .underline(true, color: .primary)
            .offset(y: 5)
        }
    }
    
    private func playAnimation() {
        vm.items[vm.currentIndex].lottieView.currentProgress = 0
        vm.items[vm.currentIndex].lottieView.play(toProgress: 0.7)
    }
}

fileprivate struct ResizableAnimationView: UIViewRepresentable {
    @Binding var item: OnboardingItem
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        setupLottieView(to: view)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
       
    }
    
    private func setupLottieView(to: UIView) {
        let lottieView = item.lottieView
        lottieView.backgroundColor = UIColor.clear
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        to.addSubview(lottieView)
        
        let contsraints = [
            lottieView.topAnchor.constraint(equalTo: to.topAnchor),
            lottieView.leadingAnchor.constraint(equalTo: to.leadingAnchor),
            lottieView.bottomAnchor.constraint(equalTo: to.bottomAnchor),
            lottieView.trailingAnchor.constraint(equalTo: to.trailingAnchor)
        ]
        
        contsraints.forEach { constraint in
            constraint.isActive = true
        }
    }
}

struct AppIntroOnboarding_Previews: PreviewProvider {
    static var previews: some View {
        AppIntroOnboarding()
    }
}
