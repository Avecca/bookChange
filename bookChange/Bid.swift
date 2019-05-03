//
//  Bid.swift
//  bookChange
//
//  Created by Hanna Astlind on 2019-05-02.
//  Copyright © 2019 Hanna Astlind. All rights reserved.
//

import Foundation
import Firebase


class Bid {
    
    private(set) var bookUId: String!
    private(set) var bookId: String!
    private(set) var offeredBookId: String!
    private(set) var offeredBookUserId: String!
    private(set) var timeStamp: String!
    private(set) var status: String!
    
    private let format = DateFormatter()
    
    //place senare , TODO
    //bookId: String,
    init(bookUId: String, bookId: String, offeredBookId: String, offeredBookUserId: String, timeStamp: String,  status: String ) {
        
        self.bookUId = bookUId
        self.bookId = bookId
        self.offeredBookId = offeredBookId
        self.offeredBookUserId = offeredBookUserId
        self.timeStamp = timeStamp

        self.status = status
        
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        let sSValue = snapshot.data() as [String: Any]
        
        
        bookId = sSValue["bookId"] as! String
        bookUId = sSValue["bookUId"] as! String
        offeredBookId = sSValue["offeredBookId"] as! String
        offeredBookUserId = sSValue["offeredBookUserId"] as! String
        timeStamp = sSValue["timeStamp"] as! String
        status = sSValue["status"] as! String

        
        //snapshot.documentID
        
    }
    
    
    
}

