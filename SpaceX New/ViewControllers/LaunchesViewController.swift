//
//  LaunchesViewController.swift
//  SpaceX New
//
//  Created by Stanislav Demyanov on 14.08.2022.
//

import UIKit

class LaunchesViewController: UIViewController {

    var nameRocketLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 139,
                                          y: 54,
                                          width: 100,
                                          height: 24))
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

    }
}
