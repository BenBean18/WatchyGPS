//
//  GeocacheMapView.swift
//  WatchyGPS
//
//  Created by Ben Goldberg on 7/17/22.
//

import SwiftUI
import MapKit

class RegionWrapper: ObservableObject {
    var _region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 30, longitude: -90),
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    
    var region: Binding<MKCoordinateRegion> {
        Binding(
            get: { self._region },
            set: { self._region = $0 }
        )
    }
    
    @Published var flag = false
}

struct MapProvider: Hashable, Equatable {
    var url: String
    var name: String
    var scaleFactor: CGFloat
    var maxZoom: Int
}

struct GCIcon: View, Equatable {
    static func == (lhs: GCIcon, rhs: GCIcon) -> Bool {
        return lhs.gc == rhs.gc
    }
    
    var gc: Geocache
    @Binding var detailView: GeocacheDetailView?
    @Binding var showDetailView: Bool
    var body: some View {
        Group{if gc.userFound ?? false {
            Smiley()
                .frame(width: 32, height: 32)
        } else if gc.userDidNotFind ?? false {
            SadFace()
                .frame(width: 32, height: 32)
        } else {
            GeocacheIcon(type: GeocacheType(rawValue: gc.geocacheType) ?? .Mystery, size: 32)
        }
            /*}*/}
            .padding()
            .contentShape(Rectangle())
            .drawingGroup()
            .onTapGesture {
                print("Showing detail view")
                detailView = GeocacheDetailView(cache: gc)
                showDetailView = true
            }
    }
}

struct Annotation {
    var gc: Geocache?
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        if lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude {
            return true
        }
        return false
    }
}

struct GeocacheMapView: View {
    @State var delegate: LocationDelegate?
    @State var heading: CLHeading? = nil
    @State var location: CLLocation? = nil
    @Binding var geocaches: [Geocache]
    @State var success: Bool = true
    @State var requestedCaches: Bool = false
    @State var downloadingCaches: Bool = false
    @State private var hasRegion: Bool = false
    @State var center: CLLocationCoordinate2D = CLLocationCoordinate2D()
    @State var z: CGFloat = 16
    @StateObject var regionWrapper = RegionWrapper()
    @State var detailView: GeocacheDetailView? = nil
    @State var showDetailView: Bool = false
    @State var settingsPresented: Bool = false
    @State var maxGeocaches: Double = 100
    @State var caching: Bool = false
    @State var cacheCleared: Bool = false
    var body: some View {
        Group {
            ZStack {
                if !hasRegion {
                    NavigationLink(destination: detailView, isActive: $showDetailView, label: { EmptyView() })
                        .hidden()
                    MapView(annotationItems: geocaches.map { geocache in MapTileAnnotation(coords: CLLocationCoordinate2D(latitude: geocache.postedCoordinates.latitude, longitude: geocache.postedCoordinates.longitude), data: geocache) }, z: $z, center: $center, userLocation: $location, userHeading: $heading, caching: $caching) { annot in
                        GCIcon(gc: annot.data as! Geocache, detailView: $detailView, showDetailView: $showDetailView)
//                        AnyView(//NavigationLink {
//                            //GeocacheDetailView(cache: annot.data as! Geocache)
//                        //} label: {
//                            Group{if (annot.data as! Geocache).userFound ?? false {
//                                Smiley()
//                                    .frame(width: 32, height: 32)
//                            } else if (annot.data as! Geocache).userDidNotFind ?? false {
//                                SadFace()
//                                    .frame(width: 32, height: 32)
//                            } else {
//                                GeocacheIcon(type: GeocacheType(rawValue: (annot.data as! Geocache).geocacheType) ?? .Mystery, size: 32)
//                            }
//                                /*}*/}
//                                .padding()
//                                .contentShape(Rectangle())
//                                .onTapGesture {
//                                    print("Showing detail view")
//                                    detailView = GeocacheDetailView(cache: annot.data as! Geocache)
//                                    showDetailView = true
//                                })
                    }
                    .onAppear {
                        // z = findMaxZoom(CLLocationCoordinate2D(latitude: center.latitude - 10000 * m, longitude: center.longitude - 10000 * m), CLLocationCoordinate2D(latitude: center.latitude + 10000 * m, longitude: center.longitude + 10000 * m), tileLimit: 16)
                    }
                }
                VStack {
                    HStack {
                        Text("R")
                            .font(.footnote)
                            .foregroundColor(.primary)
                            .padding()
                            .background(Color.gray.opacity(0.75))
                            .cornerRadius(8)
                            .onTapGesture {
                                Task.init {
                                    downloadingCaches = true
                                    (geocaches, success) = await getGeocachesFromJSON(centeredAt: center, radius: 10000, maxNumber: Int(round(maxGeocaches)))
                                    downloadingCaches = false
                                }
                            }
                        Spacer()
                        Text("\(cacheCleared ? "! " : "")C \(caching ? "on" : "off")")
                            .font(.footnote)
                            .foregroundColor(.primary)
                            .padding()
                            .background(Color.gray.opacity(0.75))
                            .cornerRadius(8)
                            .onTapGesture {
                                caching = !caching
                                cacheCleared = false
                            }
                            .onLongPressGesture {
                                cacheCleared = TileCache.shared.clearTileCache()
                            }
                        Button {
                            settingsPresented = true
                        } label: {
                            Image(systemName: "gear")
                                .font(.footnote)
                                .foregroundColor(.primary)
                                .padding()
                        }
                        .padding(-5)
                        .background(Color.gray.opacity(0.75))
                        .clipShape(Circle())
                        .clipped()
                        Button {
                            withAnimation {
                                if location != nil {
                                    center = location!.coordinate
                                }
                            }
                        } label: {
                            Image(systemName: "location.circle.fill")
                                .font(.footnote)
                                .foregroundColor(.primary)
                                .padding()
                        }
                        .padding(-5)
                        .background(Color.gray.opacity(0.75))
                        .clipShape(Circle())
                        .clipped()
                            .sheet(isPresented: $settingsPresented) {
                                VStack {
                                    Picker("Tile Server", selection: Binding<MapProvider>(get: {
                                        return MapProvider(url: MAP_PROVIDER.url, name: MAP_PROVIDER.name, scaleFactor: MAP_PROVIDER.scaleFactor, maxZoom: MAP_PROVIDER.maxZoom)
                                    }, set: { pr in
//                                        MAP_PROVIDER.url = pr.url
//                                        scaleFactor = pr.scaleFactor
//                                        MAP_PROVIDER.maxZoom = pr.maxZoom
                                        MAP_PROVIDER = pr
                                    }), content: {
                                        Text("GC.com").tag(MapProvider(url: "https://maptiles.geocaching.com/tile/{z}/{x}/{y}@2x.png", name: "GC.com", scaleFactor: 2, maxZoom: 17))
                                        Text("OSM").tag(MapProvider(url: "https://tile.openstreetmap.org/{z}/{x}/{y}.png", name: "OSM", scaleFactor: 1, maxZoom: 19))
                                        Text("Carto Dark").tag(MapProvider(url: "https://basemaps.cartocdn.com/dark_all/{z}/{x}/{y}@2x.png", name: "Carto Dark", scaleFactor: 2, maxZoom: 30))
                                        Text("Watercolor").tag(MapProvider(url: "http://tile.stamen.com/watercolor/{z}/{x}/{y}.jpg", name: "Watercolor", scaleFactor: 1, maxZoom: 17))
                                        Text("Google Maps").tag(MapProvider(url: "https://mts1.google.com/vt/lyrs=r&x={x}&y={y}&z={z}&scale=2", name: "Google Maps", scaleFactor: 2, maxZoom: 21))
                                        Text("Google Maps (Satellite)").tag(MapProvider(url: "https://mts1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}&scale=2", name: "Google Maps (Satellite)", scaleFactor: 2, maxZoom: 21)) // definitely authorized (sheepish smile). use at own risk
                                        Text("Google Maps (Satellite) w/ Traffic").tag(MapProvider(url: "https://mts1.google.com/vt/lyrs=y,traffic,bike&x={x}&y={y}&z={z}&scale=2", name: "Google Maps (Satellite) w/ Traffic", scaleFactor: 2, maxZoom: 21)) // definitely authorized (sheepish smile). use at own risk
                                        Text("The Duck Map").tag(MapProvider(url: "https://m.media-amazon.com/images/I/51VXgNZFIoL._AC_SX522_.jpg", name: "The Duck Map", scaleFactor: 2, maxZoom: 20))
                                    })
                                    HStack {
                                        Text("Custom URL")
                                            .minimumScaleFactor(0.5)
                                        TextField("URL", text: Binding<String>(get: {
                                            return MAP_PROVIDER.url
                                        }, set: { url in
                                            Task.init {
                                                do {
                                                    let tile = Tile(x: 0, y: 0, z: 0)
                                                    let u = URL(string: url.replacingOccurrences(of: "{z}", with: "\(tile.z)").replacingOccurrences(of: "{x}", with: "\(tile.x)").replacingOccurrences(of: "{y}", with: "\(tile.y)"))
                                                    if u != nil {
                                                        let data = try await getData(url: u!)
                                                        let uiIm = UIImage(data: data.1, scale: 1)
                                                        MAP_PROVIDER.scaleFactor = (uiIm?.size.width ?? 256) / TILE_SIZE
                                                        MAP_PROVIDER.url = url
                                                    } else {
                                                        // url invalid, do nothing
                                                    }
                                                } catch {
                                                    // url is likely invalid, do nothing
                                                }
                                            }
                                        }))
                                        .font(.system(.body, design: .monospaced))
                                    }
                                    Slider(value: $maxGeocaches, in: 0...300)
                                }
                            }
                    }
                    .padding(.top)
                    if !success {
                        Text("Rate limit exceeded!")
                            .foregroundColor(.primary)
                            .padding()
                            .background(Color.red.opacity(0.5))
                            .cornerRadius(8)
                    }
                    Spacer()
                }
                .padding()
                VStack {
                    HStack {
                        Spacer()
                        
                    }
                    Spacer()
                }
            }
        }
        .onAppear {
            delegate = LocationDelegate()
            delegate?.addCallback {
                heading = delegate?.lastHeading
                location = delegate?.lastLocation
                if location != nil {
                    if !requestedCaches {
                        regionWrapper.region.wrappedValue = MKCoordinateRegion(center: location!.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
                        center = location!.coordinate
                        withAnimation {
                            regionWrapper.flag.toggle()
                        }
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
        .onDisappear {
            delegate?.callbacks = []
        }
    }
}

struct GeocacheMapView2_Previews: PreviewProvider {
    static var previews: some View {
        GeocacheMapView(geocaches: .constant([]))
    }
}
