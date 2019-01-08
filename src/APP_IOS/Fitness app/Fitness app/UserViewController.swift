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
        defaults.removeObject(forKey: "email")
        defaults.synchronize()
        
        FBSDKLoginManager().logOut()
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
            
        let urlComp = NSURLComponents(string: "http://localhost:3333/users/getUserInfo")!
            
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
            
//            let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
//            if let responseJSON = responseJSON as? [String: Any] {
//                print(responseJSON)
//                self.jsonlement = responseJSON as NSDictionary
//
//                DispatchQueue.main.async { // Correct
//                    self.EmailLabel.text = "Email: \(responseJSON["email"] as! String)"
//                    self.TimeLabel.text = "Time spend: \(responseJSON["timeSpendPerWeek"] as! String)"
//                }
//            }
            
        })
        task.resume()
    }
    
}
