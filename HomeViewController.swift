//
//  HomeViewController.swift
//  climbingweather
//
//  Created by Jon St. John on 2/22/17.
//
//

import Foundation

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
        let settingsTabImage = UIImage(named: "20-gear2.png")
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: settingsTabImage, selectedImage: settingsTabImage)
        tabBarController.viewControllers = [AboutViewController(), settingsViewController]
        self.navigationController?.pushViewController(tabBarController, animated: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        if let searchController = self.tabBarController?.viewControllers?[4] as? AreasViewController {
            searchController.search = .Term(textField.text ?? "")
        }
        
        self.tabBarController?.selectedIndex = 4
        
        return true
    }
    
}
