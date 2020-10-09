//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Haley Kell on 10/9/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]();

    override func viewDidLoad() {
        super.viewDidLoad();
        self.loadTweets();
    }
    
    func loadTweets(){
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json";
        let parameters = ["count": 10];
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: parameters, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll();
            for tweet in tweets {
                self.tweetArray.append(tweet);
            }
            
            self.tableView.reloadData();
            
        }, failure: { (Error) in
            print("Could not retrieve tweets.");
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCellTableViewCell;
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary;
        let imageUrl = URL(string: (user["profile_image_url_https"]) as! String)!;
        let data = try? Data(contentsOf: imageUrl);
        
        cell.nameLabel.text = user["name"] as? String;
        cell.tweetLabel.text = tweetArray[indexPath.row]["text"] as? String;
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData);
        }

        return cell;
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count;
    }

    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout();
        self.dismiss(animated: true, completion: nil);
        UserDefaults.standard.set(false, forKey: "userLoggedIn");
    }
    

}
