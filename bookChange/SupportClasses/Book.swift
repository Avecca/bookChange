//
//  Book.swift
//  bookChange
//
//  Created by Hanna Astlind on 2019-04-25.
//  Copyright © 2019 Hanna Astlind. All rights reserved.
//

import Foundation
import  Firebase

class Book {
    
    private(set) var userId: String!
    private(set) var bookId: String!
    private(set) var title: String!
    private(set) var authorFirstName: String!
    private(set) var authorLastName: String!
    private(set) var genre: String!
    private(set) var description: String!
    private(set) var meetingAdress: String!
    private(set) var timeStamp: String!
    private(set) var status: String!
    
    private let format = DateFormatter()
    
    //place senare , TODO
    //bookId: String,
    init(userId: String, bookId: String, title: String, authorFirstName: String, authorLastName: String, genre: String, description: String, timeStamp: String, status: String ) {
        
        self.userId = userId
        self.bookId = bookId
        self.title = title
        self.authorFirstName = authorFirstName
        self.authorLastName = authorLastName
        self.genre = genre
        self.description = description
        self.meetingAdress = "Stockholm"
        self.timeStamp = timeStamp
        self.status = status
        
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        if let sSValue = snapshot.data() as? [String: Any] {
        
        //TODO GUARDLET
        
            userId = sSValue["userId"] as? String ?? ""
            bookId = snapshot.documentID
            title = sSValue["title"] as? String ?? ""
            authorFirstName = sSValue["authorFirstName"] as? String ?? ""
            authorLastName = sSValue["authorLastName"] as? String ?? ""
            genre = sSValue["genre"] as? String ?? ""
            description = sSValue["description"] as? String ?? ""
            meetingAdress = sSValue["meetingAdress"] as? String ?? ""
        
            //TODO formatera strängen till bara yyy-MM-dd
            timeStamp = sSValue["timeStamp"] as? String ?? ""
            status = sSValue["status"] as? String ?? ""
        
        }
        
        
    }
    init(snapshot:  [String: Any], docId : String ) {
        //let sSValue = snapshot.data() as [String: Any]
        
        //TODO GUARDLET
        
        userId = snapshot["userId"] as? String ?? ""
        bookId = docId
        title = snapshot["title"] as? String ?? ""
        authorFirstName = snapshot["authorFirstName"] as? String ?? ""
        authorLastName = snapshot["authorLastName"] as? String ?? ""
        genre = snapshot["genre"] as? String ?? ""
        description = snapshot["description"] as? String ?? ""
        meetingAdress = snapshot["meetingAdress"] as? String ?? ""
        
        //TODO formatera strängen till bara yyy-MM-dd
        timeStamp = snapshot["timeStamp"] as? String ?? ""
        status = snapshot["status"] as? String ?? ""
        
        
        
        
    }
    
    
    
}
