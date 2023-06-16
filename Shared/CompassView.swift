//
//  CompassView.swift
//  WatchyGPS
//
//  Created by Ben Goldberg on 7/13/22.
//

import SwiftUI
import CoreLocation

struct CompassView: View {
    @Environment(\.colorScheme) var colorScheme
    func getHeight(_ i : Int) -> CGFloat {
        if i % 5 == 0 {
            return 8
        }
        return 5
    }
    
    func showText(_ i : Int) -> Bool {
        return i % 30 == 0
    }
    
    func getColor(_ i : Int) -> Color {
        if i % 30 == 0 {
            return .primary
        }
        return .gray
    }
    
    func getOpacity(_ i : Int) -> Double {
        return i % 30 == 0 ? 1 : 0.5
    }
    
    func getText(_ i : Int) -> String {
        switch i {
        case 0:
            return "N"
        case 90:
            return "E"
        case 180:
            return "S"
        case 270:
            return "W"
        default:
            return ""
        }
    }
    
    func showLine(_ i : Int) -> Bool {
        return !(i % 90 < 5 || i % 90 > 85)
    }
    
    @State var delegate: LocationDelegate?
    @State var heading: CLHeading? = nil
    @State var location: CLLocation? = nil
    @State var lat: String = "45.1523667"
    @State var lon: String = "-64.79925"
    @State var angle: Double = 0
    @State var distance: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                ZStack {
                    Capsule()
                        .frame(width: 3, height: min(geometry.size.width, geometry.size.height) * 0.36)
                        .padding(.bottom, min(geometry.size.width, geometry.size.height) * 0.36 + 8)
                        .rotationEffect(Angle.degrees(angle))
                        .foregroundColor(.red)
                    Circle()
                        .stroke(AngularGradient(gradient: Gradient(stops: [Gradient.Stop(color: colorScheme == .dark ? .white : .black, location: 0), Gradient.Stop(color: colorScheme == .dark ? .white : .black, location: 0.5), Gradient.Stop(color: .red, location: 0.5), Gradient.Stop(color: .red, location: 1)]), center: .center), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .miter, miterLimit: 1, dash: [0], dashPhase: 1))
                        .frame(width: 10, height: 10)
                        .rotationEffect(Angle.degrees(angle))
                    Capsule()
                        .frame(width: 3, height: min(geometry.size.width, geometry.size.height) * 0.36)
                        .padding(.top, min(geometry.size.width, geometry.size.height) * 0.36 + 8)
                        .rotationEffect(Angle.degrees(angle))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
                .rotationEffect(-Angle.degrees( heading?.trueHeading ?? 0))
                Text(getDistanceString(distance: distance))
                    .font(.system(.body, design: .rounded))
                    .padding(.top, 50)
                ForEach(0..<360, id: \.self) { i in
                    VStack(spacing: 3) {
                        if getText(i) != "" {
                            Text(getText(i))
                                .font(.system(size: fontSize(.footnote) / 1.25, weight: .regular, design: .rounded))
                                .foregroundColor(.primary)
                                .frame(height: getHeight(i))
                        }
                        if showLine(i) {
                            Capsule()
                                .frame(width: 1, height: getHeight(i))
                                .foregroundColor(getColor(i))
                                .opacity(getOpacity(i))
                        }
                        if showText(i) {
                            Text("\(i)")
                                .font(.system(size: fontSize(.footnote) / 1.5, weight: .regular, design: .rounded))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.bottom, min(geometry.size.width, geometry.size.height) * 0.98 - getHeight(i) - (showText(i) ? "180".heightOfString(usingFont: UIFont.systemFont(ofSize: fontSize(.footnote) / 1.5, weight: .regular))+3 : 0))
                    .rotationEffect(Angle.degrees(Double(i)))
                }
                .rotationEffect(-Angle.degrees( heading?.trueHeading ?? 0))
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onAppear {
                delegate = LocationDelegate()
                delegate?.addCallback {
                    print("cb")
                    heading = delegate?.lastHeading
                    location = delegate?.lastLocation
                    let coord = CLLocationCoordinate2D(latitude: Double(lat) ?? 0, longitude: Double(lon) ?? 0)
                    angle = getHeading(from: location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), to: coord)
                    distance = distanceInMeters(from: location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), to: coord)
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct CompassView_Previews: PreviewProvider {
    static var previews: some View {
        CompassView()
            
            
    }
}
