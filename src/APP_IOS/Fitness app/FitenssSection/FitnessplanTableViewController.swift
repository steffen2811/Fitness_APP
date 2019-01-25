//
//  FitnessplanTableViewController.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 24/01/2019.
//  Copyright © 2019 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation
import UIKit

class FitnessplanTableViewController: UITableViewController {
    
    
    var tableData: NSArray = NSArray()
    var element: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRequest()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(getRequest), for: UIControl.Event.valueChanged)
        self.refreshControl = refreshControl
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    @objc func getRequest() {
        
        let urlComp = NSURLComponents(string: "http://localhost:3333/sports/fitness/getFitnessPlans")!
        
        var urlRequest = URLRequest(url: urlComp.url!)
        urlRequest.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            
            print(response)
            
            guard let data = data, error == nil else { return }
            
            do {
                //create json object from data
                if var json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyObject] {
                    // handle json...
                    //print(json)
                    var jsonElement = NSDictionary()
                    let Data = NSMutableArray()
                    for i in 0 ..< json.count
                    {
                        jsonElement = json[i] as! NSDictionary
                        print(json[i])
                        let cell = Cell()
                        cell.object = jsonElement
                        Data.add(cell)
                        
                        
                    }
                    
                    DispatchQueue.main.sync(execute: { () -> Void in
                        
                        self.itemsDownloaded(items: Data)
                        
                    })
                    
                } else {
                    print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        })
        task.resume()
    }
    
    
    func itemsDownloaded(items: NSArray) {
        
        tableData = items
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of feed items
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 130.0;//Choose your custom row height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell
        
        let item: Cell = tableData[indexPath.row] as! Cell
        
        cell.textLabel?.text = "Name: " + (item.object!["FitnessPlanName"] as! String)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(tableData[indexPath.item])
        let IDitem: Cell = tableData[indexPath.row] as! Cell
        var elementitem = IDitem.object!["id_fitness_plan"] as! Int
        element = elementitem
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "Info", sender: self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "Info") {
            let vc = segue.destination as! PlanExercisesTableView
            vc.ID = element
        }else{
            print("hvor er info")
        }
    }
}
