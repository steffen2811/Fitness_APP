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

class Signup2Viewcontroller: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    
    var base64SignupString = ""
    var base64StringImage = ""
    var base64FacebookToken = ""
    
    var facebooklogin = false
    
    @IBOutlet var NameLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet var ImageBtn: UIButton!
    @IBOutlet weak var NameText: UITextField!
    @IBOutlet weak var TimeSpendText: UITextField!
    @IBOutlet weak var AgeText: UITextField!
    @IBOutlet weak var MobileText: UITextField!
    @IBOutlet weak var Primary_Sports: UITextField!
    @IBOutlet weak var Sport_Level: UITextField!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet var GenderText: UITextField!
    
    private let locationManager = LocationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NameText.delegate = self
        TimeSpendText.delegate = self
        AgeText.delegate = self
        MobileText.delegate = self
        Primary_Sports.delegate = self
        Sport_Level.delegate = self
        
        if facebooklogin == true {
            ImageView.isHidden = true
            ImageBtn.isHidden = true
            NameText.isHidden = true
            NameLabel.isHidden = true
        }else {
            ImageView.isHidden = false
            ImageBtn.isHidden = false
            NameText.isHidden = false
            NameLabel.isHidden = false
        }
        
        //print(base64SignupString)
        imagePicker.delegate = self
        
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
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
        if(facebooklogin == true){
            if CheckisCompleate == true {
                signupFacebook()
            }
        }else{
            if CheckisCompleate == true {
                Signup()
            }
        }
    }
    
    @IBAction func upLoadPicBtn(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        // print out the image size as a test
        ImageView.image = image
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
    
    func Checkfields() {
        if facebooklogin == false {
            guard let NameTxt = NameText.text, !NameTxt.isEmpty else {
                print("no text in name")
                return
            }
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
        
        guard let Gender = GenderText.text, !Gender.isEmpty else {
            print("not Gender")
            return
        }
        
        //do something if it's not empty
        CheckisCompleate = true
    }
    
    func Signup() {
        
        let parameters = ["timeSpendPerWeek": TimeSpendText.text, "name": NameText.text, "locationLong": center.longitude, "locationLat": center.latitude, "age": AgeText.text, "mobile": MobileText.text, "primarySports": Primary_Sports.text, "gender": GenderText.text, "sportLevel": Sport_Level.text, "profilePicture": base64StringImage ] as [String : Any]
        
        //Create the url
        let url = URL(string: "http://\(UrlVar.urlvar)/users/create")
        
        //Create the session object
        let session = URLSession.shared
        
        //Create the UrlRequest object using the url object
        var request = URLRequest(url: url!)
        request.httpMethod = "POST" // set request to POST
        request.setValue("Basic \(base64SignupString)", forHTTPHeaderField: "Authorization")
        
        //Add parameters to httpbody
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
                            self.performSegue(withIdentifier: "SignedUp", sender: self)
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
    
    func signupFacebook() {
        
        let parameters = ["timeSpendPerWeek": TimeSpendText.text, "locationLong": center.longitude, "locationLat": center.latitude, "age": AgeText.text, "mobile": MobileText.text, "primarySports": Primary_Sports.text, "gender": GenderText.text, "sportLevel": Sport_Level.text, "profilepicture": base64StringImage ] as [String : Any]
        
        //Create the url
        let url = URL(string: "http://\(UrlVar.urlvar)/users/facebook/create")
        
        //Create the session object
        let session = URLSession.shared
        
        //Create the UrlRequest object using the url object
        var request = URLRequest(url: url!)
        request.httpMethod = "POST" // set request to POST
        request.setValue("Bearer \(base64FacebookToken)", forHTTPHeaderField: "Authorization")
        
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
                            self.performSegue(withIdentifier: "SignedUp", sender: self)
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

