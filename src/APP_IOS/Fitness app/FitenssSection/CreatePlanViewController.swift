//
//  CreatePlanViewController.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 23/01/2019.
//  Copyright © 2019 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation
import UIKit

class CreatePlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var nameTxt: UITextField!
    
    var Friendsadded = [Int]()
    var execises = [Exercise]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTxt.delegate = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        getRequest()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    //let url = URL(string: "http://\(UrlVar.urlvar)/sports/fitness/getAllExecises")!
    func getRequest() {
        let url = URL(string: "http://192.168.153.140/sports/fitness/getAllExecises")!
        let task = URLSession.shared.exercisesTask(with: url) { exercises, response, error in
            print(response)
            print(exercises)
            if let exercises = exercises {
                print(exercises)
                
                for exercise in exercises {
                    print("User is \(exercise.execiseName)")
                    print("---")
                    self.execises.append(exercise)
                    print(self.execises.count)
                    
                    DispatchQueue.main.sync(execute: { () -> Void in
                        self.tableView.reloadData()
                    })
                    
                }
            }
            
        }
        task.resume()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return execises.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        
        let user1: Exercise
        user1 = execises[indexPath.row]
        cell.textLabel!.text = "Name: \(user1.execiseName)"
        print(user1.execiseName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
        print("saved")
        
        let user1: Exercise
        user1 = execises[indexPath.row]
        
        self.Friendsadded.append(user1.idFitnessExercises)
        
        print(Friendsadded)
        
        
        self.execises.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
    @IBAction func CreatePlanBtn(_ sender: Any) {
        SendPlan()
    }
    
    
    func SendPlan() {
        let parameters = ["FitnessPlanName": nameTxt.text , "FitnessPlanExecises": Friendsadded ] as [String : Any]
        //Create the url
        let url = URL(string: "http://\(UrlVar.urlvar)/sports/fitness/createFitnessPlan/")
        
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
                        
                        DispatchQueue.main.sync(execute: { () -> Void in
                            
                            self.navigationController?.popViewController(animated: true)
                            
                            self.dismiss(animated: true, completion: nil)
                            
                        })
                        
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
