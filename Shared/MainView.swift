//
//  GeocachesView.swift
//  WatchyGPS
//
//  Created by Ben Goldberg on 7/17/22.
//

import SwiftUI
import CoreLocation

struct MainView: View {
    @State var geocaches: [Geocache] = []
    var body: some View {
        TabView {
            NavigationView {
                GeometryReader { geometry in
                    GeocacheMapView(geocaches: $geocaches)
                        .edgesIgnoringSafeArea([.horizontal, .top])
                        .navigationBarHidden(true)
                        //.frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
                .edgesIgnoringSafeArea([.horizontal, .top])
                .navigationViewStyle(StackNavigationViewStyle())
            }
            .edgesIgnoringSafeArea([.horizontal, .top])
            .tabItem {
                Label("Map", systemImage: "map.fill")
            }
            .zIndex(5)
            .navigationViewStyle(StackNavigationViewStyle())
            
            NavigationView {
                GeocacheListView(geocaches: $geocaches)
                    .navigationViewStyle(StackNavigationViewStyle())
            }
            .tabItem {
                Label("List", systemImage: "list.bullet")
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .navigationTitle("WatchyGPS")
        .edgesIgnoringSafeArea(.all)
        .zIndex(10)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
