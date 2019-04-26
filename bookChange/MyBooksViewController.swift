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
    var userId: String!
    var orderBy: String!
    //var fBRef : CollectionReference//()//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        //default orderby, TODO kanske i viewwillappear
        self.orderBy = "title"
        
        //TODO Behövs detta
       // myBooksSegmentCtrl.addTarget(self, action: #selector(myBooksSegmentChanged.indexChanged(_:)), for: .valueChanged)
        

        myBooksSegmentCtrl.addTarget(self, action: "myBooksSegmentChanged:", for:.touchUpInside)
        
        myBooksViewController.delegate = self
        myBooksViewController.dataSource = self


        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    //innan sidan ladda, ladda ner spelarens böcker, eller när den reloadas, när vi komemr tilbaka till den
    override func viewWillAppear(_ animated: Bool) {
        
        
        if Auth.auth().currentUser != nil {
            
            print("User är inloggad!")
            // User is signed in.
            let user = Auth.auth().currentUser

            self.userId = user?.uid
            let fBRef = db.collection("books").whereField("userId", isEqualTo: self.userId).order(by: self.orderBy, descending: true)
            
            fBRef.addSnapshotListener() {
                (snapshot, error) in
                
                var newBooks = [Book]()
                
                for document in snapshot!.documents {
                    let book =  Book(snapshot: document)
                    newBooks.append(book)
                }
                
                self.books = newBooks
                self.myBooksViewController.reloadData()
            }
        }
        

       
        
        //

    }
    
    
    @IBAction func myBooksSegmentChanged(_ sender: UISegmentedControl) {
        
        
        if sender.selectedSegmentIndex == 1 {
            self.orderBy = "title"
            
        } else {
            
            self.orderBy = "authorLastName"
            
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
        return cell
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
