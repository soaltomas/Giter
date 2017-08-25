//
//  MapKitViewController.swift
//  Giter
//
//  Created by Артем Полушин on 25.08.17.
//  Copyright © 2017 Артем Полушин. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapKitViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager  =  CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last?.coordinate {
            print(currentLocation)
            let coordinate = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            let coder = CLGeocoder()
            coder.reverseGeocodeLocation(coordinate) {
                (myPlaces, Error) -> Void in
                if let place = myPlaces?.first {
                    print(place.locality)
                }
            }
            let currentRadius: CLLocationDistance = 1000
            let currentRegion = MKCoordinateRegionMakeWithDistance((currentLocation), currentRadius * 2.0, currentRadius * 2.0)
            self.mapView.setRegion(currentRegion, animated: true)
            self.mapView.showsUserLocation = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
