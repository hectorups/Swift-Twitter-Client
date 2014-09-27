//
//  LoginViewController.swift
//  Twitter
//
//  Created by Hector Monserrate on 25/09/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import UIKit
import SwifteriOS

class LoginViewController: UIViewController {

    private var swifter = SwifterApi.sharedInstance
    private var defaults = NSUserDefaults.standardUserDefaults()
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        if let data = defaults.objectForKey("account") as NSData? {
            let account = NSKeyedUnarchiver.unarchiveObjectWithData(data) as TwitterAccount
            let credentialToken = SwifterCredential.OAuthAccessToken(key: account.key, secret: account.secret)
            swifter.client.credential = SwifterCredential(accessToken: credentialToken)
            goToHomeController()
        }
    }
    
    
    @IBAction func didTouchUpInsideLoginButton(sender: AnyObject) {
        swifter.client.credential = nil
        
        let failureHandler: ((NSError) -> Void) = {
            error in
            
            println("error")
            println(error)
        }
        

        swifter.authorizeWithCallbackURL(NSURL(string: "codepathtwitter://success"), success: {
            accessToken, response in
                println("logged with tweeter")
                self.verifyCredentials()
            },failure: failureHandler
        )
    }
    
    func goToHomeController() {
        let mainNavigationController = self.storyboard!.instantiateViewControllerWithIdentifier("MainNavigationController") as UINavigationController
        
        presentViewController(mainNavigationController, animated: true, completion: nil)
    }
    
    func fetchTwitterHomeStream() {
        println(swifter.client.credential?.accessToken?.key)
        swifter.getStatusesHomeTimelineWithCount(20, sinceID: nil, maxID: nil, trimUser: true,
            contributorDetails: false, includeEntities: true, success: {
                (statuses: [JSONValue]?) in
                println("fetched successfully")
            }, failure: failureHandler())
    }
    
    func verifyCredentials() {
        swifter.getAccountVerifyCredentials(true, skipStatus: false, success: { (myInfo) -> Void in
            println(myInfo)
            
            let user = TwitterUser(jsonValue: myInfo!)
            let accessToken = self.swifter.client.credential!.accessToken!
            let account = TwitterAccount(user: user, key: accessToken.key, secret: accessToken.secret)
            let data = NSKeyedArchiver.archivedDataWithRootObject(account)
            self.defaults.setObject(data, forKey: "account")
            
            self.goToHomeController()
        }, failure: failureHandler())
    }
    
    func failureHandler() -> ((NSError) -> Void) {
        return {
            error in
            
            println("error")
            println(error)
        }
    }

}
