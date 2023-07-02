//
//  TrackableListView.swift
//  WatchyGPS
//
//  Created by Ben Goldberg on 7/2/23.
//

import SwiftUI

struct TrackableListView: View {
    @Binding var trackables: [Trackable]
    var body: some View {
        List {
            ForEach(trackables, id: \.id) { trackable in
                HStack {
                    Text(trackable.name)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Spacer()
                    Image(systemName: "map.fill")
                    if Locale.current.usesMetricSystem {        Text("\(Int(round(trackable.distance))) km")
                    } else {
                        Text("\(Int(round(trackable.distance * 0.621371))) mi")
                    }
                }
            }
        }
    }
}

struct TrackableListView_Previews: PreviewProvider {
    static var previews: some View {
        TrackableListView(trackables: .constant([Trackable(name: "&quot;Calimete, Cuba&quot; Unite for Diabetes Travel Bug", iconURL: URL(string: "https://www.geocaching.com/images/WptTypes/721.gif")!, lastLogDate: Date(), owner: Owner(code: "723bea5c-ab67-4a18-97f3-09a730af4adb", username: "____Unite for Diabetes"), location: URL(string: ""), distance: 36209.0, detailsURL: URL(string: "https://www.geocaching.com/track/details.aspx?id=859639")!)]))
            
    }
}
