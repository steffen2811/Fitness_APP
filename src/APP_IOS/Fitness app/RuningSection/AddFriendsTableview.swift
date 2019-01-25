//
//  AddFriendsTableview.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 22/01/2019.
//  Copyright © 2019 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation
import UIKit

class AddFriendsTableview: UITableViewController{

    
    var data: [PictureData] = []
    
    var users = [User]()
    
    var run: Run!
    var Lat = [Double]()
    var long = [Double]()
    var timestamp = [Int]()
    var runtimestamp: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(run)
        
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
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    @objc func getRequest() {
        
        let urlComp = NSURLComponents(string: "http://localhost:3333/users/community/getFriends")!
        
        var urlRequest = URLRequest(url: urlComp.url!)
        urlRequest.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
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
            
        })
        task.resume()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of feed items
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 130.0;//Choose your custom row height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> FindPotentielleUsersCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! FindPotentielleUsersCell
        
        let user1: User
        user1 = users[indexPath.row]
        cell.Name.text = "Name: " + user1.name
        
        var age = "Age: \(user1.age as! Int)"
        cell.Age.text = String(age)
        
        cell.Fitness.text = "Sport: " + user1.primarySports
        
        var data = PictureData()
        //let url = URL(string: "https://avatars.io/static/default_128.jpg")
        let url = URL(string: user1.profileImgPath as! String)
        let data1 = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        data.avatar = UIImage(data: data1!)
        cell.Profilepic.dataSource = data
        
        return cell
    }
    
    var Friendsadded = [Int]()
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("saved")
        
        let user1: User
        user1 = users[indexPath.row]
        
        self.Friendsadded.append(user1.id_users)
        
        print(Friendsadded)
        
        
        self.users.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
    @IBAction func SaveFriends(_ sender: Any) {
        SendRun()
    }
    
    func SendRun() {
        let locations = run.locations
        let parameters = ["distance": run.distance,"startTime": runtimestamp  , "duration": run.duration, "lat": Lat, "long": long, "locationTime": timestamp, "perticipatingUsers": Friendsadded ] as [String : Any]
        //Create the url
        let url = URL(string: "http://localhost:3333/sports/running/registerRun")
        
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
                            
                            self.performSegue(withIdentifier: "Saved", sender: self)
                            
                        })
                        
                    }
                } else {
                    print("statusCode: \(httpResponse.statusCode)")
                    print(error)
                }
                
            }
        })
        task.resume()
    }
}
