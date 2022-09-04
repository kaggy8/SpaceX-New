//
//  LaunchesViewController.swift
//  SpaceX New
//
//  Created by Stanislav Demyanov on 14.08.2022.
//

import UIKit
import Alamofire

class LaunchesViewController: UIViewController {
    
    // MARK: - Public properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    let nameRocketLabel = UILabel()
    var rocket: String = ""
    
    // MARK: - Private Properties
    private let networkManager = NetworkManager.shared
    private var launches = [Launch]()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setupNavigationBar()
        setupLoader()
        print(Link.launches.rawValue + self.rocket)
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
        AF.request(Link.launches.rawValue + rocket, method: .post)
            .validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    self.launches = Launch.getLaunches(from: value)
                    print(self.launches)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    @objc private func backTap() {
        dismiss(animated: true)
    }
    
    private func setupUIView() {
        
    }
}
