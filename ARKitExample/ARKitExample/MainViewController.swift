//
//  ViewController.swift
//  ARKitExample
//
//  Created by 이동건 on 15/10/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class MainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var menu = Menu.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(menu[indexPath.row])"
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(menu[indexPath.row].vc, animated: true)
    }
}
