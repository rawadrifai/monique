//
//  TabControl.swift
//  Prossimo
//
//  Created by Rawad Rifai on 5/31/17.
//  Copyright © 2017 Elrifai, Rawad. All rights reserved.
//

import UIKit
import FontAwesomeKit

class TabControl: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tabBarItems = tabBar.items!
        
        // seach icon
        var searchImage = FAKFontAwesome.searchIcon(withSize: 25).image(with: CGSize(width: 30, height: 30))
        searchImage = searchImage?.imageWithColor(color: Commons.myColor)
        tabBarItems[0].image = searchImage
        tabBarItems[0].title = "Clients"
        
        // money icon
        var moneyImage = FAKFontAwesome.dollarIcon(withSize: 25).image(with: CGSize(width: 30, height: 30))
        moneyImage = moneyImage?.imageWithColor(color: Commons.myColor)
        tabBarItems[1].image = moneyImage
        tabBarItems[1].title = "Expenses"
        
        // Info icon
        var infoImage = FAKFontAwesome.infoCircleIcon(withSize: 28).image(with: CGSize(width: 30, height: 30))
        infoImage = infoImage?.imageWithColor(color: Commons.myColor)
        tabBarItems[2].image = infoImage
        tabBarItems[2].title = "Info"
        
    }

    

}
