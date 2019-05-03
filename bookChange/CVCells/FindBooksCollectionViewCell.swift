//
//  FindBooksCollectionViewCell.swift
//  bookChange
//
//  Created by Hanna Astlind on 2019-04-29.
//  Copyright © 2019 Hanna Astlind. All rights reserved.
//

import UIKit
import Firebase

class FindBooksCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var genreLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var bidBookBtn: UIButton!
    
    var auth : Auth!

    
    
    
    func configCell(book: Book)  {
        auth = Auth.auth()
        if auth.currentUser != nil {
            
            titleLbl.text = book.title
            //TODO maybe format here and not when adding to db, if so change Book. init
            dateLbl.text = book.timeStamp
            authorLbl.text = " by: " + book.authorFirstName + " " + book.authorLastName
            genreLbl.text = book.genre
            descriptionLbl.text = book.description
            
             let user = auth.currentUser
            
            if let usr = user?.uid {
                
                if usr == book.userId {
                    bidBookBtn.isHidden = true
                }else {
                    bidBookBtn.isHidden = false
                }
                
            }
        
     
        }
 
    }
    
}
