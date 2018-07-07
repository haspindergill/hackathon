//
//  LocationManager.swift
//
//
//  Created by cbl16 on 9/28/16.
//  Copyright © 2016 Haspinder. All rights reserved.
//

import UIKit
import Foundation
import UIKit
import CoreLocation

struct Location : CustomStringConvertible {
    var current_lat : String?
    var current_lng : String?
    var current_formattedAddr : String?
    var current_city : String?
    var current_state : String?
    var current_locality : String?
    var current_country : String?

    var description: String{
        return ""
       // return UtilityFunctions.appendOptionalStrings(withArray: [current_formattedAddr])
    }
}

class LocationManager: NSObject  {
    static let sharedInstance: LocationManager = { LocationManager() }()
    
    typealias locationServicesEnabledStatus = (AnyObject,AnyObject) -> ()


    
    var currentLocation : Location? = Location()
    var GetCoordinate : CLLocation?
    let locationManager = CLLocationManager()
    

    
    func startTrackingUser(){
            self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
    }
    
}

extension LocationManager : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.authorizedWhenInUse || status == CLAuthorizationStatus.authorizedAlways {
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        GetCoordinate = locations.last
        
        guard let firstLocation = locations.first else{return}
        CLGeocoder().reverseGeocodeLocation(firstLocation) {[unowned self] (placemarks, error) in
            self.currentLocation?.current_lat = "\(firstLocation.coordinate.latitude)"
            self.currentLocation?.current_lng = "\(firstLocation.coordinate.longitude)"
            guard let bestPlacemark = placemarks?.first else{return}
            //print(bestPlacemark.country)
            self.currentLocation?.current_country = bestPlacemark.country
            self.currentLocation?.current_city = bestPlacemark.locality
            self.currentLocation?.current_state = bestPlacemark.administrativeArea
            self.currentLocation?.current_locality = bestPlacemark.subLocality

        //    self.currentLocation?.current_formattedAddr = UtilityFunctions.appendOptionalStrings(withArray: [bestPlacemark.subThoroughfare , bestPlacemark.thoroughfare , bestPlacemark.locality , bestPlacemark.country])
            self.locationManager.stopUpdatingLocation()
            self.locationManager.delegate = nil
        
        }
        
    }

}
