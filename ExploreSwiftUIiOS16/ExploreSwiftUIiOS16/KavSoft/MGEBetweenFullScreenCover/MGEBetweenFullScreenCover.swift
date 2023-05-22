//
//  MGEBetweenFullScreenCover.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 21/02/23.
//

import SwiftUI

fileprivate struct Row: Identifiable {
    let id = UUID()
    var color: Color
}


fileprivate class ViewModel: ObservableObject {
    let rows: [Row] = [
        .init(color: .red),
        .init(color: .green),
        .init(color: .blue),
        .init(color: .mint),
        .init(color: .indigo),
        .init(color: .cyan)
    ]
}

struct MGEBetweenFullScreenCover: View {
    
    private var vm = ViewModel()
    @State private var show = false
    @State private var selectedRow: Row = .init(color: .clear)
    @Namespace private var animation
//    @State private var test = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: Array.init(repeating: .init(.flexible(), spacing: 5), count: 3), spacing: 5) {
                    ForEach(vm.rows) { row in
                        Rectangle()
                            .fill(row.color.gradient)
                            .frame(height: 100)
                            .onTapGesture {
                                selectedRow = row
                                show.toggle()
                            }
                    }
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("Navigation Stack")
            .heroFullscreenCover(show: $show) {
                DetailView(row: $selectedRow, animationID: animation)
//                    .overlay {
//                        Button(test ? "Clicked" : "Click Me!") {
//                            test.toggle()
//                        }
//                    }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct MGEBetweenFullScreenCover_Previews: PreviewProvider {
    static var previews: some View {
        MGEBetweenFullScreenCover()
    }
}

fileprivate extension View {
    func heroFullscreenCover<Content: View>(show: Binding<Bool>, @ViewBuilder content: () -> Content) -> some View {
        self.modifier(HomeFullScreenModifier(show: show, overlay: content()))
    }
}

fileprivate struct HomeFullScreenModifier<Overlay: View>: ViewModifier {
    @Binding var show: Bool
    var overlay: Overlay
    
    @State var hostView: CustomHostingController<Overlay>?
    @State var parentVC: UIViewController?
    
    func body(content: Content) -> some View {
        content
            .background {
                ExtractParentVC(content: overlay, hostView: $hostView) { parentVC in
                    self.parentVC = parentVC
                }
            }
            .onAppear {
                hostView = CustomHostingController(show: $show, rootView: overlay)
            }
            .onChange(of: show) { newValue in
                if newValue {
                    hostView?.modalPresentationStyle = .overCurrentContext
                    hostView?.modalTransitionStyle = .crossDissolve
                    hostView?.view.backgroundColor = UIColor.clear
                    
                    if let hostView {
                        parentVC?.present(hostView, animated: true)
                    }
                } else {
                    hostView?.dismiss(animated: true)
                }
            }
    }
}

fileprivate struct ExtractParentVC<Content: View>: UIViewRepresentable {
    
    var content: Content
    @Binding var hostView: CustomHostingController<Content>?
    let parentController: (UIViewController?) -> Void
    
    func makeUIView(context: Context) -> UIView {
        UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        hostView?.rootView = content
        DispatchQueue.main.async {
            parentController(uiView.superview?.superview?.parentController)
        }
    }
}

fileprivate class CustomHostingController<Content: View>: UIHostingController<Content> {
    @Binding var show: Bool

    init(show: Binding<Bool>, rootView: Content) {
        self._show = show
        super.init(rootView: rootView)
    }
    
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        show = false
    }
}

fileprivate extension UIView {
    var parentController: UIViewController? {
        var responder = self.next
        while responder != nil {
            if let vc = responder as? UIViewController {
                return vc
            }
            responder = responder?.next
        }
        return nil
    }
}


fileprivate struct DetailView: View {
    @Binding var row: Row
    var animationID: Namespace.ID
    
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            Rectangle()
                .fill(row.color.gradient)
                .frame(width: 200, height: 200)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .topLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundColor(.primary)
            }
        }
    }
}
