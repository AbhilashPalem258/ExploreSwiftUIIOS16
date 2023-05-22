//
//  NavSplitViewBootcamp.swift
//  ExploreSwiftUIiOS16
//
//  Created by Abhilash Palem on 07/01/23.
//

import SwiftUI

/*
 Links:
 - https://www.youtube.com/watch?v=6-OeaFfDXXw&list=PLBn01m5Vbs4DJyxwFZEM4-AIs7jzHrb60&index=7
 
 Definition:
 - NavigationSplitView
 - 2 and 3 column views
 
 Notes:
 
 */
struct NavSplitViewBootcamp: View {
    
    private var dataModel = CoffeeEquipmenModel()
    @State private var selectedCategoryID: MenuItem.ID?
    @State private var selectedMenuID: MenuItem.ID?
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            List(dataModel.mainMenuItems, selection: $selectedCategoryID) { categoryItem in
                HStack {
                    Image(systemName: categoryItem.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    Text(categoryItem.name)
                        .font(.system(.title3, design: .rounded))
                        .bold()
                }
            }
            .navigationTitle("Category")
        } content: {
            if let selectedCategoryID, let menuItems = dataModel.subMenuItems(for: selectedCategoryID) {
                List(menuItems, selection: $selectedMenuID) { item in
                    HStack {
                        Image(systemName: item.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        Text(item.name)
                            .font(.system(.title3, design: .rounded))
                            .bold()
                    }
                }
                .navigationTitle("Menu")
                .listStyle(.plain )
                .navigationBarTitleDisplayMode(.inline)
            } else {
                Text("Please select a category")
            }
        } detail: {
            if let selectedCategoryID, let selectedMenuID, let item = dataModel.menuItem(for: selectedCategoryID, itemID: selectedMenuID) {
                VStack {
                    Image(systemName: item.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    Text(item.name)
                        .font(.largeTitle)
                        .bold()
                }
            } else {
                Text("Please select an item")
            }
        }
        .navigationSplitViewStyle(.automatic)
//        .navigationSplitViewStyle(.balanced)
//        .navigationSplitViewStyle(.prominentDetail)

    }
}

struct NavSplitViewBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        NavSplitViewBootcamp()
    }
}

fileprivate struct CoffeeEquipmenModel {
    let mainMenuItems = {
        
        // Sub-menu items for Espresso Machines
        let espressoMachineMenuItems = [ MenuItem(name: "Leva", image: "menucard", subMenuItems: [ MenuItem(name: "Leva X", image: "leva-x"), MenuItem(name: "Leva S", image: "leva-s") ]),
                                         MenuItem(name: "Strada", image: "menucard", subMenuItems: [ MenuItem(name: "Strada EP", image: "strada-ep"), MenuItem(name: "Strada AV", image: "strada-av"), MenuItem(name: "Strada MP", image: "strada-mp"), MenuItem(name: "Strada EE", image: "strada-ee") ]),
                                         MenuItem(name: "KB90", image: "menucard"),
                                         MenuItem(name: "Linea", image: "menucard", subMenuItems: [ MenuItem(name: "Linea PB X", image: "linea-pb-x"), MenuItem(name: "Linea PB", image: "linea-pb"), MenuItem(name: "Linea Classic", image: "linea-classic") ]),
                                         MenuItem(name: "GB5", image: "menucard"),
                                         MenuItem(name: "Home", image: "menucard", subMenuItems: [ MenuItem(name: "GS3", image: "gs3"), MenuItem(name: "Linea Mini", image: "linea-mini") ])
        ]
        
        // Sub-menu items for Grinder
        let grinderMenuItems = [ MenuItem(name: "Swift", image: "filemenu.and.cursorarrow"),
                                 MenuItem(name: "Vulcano", image: "filemenu.and.cursorarrow"),
                                 MenuItem(name: "Swift Mini", image: "filemenu.and.cursorarrow"),
                                 MenuItem(name: "Lux D", image: "filemenu.and.cursorarrow")
        ]
        
        // Sub-menu items for other equipment
        let otherMenuItems = [ MenuItem(name: "Espresso AV", image: "contextualmenu.and.cursorarrow"),
                               MenuItem(name: "Espresso EP", image: "contextualmenu.and.cursorarrow"),
                               MenuItem(name: "Pour Over", image: "contextualmenu.and.cursorarrow"),
                               MenuItem(name: "Steam", image: "contextualmenu.and.cursorarrow")
        ]
        
        // Top menu items
        let topMenuItems = [ MenuItem(name: "Espresso Machines", image: "square.grid.3x1.folder.badge.plus", subMenuItems: espressoMachineMenuItems),
                             MenuItem(name: "Grinders", image: "square.grid.3x1.folder.badge.plus", subMenuItems: grinderMenuItems),
                             MenuItem(name: "Other Equipments", image: "square.grid.3x1.folder.badge.plus", subMenuItems: otherMenuItems)
        ]
        
        return topMenuItems
    }()
    
    func subMenuItems(for id: MenuItem.ID) -> [MenuItem]? {
        guard let menuItem = mainMenuItems.first(where: { $0.id == id }) else {
            return nil
        }
 
        return menuItem.subMenuItems
    }
     
    func menuItem(for categoryID: MenuItem.ID, itemID: MenuItem.ID) -> MenuItem? {
 
        guard let subMenuItems = subMenuItems(for: categoryID) else {
            return nil
        }
 
        guard let menuItem = subMenuItems.first(where: { $0.id == itemID }) else {
            return nil
        }
 
        return menuItem
    }
}

fileprivate struct MenuItem: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var image: String
    var subMenuItems: [MenuItem]?
}
