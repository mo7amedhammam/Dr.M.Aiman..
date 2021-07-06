//
//  MapKit.swift
//  Pina
//
//  Created by Mohamed Salman on 3/2/21.
//

import UIKit
import MapKit

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        super.init()
    }
    var subtitle: String? {
        return locationName
    }
}
class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    init(pinTitle:String, pinSubTitle:String, location:CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
    }
}
class GetAddress : NSObject {
    class func convertLatLongToAddress(latitude:Double, longitude:Double , labelText : UILabel) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in

            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]

            if placeMark != nil {
                if let name = placeMark.name {
                    labelText.text = name
                }
                if let subThoroughfare = placeMark.subThoroughfare {
                    if (subThoroughfare != placeMark.name) && (labelText.text != subThoroughfare) {
                        labelText.text = (labelText.text != "") ? labelText.text! + "," + subThoroughfare : subThoroughfare
                    }
                }
                if let subLocality = placeMark.subLocality {
                    if (subLocality != placeMark.subThoroughfare) && (labelText.text != subLocality) {
                        labelText.text = (labelText.text != "") ? labelText.text! + "," + subLocality : subLocality
                    }
                }
                if let street = placeMark.thoroughfare {
                    if (street != placeMark.subLocality) && (labelText.text != street) {
                        labelText.text = (labelText.text != "") ? labelText.text! + "," + street : street
                    }
                }
                if let locality = placeMark.locality {
                    if (locality != placeMark.thoroughfare) && (labelText.text != locality) {
                        labelText.text = (labelText.text != "") ? labelText.text! + "," + locality : locality
                    }
                }
                if let city = placeMark.subAdministrativeArea {
                    if (city != placeMark.locality) && (labelText.text != city) {
                        labelText.text = (labelText.text != "") ? labelText.text! + "," + city : city
                    }
                }
//                if let state = placeMark.postalAddress?.state {
//                    if (state != placeMark.subAdministrativeArea) && (labelText != state) {
//                        labelText.text = (labelText != "") ? labelText + "," + state : state
//                    }
//
//                }
                if let country = placeMark.country {
                    labelText.text = (labelText.text != "") ? labelText.text! + "," + country : country
                }
                // labelText gives you the address of the place
            }
        })
    }
}



class Draw :NSObject {
    class func DrawRoute (fromLat : String , fromLon : String , fromArea : String , toLat : String , toLon : String , toArea : String , mapKit : MKMapView ) {

        print(fromLat)
        print(fromLon)
        print(fromArea)
        print(toLat)
        print(toLon)
        print(toArea)


        let source = MKPlacemark(coordinate: CLLocationCoordinate2DMake(Double(fromLat) ?? 0.0, Double(fromLon) ?? 0.0), addressDictionary: [
            "" : ""
        ])
        //----//

        addPin(lat: Double(fromLat) ?? 0.0, lon: Double(fromLon) ?? 0.0, title: fromArea, mapKit: mapKit)
        //----//
        let srcMapItem = MKMapItem(placemark: source)
        srcMapItem.name = ""
        
        let destination = MKPlacemark(coordinate: CLLocationCoordinate2DMake(Double(toLat) ?? 0.0, Double(toLon) ?? 0.0), addressDictionary: [
            "" : ""
        ])
        
        let distMapItem = MKMapItem(placemark: destination)
        distMapItem.name = ""
        
        //----//

        addPin(lat: Double(toLat) ?? 0.0, lon: Double(toLat) ?? 0.0, title: toArea, mapKit: mapKit)
        focusMapView(lat: Double(toLat) ?? 0.0, lon: Double(toLat) ?? 0.0, mapKit: mapKit)
        //----//
        let request = MKDirections.Request()
        request.source = srcMapItem
        request.destination = distMapItem
        request.transportType = .walking
        
        let direction = MKDirections(request: request)
        direction.calculate(completionHandler: { [self] response, error in
            if let response = response {
                print("response = \(response)")
            }
            let arrRoutes = response?.routes
            (arrRoutes as NSArray?)?.enumerateObjects({ [self] obj, idx, stop in
                let rout = obj as? MKRoute
                let line = rout?.polyline
                if let line = line {
                    mapKit.addOverlay(line)
                }
                print("Rout Name : \(rout?.name ?? "")")
                print("Total Distance (in Meters) :\(rout?.distance ?? 0)")
            })
            })
        
        }
    
   class func addPin(lat : Double , lon : Double , title : String , mapKit : MKMapView) {
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: lat, longitude:lon)
        annotation.coordinate = centerCoordinate
        annotation.title = title
        mapKit.addAnnotation(annotation)
    }
    
    class func focusMapView(lat : Double , lon : Double, mapKit : MKMapView)  {
        let locationDelivery = CLLocationCoordinate2D(latitude: lat , longitude: lon)
        let region1 = MKCoordinateRegion(
            center: locationDelivery, latitudinalMeters: 3500, longitudinalMeters: 3500)
        mapKit.setRegion(region1, animated: true)
        
    }
}
