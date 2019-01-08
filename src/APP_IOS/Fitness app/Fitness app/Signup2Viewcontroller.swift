//
//  SignupStep2Viewcontroller.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 07/01/2019.
//  Copyright © 2019 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation
import UIKit

class Signup2Viewcontroller: UIViewController {
    
    var base64SignupString = ""
    
    @IBOutlet weak var NameText: UITextField!
    @IBOutlet weak var TimeSpendText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(base64SignupString)
    }
    
    
    @IBAction func Signup(_ sender: Any) {
        Signup()
    }
    
    func Signup() {
        
        let parameters = ["timeSpendPerWeek": TimeSpendText.text, "Name": NameText.text] as [String : Any]
        
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
        })
        task.resume()
    }
}
