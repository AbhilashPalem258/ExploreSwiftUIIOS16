//
//  GaugeBasic.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 10/01/23.
//

import SwiftUI

/*
 Links:
 - https://www.appcoda.com/swiftui-gauge/
 
 Definition:

 
 Notes:

 
 */
struct GaugeBasic: View {
    
    @State private var progress = 0.5
    var defaultValuesGauge: some View {
        Gauge(value: progress) {
            Text("Upload Status")
        } currentValueLabel: {
            Text(progress.formatted(.percent))
        } minimumValueLabel: {
            Text(0.formatted(.percent))
        } maximumValueLabel: {
            Text(100.formatted(.percent))
        }
    }
    
    
    @State private var currentSpeed = 100.0
    var customValuesGauge: some View {
        Gauge(value: currentSpeed, in: 0...200) {
//            Text("Speed")
            Image(systemName: "gauge.medium")
                .font(.system(size: 50.0))
        } currentValueLabel: {
            HStack {
                Image(systemName: "gauge.high")
                Text("\(currentSpeed.formatted(.number))km/h")
            }
        } minimumValueLabel: {
            Text(0.formatted(.number))
        } maximumValueLabel: {
            Text(100.formatted(.number))
        }
        .tint(.purple)
//        .gaugeStyle(.automatic)
//        .gaugeStyle(.accessoryLinear)
//        .gaugeStyle(.accessoryLinearCapacity)
//        .gaugeStyle(.accessoryCircularCapacity)
//        .gaugeStyle(.accessoryCircular)
        .gaugeStyle(.linearCapacity)
    }
    
    
    var customGaugeStyle: some View {
        Gauge(value: currentSpeed) {
            Image(systemName: "gauge.medium")
                .font(.system(size: 50.0))
        } currentValueLabel: {
            Text("\(currentSpeed.formatted(.number))km/h")
        } minimumValueLabel: {
            Text(0.formatted(.number))
        } maximumValueLabel: {
            Text(180.formatted(.number))
        }
        .gaugeStyle(SpeedOMeterGaugeStyle())
    }
    
    var body: some View {
        VStack {
            defaultValuesGauge
            Spacer()
                .frame(height: 100)
            customValuesGauge
            Spacer()
                .frame(height: 100)
            customGaugeStyle
        }
        .padding()
        .accentColor(.orange)
    }
}

struct GaugeBasic_Previews: PreviewProvider {
    static var previews: some View {
        GaugeBasic()
    }
}

fileprivate struct SpeedOMeterGaugeStyle: GaugeStyle {
    let purpleGradient = LinearGradient(colors: [.red, .blue], startPoint: .leading, endPoint: .trailing)
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .foregroundColor(Color(.systemGray6))
            
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(purpleGradient, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(.degrees(135))
            
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(Color.black, style: StrokeStyle(lineWidth: 10, lineCap: .butt, lineJoin: .round, dash: [1, 34], dashPhase: 0.0))
                .rotationEffect(.degrees(135))
            
            VStack {
                Image(systemName: "gauge.medium")
                    .font(.title)
                    .foregroundColor(.gray)
                configuration.currentValueLabel
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.gray)
            }
        }
    }
}
