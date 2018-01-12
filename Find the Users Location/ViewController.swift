//
//  ViewController.swift
//  Find the Users Location
//
//  Created by Joe Riggs on 1/1/18.
//  Copyright © 2018 Joe Riggs. All rights reserved.
//


/* This program will give you the coordinates of the user's current location.  If you run it in
 * the simulator it will show you an address in San Francisco.
 *
 * In the "Build Phases" -> "Link Binary With Libraries", I added the CoreLocation.framework library.
 * In the info.plist file, I added "Privacy: Location Always and When In Use Usage Description".
 * In the info.plist file, I added "Privacy: Location WHen In Use Usage Description".
 * Added "import CoreLocation".
 * Added "CLLocationManagerDelegate" to the list of super classes for the ViewController class.
 */


import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var address1Label: UILabel!
    @IBOutlet weak var address2Label: UILabel!
    @IBOutlet weak var address3Label: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    var locationManager = CLLocationManager()
    var latLonDelta = 0.02
    let annotation = MKPointAnnotation()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    @IBAction func stepperFunc(_ sender: UIStepper) {
        latLonDelta = 1 / sender.value
        print("sender.value = \(sender.value): latLonDelta = \(latLonDelta)")
    }

    /* This function will be called with the user's location.  Note that
     * locations is an array.
     *
     * You can go to "Debug" -> "Locations" in the Simulator to select the
     * location.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        /*
        print("Latitude            = \(userLocation.coordinate.latitude)")
        print("Longitude           = \(userLocation.coordinate.longitude)")
        print("Altitude            = \(userLocation.altitude)")
        print("Horizontal Accuracy = \(userLocation.horizontalAccuracy)")
        print("Vertical Accuracy   = \(userLocation.verticalAccuracy)")
        print("Course              = \(userLocation.course)")
        print("Speed               = \(userLocation.speed)")
        print("Timestamp           = \(userLocation.timestamp)")
        if let floor = userLocation.floor?.level {
            print("Floor               = \(floor)")
        }
        */

        // Set the latitude/longitude of the center of the map.
        let latitude: CLLocationDegrees =  userLocation.coordinate.latitude
        let longitude: CLLocationDegrees = userLocation.coordinate.longitude
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        // Set the size of the map.  The smaller the number, the more it zooms.
        let latDelta: CLLocationDegrees = latLonDelta
        let lonDelta: CLLocationDegrees = latLonDelta
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        // Display the desired map location and size.
        let region = MKCoordinateRegion(center: coordinates, span: span)
        map.setRegion(region, animated: true)

        // Add an annotation to the map.
        if annotation.title != nil {
            map.removeAnnotation(annotation)
        }
        
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: geocodeCompletionHandler)

        annotation.title = "Tracker"
        annotation.subtitle = "Current location"
        annotation.coordinate = coordinates
        map.addAnnotation(annotation)
    }

    /* Called whenever there is updated map information for us to process */
    func geocodeCompletionHandler(placemarks: [CLPlacemark]?, error: Error?) -> Void {
        if let placemark = placemarks?[0] {
            if placemark.location != nil {
                let location = placemark.location!

                let altitude = location.altitude // in meters
                //print("Altitude:  \(altitude)")
                altitudeLabel.text = String(altitude)

                let coordinate = location.coordinate
                let latitude = coordinate.latitude
                let longitude = coordinate.longitude
                //print("Latitude:  \(latitude)")
                //print("Longitude: \(longitude)")
                latitudeLabel.text = String(latitude)
                longitudeLabel.text = String(longitude)

                let course = location.course // In degrees (0 = due north)
                //print("Course:    \(course)")
                if course == -1.0 {
                    courseLabel.text = "unknown"
                } else {
                    courseLabel.text = String(course)
                }

                /* Enable to get the floor number in a building.
                var floorLevel = 0
                if let floor = location.floor {
                    floorLevel = floor.level
                }
                print("Floor:     \(floorLevel)")
                */

                let speed = location.speed // Speed in meters/second.
                //print("Speed:     \(speed)")
                if speed == -1.0 {
                    speedLabel.text = "unknown"
                } else {
                    speedLabel.text = String(speed)
                }

                /* Enable to get a "timestamp".
                let timestamp = location.timestamp
                print("Timestamp: \(timestamp)")
                */
            }

            /* Enable to get the "identifier".
            var identifier = ""
            if let region = placemark.region {
                identifier = region.identifier
            }
            print("identifier: \(identifier)")
            */

            /* Enable to get the "tzIdentifier".
            var tzIdentifier = ""
            if let timeZone = placemark.timeZone {
                tzIdentifier = timeZone.identifier
            }
            print("tzIdentifier:   \(tzIdentifier)")
            */

            var name = ""
            if placemark.name != nil {
                name = placemark.name!
            }
            //print("name: \(name)")

            /* Enable to get the "thoroughfare".
            var thoroughfare = ""
            if placemark.thoroughfare != nil {
                thoroughfare = placemark.thoroughfare!
            }
            print("thoroughfare: \(thoroughfare)")
            */

            /* Enable to get the "subThoroughfare".
            var subThoroughfare = ""
            if placemark.subThoroughfare != nil {
                subThoroughfare = placemark.subThoroughfare!
            }
            print("subThoroughfare: \(subThoroughfare)")
            */
            
            var locality = ""
            if placemark.locality != nil {
                locality = placemark.locality!
            }
            //print("locality: \(locality)")

            /* Enable to get the "subLocality".
            var subLocality = ""
            if placemark.subLocality != nil {
                subLocality = placemark.subLocality!
            }
            print("subLocality: \(subLocality)")
            */

            var administrativeArea = ""
            if placemark.administrativeArea != nil {
                administrativeArea = placemark.administrativeArea!
            }
            //print("administrativeArea: \(administrativeArea)")

            /* Enable to get the "subAdministrativeArea.
            var subAdministrativeArea = ""
            if placemark.subAdministrativeArea != nil {
                subAdministrativeArea = placemark.subAdministrativeArea!
            }
            print("subAdministrativeArea: \(subAdministrativeArea)")
            */

            var postalCode = ""
            if placemark.postalCode != nil {
                postalCode = placemark.postalCode!
            }
            //print("postalCode: \(postalCode)")

            /* Enable to get the "isoCountryCode".
            var isoCountryCode = ""
            if placemark.isoCountryCode != nil {
                isoCountryCode = placemark.isoCountryCode!
            }
            print("isoCountryCode: \(isoCountryCode)")
            */

            /*
            var country = ""
            if placemark.country != nil {
                country = placemark.country!
            }
            print("country: \(country)")
            */

            /* Enable to get the "inlandWater".
            var inlandWater = ""
            if placemark.inlandWater != nil {
                inlandWater = placemark.inlandWater!
            }
            print("inlandWater: \(inlandWater)")
            */

            /* Enable to get the "ocean".
            var ocean = ""
            if placemark.ocean != nil {
                ocean = placemark.ocean!
            }
            print("ocean: \(ocean)")
            */

            /* Enable to get the "areasOfInterest.
            var areasOfInterest: [String] = [""]
            if placemark.areasOfInterest != nil {
                areasOfInterest = placemark.areasOfInterest!
            }
            print("areasOfInterest: \(areasOfInterest)")
            */

            /*
            print("===========================================")
            print("\(name)")
            print("\(locality), \(administrativeArea)")
            print("\(postalCode)")
            print("\(country)")
            print("===========================================")
            */

            address1Label.text = name
            address2Label.text = locality + ", " + administrativeArea
            address3Label.text = postalCode
        }
    }

}

