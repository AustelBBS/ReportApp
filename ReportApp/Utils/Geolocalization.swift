//
//  Geolocalization.swift
//  ReportApp
//
//  Created by DonauMorgen on 07/05/18.
//  Copyright © 2018 Los Ponis. All rights reserved.
//

import Foundation
import CoreLocation

class Geolocalization {
    
    let mLocationManager = CLLocationManager()
    var mCurrentLocation : CLLocation?
    
    func requestLocation() {
        mLocationManager.requestWhenInUseAuthorization()
    }
    
    func requestCoords() -> CLLocation {
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
            mCurrentLocation = mLocationManager.location
            return mCurrentLocation!
        } else {
            mCurrentLocation = mLocationManager.location
            return mCurrentLocation!
        }
    }
    
}
