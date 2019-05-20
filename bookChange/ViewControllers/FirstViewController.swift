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
    
    @IBOutlet weak var segmentCtrl: UISegmentedControl!
    @IBOutlet weak var offersBidsView: UICollectionView!
    
    //var books = [Book]()
    var bids = [Bid]()
    var bidBookInfos = [BidBookInfo]()
    var db : Firestore!
    var auth : Auth!
    var listener : ListenerRegistration?
    //var userId: String!
    
    let segToLogIn = "unwindToLogInId"
    var findByGenre: String!
    var orderBy: String!
    var searchString: String!
    

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
    
    @IBAction func deleteBtnPressed(_ sender: UIButton) {
  
         print("Deletebtn presed with index : \(sender.tag)")

        
        let index = sender.tag
        
        switch sender.titleLabel?.text {
            case "remove bid":
                print("DELETING BID")
                updateBid(index: index, status : "deleted")
            case "accepted email":
                print("POPUP!!!!!")
            case "decline":
                print("Decline the offer!")
                updateBid(index: index, status: "declined")
            default:
                return
        }
        
    }

    
    @IBAction func acceptBtnPressed(_ sender: UIButton) {
        print("Acceptbtn presed with index : \(sender.tag)")
        let index = sender.tag
        switch sender.titleLabel?.text {
        case "accept":
            print("Accepting offer")
            updateBid(index: index, status: "accepted")
        default:
            return
        }
    }
    
    @IBAction func logOutBtnPressed(_ sender: Any) {
        
        do {
            try auth.signOut()
            
            listener?.remove()
            //tillbaka segway händer genom storyboarden
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
    }
    
    //to change values on segment choosen changed
    @IBAction func segmentCtrlChanged(_ sender: Any) {
        
        //TODO ändra så det här ändrar hela searchsträngen man slänger in i listenern istället?
        
        //REMOVE SNAPSHOTLISTENERN
        listener?.remove()
        
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
    
    func updateBid(index : Int, status : String){
        
        //not actually deleteing, but updating the status to deleted
        if let bidId = bids[index].bidId {
            if auth.currentUser != nil{
                
                let updateRef = db.collection("bids").document(bidId)
                
                updateRef.updateData(["status" : status])
                print("updated bid with DELETED")
                //self.offersBidsView.reloadData()
            }
        }
        
        
    }
    
    func showMyBids() {
        
        if auth.currentUser != nil {
            
            let user = auth.currentUser
            guard let cUserId = user?.uid else {return}
            
            print("user id \(cUserId)")
            
             //TODO SHOWS MY BIDS SO FAR UNder
            //let ref = db.collection("bids").whereField("offeredBookUserId", isEqualTo: self.userId)//.order(by: self.orderBy)
            
            //Find a bid where I have made clicked bid, thereby making an offer
            let bidRef = db.collection("bids").whereField(searchString, isEqualTo: cUserId).whereField("status", isLessThanOrEqualTo: "bid") //.whereField("status", isEqualTo: "bid")//.whereField("status", isLessThanOrEqualTo: "bid")//.order(by: "status")//.order(by: "timeStamp")//.order(by: "timeStamp")
            print("query gjord")
            
            //TODO Visa decloined men inte deleted?
            //TODO kanske visa ddclined o sen autoremove declined inom 24h?
            
            listener = bidRef.addSnapshotListener() {
                (snapShot, error) in
                
                
                print("inne i listener")
                var newBids = [Bid]()
                print("lista av bids gjord")
                //var newBidInfo = [BidBookInfo]()
                
                if error != nil {
                    print("error in finding bids")
                    return
                    
                }
                
                
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
                
                print("Hittat \(newBids.count) böcker till bidinfo")
                
                //self.bidBookInfos = newBidInfo
                
                //print(self.bidBookInfos.description)
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
        
        cell.declineBtn.tag = cellIndex
        cell.acceptBtn.tag = cellIndex
        
        
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

