//
//  BidBookInfo.swift
//  bookChange
//
//  Created by Hanna Astlind on 2019-05-02.
//  Copyright © 2019 Hanna Astlind. All rights reserved.
//

import Foundation
import Firebase


class BidBookInfo {
    
    
    var db : Firestore!
    
    private(set) var bookUId: String!
    private(set) var bookId: String!
    private(set) var bookTitle: String!
    private(set) var bookAuthor: String!
    private(set) var offeredBookId: String!
    private(set) var offeredBookUserId: String!
    private(set) var offeredBookTitle: String!
    private(set) var offeredBookAuthor: String!
    private(set) var timeStamp: String!
    private(set) var status: String!
  
    
    private let format = DateFormatter()
    
    //place senare , TODO
    //bookId: String,
    init(bookUId: String, bookId: String, bookTitle : String, bookAuthor : String,  offeredBookId: String, offeredBookUserId: String, offeredBookTitle : String, offeredBookAuthor: String, timeStamp: String,  status: String ) {
        
        self.bookUId = bookUId
        self.bookId = bookId
        self.bookTitle = bookTitle
        self.bookAuthor = bookAuthor
        self.offeredBookId = offeredBookId
        self.offeredBookUserId = offeredBookUserId
        self.offeredBookTitle = offeredBookTitle
        self.offeredBookAuthor = offeredBookAuthor
        self.timeStamp = timeStamp
        
        self.status = status
        
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        
        //TODO guard let
        if let sSValue = snapshot.data() as? [String: Any]{
        
        
            bookId = sSValue["bookId"] as? String ?? ""
            offeredBookId = sSValue["offeredBookId"] as? String ?? ""
            offeredBookUserId = sSValue["offeredBookUserId"] as? String ?? ""
            timeStamp = sSValue["timeStamp"] as? String ?? ""
            status = sSValue["status"] as? String ?? ""
            bookUId = sSValue["bookUId"] as? String ?? ""
        }
        
        
        if bookId.isEmpty || offeredBookId.isEmpty {
            return
        }
        
        db = Firestore.firestore()
        
        print(bookId)
        var bidBook : Book?
        var offerBook : Book?
        
        let fbBidRef = db.collection("books").document(bookId)
        let fbOfferRef = db.collection("books").document(offeredBookId)
        //let ref = db.collection("books").document(bookId)
        
        fbOfferRef.getDocument() {
            (doc , err ) in
            
            if let doc = doc, doc.exists {
                let value = doc.data() as! [String: Any]
                bidBook = Book(snapshot: value, docId: doc.documentID)
                
                print("found bid book")
                
                self.bookTitle = bidBook?.title
                self.bookAuthor = bidBook!.authorFirstName + " " + bidBook!.authorLastName
                
                
                fbBidRef.getDocument(){
                    (offer, err) in
                    
                    if let offer = offer, offer.exists {
                        let oValue = offer.data() as! [String: Any]
                        offerBook = Book(snapshot: oValue, docId: offer.documentID)
                        
                        print("found offer book")
                        
                        self.offeredBookTitle = offerBook?.title
                        self.offeredBookAuthor = offerBook!.authorFirstName + " " + offerBook!.authorLastName
                        
                        print("bid \(self.bookTitle)")
                        print("offer: \(self.offeredBookTitle)")
                        
                        //$0.data()
                    } else {
                       print("Did not find offer book")
                    }
                    
                }
       
            } else {
                print("Did not find bid book")
                
            }
            
            
        }
        
        
        //TODO Query o hämta böckerna sinfo individuellt
        
        //använd sedan och koppla till firstviewcontrollers collectionview
        
        
    }
    
    
    
}


//            if let book = doc.flatMap({ (data) in
//                $0.data().flatMap({
//                    (data) in
//                    return Book(snapshot: data)
//                })
//            }) {
//                 book.
//                //let value = doc.data() as [String : Any]
//
//            } else {


