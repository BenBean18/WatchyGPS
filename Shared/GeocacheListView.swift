//
//  GeocacheListView.swift
//  WatchyGPS
//
//  Created by Ben Goldberg on 7/15/22.
//

import SwiftUI
import CoreLocation

struct Refreshable: ViewModifier {
    var cb: () -> Void
    func body(content: Content) -> some View {
        if #available(iOS 15.0, watchOS 8.0, *) {
            content.refreshable {
                cb()
            }
        } else {
            content
        }
    }
}

struct GeocacheListView: View {
    @State var delegate: LocationDelegate?
    @State var heading: CLHeading? = nil
    @State var location: CLLocation? = nil
    @Binding var geocaches: [Geocache]
    @State var success: Bool = false
    @State var requestedCaches: Bool = false
    @State var downloadingCaches: Bool = false
    let sortingMethods = ["distance", "favorites", "TBs"]
    @State var sort: String = "distance"
    
    func sortGeocaches() {
        var sortFunc: ((Geocache, Geocache) -> Bool)? = nil
        switch sort {
        case "distance":
            sortFunc = { $0.distance < $1.distance } // this won't actually work, need to use GPS position
        case "favorites":
            sortFunc = { $0.favoritePoints > $1.favoritePoints }
        case "TBs":
            sortFunc = { $0.trackableCount > $1.trackableCount }
        default:
            sortFunc = { $0.distance < $1.distance } // this won't actually work, need to use GPS position
        }
        geocaches.sort(by: sortFunc!)
    }
    
    var body: some View {
        VStack {
            Picker("Sort by", selection: $sort) {
                ForEach(sortingMethods, id: \.self) {
                    Text("\($0)")
                }
            }
            .pickerStyle(.automatic)
            List {
                if geocaches.count == 0 {
                    Text(downloadingCaches ? "Loading geocaches..." : "No geocaches found 😥")
                }
                ForEach(geocaches, id: \.id) { geocache in
                    NavigationLink {
                        GeocacheDetailView(cache: geocache)
                    } label: {
                        GeocacheView(geocache: geocache, location: $location)
                    }
                }
            }
            .navigationTitle("Nearby Geocaches")
            .modifier(Refreshable(cb: {
                Task.init {
                    if location != nil {
                        geocaches = []
                        downloadingCaches = true
                        (geocaches, success) = await getGeocachesFromJSON(centeredAt: location!, radius: 10000, maxNumber: 100)
                        downloadingCaches = false
                    }
                }
            }))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        Task.init {
                            if location != nil {
                                geocaches = []
                                downloadingCaches = true
                                (geocaches, success) = await getGeocachesFromJSON(centeredAt: location!, radius: 10000, maxNumber: 100)
                                downloadingCaches = false
                            }
                        }
                    } label: {
                        Text("Reload")
                    }
                }
            }
            .onChange(of: sort) { _ in
                sortGeocaches()
            }
            .onAppear {
                delegate = LocationDelegate()
                delegate?.addCallback {
                    heading = delegate?.lastHeading
                    location = delegate?.lastLocation
                    if location != nil && !requestedCaches && geocaches == [] {
                        requestedCaches = true
                        Task.init {
                            downloadingCaches = true
                            (geocaches, success) = await getGeocachesFromJSON(centeredAt: location!, radius: 10000, maxNumber: 100)
                            downloadingCaches = false
                        }
                    }
                }
            }
        }
    }
}

struct GeocacheListView_Previews: PreviewProvider {
    static var previews: some View {
        GeocacheListView(geocaches: .constant([GeocacheView(location: .constant(nil)).geocache]))
    }
}
