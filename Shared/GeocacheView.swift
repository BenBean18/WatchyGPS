//
//  GeocacheView.swift
//  WatchyGPS
//
//  Created by Ben Goldberg on 7/14/22.
//

import SwiftUI
import CoreLocation
#if canImport(UIKit)
import UIKit
#endif

struct GeocacheView: View {
    var geocache: Geocache = Geocache(id: 5, name: "Endangered Geocacheeeeeeeee", code: "GC4ZYQ3", premiumOnly: false, favoritePoints: 1, geocacheType: 2, containerType: 3, difficulty: 1.5, terrain: 2.5, userFound: true, userDidNotFind: false, cacheStatus: 0, postedCoordinates: Coordinates(latitude: 1.5, longitude: 1.5), detailsUrl: "abcd", hasGeotour: true, hasLogDraft: true, placedDate: "date1", owner: Owner(code: "abc", username: "def"), lastFoundDate: "date2", trackableCount: 5, region: "NC", country: "US", attributes: [Attribute(id: 5, name: "hi", isApplicable: true)], hasCallerNote: true, distance: "5", bearing: "E")
    @Binding var location: CLLocation?
    var distanceString: String {
        get {
            let distance = distanceInMeters(from: location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), to: CLLocationCoordinate2D(latitude: geocache.postedCoordinates.latitude, longitude: geocache.postedCoordinates.longitude))
            return getDistanceString(distance: distance)
        }
    }
    #if os(iOS)
    let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    #endif
    #if os(watchOS)
    let screenWidth: CGFloat = WKInterfaceDevice.current().screenBounds.size.width
    #endif
    var body: some View {
        HStack {
            GeocacheIcon(type: GeocacheType(rawValue: geocache.geocacheType) ?? .Mystery)
            VStack(alignment: .leading) {
                HStack(spacing: 1) {
                    Text(geocache.code)
                        .padding(.trailing, 2)
                        .font(.system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.75, weight: .light, design: .rounded))
                    Text(ContainerType(rawValue: geocache.containerType)?.getString() ?? "")
                        .padding(.trailing, 2)
                    Image(systemName: "heart")
                        .padding(.trailing, 1)
                    Text(geocache.favoritePoints.toStringTruncated())
                        .padding(.trailing, 2)
                }
                    .fixedSize()
                    .lineLimit(1)
                    .font(.system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.75, weight: .regular, design: .rounded))
                Text(geocache.name)
                    .font(.system(.headline, design: .rounded))
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                HStack(spacing: 1) {
                    Image(systemName: "mappin.circle")
                        .padding(.trailing, 1)
                    Text(distanceString)
                        .padding(.trailing, 2)
                        .fixedSize()
                        .lineLimit(1)
                    Image(systemName: "questionmark")
                        .padding(.trailing, 1)
                    Text("\(String(format: "%.1f", geocache.difficulty))")
                        .padding(.trailing, 2)
                        .fixedSize()
                        .lineLimit(1)
                    Image(systemName: "triangle") // TODO replace with mountain
                        .padding(.trailing, 1)
                        .fixedSize()
                        .lineLimit(1)
                    Text("\(String(format: "%.1f", geocache.terrain))")
                        .padding(.trailing, 2)
                        .fixedSize()
                        .lineLimit(1)
                    Image(systemName: "ladybug")
                        .padding(.trailing, 1)
                        .fixedSize()
                        .lineLimit(1)
                    Text("\(geocache.trackableCount)")
                        .padding(.trailing, 2)
                        .fixedSize()
                        .lineLimit(1)
                }
                .font(.system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize * 0.8, weight: .regular, design: .rounded))
                .minimumScaleFactor(0.8)
            }
            Spacer()
        }
    }
}

struct GeocacheView_Previews: PreviewProvider {
    static var previews: some View {
        GeocacheView(location: .constant(nil))
    }
}
