//
//  offersBidsViewCell.swift
//  bookChange
//
//  Created by Hanna Astlind on 2019-04-25.
//  Copyright © 2019 Hanna Astlind. All rights reserved.
//

import UIKit
import Firebase

class OffersBidsViewCell: UICollectionViewCell {
    
//    private(set) var bookUId: String!
//    private(set) var bookId: String!
//
//    private(set) var offeredBookId: String!
//    private(set) var offeredBookUserId: String!
    @IBOutlet weak var bidLabel: UILabel!
    @IBOutlet weak var bidTitle: UILabel!
    @IBOutlet weak var bidAuthor: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var offerTitle: UILabel!
    @IBOutlet weak var offerAuthor: UILabel!
   
    @IBOutlet weak var bidView: UIView!
    @IBOutlet weak var offerView: UIView!
    
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var declineBtn: UIButton!
    
    var db : Firestore!

    func configCell(bid: Bid)  {
//        titleLbl.text = book.title
//        //TODO maybe format here and not when adding to db, if so change Book. init
//        dateLbl.text = book.timeStamp
//        authorLbl.text = " by: " + book.authorFirstName + " " + book.authorLastName
//        genreLbl.text = book.genre
//        descriptionLbl.text = book.description
        
        print("i cell")
        print(bid.bookId)
        
        
//        bidTitle.text = bid.bookTitle
//        bidAuthor.text = bid.bookAuthor
//        offerTitle.text = bid.offeredBookTitle
//        offerAuthor.text = bid.offeredBookAuthor
        
        

        db = Firestore.firestore()
        let user = Auth.auth().currentUser
        let cUserId = user?.uid

       // print(bookId)
        var bidBook : Book?
        var offerBook : Book?

        let fbBidRef = db.collection("books").document(bid.bookId) //the one i bid on
        let fbOfferRef = db.collection("books").document(bid.offeredBookId) //the one I offered

        
        fbBidRef.getDocument(){
            (doc , err ) in

            if let doc = doc, doc.exists {
                let value = doc.data() as! [String: Any]
                bidBook = Book(snapshot: value, docId: doc.documentID)

                print("found bid book")
                
                self.bidTitle.text = bidBook?.title
                self.bidAuthor.text = bidBook!.authorFirstName + " " + bidBook!.authorLastName

//                self.bookTitle = bidBook?.title
//                self.bookAuthor = bidBook!.authorFirstName + " " + bidBook!.authorLastName
                
                //CHANGE BACKGROUND
                if bidBook?.userId != cUserId {
                    self.offerView.backgroundColor = UIColor.white
                    self.bidView.backgroundColor = #colorLiteral(red: 0.9931535125, green: 1, blue: 0.8774371147, alpha: 1)
                    self.bidLabel.text = "bid made"
                    self.offerLabel.text = "my offer"
                    self.acceptBtn.isHidden = true
                    if bid.status == "accepted" {
                        self.declineBtn.setTitle("accepted email", for: .normal)
                        self.declineBtn.backgroundColor = .darkGray
                        self.declineBtn.isEnabled = true
                        
                        
                    }else {
                      self.declineBtn.setTitle("remove bid", for: .normal)
                        self.declineBtn.backgroundColor = .red
                        self.declineBtn.isEnabled = true
                    }
                    
                    
                    self.declineBtn.isHidden = false
                    
                    
                    
                } else{
                    self.offerView.backgroundColor = #colorLiteral(red: 0.9931535125, green: 1, blue: 0.8774371147, alpha: 1)
                    self.bidView.backgroundColor = UIColor.white
                    self.bidLabel.text = "my book"
                    self.offerLabel.text = "offer recieved"
                    self.acceptBtn.setTitle("accept", for: .normal)
                    
                    if bid.status == "accepted" {
                        self.declineBtn.setTitle("bid accepted", for: .normal)
                        self.declineBtn.backgroundColor = .darkGray
                        self.declineBtn.isEnabled = false
                        self.acceptBtn.isEnabled = false
                        self.acceptBtn.isHidden = true

                        
                    }else {
                        self.acceptBtn.isHidden = false
                        self.declineBtn.setTitle("decline", for: .normal)
                        self.declineBtn.backgroundColor = .red
                        self.declineBtn.isEnabled = true
                        self.acceptBtn.isEnabled = true
                        self.acceptBtn.isHidden = false
                        

                    }
                    self.declineBtn.isHidden = false
                    
                }
                
                

                
                //TODO Om Mitt bid, gör decline knappen till remove
                //todo Om mitt offer, deline knappen ska heta decline

                fbOfferRef.getDocument(){
                    (offer, err) in

                    if let offer = offer, offer.exists {
                        let oValue = offer.data() as! [String: Any]
                        offerBook = Book(snapshot: oValue, docId: offer.documentID)

                        print("found offer book")
                        
                        self.offerTitle.text = offerBook?.title
                        self.offerAuthor.text = offerBook!.authorFirstName + " " + offerBook!.authorLastName
                        
//
//                        self.offeredBookTitle = offerBook?.title
//                        self.offeredBookAuthor = offerBook!.authorFirstName + " " + offerBook!.authorLastName
                    //TODO OM Mitt bid, ta bort accept knappen
                        //TODO Om mitt offer(jag tagit emor ett offer) accept knappen ska synas
                        

                        //$0.data()
                    } else {
                        print("Did not find offer book")
                    }

                }

            } else {
                print("Did not find bid book")

            }
            
            
            


        }
        
    }
    
}
