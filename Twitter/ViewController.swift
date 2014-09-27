//
//  ViewController.swift
//  Twitter
//
//  Created by Hector Monserrate on 24/09/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import UIKit
import SwifteriOS

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    private var defaults = NSUserDefaults.standardUserDefaults()
    
    var swifter = SwifterApi.sharedInstance
    var statuses = [TwitterStatus]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = ColorPalette.Blue.get()
        navigationController?.navigationBar.titleTextAttributes = NSDictionary(
            object: ColorPalette.White.get(), forKey: NSForegroundColorAttributeName)
        title = "Home"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out",
            style: UIBarButtonItemStyle.Plain, target: self, action: "onSignOut")
        self.navigationItem.leftBarButtonItem?.tintColor = ColorPalette.White.get()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New",
            style: UIBarButtonItemStyle.Plain, target: self, action: "onNewTweet")
        self.navigationItem.rightBarButtonItem?.tintColor = ColorPalette.White.get()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0

        fetchTwitterHomeStream()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = reusableTableCell("TweetTableViewCell") as TweetTableViewCell
        
        cell.loadStatus(statuses[indexPath.row])
        
        return cell
    }
    
    func reusableTableCell(identifier: String) -> UITableViewCell {
        var possibleCell = tableView.dequeueReusableCellWithIdentifier(identifier) as UITableViewCell?
        if possibleCell == nil {
            let topLevelObjects = NSBundle.mainBundle().loadNibNamed(identifier, owner: self, options: nil)
            possibleCell = topLevelObjects.first as UITableViewCell?
        }
        
        
        return possibleCell!
    }
    
    func fetchTwitterHomeStream() {
        let failureHandler: ((NSError) -> Void) = {
            error in
            println("error fetching tweets")
            println(error)
        }
        
        swifter.getStatusesHomeTimelineWithCount(20, sinceID: nil, maxID: nil, trimUser: false,
            contributorDetails: true, includeEntities: true, success: {
            (statuses: [JSONValue]?) in
                println("fetched successfully")
                
                self.statuses = []
                for status in statuses! {
                   self.statuses.append(TwitterStatus(jsonValue: status))
                }
                
                self.tableView.reloadData()
            }, failure: failureHandler)
    }
    
    func onSignOut() {
        defaults.setObject(nil, forKey: "key")
        defaults.setObject(nil, forKey: "secret")
        swifter.client.credential = nil
        
        let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as LoginViewController
        presentViewController(loginViewController, animated: true, completion: nil)
    }
    
    func onNewTweet() {
        println("new tweet")
    }

}

