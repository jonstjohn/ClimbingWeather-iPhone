//
//  HomeViewController.swift
//  climbingweather
//
//  Created by Jon St. John on 2/22/17.
//
//

import Foundation
import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var searchField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        super.viewWillAppear(animated)
    }
    
    @IBAction func showNearby(sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func showByState(sender: UIButton) {
        self.tabBarController?.selectedIndex = 2
    }
    
    @IBAction func showFavorites(sender: UIButton) {
        self.tabBarController?.selectedIndex = 3
    }
    
    @IBAction func showSettings(sender: UIButton) {
        
        let tabBarController = UITabBarController()
        
        let settingsViewController = SettingsViewController()
        let settingsTabImage = UIImage(named: "20-gear2")
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: settingsTabImage, selectedImage: settingsTabImage)
        
        let aboutViewController = AboutViewController()
        let aboutTabImage = UIImage(named: "icon_information")
        aboutViewController.tabBarItem = UITabBarItem(title: "About", image: aboutTabImage, selectedImage: aboutTabImage)
        
        tabBarController.viewControllers = [aboutViewController, settingsViewController]
        self.navigationController?.pushViewController(tabBarController, animated: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        if let searchController = self.tabBarController?.viewControllers?[4] as? AreasViewController {
            searchController.searchProvider?.search = .Term(textField.text ?? "")
        }
        
        self.tabBarController?.selectedIndex = 4
        
        return true
    }
    
}
