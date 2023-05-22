//
//  NominalChartExample.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 08/01/23.
//

import Foundation
import SwiftUI
import Charts

fileprivate struct Winelog: Identifiable {
    var variety: String
    var quantity: Int
    var country: String
    var entryDate: Date
    let id = UUID()
}

fileprivate func date(year: Int, month: Int, day: Int) -> Date {
    Calendar.current.date(from: .init(year: year, month: month, day: day)) ?? Date()
}

struct NominalChartExample: View {
    fileprivate let wine1 = Winelog(variety: "Chardonney", quantity: 10, country: "Canada", entryDate: date(year: 2022, month: 7, day: 22))
    fileprivate let wine2 = Winelog(variety: "Mariot", quantity: 20, country: "India", entryDate: date(year: 2022, month: 7, day: 23))
    fileprivate let wine3 = Winelog(variety: "Abhilash", quantity: 35, country: "United States", entryDate: date(year: 2022, month: 7, day: 24))
    // Stacked Bar Chart
//    fileprivate let wine2 = Winelog(variety: "Mariot", quantity: 20, country: "Canada", entryDate: date(year: 2022, month: 7, day: 23))
    
    
    var individualPlotItems: some View {
        Chart {
            BarMark(
//                    x: .value("Variety", wine1.variety),
                x: .value("Country", wine1.country),
                y: .value("In Stock", wine1.quantity)
            )
            .foregroundStyle(by: .value("Variety", wine1.variety))
            BarMark(
//                    x: .value("Variety", wine2.variety),
                x: .value("Country", wine2.country),
                y: .value("In Stock", wine2.quantity)
            )
            .foregroundStyle(by: .value("Variety", wine2.variety))
            BarMark(
//                    x: .value("Variety", wine2.variety),
                x: .value("Country", wine3.country),
                y: .value("In Stock", wine3.quantity)
            )
            .foregroundStyle(by: .value("Variety", wine3.variety))
        }
    }
    
    @ViewBuilder var collectedPlotitems: some View {
        let wines = [wine1, wine2, wine3]
        Chart(wines) {
            BarMark(
                x: .value("Country", $0.country),
                y: .value("In Stock", $0.quantity)
            )
            .foregroundStyle(by: .value("Variety", $0.variety))
        }
        .navigationTitle("Nominal Bar Chart")
    }
    
    @ViewBuilder var collectedPlotItemsByDate: some View {
        let wines = [wine1, wine2, wine3]
        Chart(wines) {
            BarMark(
                x: .value("Date", $0.entryDate, unit: .day),
                y: .value("In Stock", $0.quantity)
            )
            .foregroundStyle(by: .value("Country", $0.country))
        }
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel(format: .dateTime.month().day(), centered: true)
            }
        }
        .navigationTitle("Temporal Bar Chart")
    }
    
    var body: some View {
        NavigationStack {
            collectedPlotItemsByDate
        }
        .padding()
    }
}

struct NominalChartExample_Previews: PreviewProvider {
    static var previews: some View {
        NominalChartExample()
    }
}
