//
//  MainViewController.swift
//  SpaceX New
//
//  Created by Stanislav Demyanov on 06.08.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    // MARK: - Private properties
    private lazy var scrollView = UIScrollView()
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.backgroundColor = UIColor(red: 18/255,
                                              green: 18/255,
                                              blue: 18/255,
                                              alpha: 1)
        return pageControl
    }()
    
    private let networkManager = NetworkManager.shared
    private var rockets = [Rocket]()
    private let index = 0
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        pageControl.addTarget(self,
                              action: #selector(pageControlDidChange(_:)),
                              for: .valueChanged)
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        setupLoader()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pageControl.frame = CGRect(x:0,
                                   y: view.frame.size.height - 85,
                                   width: view.frame.size.width,
                                   height: 85)
    }
}

// MARK: - Private methods
extension MainViewController {
    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        let currentDot = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: CGFloat(currentDot) * view.frame.size.width,
                                            y: 0),
                                    animated: true)
    }
    
    private func configureScrollView() {
        scrollView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: view.frame.size.width,
                                  height: view.frame.size.height - 85)
        
        scrollView.contentSize = CGSize(width: view.frame.size.width * CGFloat(rockets.count),
                                        height: 920 + 248)
        scrollView.isPagingEnabled = true
        
        for index in 0..<rockets.count {
            let page = UIView(frame: CGRect(x: CGFloat(index) * view.frame.size.width,
                                            y: 280,
                                            width: view.frame.size.width,
                                            height: scrollView.contentSize.height))
            page.layer.cornerRadius = 32
            page.backgroundColor = .black
            
            let image = UIImageView(frame: CGRect(x: CGFloat(index) * view.frame.size.width,
                                                  y: 0,
                                                  width: view.frame.size.width,
                                                  height: 330))
            let nameRocketLabel = UILabel(frame: CGRect(x: 32,
                                                  y: 48,
                                                  width: 200,
                                                  height: 32))
            nameRocketLabel.text = "\(rockets[index].name)"
            nameRocketLabel.font = UIFont(name: "Verdana", size: 24)
            nameRocketLabel.textColor = .white
            
            let infoScrollView = UIScrollView(frame: CGRect(x: 0,
                                                            y: 112,
                                                            width: view.frame.size.width,
                                                            height: 96))
            infoScrollView.contentSize = CGSize(width: view.frame.size.width + 120,
                                                height: 96)
            infoScrollView.showsVerticalScrollIndicator = false
            infoScrollView.showsHorizontalScrollIndicator = false
            infoScrollView.contentInsetAdjustmentBehavior = .never
            infoScrollView.bounces = false
            infoScrollView.bouncesZoom = false
            infoScrollView.alwaysBounceVertical = false
            infoScrollView.alwaysBounceHorizontal = false
            
            let stackViewInfo = UIStackView(frame: CGRect(x: 0,
                                                          y: 0,
                                                          width: infoScrollView.contentSize.width,
                                                          height: 96))
            stackViewInfo.axis = .horizontal
            stackViewInfo.distribution = .fillProportionally
            stackViewInfo.alignment = .center
            stackViewInfo.spacing = 20
            stackViewInfo.translatesAutoresizingMaskIntoConstraints = false
            
            for _ in 0...3 {
                let view = UIView()
                view.heightAnchor.constraint(equalToConstant: 96).isActive = true
                view.widthAnchor.constraint(equalToConstant: 96).isActive = true
                view.backgroundColor = UIColor(red: 33/255,
                                               green: 33/255,
                                               blue: 33/255,
                                               alpha: 1)
                view.layer.cornerRadius = 32
                stackViewInfo.addArrangedSubview(view)
            }
            
            infoScrollView.addSubview(stackViewInfo)
            
            scrollView.addSubview(image)
            scrollView.addSubview(page)
            
            page.addSubview(nameRocketLabel)
            page.addSubview(infoScrollView)
            
            
            DispatchQueue.global().async {
                guard let imageData = self.networkManager.fetchImage(from: self.rockets[index].flickrImages.randomElement()) else { return }
                DispatchQueue.main.async {
                    image.image = UIImage(data: imageData)
                    image.clipsToBounds = true
                    image.contentMode = .scaleAspectFill
                }
            }
        }
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.bouncesZoom = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = .black
    }
    
    
    private func setupLoader() {
        self.networkManager.fetchData(dataType: [Rocket].self, from: Links.rockets.rawValue) { (model) in
            switch model {
            case .success(let rockets):
                DispatchQueue.main.async {
                    self.rockets = rockets
                    self.pageControl.numberOfPages = rockets.count
                    self.configureScrollView()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - UIScrollViewDelegate
extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}
