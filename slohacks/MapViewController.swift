//
//  ResultsViewController.swift
//  slohacks
//
//  Created by Joe Wijoyo on 2/3/18.
//  Copyright © 2018 Devin Nicholson. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    let googlePlacesApiKey = "AIzaSyB5L-BPOfeL3A4WU3PsyTNw1ekBpKRQ3Wg"
    var mapAnnotationsOfSearchResultsLocations: [MapAnnotation]?
    
    var centerCoordinates = CLLocationCoordinate2D.init(latitude: 35.2828, longitude: -120.6596)
    let clLocationManager = CLLocationManager()
    var locationToSearch:String!
    var searchString = ""
    
    var storePtr: LogHorizon.StorePtr!
    var storeItems: [LogHorizon.Item]!
    
    
    @IBOutlet weak var placesList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.storeItems = []
        // Do any additional setup after loading the view.
        storePtr.storeItems( { (items) in
            self.storeItems = items
            self.placesList.reloadData()
        })
        
        self.mapView.delegate = self
        
        // Set search string
        //self.searchString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=" + "grocery+stores" + "&location=35.2828,-120.6596&radius=10000&key=" + self.googlePlacesApiKey
        self.searchString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=" + self.locationToSearch.replacingOccurrences(of: " ", with: "+") +
            "&location=35.2828,-120.6596&radius=10000&key=" + self.googlePlacesApiKey
        
        
        
        //Set map region to center coordinates
        var mkCoordinateSpan = MKCoordinateSpan.init()
        mkCoordinateSpan.latitudeDelta = 0.1 //0.01
        mkCoordinateSpan.longitudeDelta = 0.1 //0.01
        var mkCoordinateRegion = MKCoordinateRegion.init()
        mkCoordinateRegion.span = mkCoordinateSpan
        mkCoordinateRegion.center = self.centerCoordinates
        self.mapView.setRegion(mkCoordinateRegion, animated: true)
        self.mapView.regionThatFits(mkCoordinateRegion)
        self.mapView.showsUserLocation = true
        
        self.clLocationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.clLocationManager.delegate = self
            self.clLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.clLocationManager.startUpdatingLocation()
        }
        
        self.makeURLRequest()
    }
    
    func makeURLRequest () {
        let url = URL(string: self.searchString)
        
        if self.mapAnnotationsOfSearchResultsLocations != nil {
            self.mapView.removeAnnotations(self.mapAnnotationsOfSearchResultsLocations!)
        }
        
        self.mapAnnotationsOfSearchResultsLocations = []
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            //let dataString = String.init(data: data!, encoding: String.Encoding.utf8)
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                let jsonResults = json["results"] as! [[String: Any]]
                for jsonResult in jsonResults {
                    let geometry = jsonResult["geometry"] as! [String: Any]
                    let location = geometry["location"] as! [String: Any]
                    let lat = location["lat"] as! Double
                    let long = location["lng"] as! Double
                    
                    let locationName = jsonResult["name"] as! String
                
                    let clLocationCoordinate = CLLocationCoordinate2D.init(latitude: lat, longitude: long)
                
                    let mapAnnotation = MapAnnotation.init(locationName: locationName, coordinate: clLocationCoordinate)
                    self.mapAnnotationsOfSearchResultsLocations!.append(mapAnnotation)
                }
                self.mapView.addAnnotations(self.mapAnnotationsOfSearchResultsLocations!)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MapAnnotation else { return nil }
        var view: MKMarkerAnnotationView
        
        let identifier = "marker"
        if let dequeuedView = self.mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        }
        else {
            view = MKMarkerAnnotationView.init(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.centerCoordinates = (manager.location?.coordinate)!
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation
        let mkPlacemark = MKPlacemark.init(coordinate: annotation!.coordinate)
        let mkMapItem = MKMapItem.init(placemark: mkPlacemark)
        mkMapItem.name = annotation!.title!
        mkMapItem.openInMaps(launchOptions: nil)
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

extension MapViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storeItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableViewCell: UITableViewCell
        tableViewCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell")!
        tableViewCell.textLabel?.text = self.storeItems[indexPath.row].name
        return tableViewCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
}
