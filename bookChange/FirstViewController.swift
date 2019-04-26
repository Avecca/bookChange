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

    var auth : Auth!
    let segToLogIn = "unwindToLogInId"
    
    
    @IBOutlet weak var segmentCtrl: UISegmentedControl!
    @IBOutlet weak var offersBidsView: UICollectionView!
    


    override func viewDidLoad() {
        super.viewDidLoad()

        auth = Auth.auth()
        
        //collectionViews elegate and datasource connection
        offersBidsView.delegate = self
        offersBidsView.dataSource = self
        
        
        
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
    }
    
    
    
    //CollectionView Delegates and datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1  //TODO .count  antalet
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = offersBidsView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OffersBidsViewCell
        
        
        
        let cellIndex = indexPath.item
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segToLogIn {
            
             print("Segue vid logout")
            
            //TODO NOLLA txt fönstrena
 
            
        }
        
    }
    
    
}

