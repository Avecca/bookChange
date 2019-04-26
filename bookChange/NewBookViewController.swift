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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //how i want the date formatted
        format.dateFormat = "yyy-MM-dd HH:mm"
        
        
        //default value of the segmentcontroller
        self.genreChoosen = "cooking"
        
        //begin with title selected
        titleTxt.becomeFirstResponder()

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
    
        
        
        
    }
    @IBAction func saveBtnPressed(_ sender: Any) {
        
//        if let title = titleTxt.text {
//
//        }
        self.date = Date()
        let formattedDate = format.string(from: self.date)
        
        
        //UserID!!!!! TODO, changeplace!
        
        if Auth.auth().currentUser != nil {
            // User is signed in.
            let user = Auth.auth().currentUser
            
            let newBook : Dictionary<String, Any> = [
                "userId" : user?.uid,
                "title" : titleTxt.text,
                "authorFirstName" : authorFirstTxt.text,
                "authorLastName" : authorLastTxt.text,
                "genre": genreChoosen,
                "meetingAdress": "Stockholm",
                "description": descriptionTxtBox.text,
                "timeStamp": formattedDate,
                "status": ""
            ]
            
            db.collection("books").addDocument(data: newBook)
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
