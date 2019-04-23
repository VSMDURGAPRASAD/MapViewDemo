//
//  WeatherFetcher.swift
//  MapViewDemo
//
//  Created by Michael Rogers on 4/22/19.
//  Copyright © 2019 Michael Rogers. All rights reserved.
//

import Foundation
import MapKit

class WeatherFetcher {
    
    let openWeatherMapAPIKey = "12bb498c3677cdfe5285a277361e412f"
    var openWeatherMapURL:String
    
    private var annotations:[MKAnnotation] = []
    
    subscript(index:Int) -> MKAnnotation {
        return annotations[index]
    }
    static let shared = WeatherFetcher()
    
   
    
    init(){
        openWeatherMapURL = "http://api.openweathermap.org/data/2.5/box/city?bbox=-85,40,-83,42,10&appid=\(openWeatherMapAPIKey)&units=imperial"
    }
    
    func numAnnotations() -> Int {
        return annotations.count
    }

    
    // called to start the temperature fetching process
    func fetchTemperature() -> Void {
        
        let urlSession = URLSession.shared
        let url = URL(string: openWeatherMapURL)
        urlSession.dataTask(with: url!, completionHandler: displayTemperature).resume()
    }
    
    
    // Callback after JSON has been fetched
    func displayTemperature(data:Data?, urlResponse:URLResponse?, error:Error?)->Void {
        var weatherRecord:[String:Any]!
        var cities:[[String:Any]]!
        do {
            try weatherRecord = JSONSerialization.jsonObject(with: data!,
                                                             options: .allowFragments) as? [String:Any]
            if weatherRecord != nil {
                cities = weatherRecord["list"]! as? [[String:Any]]
                for city in cities {
                    let name = city["name"] as! String
                    let coord = city["coord"] as! [String:Double]
                    let lat = coord["Lat"]!
                    let long = coord["Lon"]!
                    let main = city["main"] as! [String:Double]
                    let temperature = main["temp"]!
                    
                    let myAnnotation = MKPointAnnotation()
                    myAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    myAnnotation.title = name
                    myAnnotation.subtitle = "\(temperature)"
                    annotations.append(myAnnotation)
                    print(myAnnotation.title!, myAnnotation.subtitle!, myAnnotation.coordinate)
                 }
                NotificationCenter.default.post(name: NSNotification.Name("annotationsReceived"), object: nil)
                
            }
        }catch {
            print(error)
        }
    }
    
}
