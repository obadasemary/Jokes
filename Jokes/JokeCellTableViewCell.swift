//
//  JokeCellTableViewCell.swift
//  Jokes
//
//  Created by Abdelrahman Mohamed on 5/2/16.
//  Copyright © 2016 Abdelrahman Mohamed. All rights reserved.
//

import UIKit
import Firebase

class JokeCellTableViewCell: UITableViewCell {
    
    var joke: Joke!
    var voteRef: Firebase!

    @IBOutlet weak var jokeText: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var totalVotesLabel: UILabel!
    @IBOutlet weak var thumbVoteImage: UIImageView!
    @IBOutlet weak var userImage: UIImageView!

    func configureCell(joke: Joke) {
        self.joke = joke
        
        // Set the labels and textView.
        
        self.jokeText.text = joke.jokeText
        self.totalVotesLabel.text = "Total Votes: \(joke.jokeVotes)"
        self.usernameLabel.text = joke.username
        
        // Set "votes" as a child of the current user in Firebase and save the joke's key in votes as a boolean.
        
        voteRef = DataService.dataService.CURRENT_USER_REF.childByAppendingPath("votes").childByAppendingPath(joke.jokeKey)
        
        // observeSingleEventOfType() listens for the thumb to be tapped, by any user, on any device.
        
        voteRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            // Set the thumb image.
            
            if let thumbsUpDown = snapshot.value as? NSNull {
                
                // Current user hasn't voted for the joke... yet.
                
                print(thumbsUpDown)
                self.thumbVoteImage.image = UIImage(named: "Hearts")
            } else {
                
                // Current user voted for the joke!
                
                self.thumbVoteImage.image = UIImage(named: "Hearts Filled")
            }
        })
    }
    
    func voteTapped(sender: UITapGestureRecognizer) {
        
        // observeSingleEventOfType listens for a tap by the current user.
        
        voteRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let thumbsUpDown = snapshot.value as? NSNull {
                print(thumbsUpDown)
                self.thumbVoteImage.image = UIImage(named: "Hearts Filled")
                
                // addSubtractVote(), in Joke.swift, handles the vote.
                
                self.joke.addSubtractVote(true)
                
                // setValue saves the vote as true for the current user.
                // voteRef is a reference to the user's "votes" path.
                
                self.voteRef.setValue(true)
            } else {
                self.thumbVoteImage.image = UIImage(named: "Hearts")
                self.joke.addSubtractVote(false)
                self.voteRef.removeValue()
            }
            
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // UITapGestureRecognizer is set programatically.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(JokeCellTableViewCell.voteTapped(_:)))
        tap.numberOfTapsRequired = 1
        thumbVoteImage.addGestureRecognizer(tap)
        thumbVoteImage.userInteractionEnabled = true
    }

}
