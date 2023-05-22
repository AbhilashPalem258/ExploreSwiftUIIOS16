//
//  NavStackBootcamp2.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 07/01/23.
//

import SwiftUI

/*
 Links:
 - https://www.youtube.com/watch?v=6-OeaFfDXXw&list=PLBn01m5Vbs4DJyxwFZEM4-AIs7jzHrb60&index=7
 
 Definition:
 - Programmable Navigation
 - Deep Links
 
 Notes:
 
 */
struct NavStackBootcamp2: View {
    
    var countryList: some View {
        NavigationStack {
            List {
                ForEach(Country.sample) { country in
                    NavigationLink(value: country) {
                        Text("\(country.flag) \(country.name)")
                    }
                }
            }
            .navigationTitle("Country List")
            .navigationDestination(for: Country.self) { country in
                CountryDetail(country: country)
            }
        }
    }
    
    var body: some View {
        countryList
    }
}

struct NavStackBootcamp2_Previews: PreviewProvider {
    static var previews: some View {
        NavStackBootcamp2()
    }
}

fileprivate struct CountryDetail: View {
    let country: Country
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(country.flag) \(country.name)")
                .font(.largeTitle)
            HStack {
                Spacer()
                Text("Population: \(country.population)")
                    .font(.title)
            }
            let cities = City.get(for: country.name)
            List {
                Section("Cities") {
                    ForEach(cities) { city in
                        NavigationLink(value: city) {
                            Text(city.name)
                        }
                    }
                }
            }
            .navigationDestination(for: City.self) { city in
                CityDetail(city: city)
            }
        }
    }
}

fileprivate struct CityDetail: View {
    let city: City
    var body: some View {
        VStack {
            ZStack {
                Text("🌟")
                    .font(.system(size: 200))
                Text(city.name)
                    .font(.title)
            }
            Spacer()
            Button {
                
            } label: {
                Text("Countries List")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
    }
}
