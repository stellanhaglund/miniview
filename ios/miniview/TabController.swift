//
//  TabController.swift
//  new-wv
//
//  Created by Stellan Haglund on 2023-01-12.
//

import UIKit
import WebKit


class TabController: UITabBarController, UITabBarControllerDelegate, UINavigationControllerDelegate{
    
    var url = K.url
    var tabs: [[String: String]] = []
    var background = K.background
    var tint = K.tint
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        tabBar.tintColor = tint
        tabBar.barTintColor = background
        tabBar.isTranslucent = false
        
        var tab_list: [UIViewController] = []
        
        for t in tabs {
            
            let tab = ViewController()
            tab.url = url + (t["url"] ?? "")
            tab.nested = false
            tab.view.layer.zPosition = -1
            
            
            let imageUrlString = url + (t["icon"] ?? "")
            let imageUrl:URL = URL(string: imageUrlString)!
            let imageData:NSData = NSData(contentsOf: imageUrl)!
            let image = UIImage(data: imageData as Data)
            let tabItem = UITabBarItem(title: (t["title"] ?? ""), image: image, selectedImage: image)
            
            tab.tabBarItem = tabItem
            
            tab_list.append(tab)
            
        }
        

        self.viewControllers = tab_list
        
        super.viewDidLoad()
        
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //print("viewcontroller set")
        //print("Selected \(viewController.title!)")
    }
        
}
