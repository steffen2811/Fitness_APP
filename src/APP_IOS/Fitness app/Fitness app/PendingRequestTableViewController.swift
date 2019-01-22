//
//  PendingRequestTableViewController.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 17/01/2019.
//  Copyright © 2019 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation
import UIKit
import AvatarImageView


class PendingRequestTableViewController: UITableViewController {
    
    
    var tableData: NSArray = NSArray()
    var element:NSDictionary = [:]
    
    var data: [PictureData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRequest()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(getRequest), for: UIControl.Event.valueChanged)
        self.refreshControl = refreshControl
    }
    
    
    @objc func getRequest() {
        
        let urlComp = NSURLComponents(string: "http://localhost:3333/users/community/getPendingRequest")!
        
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
                    DispatchQueue.main.sync(execute: { () -> Void in
                        
                        var tableData1: NSArray = NSArray()
                        
                        self.tableData = tableData1
                        self.tableView.reloadData()
                        self.refreshControl?.endRefreshing()
//                        let alert = UIAlertController(title: "Alert", message: "You have no requests", preferredStyle: .alert)
//
//                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
//                            self.performSegue(withIdentifier: "noRequests", sender: Any?.self)
//                        }))
//
//                        self.present(alert, animated: true)
                    })
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> FindPotentielleUsersCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! FindPotentielleUsersCell
        
        if cell == nil {
            cell = FindPotentielleUsersCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
            print("cant find cell")
        }
        let item: Cell = tableData[indexPath.row] as! Cell
        //        cell?.order_idtxt.text = "\(item.object!["order_id"]!)"
        cell.Name.text = "Name: " + (item.object!["name"] as! String)
        
        var age = "Age: \(item.object!["age"] as! Int)"
        cell.Age.text = String(age)
        
        cell.Fitness.text = "Sport: " + (item.object!["primarySports"] as! String)
        
        
        var data = PictureData()
        let url = URL(string: "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973461_1280.png")
        let data1 = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        
        
        data.avatar = UIImage(data: data1!)
        cell.Profilepic.dataSource = data
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(tableData[indexPath.item])
        let IDitem: Cell = tableData[indexPath.row] as! Cell
        var elementitem = IDitem.object
        element = elementitem!
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "Info", sender: self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("pre for seque")
        
        if (segue.identifier == "Info") {
            let vc = segue.destination as! PendingRequestDetailViewController
            vc.jsonlement = element
        }else{
            print("hvor er info")
        }
    }
}
