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
        
        CheckifLogedin()
        
        
        
    }
    
    func CheckifLogedin() {
        
        let urlComp = NSURLComponents(string: "http://localhost:3333/users/getCurrentUser")!
        
        var urlRequest = URLRequest(url: urlComp.url!)
        urlRequest.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            //print(response)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "Login", sender: self)
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func viewDidAppear() {
        if (FBSDKAccessToken.current() != nil)
        {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "Login", sender: self)
            }
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
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "Login", sender: self)
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
                        self.FacebookLoginrequest(params: ["access_token": FBSDKAccessToken.current().tokenString])
                        self.facebookToken = FBSDKAccessToken.current().tokenString
                    }
                    
                }
            })
        }
    }
    
    
    func FacebookLoginrequest(params: [String:String]) {
        
        let urlComp = NSURLComponents(string: "http://localhost:3333/users/facebook/login")!
        
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
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode == 200){
                    
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                        print("200")
                        sleep(1)
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "Login", sender: self)
                        }
                    }
                } else if(httpResponse.statusCode == 401){
                    self.FacebookSignup()
                    print("401")
                    
                }else {
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
    
    func facebooklogin200() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "Login", sender: Any?.self)
        }
    }
    
    
    var facebookToken = ""
    
    func FacebookSignup() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "FacebookSignup", sender: Any?.self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "FacebookSignup") {
            if let vc = segue.destination as? Signup2Viewcontroller
            {
                vc.base64FacebookToken = facebookToken
                vc.facebooklogin = true
            }
        }else if (segue.identifier == "Login"){
            print("seque er kørt")
        }else{
            print("hvor er info")
        }
    }

}
