//
//  UserViewController.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 07/12/2018.
//  Copyright © 2018 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation
import UIKit
import SideMenu
import FBSDKCoreKit
import FBSDKLoginKit

class UserViewController: UIViewController {
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var AgeLabel: UILabel!
    @IBOutlet weak var SportLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var LevelLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var MobileLabel: UILabel!
    @IBOutlet weak var CityLabel: UILabel!
    
    let defaults = UserDefaults.standard
    
    var jsonlement:NSDictionary = [:]
    
    @IBAction func LogudButton(_ sender: Any) {
        Logout()
    }
    
    @IBAction func Menu(_ sender: Any) {
        // open menu
        //present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getRequest(params: ["user": defaults.object(forKey: "email") as! String])
    }
    
    func getRequest(params: [String:String]) {
            
        let urlComp = NSURLComponents(string: "http://localhost:3333/users/getCurrentUser")!
            
        var items = [URLQueryItem]()
            
        for (key,value) in params {
            items.append(URLQueryItem(name: key, value: value))
        }
            
        items = items.filter{!$0.name.isEmpty}
            
        if !items.isEmpty {
            urlComp.queryItems = items
        }
            
        var urlRequest = URLRequest(url: urlComp.url!)
        urlRequest.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
            
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            //print(response)
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                self.jsonlement = responseJSON as NSDictionary

                DispatchQueue.main.async { // Correct
                    self.EmailLabel.text = "Email: \(responseJSON["email"] as! String)"
                    //self.TimeLabel.text = "Time spend: \(responseJSON["time_spend_per_week"])"
//                    self.AgeLabel.text = "Age: \(responseJSON["age"])"
//                    self.LevelLabel.text = "Level: \(responseJSON["sport_level"])"
//                    self.MobileLabel.text = "Mobile: \(String(describing: responseJSON["mobile"]))"
//                    self.NameLabel.text = "Name: \(responseJSON["full_name"] as! String)"
//                    self.SportLabel.text = "Sport: \(responseJSON["primary_sports"] as! String)"
                }
            }
            
        })
        task.resume()
    }
    
    func Logout() {
        //Create the url
        let url = URL(string: "http://localhost:3333/users/logout")
        
        //Create the session object
        let session = URLSession.shared
        
        //Create the UrlRequest object using the url object
        var request = URLRequest(url: url!)
        request.httpMethod = "GET" // set request to POST
    
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
            
            let datastring = String(data: data, encoding: String.Encoding.utf8)
            print(datastring)
            
            print(response)
            
            if(FBSDKAccessToken.current() != nil){
            FBSDKLoginManager().logOut()
            }
            
            self.defaults.removeObject(forKey: "email")
            self.defaults.synchronize()
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "Logud", sender: self)
            }
            
        })
        task.resume()
    }
    
}
