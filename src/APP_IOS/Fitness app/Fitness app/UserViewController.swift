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
import MapKit

class UserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var NameTxt: UITextField!
    @IBOutlet var AgeTxt: UITextField!
    @IBOutlet var levelTxt: UITextField!
    @IBOutlet var SportTxt: UITextField!
    @IBOutlet var timeSpendTxt: UITextField!
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var MobileTxt: UITextField!
    @IBOutlet var latLabel: UILabel!
    @IBOutlet var longLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    var base64StringImage = ""
    
    let defaults = UserDefaults.standard
    
    var jsonlement:NSDictionary = [:]
    
    var newLatitude: Double = 0.0
    var newLongtitude: Double = 0.0
    
    //Dette er locationmanager fra Locationmanager i Suportfiles
    private let locationManager = LocationManager.shared
    
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
        
        imagePicker.delegate = self
        
        getRequest()
        
        print("\(newLongtitude)")
        print("\(newLatitude)")
        
        // create tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(gesture:)))
        
        // add it to the image view;
        imageView.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        imageView.isUserInteractionEnabled = true
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    //locationManager stops when view is closed. to save energy and process speed.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
        newLongtitude = 0.0
        newLatitude = 0.0
        
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            print("Image Tapped")
            //Here you can initiate your new ViewController
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        }
    }
    
    func getRequest() {
            
        let urlComp = NSURLComponents(string: "http://localhost:3333/users/getCurrentUser")!
        
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

                DispatchQueue.main.async {
                    self.NameTxt.text = responseJSON["name"] as! String
                    self.timeSpendTxt.text = "\(responseJSON["timeSpendPerWeek"] ?? 0)"
                    self.AgeTxt.text = "\(responseJSON["age"] ?? 0)"
                    self.levelTxt.text = "\(responseJSON["sportLevel"] ?? 0)"
                    self.MobileTxt.text = "\(responseJSON["mobile"] ?? 0)"
                    self.SportTxt.text = responseJSON["primarySports"] as! String
                    self.emailTxt.text = responseJSON["email"] as! String
                    self.longLabel.text = "\(responseJSON["locationLat"] ?? 0.0)"
                    self.latLabel.text = "\(responseJSON["locationLong"] ?? 0.0)"
                    self.newLongtitude = responseJSON["locationLong"] as! Double
                    self.newLatitude = responseJSON["locationLat"] as! Double
                }
            }
            
        })
        task.resume()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        // print out the image size as a test
        imageView.image = image
        if (image == nil){
            print("no image")
        }else {
            var image1 = self.resizeImage(image: image, targetSize: CGSize(width: 128.0, height: 128.0))
            base64StringImage = convertImageTobase64(format: .png, image: image1)!
            //print(base64StringImage.count)
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    public enum ImageFormat {
        case png
        case jpeg(CGFloat)
    }
    
    func convertImageTobase64(format: ImageFormat, image:UIImage) -> String? {
        var imageData: Data?
        switch format {
        case .png: imageData = image.pngData()
        case .jpeg(let compression): imageData = image.jpegData(compressionQuality: compression)
        }
        return imageData?.base64EncodedString()
    }
    
    var center = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var location = locations.last as! CLLocation
        
        center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
    }
    
    @IBAction func UpdateLocation(_ sender: Any) {
        newLatitude = center.latitude
        newLongtitude = center.longitude
        latLabel.text = "\(newLatitude)"
        longLabel.text = "\(newLongtitude)"
    }
    
    @IBAction func UpdateInfoBtn(_ sender: Any) {
        UpdateInfo()
    }
    
    
    func UpdateInfo() {
        let parameters = ["timeSpendPerWeek": timeSpendTxt.text, "name": NameTxt.text, "locationLong": newLongtitude, "locationLat": newLatitude, "age": AgeTxt.text, "mobile": MobileTxt.text, "primarySports": SportTxt.text, "sportLevel": levelTxt.text, "profilepictur": base64StringImage ] as [String : Any]
        
        //Create the url
        let url = URL(string: "http://localhost:3333/users/create")
        
        //Create the session object
        let session = URLSession.shared
        
        //Create the UrlRequest object using the url object
        var request = URLRequest(url: url!)
        request.httpMethod = "POST" // set request to POST
        
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
                        
                        
                    }
                } else {
                    print("statusCode: \(httpResponse.statusCode)")
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
