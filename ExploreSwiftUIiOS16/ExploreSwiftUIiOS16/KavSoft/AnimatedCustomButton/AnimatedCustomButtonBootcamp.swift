//
//  AnimatedCustomButtonBootcamp.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 22/08/23.
//

import SwiftUI

struct AnimatedCustomButtonBootcamp: View {
    var body: some View {
        CustomButton {
            HStack(spacing: 10) {
                Text("Login")
                Image(systemName: "chevron.right")
            }
            .fontWeight(.bold)
            .foregroundStyle(.green)
        } action: {
            try? await Task.sleep(for: .seconds(2))
            return TaskStatus.failed(message: "Password incorrect")
        }
    }
}

fileprivate struct CustomButton<ButtonContent: View>: View {
    var content: () -> ButtonContent
    let action: () async -> TaskStatus
    
    @State private var isLoading: Bool = false
    @State private var taskStatus: TaskStatus = .idle
    @State private var isFailed: Bool = false
    
    @State private var showPopup: Bool = false
    @State private var popupMessage: String = ""
    
    var body: some View {
        Button {
            Task {
                self.isLoading = true
                let taskStatus = await action()
                switch taskStatus {
                case .failed(let msg):
                    isFailed = true
                    popupMessage = msg
                case .idle:
                    isFailed = false
                case .success:
                    isFailed = false
                }
                self.taskStatus = .idle
                self.isLoading = false
            }
        } label: {
            content()
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .opacity(isLoading ? 0 : 1)
                .frame(width: isLoading ? 50 : nil, height: isLoading ? 50 : nil)
                .background(Color(taskStatus == .idle ? .white : taskStatus == .success ? .green : .red).shadow(.drop(color:  .black.opacity(0.2),radius: 6)), in: Capsule())
                .overlay {
                    if isLoading && taskStatus == .idle {
                        ProgressView()
                    }
//                    } else if !isLoading && taskStatus == .failed {
//                        Image(systemName: "exclamationmark.triangle.fill")
//                    }
                }
        }
        .disabled(isLoading)
        .animation(.spring(), value: isLoading)
    }
}

fileprivate enum TaskStatus: Equatable {
    case idle
    case failed(message: String)
    case success
}

struct AnimatedCustomButtonBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedCustomButtonBootcamp()
    }
}
