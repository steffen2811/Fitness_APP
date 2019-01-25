//
//  changePasswordViewController.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 22/01/2019.
//  Copyright © 2019 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation
import UIKit

class changePasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var Password: UITextField!
    
    @IBOutlet var NewPassword: UITextField!
    
    @IBOutlet var ReNewPassword: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Password.delegate = self
        NewPassword.delegate = self
        ReNewPassword.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    @IBAction func ChangePasswordBtn(_ sender: Any) {
        checkTextfields()
    }
    
    func checkTextfields() {
        guard let oldPassword1 = Password.text, !oldPassword1.isEmpty else {
            print("old password is not set")
            return
        }
        
        guard let newPassword1 = NewPassword.text, !newPassword1.isEmpty else {
            print("new password not set")
            return
        }
        
        guard let reNewPassword1 = ReNewPassword.text, !reNewPassword1.isEmpty else {
            print("re enter new password is not set")
            return
        }
        updatePassword(oldpass: oldPassword1, newPassword: newPassword1, reNewPassword: reNewPassword1)
    }
    
    func updatePassword(oldpass: String, newPassword: String, reNewPassword: String) {
        let parameters = ["oldPassword": oldpass, "password": newPassword, "reTypePassword": reNewPassword] as [String : Any]
        
        print(parameters)
        //Create the url
        let url = URL(string: "http://localhost:3333/users/changePassword")
            
        print(url)
            
        //Create the session object
        let session = URLSession.shared
            
        //Create the UrlRequest object using the url object
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT" // set request to Put
        
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
                            
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "Logud", sender: self)
                        }
                    }
                } else {
                    print("statusCode: \(httpResponse.statusCode)")
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                    }
                }
                    
            }
        })
        task.resume()
    }
    
}
