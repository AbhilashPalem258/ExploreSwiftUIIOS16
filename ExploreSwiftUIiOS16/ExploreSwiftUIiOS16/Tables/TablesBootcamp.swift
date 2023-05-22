//
//  TablesBootcamp.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 13/01/23.
//

import SwiftUI

/*
 link: https://www.youtube.com/watch?v=F3LziFHJGUo&list=PLBn01m5Vbs4DJyxwFZEM4-AIs7jzHrb60&index=10
 */

struct TablesBootcamp: View {
    var body: some View {
        TabView {
            TablesRegular()
                .tabItem {
                    Image(systemName: "1.circle.fill")
                    Text("Regular Table")
                }
            
            TablesNavSplit()
                .tabItem {
                    Image(systemName: "2.circle.fill")
                    Text("Nav Split Table")
                }
        }
    }
}

struct TablesBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        TablesBootcamp()
    }
}

fileprivate struct TablesRegular: View {
    
    @State private var path: [Tables.City] = []
    
    @State private var cities = Tables.City.sample.sorted(using: KeyPathComparator(\.name))
    @State private var sortOrder = [
        KeyPathComparator(\Tables.City.name)
    ]
    @State private var citySelection: Tables.City.ID?
    
    @Environment(\.horizontalSizeClass) var sizeClass
    @State private var ascend = true
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .leading) {
                HStack {
                    Text("Cities")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top)
                    Spacer()
                    if sizeClass == .compact {
                        Button {
                            ascend.toggle()
                            if ascend {
                                cities.sort {$0.name < $1.name}
                            } else {
                                cities.sort {$0.name > $1.name}
                            }
                        } label: {
                            HStack {
                                Text("Sort")
                                Image(systemName: "chevron.up.chevron.down")
                            }
                            .bold()
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                }
                
                Table(cities, selection: $citySelection, sortOrder: $sortOrder) {
                    TableColumn("Name", value: \.name) { city in
                        HStack {
                            Text(city.name)
                            Spacer()
                            if sizeClass == .compact {
                                Text(city.country)
                            }
                        }
                    }
                    TableColumn("Capital", value: \.isCapitalInt) { city in
                        HStack {
                            Spacer()
                            Text(city.isCapital ? "🌟" : "")
                            Spacer()
                        }
                    }
                    .width(80)
                    TableColumn("Country", value: \.country)
                    TableColumn("Population", value: \.population) { city in
                        Text("\(city.population)")
                    }
                }
            }
            .padding()
            .navigationDestination(for: Tables.City.self) { city in
                CityView(city: city)
            }
            .onAppear {
                citySelection = nil
            }
        }
        .onChange(of: sortOrder) { newOrder in
            print("New Order: \(newOrder)")
            cities.sort(using: newOrder)
        }
        .onChange(of: citySelection) { newValue in
            if let citySelection, let selectedCity = Tables.City.sample.first(where: {
                $0.id == citySelection
            }) {
                path.append(selectedCity)
            }
        }
    }
}

fileprivate struct TablesNavSplit: View {
    
    enum SelectionType: Hashable {
        case all
        case specific([Tables.City])
        
        var countryName: String {
            switch self {
            case .all:
                return "All countries"
            case .specific(let cities):
                return cities[0].country
            }
        }
        
        var cities: [Tables.City] {
            switch self {
            case .all:
                return Tables.City.sample
            case .specific(let cities):
                return cities
            }
        }
    }
    
    @State private var cities: [Tables.City] = []
    @State private var sidebarSelection: SelectionType?
    @State private var path: [Tables.City] = []
    @State private var selectedCityID: Tables.City.ID?
    @State private var sortOrder = [KeyPathComparator(\Tables.City.name)]
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.doubleColumn)) {
            List(selection: $sidebarSelection) {
                Text("All Countries")
                    .bold()
                    .tag(SelectionType.all)
                ForEach(Tables.City.countries, id: \.self) { country in
                    Text(country)
                        .tag(SelectionType.specific(Tables.City.sample.filter{ city in
                            city.country == country
                        }))
                }
            }
            .navigationTitle("Countries")
            .onChange(of: sidebarSelection) { newValue in
                self.cities = newValue?.cities ?? []
            }
        } detail: {
            NavigationStack(path: $path) {
                if cities.isEmpty {
                    Text("Please select a country in side bar")
                } else {
                    VStack(alignment: .leading) {
                        Text(sidebarSelection?.countryName ?? "")
                            .font(.largeTitle)
                            .bold()
                            .padding(.top)
                        
                        Table(cities, selection: $selectedCityID, sortOrder: $sortOrder) {
                            TableColumn("Name", value: \.name)
                            TableColumn("Capital", value: \.isCapitalInt) { city in
                                HStack {
                                    Spacer()
                                    Text(city.isCapital ? "🌟" : "")
                                    Spacer()
                                }
                            }
                            .width(80)
                            TableColumn("Country", value: \.country)
                            TableColumn("Population", value: \.population) { city in
                                Text("\(city.population)")
                            }
                        }
                    }
                    .padding(.leading)
                    .navigationDestination(for: Tables.City.self, destination: { city in
                        CityView(city: city)
                    })
                    .onChange(of: selectedCityID) { newValue in
                        if let selectedCity = Tables.City.sample.first(where: { $0.id == newValue }) {
                            path.append(selectedCity)
                        }
                    }
                }
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}

fileprivate struct CityView: View {
    let city: Tables.City
    var body: some View {
        ZStack {
            
            LinearGradient(colors: [.brown, .green], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                Text(city.isCapital ? "🌟" : "")
                    .font(.system(size: 200, design: .rounded))
                Text(city.name)
                Text(city.country)
                Text("\(city.population)")
            }
            .font(.largeTitle)
            .bold()
        }
    }
}
