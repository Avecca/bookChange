//
//  FirstViewController.swift
//  bookChange
//
//  Created by Hanna Astlind on 2019-03-04.
//  Copyright © 2019 Hanna Astlind. All rights reserved.
//

import UIKit
import Firebase

class FirstViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //var books = [Book]()
    var bids = [Bid]()
    var bidBookInfos = [BidBookInfo]()
    var db : Firestore!
    var auth : Auth!
    var userId: String!
    
    var findByGenre: String!
    var orderBy: String!
    var searchString: String!
    
    let segToLogIn = "unwindToLogInId"
    
    
    @IBOutlet weak var segmentCtrl: UISegmentedControl!
    @IBOutlet weak var offersBidsView: UICollectionView!
    


    override func viewDidLoad() {
        super.viewDidLoad()

        db = Firestore.firestore()
        auth = Auth.auth()
        
        
        
        self.orderBy = "timeStamp"
        self.searchString = "offeredBookUserId"
        
        //collectionViews elegate and datasource connection
        offersBidsView.delegate = self
        offersBidsView.dataSource = self
        
        
        
    }
    
    
    //TODO SHOWS MY BIDS SO FAR UNder
    override func viewWillAppear(_ animated: Bool) {
      showMyBids()
    }
    
    func showMyBids() {
        
        if auth.currentUser != nil {
            
            let user = auth.currentUser
            let cUserId = user?.uid
            
            print("user id \(userId)")
            
             //TODO SHOWS MY BIDS SO FAR UNder
            //let ref = db.collection("bids").whereField("offeredBookUserId", isEqualTo: self.userId)//.order(by: self.orderBy)
            
            //Find a bid where I have made clicked bid, thereby making an offer
            let bidRef = db.collection("bids").whereField(searchString, isEqualTo: cUserId).whereField("status", isLessThanOrEqualTo: "bid") //.whereField("status", isEqualTo: "bid")//.whereField("status", isLessThanOrEqualTo: "bid")//.order(by: "status")//.order(by: "timeStamp")//.order(by: "timeStamp")
            print("query gjord")
            
            
            
            bidRef.addSnapshotListener() {
                (snapShot, error) in
                
                
                print("inne i listener")
                var newBids = [Bid]()
                print("lista av bids gjord")
                //var newBidInfo = [BidBookInfo]()
                
                for document in snapShot!.documents {
                    
                    print("inne i snapshot : \(document.data().count)")
                    print(document.data().description)
                    
                    let bid = Bid(snapshot: document)
                    //create BidINfo?
                    newBids.append(bid)
                    
                    
                    print("förbi första")
                    //let bidInfo = BidBookInfo(snapshot : document)
                    
                    //newBidInfo.append(bidInfo)
                    
                   // fillBidBookInfo(bid: bid)
                }
                
                print("Hittat böcker till bidinfo")
                
                //self.bidBookInfos = newBidInfo
                
                //print(self.bidBookInfos.description)
                //TODO Remove later
                self.bids = newBids
                print(self.bids.description)
                
                self.offersBidsView.reloadData()
    
            }
        }
    }
    
//    func fillBidBookInfo(bid : Bid) -> ([String]) {
//        function body
//    }
    
    func showMyOffers()  {
        //TODO SHOWS MY OFFERS SO FAR UNder
        //Kalla från switch stamenet under segment ändringar
    }
    
    @IBAction func logOutBtnPressed(_ sender: Any) {
        

        do {
            try auth.signOut()
            
            
            //tillbaka segway händer genom storyboarden
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
    }
    //to change values on segment choosen changed
    @IBAction func segmentCtrlChanged(_ sender: Any) {
        
        //TODO ändra så det här ändrar hela searchsträngen man slänger in i listenern istället?
        
        //change the searchstring
        switch segmentCtrl.selectedSegmentIndex {
        case 0:
            self.searchString = "offeredBookUserId"
        case 1:
            self.searchString = "bookUId"
        default:
            self.searchString = "offeredBookUserId"
        }
        
        print("trying to change the searchString")
        
        showMyBids()
    }
    
    
    
    //CollectionView Delegates and datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bids.count //TODO .count  antalet
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = offersBidsView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OffersBidsViewCell
        
        
        
        let cellIndex = indexPath.item
        
        cell.configCell(bid: bids[cellIndex])
        
        
        //TODO
        //cell.KNAPP.tag = cellindex
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segToLogIn {
            
             print("Segue vid logout")
            
            //TODO NOLLA txt fönstrena
 
            
        }
        
    }
    
    
}


//guard !bids.isEmpty else {
//    return
//}
//
////FOREACH bid in bids, kanske in i for each doc in snapshot?
//let bookBids: Dictionary <String, Any> = [
//    "userId": String!
//    "bookId": String!
//    "offeredBookId": String!
//    "offeredBookUserId": String!
//    "timeStamp": String!
//    "status": String!
//
//]

