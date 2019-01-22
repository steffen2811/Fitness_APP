//
//  PendingRequestDetailViewController.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 17/01/2019.
//  Copyright © 2019 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation
import UIKit
import AvatarImageView

class PendingRequestDetailViewController: UIViewController{
    
    @IBOutlet var Profilepic: AvatarImageView!{
        didSet {
            configureRoundAvatar() // Comment this line for a square avatar as that is the default.
            //showProfilePicture()
        }
    }
    
    @IBOutlet var NameLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var primarySportsLabel: UILabel!
    @IBOutlet var timeSpendPerWeekLabel: UILabel!
    @IBOutlet var sportLevelLabel: UILabel!
    
    var jsonlement:NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(jsonlement)
        configureView()
        
    }
    
    @IBAction func AcceptButton(_ sender: Any) {
        if let quantity = jsonlement["id_users"] as? NSNumber {
            SendRequest(ID : quantity.stringValue, Url: "http://localhost:3333/users/community/responseRequestAccept", Type: "PUT")
        }
    }
    
    @IBAction func DenyButton(_ sender: Any) {
        if let quantity = jsonlement["id_users"] as? NSNumber {
            SendRequest(ID : quantity.stringValue, Url: "http://localhost:3333/users/community/responseRequestDeny", Type: "DELETE")
        }
    }
    
    func SendRequest(ID: String, Url: String, Type: String ) {
        
        //Create the url
        let url = URL(string: Url + "/?responseToUserid=\(ID)")
        
        print(url)
        
        //Create the session object
        let session = URLSession.shared
        
        //Create the UrlRequest object using the url object
        var request = URLRequest(url: url!)
        request.httpMethod = Type // set request to POST
        
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
                        
                        DispatchQueue.main.sync(execute: { () -> Void in
                            
                            self.navigationController?.popViewController(animated: true)
                            
                            self.dismiss(animated: true, completion: nil)
                            
                        })
                        
                    }
                } else {
                    print("statusCode: \(httpResponse.statusCode)")
                }
                
            }
        })
        task.resume()
    }
    
    
    private func configureView() {
        NameLabel.text =  "Name: " + (jsonlement["name"] as? String ?? "")
        genderLabel.text = "Gender: " + (jsonlement["gender"] as? String ?? "")
        ageLabel.text = "Age: \(jsonlement["age"] as? Int ?? 0)"
        primarySportsLabel.text = "Sports: " + (jsonlement["primarySports"] as? String ?? "")
        timeSpendPerWeekLabel.text = "Time per week:  \(jsonlement["timeSpendPerWeek"] as? Int ?? 0)"
        sportLevelLabel.text = "Sport level: \(jsonlement["sportLevel"] as? Int ?? 0)"
        showProfilePicture(Url: "https://graph.facebook.com/v2.6/2006345182734802/picture?type=large")
    }
    
    func configureRoundAvatar() {
        struct Config: AvatarImageViewConfiguration { var shape: Shape = .circle }
        Profilepic.configuration = Config()
    }
    
    func showProfilePicture(Url: String) {
        var data = PictureData()
        let url = URL(string: Url)
        let data1 = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        
        
        data.avatar = UIImage(data: data1!)
        Profilepic.dataSource = data
    }
    
}

