//
//  ObservationBootcampObjc.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 02/12/23.
//

/*
 link: https://talk.objc.io/episodes/S01E362-swift-observation-access-tracking
 */
import SwiftUI
import Observation

@available(iOS 17.0, *)
@Observable
final class Person {
    var name: String = "Tom"
    var age: Int = 25
}

@available(iOS 17.0, *)
struct ObservationBootcampObjc: View {
    
    var person = Person()

    var body: some View {
        VStack {
            Group {
                Button("Change Name: \(person.name)") {
                    person.name = ["Abhilash", "Sandeep", "Mounika"].randomElement()!
                }
                
                Button("Change Age: \(person.age)") {
                    person.age += 1
                }
            }
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
        }
        .onAppear {
            evaluate()
        }
    }
    
    func evaluate() {
//        withObservationTracking(<#T##apply: () -> T##() -> T#>, onChange: <#T##() -> Void#>)
        _ = withObservationTracking {
            person.name
        } onChange: {
            print("OnChange Called")
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    ObservationBootcampObjc()
}
