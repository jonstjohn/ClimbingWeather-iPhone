//
//  StatesViewController.swift
//  climbingweather
//
//  Created by Jon St. John on 2/12/17.
//
//

import Foundation
import UIKit

@objc class StatesViewController: UITableViewController {
    
    var states = [State]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let frameHeight = self.tabBarController?.tabBar.frame.height {
        
            let adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, frameHeight, 0)
            self.tableView.contentInset = adjustForTabbarInsets
            self.tableView.scrollIndicatorInsets = adjustForTabbarInsets
            
        }
        
        States.fetchStates { (states) in
            self.states = states.states
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "US States"
        self.navigationController?.isNavigationBarHidden = false
        super.viewWillAppear(animated)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return states.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  UITableViewCell(style: .subtitle, reuseIdentifier: "StateCell")
        
        let state = self.states[indexPath.row]
        cell.textLabel?.text = state.name
        let areasLabel = state.areas == 1 ? "area" : "areas"
        cell.detailTextLabel?.text = String(format: "%d %@", state.areas, areasLabel)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let state = self.states[indexPath.row]
        let controller = AreasViewController()
        let state = self.states[indexPath.row]
        controller.search = Search.State(state)
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
}