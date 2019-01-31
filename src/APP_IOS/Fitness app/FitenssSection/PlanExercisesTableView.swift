//
//  PlanExercisesTableView.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 24/01/2019.
//  Copyright © 2019 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation
import UIKit

class PlanExercisesTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    
    var ID:Int = 0
    var name:String = ""
    
    var execises = [Exercise]()
    //var users = [Exercise]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        getRequest()
        
    }
    
    func getRequest() {
        let url = URL(string: "http://\(UrlVar.urlvar)/sports/fitness/getExecisesInPlan/?fitnessPlanId=\(ID)")!
        let task = URLSession.shared.exercisesTask(with: url) { exercises, response, error in
            if let exercises = exercises {
                print(exercises)
                
                for car in exercises {
                    print("User is \(car.execiseName)")
                    print("---")
                    self.execises.append(car)
                    print(self.execises.count)
                    
                    
                    DispatchQueue.main.sync(execute: { () -> Void in
                        self.tableView.reloadData()
                        self.nameLabel.text = "Plan name: \(self.name)"
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
        cell.textLabel!.text = "Execise Name: \(user1.execiseName)"
        print(user1.execiseName)
        
        return cell
    }
    
    
    
    var exercise: Exercise?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
        let exercise1: Exercise
        exercise1 = execises[indexPath.row]
        exercise = exercise1
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "execiseInfo", sender: self)
        }
    }
    

    @IBAction func ShareBtn(_ sender: Any) {
        performSegue(withIdentifier: "SharePlan", sender: Any?.self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "execiseInfo") {
            let vc = segue.destination as! execiseDetail
            vc.exercise = exercise
        }
        if (segue.identifier == "SharePlan"){
            let vc = segue.destination as! ShareFitnessPlanTableViewController
            vc.ID = ID
            
        }else{
            print("hvor er info")
        }
    }
    
}
