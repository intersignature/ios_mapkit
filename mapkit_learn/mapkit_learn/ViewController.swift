//
//  ViewController.swift
//  mapkit_learn
//
//  Created by Sirichai Binchai on 8/7/2561 BE.
//  Copyright © 2561 Sirichai Binchai. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mMapView: MKMapView!
    @IBOutlet weak var speedLb: UILabel!
    
    var mLocationManager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        goToCenterLocation()
        let myLocation: CLLocation = locations[0] as CLLocation
        let latitude: CLLocationDegrees = myLocation.coordinate.latitude
        let longtitude:CLLocationDegrees = myLocation.coordinate.longitude
        
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longtitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        mMapView.setRegion(region, animated: true)
        mMapView.mapType = .hybrid
        mMapView.showsCompass = true
        mMapView.showsScale = true
        
        let speed = myLocation.speed * 3.6
        speedLb.text = "\(speed) km/hr"
    }
    
    func goToCenterLocation() {
        if let locMan = mLocationManager.location {
            let region = MKCoordinateRegionMakeWithDistance(locMan.coordinate, 400, 400)
            mMapView.setRegion(region, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mLocationManager.delegate = self
        mLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        mMapView.delegate = self
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse &&
            CLLocationManager.authorizationStatus() != .authorizedAlways {
            mLocationManager.requestWhenInUseAuthorization()
        }
        
        mMapView.showsUserLocation = true
        mLocationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
