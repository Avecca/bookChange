//
//  LogInViewController.swift
//  bookChange
//
//  Created by Hanna Astlind on 2019-04-25.
//  Copyright © 2019 Hanna Astlind. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    
    @IBOutlet weak var logInBtn: UIButton!

    
    let segueId = "segueToBookChange"
    var date: Date!
    let format = DateFormatter()
    var auth : Auth!
    var db : Firestore!
    
    
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
         auth = Auth.auth()
         db = Firestore.firestore()
         format.dateFormat = "yyy-MM-dd HH:mm"
        
        
        //TODO byt till name, få den att hoppa vidare med enter osv
         emailTxtField.becomeFirstResponder()
        
        //IF autologged in from previous session
        
    }
    
    
    //IF autologged in from previous session
    override func viewDidAppear(_ animated: Bool) {
        if let usr = auth.currentUser {
            print(usr.email)
            performSegue(withIdentifier: segueId, sender: self)
        } else {
            print("user null")
        }
    }
    
    

    @IBAction func logInBtnPressed(_ sender: Any) {
//           performSegue(withIdentifier: segueId, sender: self)
        
        if let email = emailTxtField.text{
            print("email är här")
            
            if let pw = passwordTxtField.text{
                print("pw är här")
               
                auth.signIn(withEmail: email, password: pw){
                    user, error in
                    if let user = self.auth.currentUser{
                        print("user är här" )
                        self.performSegue(withIdentifier: self.segueId, sender: self)
                    }else {
                        
                        //TODO POPUP
                        print("ingen user")
                        return
                        
                    }
                    
                }
            }
        }

    }
    
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        
       // if let user = userNameTxtField.text {
            
            if let email = emailTxtField.text{
                
                if let pw = passwordTxtField.text{
                    
                    print("create pow exists")
                    
//                    auth.createUser(withEmail: email, password: pw) {
//                        authresul
//                    }, completion: <#T##AuthDataResultCallback?##AuthDataResultCallback?##(AuthDataResult?, Error?) -> Void#>)
//
                    
                    auth.createUser(withEmail: email, password: pw) {
                        authResult, error in

                        if let usr = self.auth.currentUser {
                            let userId = usr.uid
                            self.date = Date()
                            let formattedDate = self.format.string(from: self.date)
                            
                            //todo create username, locatiobn
                            
                            let newUser : Dictionary<String, Any> = [
                                "userName" : "Placeholder",
                                "location" : "Stockholm",
                                "created" : formattedDate
                            ]
                            
                            print("Skapar user med id: " + userId)
                            
                            self.db.collection("users").document(userId).setData(newUser)
        
                            self.performSegue(withIdentifier: self.segueId, sender: self)

                        } else{
                            //TODO POPUP
                        }

                    }
//
//                    Auth.auth().createUser(withEmail: email, password: pw) { authResult, error in
                    
                   
//
//                    }
                    
                }
            }
            
        //}
    }
    
    
    
    //segue to next page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("Override händer med \(Players.playerArray.count) players")
   
//        if segue.identifier == segueId{
//            print("använder denna")
//            let destinationVC = segue.destination as! TabOverView
//        }
    

    }
    
    @IBAction func unwindToHere(segue: UIStoryboardSegue) {
        //TODO Nolla text boxarna
        print("Tillbaka till Start")
        
    }
    
    //return segue, TODO, när loggar ut
//    @IBAction func unwindToHere(segue: UIStoryboardSegue) {
//        // print("Tillbaka till Start")
//
//    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
