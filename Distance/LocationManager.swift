//
//  LocationManager.swift
//  Distance
//
//  Created by Tanuj Girish on 10/7/17.
//  Copyright © 2017 Tanuj Girish. All rights reserved.
//

import CoreLocation
import UIKit
import Firebase

public class LocationManager: NSObject {
    
    internal let locationManager = CLLocationManager()
    internal var handlerLocation: ((CLLocation?) -> Void)?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
    }
    
    public class var shared: LocationManager {
        get {
            struct Single {
                static var shared = LocationManager()
            }
            return Single.shared
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    public func getLocation(_ handler: @escaping (_ location: CLLocation?) -> Void) {
        self.handlerLocation = nil
        self.handlerLocation = handler
        self.locationManager.requestLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.handlerLocation != nil {
            self.handlerLocation?(locations[0])
        }
        self.locationManager.stopUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        if self.handlerLocation != nil {
            self.handlerLocation?(nil)
        }
        
        self.locationManager.stopUpdatingLocation()
    }
}
