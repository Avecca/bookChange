//
//  TabOverView.swift
//  bookChange
//
//  Created by Hanna Astlind on 2019-03-30.
//  Copyright © 2019 Hanna Astlind. All rights reserved.
//

import UIKit

class TabOverView: UITabBarController {
    
    var tBI = UITabBarItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Start on the middle tab
        self.selectedIndex = 1;
        
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.blue], for: .selected)
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .normal)
        
        
        //OR
        tabBar.tintColor = .orange
         tabBar.unselectedItemTintColor = .darkGray
        
        
        //My own images for the tabs
//        let selectedImg = UIImage(named: "library_book_icon.jpg")?.withRenderingMode(.alwaysOriginal)
//        let deSelectedImg = UIImage(named: "book_icon.jpg")?.withRenderingMode(.alwaysOriginal)
//        tBI = self.tabBar.items![0]
//        tBI.image = deSelectedImg
//        tBI.selectedImage = selectedImg
        
        UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.7607843137, blue: 0, alpha: 1)
       
        
    }
    
}


extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}



