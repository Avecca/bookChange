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
    
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var logInBtn: UIButton!

    var date: Date!
    let format = DateFormatter()
    var auth : Auth!
    var db : Firestore!
    
    let segueId = "segueToBookChange"
    
    let alert = UIAlertController(title: "add a username", message: "choose a username for your account", preferredStyle: .alert)
    let loginAlert = UIAlertController(title: "error loggin in", message: "either your email or password was not correct, please try again ", preferredStyle: .alert)

    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
         auth = Auth.auth()
         db = Firestore.firestore()
         format.dateFormat = "yyy-MM-dd HH:mm"
        
        
        //Email is firstrespeonder when opening app
         emailTxtField.becomeFirstResponder()
        
        //IF autologged in from previous session, do this in viewdid appear

        //setup alerts
        //alert for missing pw and email when logging in
        loginAlert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        
        //alert for creating a user
        alert.addAction(UIAlertAction(title: "cancel", style: .default, handler: nil))
        
        let alertActionOkBtn = UIAlertAction(title: "create", style: .default) { (nil) in
            let textField = self.alert.textFields![0] as UITextField
            print("Pressing create!!!")
            
            if textField.text != "" {
                print("textfield has name: " + textField.text!)
                guard let name = textField.text else {return}
                
                self.createUserWithName(name: name)
            }
            else {
                print("textfield is empty")
            }
        }
        
        self.alert.addTextField { (textField) in
            textField.placeholder = "Enter your username"
        }
        alert.addAction(alertActionOkBtn)
        

        
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
                        print("ingen user")
                        self.present(self.loginAlert, animated: true)
                        return
                    }
                }
                
            }
            
        }

    }
    
    
    func createUserWithName(name: String){
        
        guard  let email = emailTxtField.text, !email.isEmpty, let pw = passwordTxtField.text, !pw.isEmpty else{
            print("Empty textfields!")
            return
        }
        
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
                    "userName" : name,
                    "location" : "Stockholm",
                    "created" : formattedDate
                ]
        
                print("Skapar user med id: " + userId)
        
                self.db.collection("users").document(userId).setData(newUser)
        
                self.performSegue(withIdentifier: self.segueId, sender: self)
        
            } else{
                print("failed to crerate user")
                                    //TODO POPUP maybe?
            }
        
        }
        //                    Auth.auth().createUser(withEmail: email, password: pw) { authResult, error in

    }
    
    
    
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        
        self.present(self.alert,animated: true, completion: nil)

        
       // if let user = userNameTxtField.text {
            
//            if let email = emailTxtField.text{
//
//                if let pw = passwordTxtField.text{
//
//                    print("create pow exists")
//
////                    auth.createUser(withEmail: email, password: pw) {
////                        authresul
////                    }, completion: <#T##AuthDataResultCallback?##AuthDataResultCallback?##(AuthDataResult?, Error?) -> Void#>)
////
//
//                    auth.createUser(withEmail: email, password: pw) {
//                        authResult, error in
//
//                        if let usr = self.auth.currentUser {
//                            let userId = usr.uid
//                            self.date = Date()
//                            let formattedDate = self.format.string(from: self.date)
//
//                            //todo create username, locatiobn
//
//                            let newUser : Dictionary<String, Any> = [
//                                "userName" : "Placeholder",
//                                "location" : "Stockholm",
//                                "created" : formattedDate
//                            ]
//
//                            print("Skapar user med id: " + userId)
//
//                            self.db.collection("users").document(userId).setData(newUser)
//
//                            self.performSegue(withIdentifier: self.segueId, sender: self)
//
//                        } else{
//                            //TODO POPUP
//                        }
//
//                    }
////
////                    Auth.auth().createUser(withEmail: email, password: pw) { authResult, error in
//
//
////
////                    }
//
//                }
//            }
        
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
    //return segue, TODO, när loggar ut
    @IBAction func unwindToHere(segue: UIStoryboardSegue) {
        //TODO Nolla text boxarna
        print("Tillbaka till Start")
        
    }

}
