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
    var auth : Auth!
    
    
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
         auth = Auth.auth()
        
        //IF autologged in from previous session
        
//        if let usr = auth.currentUser {
//            print(user.email)
//            performSegue(withIdentifier: segueId, sender: self)
//        } else {
//            print("user null")
//        }

        // Do any additional setup after loading the view.
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
            
            if let pw = passwordTxtField.text{
               
                auth.signIn(withEmail: email, password: pw){
                    user, error in
                    if let usr = self.auth.currentUser{
                        self.performSegue(withIdentifier: self.segueId, sender: self)
                    }
                    
                }
            }
        }

    }
    
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        
       // if let user = userNameTxtField.text {
            
            if let email = emailTxtField.text{
                
                if let pw = passwordTxtField.text{
                    
                    
                    
//                    auth.createUser(withEmail: email, password: pw) {
//                        authresul
//                    }, completion: <#T##AuthDataResultCallback?##AuthDataResultCallback?##(AuthDataResult?, Error?) -> Void#>)
//
                    
                    Auth.auth().createUser(withEmail: email, password: pw) {
                        authResult, error in

                        if let usr = Auth.auth().currentUser {
                            self.performSegue(withIdentifier: self.segueId, sender: self)

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
   
        if segue.identifier == segueId{
            let destinationVC = segue.destination as! TabOverView
        }
    

    }
    
    @IBAction func unwindToHere(segue: UIStoryboardSegue) {
        print("Tillbaka till Start")
        
    }
    
    //return segue, TODO, när loggar ut
//    @IBAction func unwindToHere(segue: UIStoryboardSegue) {
//        // print("Tillbaka till Start")
//        self.playerCollectionView.reloadData()
//        playBtn.isHidden = true
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
