//
//  WeatherFetcherStarter.swift
//  MapViewDemo
//
//  Created by Michael Rogers on 4/23/19.
//  Copyright © 2019 Michael Rogers. All rights reserved.
//

import Foundation

//
//  WeatherFetcherStarter.swift
//  MapViewDemo
//
//  Created by Michael Rogers on 4/22/19.
//  Copyright © 2019 Michael Rogers. All rights reserved.
//

import Foundation
import MapKit

class WeatherFetcherStarter {
    
    let openWeatherMapAPIKey = "35710a124c80cc74077b32d32588d8e2"
    var openWeatherMapURL:String
    
    var annotations:[MKAnnotation] = []
    
    static let shared = WeatherFetcherStarter()
    
    // called to start the temperature fetching process
    
    init(){
        openWeatherMapURL = "http://api.openweathermap.org/data/2.5/box/city?bbox=-85,40,-83,42,10&appid=\(openWeatherMapAPIKey)&units=imperial"
        print(openWeatherMapURL)
    }
    func numAnnotations()-> Int{
        return annotations.count
    }
    subscript(index:Int) -> MKAnnotation {
        return annotations[index]
    }
    
    func fetchTemperature() -> Void {
        
        let urlSession = URLSession.shared
        let url = URL(string: openWeatherMapURL)
        urlSession.dataTask(with: url!, completionHandler: displayTemperature).resume()
    }
    
    
    // Callback after JSON has been fetched
    func displayTemperature(data:Data?, urlResponse:URLResponse?, error:Error?)->Void {
        var weatherRecord:[String:Any]!
        var cities:[[String:Any]]! // array in "list"
        do {
            try weatherRecord = JSONSerialization.jsonObject(with: data!,
                                                             options: .allowFragments) as? [String:Any]
            if weatherRecord != nil {
                cities = weatherRecord["list"] as! [[String:Any]]
                for city in cities {
                    
                    let name = city["name"]! as! String
                     let coord = city["coord"]! as! [String:Double]
                    let lat = coord["Lat"] as! Double
                    let long = coord["Lon"] as! Double
                    let main = city["main"]! as! [String:Any]
                    let temperature = main["temp"] as! Double
                    
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



/* // Paste this data into jsonformatter.org to help visualize it
 {"cod":200,"calctime":0.255437521,"cnt":16,"list":[{"id":5174358,"dt":1556021138,"name":"Troy","coord":{"Lat":40.039501,"Lon":-84.203278},"main":{"temp":59.63,"temp_min":57,"temp_max":63,"pressure":1015,"humidity":58},"wind":{"speed":4.1,"deg":200},"rain":null,"snow":null,"clouds":{"today":75},"weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04d"}]},{"id":5172078,"dt":1556021138,"name":"Sidney","coord":{"Lat":40.284222,"Lon":-84.155502},"main":{"temp":60.28,"temp_min":57,"temp_max":64,"pressure":1013,"humidity":62},"wind":{"speed":4.6,"deg":200},"rain":null,"snow":null,"clouds":{"today":40},"weather":[{"id":802,"main":"Clouds","description":"scattered clouds","icon":"03d"}]},{"id":5160783,"dt":1556021137,"name":"Lima","coord":{"Lat":40.74255,"Lon":-84.105232},"main":{"temp":60.82,"temp_min":59,"temp_max":63,"pressure":1013,"humidity":62},"wind":{"speed":4.6,"deg":200},"rain":null,"snow":null,"clouds":{"today":40},"weather":[{"id":802,"main":"Clouds","description":"scattered clouds","icon":"03d"}]},{"id":5162077,"dt":1556021138,"name":"Marysville","coord":{"Lat":40.23645,"Lon":-83.367142},"main":{"temp":59.86,"temp_min":57,"temp_max":63,"pressure":1014,"humidity":67},"wind":{"speed":5.1,"deg":220},"rain":null,"snow":null,"clouds":{"today":90},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}]},{"id":5152333,"dt":1556021137,"name":"Dublin","coord":{"Lat":40.099232,"Lon":-83.114082},"main":{"temp":59.61,"temp_min":57,"temp_max":63,"pressure":1014,"humidity":58},"wind":{"speed":4.1,"deg":190},"rain":null,"snow":null,"clouds":{"today":90},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}]},{"id":5151891,"dt":1556021137,"name":"Delaware","coord":{"Lat":40.298672,"Lon":-83.067963},"main":{"temp":59.83,"temp_min":57.2,"temp_max":63,"pressure":1014,"humidity":58},"wind":{"speed":4.1,"deg":190},"rain":null,"snow":null,"clouds":{"today":90},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}]},{"id":5161902,"dt":1556021138,"name":"Marion","coord":{"Lat":40.588669,"Lon":-83.128517},"main":{"temp":60.01,"temp_min":57.2,"temp_max":63,"pressure":1014,"humidity":58},"wind":{"speed":4.1,"deg":190},"rain":null,"snow":null,"clouds":{"today":90},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}]},{"id":5151861,"dt":1556020942,"name":"Defiance","coord":{"Lat":41.284489,"Lon":-84.355782},"main":{"temp":61.14,"temp_min":59,"temp_max":64,"pressure":1011,"humidity":67},"wind":{"speed":7.7,"deg":220},"rain":null,"snow":null,"clouds":{"today":90},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}]},{"id":4983811,"dt":1556021132,"name":"Adrian","coord":{"Lat":41.897549,"Lon":-84.03717},"main":{"temp":61.43,"temp_min":59,"temp_max":64,"pressure":1011,"humidity":67},"wind":{"speed":7.7,"deg":220},"rain":null,"snow":null,"clouds":{"today":90},"weather":[{"id":211,"main":"Thunderstorm","description":"thunderstorm","icon":"11d"}]},{"id":5173572,"dt":1556021138,"name":"Sylvania","coord":{"Lat":41.718941,"Lon":-83.71299},"main":{"temp":61.5,"temp_min":57.2,"temp_max":64,"pressure":1010,"humidity":63},"wind":{"speed":3.1,"deg":210},"rain":null,"snow":null,"clouds":{"today":75},"weather":[{"id":211,"main":"Thunderstorm","description":"thunderstorm","icon":"11d"}]},{"id":5153924,"dt":1556020942,"name":"Findlay","coord":{"Lat":41.04422,"Lon":-83.649933},"main":{"temp":61.39,"temp_min":57.99,"temp_max":64,"pressure":1013,"humidity":59},"wind":{"speed":6.2,"deg":220},"rain":null,"snow":null,"clouds":{"today":90},"weather":[{"id":211,"main":"Thunderstorm","description":"thunderstorm","icon":"11d"}]},{"id":5147968,"dt":1556021137,"name":"Bowling Green","coord":{"Lat":41.374771,"Lon":-83.651321},"main":{"temp":62.13,"temp_min":60.01,"temp_max":64.4,"pressure":1011,"humidity":59},"wind":{"speed":7.7,"deg":200},"rain":{"1h":0.25},"snow":null,"clouds":{"today":90},"weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10d"},{"id":211,"main":"Thunderstorm","description":"thunderstorm","icon":"11d"}]},{"id":5173930,"dt":1556021138,"name":"Tiffin","coord":{"Lat":41.114498,"Lon":-83.177971},"main":{"temp":61.52,"temp_min":57.99,"temp_max":64.4,"pressure":1011,"humidity":59},"wind":{"speed":7.7,"deg":200},"rain":null,"snow":null,"clouds":{"today":90},"weather":[{"id":211,"main":"Thunderstorm","description":"thunderstorm","icon":"11d"}]},{"id":5155207,"dt":1556020922,"name":"Fremont","coord":{"Lat":41.35033,"Lon":-83.121857},"main":{"temp":62.38,"temp_min":59,"temp_max":64.4,"pressure":1011,"humidity":52},"wind":{"speed":5.7,"deg":220},"rain":null,"snow":null,"clouds":{"today":40},"weather":[{"id":211,"main":"Thunderstorm","description":"thunderstorm","icon":"11d"}]},{"id":5174035,"dt":1556021138,"name":"Toledo","coord":{"Lat":41.66394,"Lon":-83.555206},"main":{"temp":61.61,"temp_min":57,"temp_max":66.2,"pressure":1011,"humidity":59},"wind":{"speed":7.7,"deg":200},"rain":null,"snow":null,"clouds":{"today":90},"weather":[{"id":211,"main":"Thunderstorm","description":"thunderstorm","icon":"11d"}]},{"id":5002344,"dt":1556021133,"name":"Monroe","coord":{"Lat":41.916431,"Lon":-83.397713},"main":{"temp":60.75,"temp_min":55,"temp_max":66.2,"pressure":1009,"humidity":67},"wind":{"speed":4.6,"deg":210},"rain":null,"snow":null,"clouds":{"today":75},"weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10d"},{"id":211,"main":"Thunderstorm","description":"thunderstorm","icon":"11d"}]}]}
 
 
 
 */


