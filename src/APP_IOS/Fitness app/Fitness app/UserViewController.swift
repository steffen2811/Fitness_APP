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

class UserViewController: UIViewController {
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var AgeLabel: UILabel!
    @IBOutlet weak var SportLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var LevelLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var MobileLabel: UILabel!
    @IBOutlet weak var CityLabel: UILabel!
    
    
    @IBAction func Menu(_ sender: Any) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Getuser()
        
    }
    
    func Getuser() {
        
        let defaults = UserDefaults.standard
        let Email = defaults.object(forKey: "email")
        
        let parameters = ["email": Email] as [String : Any]
        
        //Create the url
        let url = URL(string: "http://localhost:3333/users/CurrentUser")
        
        //Create the session object
        let session = URLSession.shared
        
        //Create the UrlRequest object using the url object
        var request = URLRequest(url: url!)
        request.httpMethod = "GET" // set request to POST
        
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
            
            let datastring = String(data: data, encoding: String.Encoding.utf8)
            print(datastring)
            
            print(response)
            
            
            
            /*if let httpresponse = response as? HTTPURLResponse {
             let Respones1 = httpresponse.allHeaderFields["Set-Cookie"] as? String
             print(Respones1)
             UserDefaults.standard.set(Respones1, forKey: "token")
             }*/
            
        })
        task.resume()
    }
    
}
