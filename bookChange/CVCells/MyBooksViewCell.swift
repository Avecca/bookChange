//
//  MyBooksViewCell.swift
//  bookChange
//
//  Created by Hanna Astlind on 2019-04-25.
//  Copyright © 2019 Hanna Astlind. All rights reserved.
//

import UIKit

class MyBooksViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var genreLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var removeBookBtn: UIButton!
    
    @IBOutlet weak var publishBookBtn: UIButton!
    
    
    func configCell(book: Book)  {
        titleLbl.text = book.title
        //TODO maybe format here and not when adding to db, if so change Book. init
        dateLbl.text = book.timeStamp
        authorLbl.text = " by: " + book.authorFirstName + " " + book.authorLastName
        genreLbl.text = book.genre
        descriptionLbl.text = book.description
        
    }
    
    
}
