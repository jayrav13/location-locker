//
//  API.swift
//  
//
//  Created by Jay Ravaliya on 12/23/15.
//
//

import Alamofire
import SwiftyJSON
import CoreLocation

class API {
    
    let searchURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    // let searchURL = "http://eventsatnjit.jayravaliya.com/api/v0.2/events"
    
    func checkIn(keyword : String, latitude : CLLocationDegrees, longitude : CLLocationDegrees, completion : (success : Bool, data : JSON)->Void) {
        
        let parameters : [String : AnyObject] = [
            "rankby" : "prominence",
            "location" : "\(latitude),\(longitude)",
            "key" : "AIzaSyAeryvEAf5PNAmqcC6zAdQq2glGwQISTXI",
            "radius" : "50000"
            // "keyword" : keyword
        ]
        
        Alamofire.request(Method.GET, searchURL, parameters: parameters, encoding: ParameterEncoding.URL, headers: nil).responseJSON { (response) -> Void in
            
            if(response.result.isSuccess) {
                completion(success: true, data: JSON(data: response.data!))
            }
            else {
                completion(success: false, data: nil)
            }
        }
        
    }
    
}
