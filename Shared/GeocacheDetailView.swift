//
//  GeocacheDetailView.swift
//  WatchyGPS
//
//  Created by Ben Goldberg on 7/17/22.
//

import SwiftUI

extension Int {
    func toStringTruncated() -> String {
        let length = "\(self)".count
        var str = ""
        if length > 3 {
            let power = pow(10, Double(length-1))
            var suffix = ""
            switch length-1 {
            case 3:
                suffix = "k"
                break
            case 6:
                suffix = "m"
                break
            case 9:
                suffix = "b"
                break
            case 12:
                suffix = "t"
                break
            default:
                suffix = ""
                break
            }
            let truncatedSelf = Double(self)/power
            if suffix != "" {
                str = "\(Int(round(truncatedSelf)))\(suffix)"
            } else {
                if Int(round(truncatedSelf)) != 10 {
                    str = "\(Int(round(truncatedSelf)))e\(length-1)"
                } else {
                    str = "1e\(length)"
                }
            }
        } else {
            str = "\(self)"
        }
        return str
    }
}

#if os(iOS)
import UIKit
import WebKit
// https://developer.apple.com/forums/thread/653935
struct WebView: UIViewRepresentable {
  @Binding var text: String
   
  func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }
   
  func updateUIView(_ uiView: WKWebView, context: Context) {
    uiView.loadHTMLString(text, baseURL: nil)
  }
}
#endif

struct GeocacheDetailView: View {
    @State private var logs: [Log] = []
    @State private var details: GeocacheDetails = GeocacheDetails()
    @State private var gotDetails: Bool = false
    var cache: Geocache = Geocache(id: 5, name: "Endangered Geocacheeeeeeeeeeeabcdefghijklmnopqrstuvwxyz123456789 long geocache name", code: "GC4ZYQ3", premiumOnly: false, favoritePoints: 999, geocacheType: 2, containerType: 3, difficulty: 1.5, terrain: 2.5, userFound: true, userDidNotFind: false, cacheStatus: 0, postedCoordinates: Coordinates(latitude: 1.5, longitude: 1.5), detailsUrl: "%*@(%&@&_@84018!!!!!4375028.....:", hasGeotour: true, hasLogDraft: true, placedDate: "date1", owner: Owner(code: "abc", username: "def"), lastFoundDate: "2022-03-27T14:05:22", trackableCount: 5, region: "NC", country: "US", attributes: [Attribute(id: 5, name: "hi", isApplicable: true)], hasCallerNote: true, distance: "5", bearing: "E")
    @State private var hintTapped: Bool = false
    @State private var idx: Int = 1
    @State private var trackables: [Trackable] = []
    var body: some View {
        ScrollView {
            VStack {
                Text(cache.name)
                    .font(.headline)
                HStack {
                    Text(GeocacheType(rawValue: cache.geocacheType)?.getString() ?? "")
                        .padding()
                        .background(GeocacheIcon(type: GeocacheType(rawValue: cache.geocacheType) ?? .Mystery).type.getIcon().1)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .font(.system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize, weight: .light, design: .monospaced))
                        .lineLimit(1)
                        .fixedSize()
                        .foregroundColor(.gray)
                    Spacer()
                    Text(cache.code)
                        .font(.system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize, weight: .light, design: .monospaced))
                        .lineLimit(1)
                        .fixedSize()
                        .foregroundColor(.gray)
                }
                HStack {
                    Text("\(ContainerType(rawValue: cache.containerType)?.getString() ?? "")")
                        .padding(.trailing, 2)
                        .fixedSize()
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Spacer()
                    HStack(spacing: 1) {
                        Image(systemName: "questionmark")
                            .padding(.trailing, 1)
                        Text("\(String(format: "%.1f", cache.difficulty))")
                            .padding(.trailing, 2)
                            .fixedSize()
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    Spacer()
                    HStack(spacing: 1) {
                        Image(systemName: "triangle") // TODO replace with mountain
                            .padding(.trailing, 1)
                            .fixedSize()
                            .lineLimit(1)
                        Text("\(String(format: "%.1f", cache.terrain))")
                            .minimumScaleFactor(0.8)
                    }
                    Spacer()
                    HStack(spacing: 1) {
                        Image(systemName: "ladybug")
                            .padding(.trailing, 1)
                            .fixedSize()
                            .lineLimit(1)
                        Text("\(cache.trackableCount)")
                            .minimumScaleFactor(0.8)
                    }
                    Spacer()
                    HStack(spacing: 1) {
                        Image(systemName: "heart")
                            .padding(.trailing, 1)
                            .fixedSize()
                            .lineLimit(1)
                        Text("\(cache.favoritePoints.toStringTruncated())")
                            .minimumScaleFactor(0.6)
                    }
                }
                .font(.footnote)
                .lineLimit(1)
                .foregroundColor(.gray)
                HStack {
                    Image(systemName: "safari") // TODO replace with legal symbol
                        .padding(.trailing, 1)
                        .fixedSize()
                        .lineLimit(1)
                        .foregroundColor(.gray)
                    Text("\(String(format: "%.7f", cache.safePostedCoordinates.latitude)),\(String(format: "%.7f", cache.safePostedCoordinates.longitude))")
                        .font(.system(size: UIFont.preferredFont(forTextStyle: .footnote).pointSize, weight: .medium, design: .monospaced))
                        .lineLimit(1)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding([.top, .bottom], 1)
#if os(iOS)
                .onTapGesture(count: 1, perform: {
                    UIPasteboard.general.string = "\(String(format: "%.7f", cache.safePostedCoordinates.latitude)),\(String(format: "%.7f", cache.safePostedCoordinates.longitude))"
                })
#endif
                HStack {
                    if cache.userDidNotFind ?? false {
                        SadFace()
                            .frame(minWidth: 16, minHeight: 16)
                            .fixedSize()
                    }
                    if cache.userFound ?? false {
                        Smiley()
                            .frame(minWidth: 16, minHeight: 16)
                            .fixedSize()
                    }
                    Spacer()
                    Text("Last Find: \(cache.lastFoundDate[cache.lastFoundDate.startIndex..<cache.lastFoundDate.index(cache.lastFoundDate.startIndex, offsetBy: 10)].description)")
                }
                .font(.footnote)
                .lineLimit(1)
                .foregroundColor(.gray)
                NavigationLink {
                    TrackableListView(trackables: $trackables)
                } label: {
                    Text("Trackables!")
                }
                Group {
                    if gotDetails {
                        #if os(iOS)
                        Text("double-tap to copy")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        #endif
                        Text(details.description)
                            .font(.body)
                            .padding(.bottom)
                        #if os(iOS)
                            .onTapGesture(count: 2, perform: {
                                UIPasteboard.general.string = details.description
                            })
                        #endif
                        Text("\(details.hint)")
                            .font(.body)
                            .padding()
                            .background(Rectangle().foregroundColor(.gray))
                            .cornerRadius(8)
                            .foregroundColor(hintTapped ? .white : .gray)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    hintTapped.toggle()
                                }
                            }
                            .animation(.easeInOut, value: hintTapped)
                        VStack {
                            ForEach(logs, id: \.LogGuid) { log in
                                LogView(log: log)
                            }
                            Button {
                                Task.init {
                                    logs.append(contentsOf: try await details.getLogs(idx))
                                    idx += 1
                                }
                            } label: {
                                Text("More Logs")
                            }
                        }
                    } else {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                }
                .padding(.top)
            }
            .padding()
            .onAppear {
                Task.init {
                    print("Retrieving \(URL(string: "https://www.geocaching.com\(cache.detailsUrl)") ?? URL(string: "http://localhost/TestGeocacheDetails.html")!)")
                    details = try await getDetails(url: URL(string: "https://www.geocaching.com\(cache.detailsUrl)") ?? URL(string: "http://localhost/TestGeocacheDetails.html")!)
                    if logs == [] {
                        idx = 1
                        logs = try await details.getLogs(idx)
                        idx += 1
                    }
                    print("Retrieved")
                    gotDetails = true
                    print("https://www.geocaching.com/track/search.aspx?code=\(cache.code)")
                    trackables = try await getTBs(url: URL(string: "https://www.geocaching.com/track/search.aspx?code=\(cache.code)")!)
                }
            }
            .toolbar {
                ToolbarItem {
                    NavigationLink {
                        CompassView(lat: String(cache.safePostedCoordinates.latitude), lon: String(cache.safePostedCoordinates.longitude))
                    } label: {
                        Image(systemName: "mappin.circle.fill")
                    }
                }
            }
            .navigationTitle("Details")
        }
    }
}

struct GeocacheDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GeocacheDetailView()
    }
}
