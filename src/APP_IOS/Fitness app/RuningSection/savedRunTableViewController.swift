//
//  savedRunTableViewController.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 21/01/2019.
//  Copyright © 2019 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation
import UIKit

class savedRunTableViewController: UITableViewController{
    
    var tableData: NSArray = NSArray()
    var element:NSDictionary = [:]
    
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
        //tableData = nil
    }
    
    @objc func getRequest() {
        
        let urlComp = NSURLComponents(string: "http://localhost:3333/sports/running/getRuns")!
        
        var urlRequest = URLRequest(url: urlComp.url!)
        urlRequest.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            
            print(response)
            
            guard let data = data, error == nil else { return }
            
            print(data)
            
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> RunTableviewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! RunTableviewCell
        
        if cell == nil {
            cell = RunTableviewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
            print("cant find cell")
        }
        let item: Cell = tableData[indexPath.row] as! Cell
        
        let seconds = Int(item.object!["duration"] as! Int)
        let formattedTime = FormatDisplay.time(seconds)
        cell.Duration.text = "duration: \(formattedTime)"
        
        let distance = item.object!["distance"] as! Double
        cell.Distance.text = "Distance: \(FormatDisplay.distance(distance))"
        
        if  let  timeResult = (item.object!["startTime"] as? Double) {
            let date = Date(timeIntervalSince1970: timeResult)
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
            let localDate = dateFormatter.string(from: date)
            cell.Starttime.text = "Start time: \(localDate)"
            
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
