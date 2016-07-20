//
//  test.swift
//  Smashtag
//
//  Created by Tatiana Kornilova on 7/20/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

struct RecentSearches {
    private static let defaults = NSUserDefaults.standardUserDefaults()
    private static let key = "RecentSearces"
    private static let limit = 100
    
    static var searches: [String] {
        return (defaults.objectForKey(key) as? [String]) ?? []
    }
    
 .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  .
    static func removeAtIndex(index: Int) {
        
        var currentSearches = (defaults.objectForKey(key) as? [String]) ?? []
        currentSearches.removeAtIndex(index)
        defaults.setObject(currentSearches, forKey:key)
    }
}