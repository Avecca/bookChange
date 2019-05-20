//
//  User.swift
//  bookChange
//
//  Created by Hanna Astlind on 2019-04-25.
//  Copyright © 2019 Hanna Astlind. All rights reserved.
//

import Foundation
import  Firebase


class User {
    
    private var userName: String!
    private var location: String!
    
    
    
    //todo location
    init(_ userName: String) {
        self.userName = userName
        self.location = "Stockholm"
    }
    
    
    //TODO FLYTTA LOGOUT LOG IN HIT, DENNA GÖR INGET ÄN
    func logOut(){
        do {
            try Auth.auth().signOut()
            
            
            //tillbaka segway händer genom storyboarden
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}
