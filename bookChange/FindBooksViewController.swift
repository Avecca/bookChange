//
//  FindBooksViewController.swift
//  bookChange
//
//  Created by Hanna Astlind on 2019-03-04.
//  Copyright © 2019 Hanna Astlind. All rights reserved.
//

import UIKit
import Firebase

class FindBooksViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //TODO STATUS ACCEPTED; BID; DECLINED, iF status >= BID osv osv

    @IBOutlet weak var genreSegmentCtrl: UISegmentedControl!
    @IBOutlet weak var findBooksCV: UICollectionView!
    
    var books = [Book]()
    var db : Firestore!
    var auth : Auth!
    var date: Date!
    let format = DateFormatter()
    //var userId: String!
    var findByGenre: String!
    var orderBy: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.findByGenre = "all"
        //order by
        self.orderBy = "authorLastName"
        
        auth = Auth.auth()
        db = Firestore.firestore()
        format.dateFormat = "yyy-MM-dd HH:mm"
        
        findBooksCV.delegate = self
        findBooksCV.dataSource = self
        
        
    }
    
    @IBAction func bidPressed(_ sender: UIButton) {
        print("bid pressed")
        
        let index = sender.tag
        print("index: \(index)")
        
        let  bookId = books[index].bookId
        let bookOwnerId = books[index].userId
        //TODO FIX THE HARDCODING
        let offeredBookId = "89OCgCREq8KOZpZvqxnr"
        
        //self.present(self.alert,animated: true)
        
        
        
        if auth.currentUser !=  nil {
            
            self.date = Date()
            let formattedDate = format.string(from: self.date)
            
            let userId = auth.currentUser?.uid
            
            let newBid : Dictionary<String,Any> = [
                "bookUId" : bookOwnerId,
                "bookId" : bookId,
                "offeredBookId" : offeredBookId,
                "offeredBookUserId" : userId,
                "timeStamp" : formattedDate,
                "status": "bid"
            ]
            
            var ref : DocumentReference? = nil
            
            ref = db.collection("bids").addDocument(data: newBid) {
                err in
                
                if let erro = err {
                    print("error bidding on book")
                } else {
                    
                    print("bid added with \(ref?.documentID)")
                    
                    //add bid ref to booth users
                    
                    //add bid to user making bid(offer), my bids
                self.db.collection("users").document(userId!).collection("myBids").addDocument(data: ["bidId" : ref!.documentID]) {
                        err in
                        if let erro = err {
                            print("Bid id not saved to user")
                        } else {
                            print("Bid id saved to user")
                        }
                    }
                    
                    //add bid to bookowner, recieved, my offer
                self.db.collection("users").document(bookOwnerId!).collection("myOffers").addDocument(data: ["bidId" : ref!.documentID]) {
                        err in
                        if let erro = err {
                            print("Bid id as an offer not saved to user")
                        } else {
                            print("Bid id  as an offer saved to user")
                        }
                    }
                    
                    
                }
                
            }
            
        }
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
    
        updateFindBooksArray()
        
    }
    
    func updateFindBooksArray()  {
        
        
        if auth.currentUser != nil {
            
            print("User är inloggad och letar nya böcker!")
         
            let user = Auth.auth().currentUser
            
            //var fBRef: Query
            
            //userId = user?.uid
//            if findByGenre == "all" {
//                print("found genre in all books")
//                //fBRef = db.collection("books").order(by: self.orderBy, descending: false)
//                fBRef = db.collection("books").order(by: self.orderBy, descending: false) //.whereField("userId", isGreaterThan: self.userId)//.order(by: self.orderBy, descending: false)  //och nästa .whereField("userId", isLessThan: userId). sen addera dom båda listorna
//
//            } else {
//                print("genre is " + findByGenre)
//                fBRef = db.collection("books").whereField("genre", isEqualTo: findByGenre).order(by: self.orderBy, descending: false) as! CollectionReference
//                //.whereField("userId", isGreaterThan: self.userId).whereField("userId", isLessThan: userId)
//
//            }

            
            //print(userId + " is userid")
            
            let bookRef =  db.collection("books").whereField("status", isEqualTo: "published")//.whereField("userId", isEqualTo: userId)//db.collection("books")
            
            bookRef.addSnapshotListener() {
                (snapshot, error) in
                
                var newBooks = [Book]()
                
                for document in snapshot!.documents {
                    let book =  Book(snapshot: document)
                    newBooks.append(book)
                }
                
                
                
                //TODO SOM ÄR published !!!!
                //Lägg till is less than i listan också, order books i efterhand
                self.books = newBooks
                self.findBooksCV.reloadData()
            }
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {


            let cell = findBooksCV.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FindBooksCollectionViewCell



            let cellIndex = indexPath.item
            cell.configCell(book: books[cellIndex])

            //to be able to remove
            cell.bidBookBtn.tag = cellIndex
            return cell
    }


}

