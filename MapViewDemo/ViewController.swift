//
//  ViewController.swift
//  Expendable
//
//  Created by Michael Rogers on 11/30/18.
//  Copyright © 2019 Michael Rogers. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView:MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(addAnnotations(notification:)), name: NSNotification.Name("annotationsReceived"), object: nil)
        addAnnotation()
        WeatherFetcherStarter.shared.fetchTemperature()

    }
    
    
    func addAnnotation(){
        let myAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2D(latitude: 40.0, longitude: -94)
        myAnnotation.title = "Home"
        myAnnotation.subtitle = "No, not really"
        mapView.addAnnotation(myAnnotation)
        
    }
    
    // annotations have been received, let's show them!
    @objc
    func addAnnotations(notification:NSNotification){
        print("This is a job for ... WeatherFetcher!")
        DispatchQueue.main.async { // remember, we need to make things happen on the main thread
            
            for an in 0 ..< WeatherFetcher.shared.numAnnotations() {
                self.mapView.addAnnotation(WeatherFetcher.shared[an])
            }
            
            
        }
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "anno") as? MKPinAnnotationView // MKMarkerAnnotationView
        if annotationView == nil {
            // no annotation view, we'll make one ...
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "anno")
            annotationView!.canShowCallout = true
            let callBTN = UIButton(type: .detailDisclosure)
            callBTN.addTarget(self, action: #selector(clickMe(sender:)), for: UIControl.Event.touchUpInside)
            annotationView!.rightCalloutAccessoryView = callBTN
            annotationView?.pinTintColor = UIColor.green
            //annotationView!.markerTintColor = UIColor.green
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    @objc
    func clickMe(sender:UIButton){
        let extraInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "extraInfo")
        self.present(extraInfoVC!, animated: true, completion: nil) // probably not quite what we want ;-(
    }
}

