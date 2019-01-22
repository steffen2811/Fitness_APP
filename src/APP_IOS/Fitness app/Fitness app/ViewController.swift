//
//  ViewController.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 25/10/2018.
//  Copyright © 2018 Tobias Brammer Fredriksen. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var EmailTxtField: UITextField!
    @IBOutlet weak var PasswordTxtField: UITextField!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        EmailTxtField.delegate = self
        PasswordTxtField.delegate = self
        
        if(FBSDKAccessToken.current() == nil){
            print("Not logged in with facebook ")
        }else{
            print("Logged in already")
            print(FBSDKAccessToken.current())
            var fbAccessToken = FBSDKAccessToken.current().tokenString
            print(fbAccessToken)
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "Login", sender: self)
            }
        }
        
        
        //Check cookie insted
        if(defaults.object(forKey: "email") == nil){
            print("Not loged ind with email")
        }else{
            print("loged in with email")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "Login", sender: self)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func viewDidAppear() {
        if (FBSDKAccessToken.current() != nil)
        {
            performSegue(withIdentifier: "Login", sender: self)
        }
    }

    @IBAction func SignIn(_ sender: Any) {
        Login()
    }
    
    
    func Login() {
        let username = EmailTxtField.text!
        let password = PasswordTxtField.text!
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()

        //Create the url
        let url = URL(string: "http://localhost:3333/users/login")

        //Create the session object
        let session = URLSession.shared

        //Create the UrlRequest object using the url object
        var request = URLRequest(url: url!)
        request.httpMethod = "GET" // set request to POST
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")

//        do{
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
//        } catch let error {
//            print(error.localizedDescription)
//        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        //Create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            print(response)
            print(error)
            guard error == nil else {
                return
            }

            guard let data = data else {
                return
            }

            let datastring = String(data: data, encoding: String.Encoding.utf8)
            print(datastring)

            print(response)


            self.defaults.set(self.EmailTxtField.text, forKey: "email")
            self.defaults.synchronize()

            /*if let httpresponse = response as? HTTPURLResponse {
                let Respones1 = httpresponse.allHeaderFields["Set-Cookie"] as? String
                print(Respones1)
                UserDefaults.standard.set(Respones1, forKey: "token")
            }*/
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "Login", sender: self)
            }

        })
        task.resume()
    }

    @IBAction func FacebookLogin(_ sender: Any) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    print(result)
                    guard let Info = result as? [String: Any] else { return }
                    
                    if let Email = Info["email"] as? String
                    {
                        
                        getRequest(params: ["access_token": FBSDKAccessToken.current().tokenString])
                        
                        let defaults = UserDefaults.standard
                        defaults.set(Email, forKey: "email")
                        defaults.synchronize()
                        
                    }
                    
                }
            })
        }
    }
}

func getRequest(params: [String:String]) {
    
    let urlComp = NSURLComponents(string: "http://localhost:3000/users/login/facebook")!
    
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
