//
//  ShowFriendsTableViewController.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 18/01/2019.
//  Copyright © 2019 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation
import UIKit

class ShowFriendsTableViewController: UITableViewController{
    
    var tableData: NSArray = NSArray()
    var element:NSDictionary = [:]
    
    var data: [PictureData] = []
    
    var users = [User]()
    
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
        users.removeAll()
    }
    
    @objc func getRequest() {
        
        let urlComp = NSURLComponents(string: "http://localhost:3333/users/community/getFriends")!
        
        var urlRequest = URLRequest(url: urlComp.url!)
        urlRequest.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            
            print(response)
            
            guard let data = data, error == nil else { return }
            
            guard let cars = try? JSONDecoder().decode([User].self, from: data) else {
                print("Error: Couldn't decode data into cars array")
                return
            }
            
            for car in cars {
                print("User is \(car)")
                print("---")
                self.users.append(car)
                print(self.users.count)
                
            }
            
            DispatchQueue.main.sync(execute: { () -> Void in
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            })
            
//            do {
//                //create json object from data
//                if var json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyObject] {
//                    // handle json...
//                    print(json)
//                    var jsonElement = NSDictionary()
//                    let Data = NSMutableArray()
//                    for i in 0 ..< json.count
//                    {
//                        jsonElement = json[i] as! NSDictionary
//                        print(json[i])
//                        let cell = Cell()
//                        cell.object = jsonElement
//                        Data.add(cell)
//
//
//
//                    }
//
//                    DispatchQueue.main.sync(execute: { () -> Void in
//
//                        self.itemsDownloaded(items: Data)
//
//                    })
//
//                } else {
//                    print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
//                }
//            } catch let error {
//                print(error.localizedDescription)
//            }
            
        })
        task.resume()
    }
    
    
//    func itemsDownloaded(items: NSArray) {
//
//        tableData = items
//        self.tableView.reloadData()
//        refreshControl?.endRefreshing()
//    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of feed items
        //return tableData.count
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 130.0;//Choose your custom row height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> FindPotentielleUsersCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! FindPotentielleUsersCell
        
//        if cell == nil {
//            cell = FindPotentielleUsersCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
//            print("cant find cell")
//        }
//        let item: Cell = tableData[indexPath.row] as! Cell
//        //        cell?.order_idtxt.text = "\(item.object!["order_id"]!)"
//        cell.Name.text = "Name: " + (item.object!["name"] as! String)
//
//        var age = "Age: \(item.object!["age"] as! Int)"
//        cell.Age.text = String(age)
//
//        cell.Fitness.text = "Sport: " + (item.object!["primarySports"] as! String)
//
//
//        var data = PictureData()
//        let url = URL(string: "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973461_1280.png")
//        let data1 = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//
//
//        data.avatar = UIImage(data: data1!)
//        cell.Profilepic.dataSource = data
//
//        return cell
        
        let user1: User
        user1 = users[indexPath.row]
        cell.Name.text = "Name: " + user1.name
        
        var age = "Age: \(user1.age as! Int)"
        cell.Age.text = String(age)
        
        cell.Fitness.text = "Sport: " + user1.primarySports
        
        var data = PictureData()
        let url = URL(string: "https://avatars.io/static/default_128.jpg")
        let data1 = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        data.avatar = UIImage(data: data1!)
        cell.Profilepic.dataSource = data
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
