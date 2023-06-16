//
//  GeocacheMapView.swift
//  WatchyGPS
//
//  Created by Ben Goldberg on 7/17/22.
//

import SwiftUI
import MapKit

// https://stackoverflow.com/a/70628566
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

#if os(iOS)
class Delegate: NSObject, MKMapViewDelegate {
    var mv: MKMapView
    var tileRenderer: MKTileOverlayRenderer
    init(_mv: MKMapView) {
        mv = _mv
        // 1
        let template = "https://maptiles.geocaching.com/tile/bright-gc/{z}/{x}/{y}@2x.png"

        // 2
        let overlay = MKTileOverlay(urlTemplate: template)

        // 3
        overlay.canReplaceMapContent = true

        // 4
        MKMapView.appearance().addOverlay(overlay, level: .aboveLabels)

        //5
        tileRenderer = MKTileOverlayRenderer(tileOverlay: overlay)
    }
    func mapView(
      _ mapView: MKMapView,
      rendererFor overlay: MKOverlay
    ) -> MKOverlayRenderer {
      return tileRenderer
    }
}
#endif

struct GeocacheMapView: View {
    @State var delegate: LocationDelegate?
    @State var heading: CLHeading? = nil
    @State var location: CLLocation? = nil
    @Binding var geocaches: [Geocache]
    @State var success: Bool = true
    @State var requestedCaches: Bool = false
    @State var downloadingCaches: Bool = false
    @State private var hasRegion: Bool = false
    @StateObject var regionWrapper = RegionWrapper()
    var body: some View {
        Group {
            ZStack {
                if !hasRegion {
                    Map(coordinateRegion: regionWrapper.region, interactionModes: .all, showsUserLocation: true, annotationItems: geocaches) { geocache in
                        MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: geocache.postedCoordinates.latitude, longitude: geocache.postedCoordinates.longitude)) {
                            NavigationLink {
                                GeocacheDetailView(cache: geocache)
                            } label: {
                                if geocache.userFound ?? false {
                                    Smiley()
                                        .frame(width: 32, height: 32)
                                } else if geocache.userDidNotFind ?? false {
                                    SadFace()
                                        .frame(width: 32, height: 32)
                                } else {
                                    GeocacheIcon(type: GeocacheType(rawValue: geocache.geocacheType) ?? .Mystery, size: 32)
                                }
                            }
                        }
                    }
                    .onAppear {
#if os(iOS)
                        MKMapView.appearance().delegate = Delegate(_mv: MKMapView.appearance())
#endif
                    }
                }
                VStack {
                    HStack {
                        Text("Reload")
                            .foregroundColor(.primary)
                            .padding()
                            .background(Color.gray.opacity(0.75))
                            .cornerRadius(8)
                            .padding()
                            .onTapGesture {
                                Task.init {
                                    downloadingCaches = true
                                    (geocaches, success) = await getGeocachesFromJSON(centeredAt: regionWrapper.region.wrappedValue.center, radius: 10000, maxNumber: 100)
                                    downloadingCaches = false
                                }
                            }
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.75))
                                .frame(width: 32, height: 32)
                            Circle()
                                .stroke(Color.white, lineWidth: 3)
                                .frame(width: 32, height: 32)
                            Capsule()
                                .frame(width: 3, height: 12)
                                .padding(.bottom, 12)
                                .rotationEffect(Angle.degrees(heading?.trueHeading ?? 0))
                                .foregroundColor(.white)
                        }
                    }
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

struct GeocacheMapView_Previews: PreviewProvider {
    static var previews: some View {
        GeocacheMapView(geocaches: .constant([]))
    }
}
