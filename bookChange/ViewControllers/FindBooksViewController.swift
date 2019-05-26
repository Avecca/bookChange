//
//  FindBooksViewController.swift
//  bookChange
//
//  Created by Hanna Astlind on 2019-03-04.
//  Copyright © 2019 Hanna Astlind. All rights reserved.
//

import UIKit
import Firebase

class FindBooksViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource {


    @IBOutlet weak var genreSegmentCtrl: UISegmentedControl!
    @IBOutlet weak var findBooksCV: UICollectionView!
    @IBOutlet weak var bookPicker: UIPickerView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var offerLbl: UIButton!
    
    var books = [Book]()
    var bookPickerData = [Book]()
    
    var db : Firestore!
    var auth : Auth!
    var date: Date!
    let format = DateFormatter()
    var listener : ListenerRegistration?
    //var userId: String!
    
    var findByGenre: String = "all"
    var orderBy: String!
    
    var bookId : String = "" // books[index].bookId
    var bookOwnerId : String = "" // books[index].userId
    
    let alert = UIAlertController(title: "no books found", message: "add books to your library 'myBooks' so you have a book to trade with", preferredStyle: .alert)
    
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
        
        bookPicker.delegate = self
        bookPicker.dataSource = self
        
        
        
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        updateFindBooksArray()
        findPickerData()
        
    }
    
    @IBAction func bidPressed(_ sender: UIButton) {
        print("bid pressed")
        
        let index = sender.tag
        print("index: \(index)")
        
        bookId = books[index].bookId
        bookOwnerId = books[index].userId
        
        if bookPickerData.count > 0 {
            print("FINDING BOOKS TO TRADE!!  \(bookPickerData.count)")
            let defaultPV = bookPickerData.count / 2
            bookPicker.selectRow(defaultPV, inComponent: 0, animated: true)
            popUpView.isHidden = false
            offerLbl.isEnabled = true
        } else {
            
            self.present(self.alert, animated: true)
        
        }
        
        //self.present(self.alert,animated: true)
        
    }
    
    @IBAction func popUpXPressed(_ sender: Any) {
        //offeredBookId = ""
        print("Cancel choosing book offer!")
        bookId = ""
        bookOwnerId = ""
        popUpView.isHidden = true
        offerLbl.isEnabled = false
        
        
    }
    
    @IBAction func offerPressed(_ sender: Any) {
        
        addingOffer()
        
        popUpView.isHidden = true
        offerLbl.isEnabled = false
        
    }
    
    @IBAction func genreSegmentChanged(_ sender: Any) {
        
        listener?.remove()
        
        switch genreSegmentCtrl.selectedSegmentIndex {
        case 0:
            self.findByGenre = "all"
        case 1:
            self.findByGenre = "cooking"
        case 2:
            self.findByGenre = "fiction"
        case 3:
            self.findByGenre = "non-fiction"
        case 4:
            self.findByGenre = "sci-fi"
        default:
            self.findByGenre = "all"
        }
        
        
        
        updateFindBooksArray()
        
        
    }
    
    
    func addingOffer() {
        
        guard let offeredBookId = bookPickerData[bookPicker.selectedRow(inComponent: 0)].bookId else {return}
        
        //offeredBookId = "89OCgCREq8KOZpZvqxnr"
        //89OCgCREq8KOZpZvqxnr  Ghost av Test
        //YpEW4j78kUJ6KptcJep5"  klo av Mei
        
        print("OfferedBook: \(offeredBookId) w name : \(bookPickerData[bookPicker.selectedRow(inComponent: 0)].title )")

        if auth.currentUser !=  nil {

            self.date = Date()
            let formattedDate = format.string(from: self.date)



            guard let userId = auth.currentUser?.uid else {return}

            if bookId.isEmpty || bookOwnerId.isEmpty || offeredBookId.isEmpty {
                return
            }


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
                    print("error bidding on book: \(erro)")
                } else {

                    //add bid ref to booth users

                    //add bid to user making bid(offer), my bids
                    guard let refId = (ref?.documentID)  else {return}

                    print("bid added with \(refId)")
                   
                    //add bid reference to user
                    print("trying to add bid referense to user")
                    self.db.collection("users").document(userId).collection("myBids").addDocument(data: ["bidId" : refId]) {
                        err in
                        if let erro = err {
                            print("Bid id not saved to user")
                        } else {
                            print("Bid id saved to user")
                            self.bookId = ""
                        }
                    }

                    //add bid to bookowner, recieved, my offer
                    print("trying to add bidreference as offer")
                 self.db.collection("users").document(self.bookOwnerId).collection("myOffers").addDocument(data: ["bidId" : refId]) {
                        err in
                        if let erro = err {
                            print("Bid id as an offer not saved to user")
                        } else {
                            print("Bid id  as an offer saved to user")
                            self.bookOwnerId = ""
                        }
                    }
  
                }

            }
        }
        
    }

    func findPickerData(){
        if Auth.auth().currentUser != nil {
            
            
            //TODO Ändra till users böcker genom users istället, kanske
            
            print("User är inloggad!")
            // User is signed in.
            let user = Auth.auth().currentUser
            
            guard let userId = user?.uid  else{return}
            
            
            let fBRef = db.collection("books").whereField("userId", isEqualTo: userId).order(by: "title", descending: false)
            
            
            //TODO STOP listener när queryn ädras och gör ny, i mybooksSegmentchanged?
            fBRef.addSnapshotListener() {
                (snapshot, error) in
                
                var newBooks = [Book]()
                
                if error != nil {
                    print("error in finding mybooks")
                    return
                }
                
                for document in snapshot!.documents {
                    let book =  Book(snapshot: document)
                    newBooks.append(book)
                }
                
                self.bookPickerData = newBooks
                
//                let defaultPV = self.bookPickerData.count / 2
//
//                print(self.bookPickerData.count)
//                print("pickerviewslot: \(defaultPV)")
//                self.bookPicker.selectRow(defaultPV, inComponent: 0, animated: false)
                
            }
        }
        
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
            
            var bookRef: Query
            
            if findByGenre.isEmpty{
                return
            } else if findByGenre != "all" {
                bookRef =  db.collection("books").whereField("status", isEqualTo: "published").whereField("genre", isEqualTo: findByGenre)//.whereField("userId", isEqualTo: userId)//db.collection("books")
                
            } else {
                bookRef =  db.collection("books").whereField("status", isEqualTo: "published")//.whereField("userId", isEqualTo: userId)//db.collection("books")
                
            }
            
            

            
            bookRef.addSnapshotListener() {
                (snapshot, error) in
                
                var newBooks = [Book]()
                if error != nil {
                    print("error in finding searched books")
                    return
                }
                
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
    
    
    //pickerview delegate and datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bookPickerData.count
    }
    
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        let pickerLbl = UILabel()
//        pickerLbl.textAlignment = .left
//        pickerLbl.textColor = .black
//        pickerLbl.text = bookPickerData[row].title
//        return pickerLbl
//    }
    
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        let pickerLbl = UILabel()
//        pickerLbl.textAlignment = .center
//        pickerLbl.textColor = .black
//        pickerLbl.text = bookPickerData[row].title
//        //NSAttributedString(string: bookPickerData[row].title, attributes: [NSForegroundColorAttributeName:UIColor.black])
//        return  NSAttributedString(string: bookPickerData[row].title, attributes: [NSAttributedString.Key.foregroundColor:UIColor.black])
//    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {


        return bookPickerData[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("SELECTED ROW:  \(row)")
        
        //defaultPV = row
    }
    

    
    //Collectionview delegate and datasource
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

