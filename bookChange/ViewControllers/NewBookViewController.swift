//
//  NewBookViewController.swift
//  bookChange
//
//  Created by Hanna Astlind on 2019-04-26.
//  Copyright © 2019 Hanna Astlind. All rights reserved.
//

import UIKit
import Firebase

class NewBookViewController: UIViewController {
    
    
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var authorFirstTxt: UITextField!
    @IBOutlet weak var authorLastTxt: UITextField!
    @IBOutlet weak var genreSegmentCtrl: UISegmentedControl!
    @IBOutlet weak var descriptionTxtBox: UITextView!
    @IBOutlet weak var saveBtn: UIButton!
    
    var genreChoosen: String!
    var date: Date!
    let format = DateFormatter()
    let db = Firestore.firestore()
    var auth : Auth!
    
    let alert = UIAlertController(title: "adding book", message: "a book was added to your library myBooks", preferredStyle: .alert)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth()
        
        //how i want the date formatted
        format.dateFormat = "yyy-MM-dd HH:mm"
        
        
        //default value of the segmentcontroller
        self.genreChoosen = "cooking"
        
        //begin with title selected, Nej!
        //titleTxt.becomeFirstResponder()
        
        //alert msg initialized
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        // Do any additional setup after loading the view.
    }
    
    //to get the value, you need to have an action

    @IBAction func genreSegmentChanged(_ sender: UISegmentedControl) {
//       // self.genreChoosen = genreSegmentCtrl.selectedSegment
//
//        if sender.selectedSegmentIndex == 1 {
//
//        } else {
//            
//        }
        //har inte riktiga namnen
        //self.genreChoosen = genreSegmentCtrl.titleForSegment(at: genreSegmentCtrl.selectedSegmentIndex)
        switch genreSegmentCtrl.selectedSegmentIndex {
        case 0:
            self.genreChoosen = "cooking"
        case 1:
            self.genreChoosen = "fiction"
        case 2:
            self.genreChoosen = "non-fiction"
        case 3:
            self.genreChoosen = "sci-fi"
        default:
            self.genreChoosen = "cooking"
        }
        
  
    }
    @IBAction func saveBtnPressed(_ sender: Any) {
        
//        if let title = titleTxt.text {
//
//        }
        self.date = Date()
        let formattedDate = format.string(from: self.date)
        
        
        //UserID!!!!! TODO, changeplace!
        
        if auth.currentUser != nil {
            // User is signed in.
            let user = auth.currentUser
            let userId = user?.uid
            
            
            //TODO ändra om så använder Book klassen
            let newBook : Dictionary<String, Any> = [
                "userId" : userId,
                "title" : titleTxt.text,
                "authorFirstName" : authorFirstTxt.text,
                "authorLastName" : authorLastTxt.text,
                "genre": genreChoosen,
                "meetingAdress": "Stockholm",
                "description": descriptionTxtBox.text,
                "timeStamp": formattedDate,
                "status": ""
            ]
            
            var ref : DocumentReference? = nil
            //add the book to db and get it's reference
            ref = db.collection("books").addDocument(data: newBook) {
                err in
                if let err = err {
                    print("error adding book \(err)")
                    
                }else {
                    print("book added with ref: " + ref!.documentID)
                    //add book referense in person
                   
                    //use books ref id to add it to the users book collection
                    self.db.collection("users").document(userId!).collection("books").addDocument(data: ["bookId" : ref!.documentID]) {
                        err in
                        if let error = err {
                            print("bookId not saved to user")
                        } else {
                            print("bookId saved to user")
                            
                            self.present(self.alert,animated: true)
                            
                            self.titleTxt.text = ""
                            self.authorFirstTxt.text = ""
                            self.authorLastTxt.text = ""

                            self.descriptionTxtBox.text = ""
                            //self.titleTxt.isFirstResponder
                        }
                    }
                        
                        //).addDocument().setData(["bookId" : ref!.documentID])
                    
                        
//                        .collection("books").setData(
//                        ["bookId": ref!.documentID])
                    
                    
                    //
                    
                    }
                }
            


        } else {
            // No user is signed in.
            // ...
            //TODO POPUP?
        }

        
        //TODO get the books user id and add it to the users booklist
        
        
        
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








//            var ref : DocumentReference? = nil
//
//            ref = db.collection("books").addDocument(data: newBook) {
//                err in
//                if let err = err {
//                    print("error adding book \(err)")
//
//                }else {
//                    print("book added with ref: " + ref?.uid)
//                    //add book referense in person
//                    db.collection("users").document(userId!).collection("books").setData(
//                        ["bookId": ref?.uid])
//                }
//            }
//
//
//
//
//            )
