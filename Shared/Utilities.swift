//
//  Utilities.swift
//  WatchyGPS
//
//  Created by Ben Goldberg on 7/13/22.
//

import Foundation
import CoreLocation
import UIKit

// heading code from https://stackoverflow.com/a/3809269
func getHeading(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
    let dy = to.latitude - from.latitude
    let dx = cos(from.latitude * Double.pi/180.0) * (to.longitude - from.longitude)
    let angle = atan2(dy, dx)
    return wrapAroundAngle(angle: -angle * 180.0 / Double.pi + 90.0)
}
// end of heading code

func wrapAroundAngle(angle: Double) -> Double {
    let mod = angle.truncatingRemainder(dividingBy: 360)
    if mod < 0 {
        return 360 + mod
    }
    return mod
}

func adjustHeadingForOrientation(angle: Double, heading: CLHeading) -> Double {
    return angle - heading.trueHeading
}

func fontSize(_ style: UIFont.TextStyle) -> CGFloat {
    return UIFont.preferredFont(forTextStyle: style).pointSize
}

// https://stackoverflow.com/a/365853
func distanceInMeters(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
    let R = 6371000.0
    let dy = (to.latitude - from.latitude) * Double.pi / 180.0
    let dx = (to.longitude - from.longitude) * Double.pi / 180.0
    let y1 = from.latitude * Double.pi / 180.0
    let y2 = to.latitude * Double.pi / 180.0
    let a = sin(dy/2) * sin(dy/2) + sin(dx/2) * sin(dx/2) * cos(y1) * cos(y2)
    let c = 2 * atan2(sqrt(a), sqrt(1-a))
    return R * c
}

// https://stackoverflow.com/questions/58782245/how-to-figure-out-the-width-of-a-string-dynamically-in-swiftui
extension String {
   func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    func heightOfString(usingFont font: UIFont) -> CGFloat {
         let fontAttributes = [NSAttributedString.Key.font: font]
         let size = self.size(withAttributes: fontAttributes)
         return size.height
     }
}

func getDistanceString(distance: Double) -> String {
    let useMeters = false
    let feet: Double = distance * 3.28084
    let miles: Double = feet / 5280.0
    if useMeters {
        if distance < 1000 {
            return "\(String(format: "%.0f", distance))m"
        } else {
            return "\(String(format: "%.2f", distance))km"
        }
    } else {
        if miles < 0.1 {
            return "\(String(format: "%.0f", feet))ft"
        } else {
            return "\(String(format: "%.2f", miles))mi"
        }
    }
}
