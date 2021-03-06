//
//  User.swift
//  Twitter
//
//  Created by Hector Monserrate on 26/09/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

import Foundation
import SwifteriOS

class TwitterUser: NSObject, NSCoding {
    var userId: Int
    var profileBannerUrl: String?
    var profileImageUrl: String?
    var name: String
    var screenName: String?
    var tweetsCount: Int?
    var followingCount: Int?
    var followersCount: Int?
    var about: String?
    
    init( jsonValue: Dictionary<String, JSONValue>) {
        userId = (jsonValue["id"]?.integer)!
        profileBannerUrl = jsonValue["profile_banner_url"]?.string
        profileImageUrl = jsonValue["profile_image_url"]?.string
        name = (jsonValue["name"]?.string)!
        screenName = jsonValue["screen_name"]?.string
        tweetsCount = jsonValue["statuses_count"]?.integer
        followingCount = jsonValue["friends_count"]?.integer
        followersCount = jsonValue["followers_count"]?.integer
        about = jsonValue["description"]?.string
    }
    
    required init(coder aDecoder: NSCoder) {
        userId = aDecoder.decodeObjectForKey("userId") as Int
        profileBannerUrl  = aDecoder.decodeObjectForKey("profileBannerUrl") as? String
        profileImageUrl  = aDecoder.decodeObjectForKey("profileImageUrl") as? String
        name  = aDecoder.decodeObjectForKey("name") as String
        screenName  = aDecoder.decodeObjectForKey("screenName") as? String
        tweetsCount  = aDecoder.decodeObjectForKey("tweetsCount") as? Int
        followingCount  = aDecoder.decodeObjectForKey("followingCount") as? Int
        followersCount  = aDecoder.decodeObjectForKey("followersCount") as? Int
        about = aDecoder.decodeObjectForKey("about") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(userId, forKey: "userId")
        
        if let profileBannerUrl = self.profileBannerUrl{
            aCoder.encodeObject(profileBannerUrl, forKey: "profileBannerUrl")
        }
        
        if let profileImageUrl = self.profileImageUrl{
            aCoder.encodeObject(profileImageUrl, forKey: "profileImageUrl")
        }
        
        aCoder.encodeObject(name, forKey: "name")
        
        if let screenName = self.screenName{
            aCoder.encodeObject(screenName, forKey: "screenName")
        }
        
        if let tweetsCount = self.tweetsCount{
            aCoder.encodeObject(tweetsCount, forKey: "tweetsCount")
        }
        
        if let followingCount = self.followingCount{
            aCoder.encodeObject(followingCount, forKey: "followingCount")
        }
        
        if let followersCount = self.followersCount{
            aCoder.encodeObject(followersCount, forKey: "followersCount")
        }
        
        if let about = self.about{
            aCoder.encodeObject(about, forKey: "about")
        }
    }
}