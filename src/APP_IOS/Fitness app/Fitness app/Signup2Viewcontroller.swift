//
//  SignupStep2Viewcontroller.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 07/01/2019.
//  Copyright © 2019 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Signup2Viewcontroller: UIViewController, CLLocationManagerDelegate {
    
    var base64SignupString = ""
    
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var NameText: UITextField!
    @IBOutlet weak var TimeSpendText: UITextField!
    @IBOutlet weak var AgeText: UITextField!
    @IBOutlet weak var MobileText: UITextField!
    @IBOutlet weak var Primary_Sports: UITextField!
    @IBOutlet weak var Sport_Level: UITextField!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(base64SignupString)
        
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    var center = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var location = locations.last as! CLLocation
        
        center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        print(center.latitude)
        print(center.longitude)
    }
    
    var CheckisCompleate = false
    
    @IBAction func Signup(_ sender: Any) {
        Checkfields()
        if CheckisCompleate == true {
            Signup()
        }
    }
    
    func Checkfields() {
        guard let NameTxt = NameText.text, !NameTxt.isEmpty else {
            print("no text in name")
            return
        }
        
        guard let TimeSpend = TimeSpendText.text, !TimeSpend.isEmpty else {
            print("no text in time spend")
            return
        }
        
        guard let Age = AgeText.text, !Age.isEmpty else {
            print("no text in age")
            return
        }
        
        guard let Mobile = MobileText.text, !Mobile.isEmpty else {
            print("no mobile number")
            return
        }
        
        guard let PrimarySports = Primary_Sports.text, !PrimarySports.isEmpty else {
            print("no sport")
            return
        }
        
        guard let SportLevel = Sport_Level.text, !SportLevel.isEmpty else {
            print("not Sport level")
            return
        }
        
        //do something if it's not empty
        CheckisCompleate = true
        print("name: \(NameTxt) \nTime spend: \(TimeSpend) \nage: \(Age) \nmobile: \(Mobile) \nPrimarySport : \(PrimarySports) \nSport level: \(SportLevel)")
    }
    
    func Signup() {
        
        let parameters = ["timeSpendPerWeek": TimeSpendText.text, "usedFacebookLogin": 0, "fullName": NameText.text, "locationLong": center.longitude, "locationLat": center.latitude, "age": AgeText.text, "mobile": MobileText.text, "primarySports": Primary_Sports.text, "sportLevel": Sport_Level.text ] as [String : Any]
        
        //Create the url
        let url = URL(string: "http://localhost:3333/users/create")
        
        //Create the session object
        let session = URLSession.shared
        
        //Create the UrlRequest object using the url object
        var request = URLRequest(url: url!)
        request.httpMethod = "POST" // set request to POST
        request.setValue("Basic \(base64SignupString)", forHTTPHeaderField: "Authorization")
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //Create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                        
                        let defaults = UserDefaults.standard
                        
                        defaults.set(responseJSON["email"], forKey: "email")
                        defaults.synchronize()
                        
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "SignedUp", sender: self)
                        }
                        
                    }
                } else {
                    print("statusCode: \(httpResponse.statusCode)")
                }
                
            }
        })
        task.resume()
    }
}
