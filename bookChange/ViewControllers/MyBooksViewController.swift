//
//  MyBooksViewController.swift
//  bookChange
//
//  Created by Hanna Astlind on 2019-04-25.
//  Copyright © 2019 Hanna Astlind. All rights reserved.
//

import UIKit
import Firebase

class MyBooksViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var myBooksSegmentCtrl: UISegmentedControl!
    //TODO FIX THIS NAME TO myBooksCV
    @IBOutlet weak var myBooksViewController: UICollectionView!
    
    var books = [Book]()
    var db : Firestore!
    var auth : Auth!
    var listener : ListenerRegistration?
    
    var userId: String!
    var orderBy: String!
    //var fBRef : CollectionReference//()//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        auth = Auth.auth()
        
        //default orderby, TODO kanske i viewwillappear
        self.orderBy = "authorLastName"
        
        //TODO Behövs detta
       // myBooksSegmentCtrl.addTarget(self, action: #selector(myBooksSegmentChanged.indexChanged(_:)), for: .valueChanged)
        

        //myBooksSegmentCtrl.addTarget(self, action: "myBooksSegmentChanged:", for:.touchUpInside)
        
        myBooksViewController.delegate = self
        myBooksViewController.dataSource = self
        
        print("inloggad påmybooks: \(auth.currentUser?.uid)")


        // Do any additional setup after loading the view.
    }
    
    
    
    //innan sidan ladda, ladda ner spelarens böcker, eller när den reloadas, när vi komemr tilbaka till den
    override func viewWillAppear(_ animated: Bool) {
        updateMyBooksArray()
    }
    
    @IBAction func publishBtnPressed(_ sender: UIButton) {
        print("Publish!!")
        
        let index = sender.tag
        
        print(index)
        
        let bookId = books[index].bookId!
        
        if Auth.auth().currentUser != nil {
         
            //TODO dubbelkolla att userId stämmer också
           let updateRef =  db.collection("books").document(bookId)
            
            
            if books[index].status != "published" {
                updateRef.updateData(["status" : "published"]) {
                    err in
                    if let err = err {
                        print("Error : \(err)")
                    } else {
                        print("book status updated w/id: " + bookId)
                    }
                }
            } else {
                updateRef.updateData(["status" : ""]) {
                    err in
                    if let err = err {
                        print("Error : \(err)")
                    } else {
                        print("book status updated to unpublished w/id: " + bookId)
                    }
                }
                
            }
        
        }
    }
    
    
    //TODO DELETE alla offers där denna ingår, eller snarare updatera statusen
    @IBAction func deleteBookBtnPressed(_ sender: UIButton) {
        
        let index = sender.tag
        let user = auth.currentUser
        let userId = (user?.uid)!
        
        print(index)
        
        let bookId = books[index].bookId!
        
        if Auth.auth().currentUser != nil {
            
            //TODO dubbelkolla att userUi stämmer?
            let deleteRef =  db.collection("books").document(bookId)
            
            
            deleteRef.delete() { err in
                if let err = err {
                    print("Error: \(err)")
                }else{
                    print("deleted book with ref: \(bookId)")
                    
                    
                   // var deletedBookAtUserRef: DocumentReference? = nil
                    //deletedBookAtUserRef = self.db.collection("users").document(userId).collection("books").whereField("bookId", isEqualTo: bookId)
                   
                    let deleteBookAtUser = self.db.collection("users").document(userId).collection("books").whereField("bookId", isEqualTo: bookId).getDocuments() { (QuerySnapshot, err) in
                        
                            if let erro = err {
                                print("bookId NOT deleted from user: \(erro)")
                            } else {
                                for doc in QuerySnapshot!.documents {
                                    doc.reference.delete()
                                    print("bookId deleted from user with refId \(doc.documentID)  ")
                                }
                               
                            }
                    }
                        
                    //let bookIdAtUser = deleteBookAtUser
                    
                    //TODO hitta documentets rteferensenoch deletea med  documnetets id
                        //.whereField("bookId", isEqualTo: bookId)
                    
//                    deleteRef.delete(){ err in
//
//                        if let erro = err {
//                            print("bookId NOT deleted from user")
//                        } else {
//                            print("bookId deleted from user")
//                        }
//                    }
                    
                    
                    self.myBooksViewController.reloadData()
                    
                    //TODO deletea bookref hos personen också
                }
            }

//
//            updateRef.updateData(["status" : "published"]) {
//                err in
//                if let err = err {
//                    print("Error : \(err)")
//                } else {
//                    print("book status updated w/id: " + bookId)
//                }
//            }
            
        }
    }
    @IBAction func myBooksSegmentChanged(_ sender: UISegmentedControl) {
        //          self.orderBy = myBooksSegmentCtrl.titleForSegment(at: myBooksSegmentCtrl.selectedSegmentIndex)
        
        
        //TODO kan göra detta med sort på arreyen här istället?
        
        listener?.remove()
        
        switch myBooksSegmentCtrl.selectedSegmentIndex {
        case 0:
            self.orderBy = "authorLastName"
        case 1:
            self.orderBy = "title"
        default:
            self.orderBy = "title"
        }
        
        //TODO GAAAAH named sooo wrong
        
        print("trying to reload")
        updateMyBooksArray()
        
        
    }
    //    @IBAction func publishBtnPressed(_ sender: UIButton) {
//
//        print("publish tryckts!")
//
//        let index = sender.tag
//
//        let bookId = books[index].bookId!
//
//        if Auth.auth().currentUser != nil {
//
//           let updateRef =  db.collection("books").document(bookId)
//
//            updateRef.updateData(["status" : "published"]) {
//                err in
//                if let err = err {
//                    print("Error : \(err)")
//                } else {
//                    print("book status updated w/id: " + bookId)
//                }
//            }
//
//        }
//
//    }
    
    func updateMyBooksArray() {
        
        if Auth.auth().currentUser != nil {
            
            
            //TODO Ändra till users böcker genom users istället, kanske
            
            
            print("User är inloggad!")
            // User is signed in.
            let user = Auth.auth().currentUser
            
            self.userId = user?.uid
            let fBRef = db.collection("books").whereField("userId", isEqualTo: self.userId).order(by: self.orderBy, descending: false)
            
            
            //listener när queryn ädras och gör ny, i mybooksSegmentchanged
            listener = fBRef.addSnapshotListener() {
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
                
                self.books = newBooks
                self.myBooksViewController.reloadData()
            }
        }
    }
    
    
    //CollectionView Delegates and datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count  //TODO .count  antalet
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    //TODO BOOKID!!!!
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myBooksViewController.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyBooksViewCell
        
        
        
        let cellIndex = indexPath.item
        cell.configCell(book: books[cellIndex])
        
        //to be able to remove
        cell.removeBookBtn.tag = cellIndex
        cell.publishBookBtn.tag = cellIndex
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.darkGray.cgColor
        return cell
    }

}
