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
    @IBOutlet weak var addressLb: UILabel!
    
    var latitudeDelta:CLLocationDegrees = 0.01
    var longtitudeDelta:CLLocationDegrees = 0.01
    
    
    
    @IBAction func zoomOut(_ sender: UIButton) {
        latitudeDelta = mMapView.region.span.latitudeDelta * 2
        longtitudeDelta = mMapView.region.span.longitudeDelta * 2
        
        let span = MKCoordinateSpanMake(latitudeDelta, longtitudeDelta)
        let region = MKCoordinateRegionMake(mMapView.region.center, span)
        
        mMapView.setRegion(region, animated: true)
    }
    
    @IBAction func zoomIn(_ sender: UIButton) {
        latitudeDelta = mMapView.region.span.latitudeDelta / 2
        longtitudeDelta = mMapView.region.span.longitudeDelta / 2
        
        let span = MKCoordinateSpanMake(latitudeDelta, longtitudeDelta)
        let region = MKCoordinateRegionMake(mMapView.region.center, span)
        
        mMapView.setRegion(region, animated: true)
        
    }
    
    var mLocationManager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        goToCenterLocation()
        let myLocation: CLLocation = locations[0] as CLLocation
        let latitude: CLLocationDegrees = myLocation.coordinate.latitude
        let longtitude:CLLocationDegrees = myLocation.coordinate.longitude
        
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longtitudeDelta)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longtitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        mMapView.setRegion(region, animated: true)
        mMapView.showsCompass = true
        mMapView.showsScale = true
        
        let speed = myLocation.speed * 3.6
        speedLb.text = "\(speed) km/hr"
        
        //get address
        CLGeocoder().reverseGeocodeLocation(myLocation) { (placemark, error) in
            if error == nil {
                if let placemark = placemark?.first{
                    let subthroughface = placemark.subThoroughfare != nil ? placemark.subThoroughfare : ""
                    let throughface = placemark.thoroughfare != nil ? placemark.thoroughfare : ""
                    let subLocality = placemark.subLocality != nil ? placemark.subLocality : ""
                    let locality = placemark.locality != nil ? placemark.locality : ""
                    let administrativeArea = placemark.administrativeArea != nil ? placemark.administrativeArea : ""
                    let country = placemark.country != nil ? placemark.country : ""
                    let postalCode = placemark.postalCode != nil ? placemark.postalCode : ""
                    
                    let locationAddress = "\(subthroughface!) \(throughface!) \(subLocality!) \(locality!) \(administrativeArea!) \(country!) \(postalCode!)"
                    print(locationAddress)
                    
                    self.addressLb.text = locationAddress
                }
            }
        }
    }
    
    func createAnnotationFromLocation(location: CLLocationCoordinate2D, title:String, subTitle:String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = title
        annotation.subtitle = subTitle
        mMapView.addAnnotation(annotation)
        
        
    }
    
    func getPlaceMarkFromAddress(address:String, title:String, subTitle:String) {
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            if error == nil{
                if let placemarks = placemarks?.first{
                    if let location = placemarks.location{
                        self.createAnnotationFromLocation(location: location.coordinate, title: title, subTitle: subTitle)
                    }
                }
            }
        }
    }
    
    func goToCenterLocation() {
        if let locMan = mLocationManager.location {
            let region = MKCoordinateRegionMakeWithDistance(locMan.coordinate, 400, 400)
            mMapView.setRegion(region, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self){
            return nil
        } else if annotation.isKind(of: AnnoGreen.self){
            let annoView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Default")
            annoView.pinTintColor = UIColor.green
            annoView.animatesDrop = true
            return annoView
        } else {
            let annoView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Default")
            annoView.pinTintColor = UIColor.orange
            annoView.animatesDrop = true
            return annoView
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
        
        speedLb.text = "0 km/h"
        addressLb.text = ""
        
        getPlaceMarkFromAddress(address: "KMITL", title: "KMITL TITLE", subTitle: "KMITL SUBTITLE")
        
        let TheBerkeleyHotelLocation = CLLocationCoordinate2D(latitude: 13.7498, longitude: 100.5427)
        createAnnotationFromLocation(location: TheBerkeleyHotelLocation, title: "TheBerkeleyHotel title", subTitle: "TheBerkeleyHotel subtitle")
        
        let plattinum2Location = CLLocationCoordinate2D(latitude: 13.75055, longitude: 100.54108)
        let plattinum2Anno = AnnoGreen(coordinate: plattinum2Location)
        mMapView.addAnnotation(plattinum2Anno)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

