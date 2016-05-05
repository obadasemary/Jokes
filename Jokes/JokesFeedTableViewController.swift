//
//  JokesFeedTableViewController.swift
//  Jokes
//
//  Created by Abdelrahman Mohamed on 5/2/16.
//  Copyright © 2016 Abdelrahman Mohamed. All rights reserved.
//

import UIKit
import Firebase

class JokesFeedTableViewController: UITableViewController {
    
    var jokes = [Joke]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.dataService.JOKE_REF.observeEventType(.Value, withBlock: { snapshot in
                        
            self.jokes = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let joke = Joke(key: key, dictionary: postDictionary)
                        self.jokes.insert(joke, atIndex: 0)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return jokes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let joke = jokes[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("JokeCellTableViewCell") as? JokeCellTableViewCell {
            
            // Send the single joke to configureCell() in JokeCellTableViewCell.
            
            cell.configureCell(joke)
            
            return cell
            
        } else {
            
            return JokeCellTableViewCell()
            
        }
    }

    @IBAction func logout(sender: AnyObject) {
        
        DataService.dataService.CURRENT_USER_REF.unauth()
        
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: KEY_UID)
        
        let loginViewController = self.storyboard?.instantiateInitialViewController()
        UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
    }
}
