//
//  MainpageViewController.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 14/12/2018.
//  Copyright © 2018 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

class MainpageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    //var detailViewController: DetailViewController? = nil
    var users = [Users]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func Menu(_ sender: Any) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 130.0;//Choose your custom row height
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let User = users[indexPath.row]
        cell.textLabel!.text = User.name
        cell.detailTextLabel!.text = User.category
        return cell
    }
        
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let candy = users[indexPath.row]
                //let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                //controller.detailCandy = candy
            }
        }
    }
}
