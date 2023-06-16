//
//  LocationDelegate.swift
//  WatchyGPS
//
//  Created by Ben Goldberg on 7/13/22.
//

import Foundation
import CoreLocation

var locationManager: CLLocationManager?

class LocationDelegate: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    public var lastLocation: CLLocation?
    public var lastHeading: CLHeading?
    public var callbacks: [() -> Void] = []
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = 1
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingHeading()
        locationManager?.startUpdatingLocation()
    }
    
    func addCallback(_ cb: @escaping () -> Void) {
        callbacks.append(cb)
    }
    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last!
        for cb in callbacks {
            cb()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        lastHeading = newHeading
        for cb in callbacks {
            cb()
        }
    }
}
