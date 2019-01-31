//
//  SearchTableViewController.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 17/01/2019.
//  Copyright © 2019 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation
import UIKit
import AvatarImageView

class SearchTableViewController: UITableViewController, UISearchBarDelegate{
    
    @IBOutlet var SearchBar: UISearchBar!
    
    var users = [User]()
    
    var data: [PictureData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        SearchBar.delegate = self
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        getRequest(Search: SearchBar.text!)
        searchBar.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        users.removeAll()
    }
    
    
    func getRequest(Search: String) {
        
        if(users.isEmpty == false){
            users.removeAll()
        }
        
        let urlComp = NSURLComponents(string: "http://\(UrlVar.urlvar)/users/community/searchForUsers/?search=\(Search)")!
        
        var urlRequest = URLRequest(url: urlComp.url!)
        urlRequest.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            
            print(response)
            
            guard let data = data, error == nil else { return }
            
            guard let Users = try? JSONDecoder().decode([User].self, from: data) else {
                print("Error: Couldn't decode data into cars array")
                return
            }
            
            for user in Users {
                print("User is \(user)")
                print("---")
                self.users.append(user)
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
        
        if cell == nil {
            cell = FindPotentielleUsersCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
            print("cant find cell")
        }
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
    var user : User?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(tableData[indexPath.item])
        let user1: User
        user1 = users[indexPath.row]
        user = user1
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "Info", sender: self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("pre for seque")
        
        if (segue.identifier == "Info") {
            let vc = segue.destination as! PotentielleUsersDetail
            vc.user = user
        }else{
            print("hvor er info")
        }
    }
}

