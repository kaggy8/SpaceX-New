//
//  LaunchesViewController.swift
//  SpaceX New
//
//  Created by Stanislav Demyanov on 14.08.2022.
//

import UIKit

class LaunchesViewController: UIViewController {
    
    // MARK: - Public properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    let nameRocketLabel = UILabel()
    var id: String = ""
    
    // MARK: - Private Properties
    private let networkManager = NetworkManager.shared
    private var launches = [Launch]()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setupNavigationBar()
        setupLoader()
    }
}

extension LaunchesViewController {
    // MARK: - Private methods
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
    
    private func setupLoader() {
        self.networkManager.fetchData(dataType: [Launch].self, from: Links.launches.rawValue) { (model) in
            switch model {
            case .success(let launches):
                DispatchQueue.main.async {
                    self.launches = launches
                    print(launches[0].id)
                }
            case .failure(let error):
                print(error)
            }
        }

    }
    
    @objc private func backTap() {
        dismiss(animated: true)
    }
    
    private func setupUIViewController() {
        
    }
}

