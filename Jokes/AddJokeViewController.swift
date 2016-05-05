//
//  AddJokeViewController.swift
//  Jokes
//
//  Created by Abdelrahman Mohamed on 5/2/16.
//  Copyright © 2016 Abdelrahman Mohamed. All rights reserved.
//

import UIKit
import Firebase

class AddJokeViewController: UIViewController {
    
    var currentUsername = ""
    
    @IBOutlet weak var jokeField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.dataService.CURRENT_USER_REF.observeEventType(.Value, withBlock: { snapshot in
            
            let currentUser = snapshot.value.objectForKey("username") as! String
            
            print("Username: \(currentUser)")
            self.currentUsername = currentUser
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    @IBAction func saveJoke(sender: AnyObject) {
        
        let jokeText = jokeField.text
        
        if jokeText != "" {
            
            let newJoke: Dictionary<String, AnyObject> = [
                "jokeText": jokeText!,
                "votes": 0,
                "author": currentUsername
            ]
            
            DataService.dataService.createNewJoke(newJoke)
            
            if let navController = self.navigationController {
                navController.popViewControllerAnimated(true)
            }
        }
    }
}
