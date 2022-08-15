//
//  LaunchesViewController.swift
//  SpaceX New
//
//  Created by Stanislav Demyanov on 14.08.2022.
//

import UIKit

class LaunchesViewController: UIViewController {
    
    // MARK: - Private Properties
    let nameRocketLabel = UILabel()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupNavigationBar()
    }
}

extension LaunchesViewController {
    private func setupNavigationBar() {
        let navigationBar = UINavigationBar(frame: CGRect(x: 0,
                                                          y: 44,
                                                          width: view.frame.size.width,
                                                          height: 44))
        self.view.addSubview(navigationBar)
        
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.barTintColor = .black
        navigationBar.isTranslucent = false
        
        guard let nameRocket = nameRocketLabel.text else { return }
        let navigationItem = UINavigationItem(title: "\(nameRocket)")
        let backItem = UIBarButtonItem(barButtonSystemItem: .close, target: nil, action: #selector(backTap))
        navigationItem.rightBarButtonItem = backItem
        
        navigationBar.setItems([navigationItem], animated: false)
    }
    
    @objc private func backTap() {
        dismiss(animated: true)
    }
    
}

