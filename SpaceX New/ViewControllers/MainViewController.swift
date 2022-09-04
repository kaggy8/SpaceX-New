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
    private var index = 0
    
    
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
    private func setupLoader() {
        self.networkManager.fetchData(dataType: [Rocket].self, from: Link.rockets.rawValue) { (model) in
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
            
            let stackViewInfo = UIStackView(frame: CGRect(x: 32,
                                                          y: 0,
                                                          width: infoScrollView.contentSize.width,
                                                          height: 96))
            stackViewInfo.axis = .horizontal
            stackViewInfo.distribution = .fillProportionally
            stackViewInfo.alignment = .center
            stackViewInfo.spacing = 20
            stackViewInfo.translatesAutoresizingMaskIntoConstraints = false
            stackViewInfo.layoutMargins = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
            stackViewInfo.isLayoutMarginsRelativeArrangement = true
            
            for screen in 0...3 {
                let view = UIView()
                view.heightAnchor.constraint(equalToConstant: 96).isActive = true
                view.widthAnchor.constraint(equalToConstant: 96).isActive = true
                view.backgroundColor = UIColor(red: 33/255,
                                               green: 33/255,
                                               blue: 33/255,
                                               alpha: 1)
                view.layer.cornerRadius = 32
                let label = setupLabelInfo(viewNumber: screen, index: index)
                self.index += 1
                view.addSubview(label[0])
                view.addSubview(label[1])
                stackViewInfo.addArrangedSubview(view)
            }
            
            let mainInfo = setupMainInfo(index: index)
            let firstStage = setupFirstStageUI(index: index)
            let secondStage = setupSecondStageUI(index: index)
            let button = setButtonLaunches(index: index)
            
            infoScrollView.addSubview(stackViewInfo)
            
            scrollView.addSubview(image)
            scrollView.addSubview(page)
            
            page.addSubview(nameRocketLabel)
            page.addSubview(infoScrollView)
            
            for label in mainInfo {
                page.addSubview(label)
            }
            
            for label in firstStage {
                page.addSubview(label)
            }
            
            for label in secondStage {
                page.addSubview(label)
            }
            page.addSubview(button)
            
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
        scrollView.isDirectionalLockEnabled = true
    }
    
    private func setupLabelInfo(viewNumber: Int, index: Int) -> [UILabel] {
        let tag = viewNumber
        
        let labelValue = UILabel(frame: CGRect(x: 8,
                                               y: 28,
                                               width: 80,
                                               height: 24))
        let labelInfo = UILabel(frame: CGRect(x: 8,
                                              y: 52,
                                              width: 80,
                                              height: 24))
        labelValue.textAlignment = .center
        labelValue.textColor = .white
        labelValue.font  = UIFont.boldSystemFont(ofSize: 16)
        labelValue.tag = tag
        
        labelInfo.textAlignment = .center
        labelInfo.textColor = .gray
        labelInfo.font = UIFont.systemFont(ofSize: 14)
        labelValue.tag = tag
        
        if tag == 0 {
            let heighValue = "\(rockets[index].height.meters)"
            labelValue.text = heighValue
            labelInfo.text = "Высота, м"
        } else if tag == 1 {
            let diameterValue = "\(rockets[index].diameter.meters)"
            labelValue.text = diameterValue
            labelInfo.text = "Диаметр, м"
        } else if tag == 2 {
            let massValue = "\(rockets[index].mass.kg)"
            labelValue.text = massValue
            labelInfo.text = "Масса, кг"
        } else {
            let payloadValue = "\(rockets[index].payloadWeights[0].kg)"
            labelValue.text = payloadValue
            labelInfo.frame.size.height = 40
            labelInfo.numberOfLines = 0
            labelInfo.text = "Загрузка, \n кг"
        }
        
        return [labelValue, labelInfo]
    }
    
    private func setupMainInfo(index: Int) -> [UILabel] {
        let date = getDate(index: index)
        let country = getCountry(index: index)
        let cost = "$\(rockets[index].costPerLaunch / 100000) млн"
        let firstLaunch = UILabel(frame: CGRect(x: 32,
                                                y: 248,
                                                width: 115,
                                                height: 24))
        let countryWord = UILabel(frame: CGRect(x: 32,
                                                y: 288,
                                                width: 176,
                                                height: 24))
        let costLabel = UILabel(frame: CGRect(x: 32,
                                                  y: 328,
                                                  width: 375,
                                                  height: 24))
        let dateLaunchLabel = UILabel(frame: CGRect(x: 195,
                                                    y: 248,
                                                    width: 170,
                                                    height: 24))
        let countryLabel = UILabel(frame: CGRect(x: 195,
                                                 y: 288,
                                                 width: 170,
                                                 height: 24))
        let costPerLaunch = UILabel(frame: CGRect(x: 195,
                                                  y: 328,
                                                  width: 170,
                                                  height: 24))
        
        firstLaunch.textAlignment = .left
        firstLaunch.textColor = .white
        firstLaunch.font = UIFont.systemFont(ofSize: 16)
        firstLaunch.text = "Первый запуск"
        
        countryWord.textAlignment = .left
        countryWord.textColor = .white
        countryWord.font = UIFont.systemFont(ofSize: 16)
        countryWord.text = "Страна"
        
        costLabel.textAlignment = .left
        costLabel.textColor = .white
        costLabel.font = UIFont.systemFont(ofSize: 16)
        costLabel.text = "Стоимость запуска"
        
        dateLaunchLabel.textAlignment = .right
        dateLaunchLabel.textColor = .white
        dateLaunchLabel.font = UIFont.systemFont(ofSize: 16)
        dateLaunchLabel.text = date
        
        countryLabel.textAlignment = .right
        countryLabel.textColor = .white
        countryLabel.font = UIFont.systemFont(ofSize: 16)
        countryLabel.text = country
        
        costPerLaunch.textAlignment = .right
        costPerLaunch.textColor = .white
        costPerLaunch.font = UIFont.systemFont(ofSize: 16)
        costPerLaunch.text = cost
        
        return [firstLaunch, countryWord, costLabel, dateLaunchLabel, countryLabel, costPerLaunch]
    }
    
    private func setupFirstStageUI(index: Int) -> [UILabel] {
        let firstStageLabel = UILabel(frame: CGRect(x: 32,
                                                    y: 392,
                                                    width: 300,
                                                    height: 32))
        let numberOfEnginesStringLabel = UILabel(frame: CGRect(x: 32,
                                                               y: 432,
                                                               width: 180,
                                                               height: 24))
        let fuelLabel = UILabel(frame: CGRect(x: 32,
                                              y: 472,
                                              width: 180,
                                              height: 24))
        let engines = UILabel(frame: CGRect(x: 175,
                                            y: 432,
                                            width: 150,
                                            height: 24))
        let fuelAmountTons = UILabel(frame: CGRect(x: 175,
                                                   y: 472,
                                                   width: 150,
                                                   height: 24))
        let measureOfWeight = UILabel(frame: CGRect(x: 335,
                                                    y: 472,
                                                    width: 28,
                                                    height: 24))
        let timeLabel = UILabel(frame: CGRect(x: 32,
                                              y: 512,
                                              width: 180,
                                              height: 24))
        let burnTimeSec = UILabel(frame: CGRect(x: 175,
                                                y: 512,
                                                width: 150,
                                                height: 24))
        let seconds = UILabel(frame: CGRect(x: 335,
                                            y: 512,
                                            width: 28,
                                            height: 24))
        
        firstStageLabel.textAlignment = .left
        firstStageLabel.textColor = .white
        firstStageLabel.font = UIFont.boldSystemFont(ofSize: 24)
        firstStageLabel.text = "Первая ступень"
        
        numberOfEnginesStringLabel.textAlignment = .left
        numberOfEnginesStringLabel.textColor = .white
        numberOfEnginesStringLabel.font = UIFont.systemFont(ofSize: 16)
        numberOfEnginesStringLabel.text = "Количество двигателей"
        
        fuelLabel.textAlignment = .left
        fuelLabel.textColor = .white
        fuelLabel.font = UIFont.systemFont(ofSize: 16)
        fuelLabel.text = "Количество топлива"
        
        engines.textAlignment = .right
        engines.textColor = .white
        engines.font = UIFont.systemFont(ofSize: 16)
        engines.text = "\(rockets[index].firstStage.engines)"
        
        fuelAmountTons.textAlignment = .right
        fuelAmountTons.textColor = .white
        fuelAmountTons.font = UIFont.systemFont(ofSize: 16)
        fuelAmountTons.text = "\(Int(rockets[index].firstStage.fuelAmountTons))"
        
        measureOfWeight.textAlignment = .right
        measureOfWeight.textColor = .gray
        measureOfWeight.font = UIFont.systemFont(ofSize: 16)
        measureOfWeight.text = "ton"
        
        timeLabel.textAlignment = .left
        timeLabel.textColor = .white
        timeLabel.font = UIFont.systemFont(ofSize: 16)
        timeLabel.text = "Время сгорания"
        
        burnTimeSec.textAlignment = .right
        burnTimeSec.textColor = .white
        burnTimeSec.font = UIFont.systemFont(ofSize: 16)
        
        if let burn = rockets[index].firstStage.burnTimeSec {
            burnTimeSec.text = "\(burn)"
            seconds.text = "sec"
        } else {
            burnTimeSec.text = "Нет данныx"
        }
        
        seconds.textAlignment = .right
        seconds.textColor = .gray
        seconds.font = UIFont.systemFont(ofSize: 16)
        
        return [firstStageLabel,
                numberOfEnginesStringLabel,
                fuelLabel,
                engines,
                fuelAmountTons,
                measureOfWeight,
                timeLabel,
                burnTimeSec,
                seconds
        ]
    }
    
    private func setupSecondStageUI(index: Int) -> [UILabel] {
        let secondStageLabel = UILabel(frame: CGRect(x: 26,
                                                    y: 576,
                                                    width: 300,
                                                    height: 32))
        let numberOfEnginesStringLabel = UILabel(frame: CGRect(x: 32,
                                                               y: 616,
                                                               width: 180,
                                                               height: 24))
        let fuelLabel = UILabel(frame: CGRect(x: 32,
                                              y: 656,
                                              width: 180,
                                              height: 24))
        let engines = UILabel(frame: CGRect(x: 175,
                                            y: 616,
                                            width: 150,
                                            height: 24))
        let fuelAmountTons = UILabel(frame: CGRect(x: 175,
                                                   y: 656,
                                                   width: 150,
                                                   height: 24))
        let measureOfWeight = UILabel(frame: CGRect(x: 335,
                                                    y: 656,
                                                    width: 28,
                                                    height: 24))
        let timeLabel = UILabel(frame: CGRect(x: 32,
                                              y: 696,
                                              width: 180,
                                              height: 24))
        let burnTimeSec = UILabel(frame: CGRect(x: 175,
                                                y: 696,
                                                width: 150,
                                                height: 24))
        let seconds = UILabel(frame: CGRect(x: 335,
                                            y: 696,
                                            width: 28,
                                            height: 24))
        
        secondStageLabel.textAlignment = .left
        secondStageLabel.textColor = .white
        secondStageLabel.font = UIFont.boldSystemFont(ofSize: 24)
        secondStageLabel.text = " Вторая ступень"
        
        numberOfEnginesStringLabel.textAlignment = .left
        numberOfEnginesStringLabel.textColor = .white
        numberOfEnginesStringLabel.font = UIFont.systemFont(ofSize: 16)
        numberOfEnginesStringLabel.text = "Количество двигателей"
        
        fuelLabel.textAlignment = .left
        fuelLabel.textColor = .white
        fuelLabel.font = UIFont.systemFont(ofSize: 16)
        fuelLabel.text = "Количество топлива"
        
        engines.textAlignment = .right
        engines.textColor = .white
        engines.font = UIFont.systemFont(ofSize: 16)
        engines.text = "\(rockets[index].secondStage.engines)"
        
        fuelAmountTons.textAlignment = .right
        fuelAmountTons.textColor = .white
        fuelAmountTons.font = UIFont.systemFont(ofSize: 16)
        fuelAmountTons.text = "\(Int(rockets[index].secondStage.fuelAmountTons))"
        
        measureOfWeight.textAlignment = .right
        measureOfWeight.textColor = .gray
        measureOfWeight.font = UIFont.systemFont(ofSize: 16)
        measureOfWeight.text = "ton"
        
        timeLabel.textAlignment = .left
        timeLabel.textColor = .white
        timeLabel.font = UIFont.systemFont(ofSize: 16)
        timeLabel.text = "Время сгорания"
        
        burnTimeSec.textAlignment = .right
        burnTimeSec.textColor = .white
        burnTimeSec.font = UIFont.systemFont(ofSize: 16)
        if let burn = rockets[index].secondStage.burnTimeSec {
            burnTimeSec.text = "\(burn)"
            seconds.text = "sec"
        } else {
            burnTimeSec.text = "Нет данныx"
        }
        
        seconds.textAlignment = .right
        seconds.textColor = .gray
        seconds.font = UIFont.systemFont(ofSize: 16)
        
        return [secondStageLabel,
                numberOfEnginesStringLabel,
                fuelLabel,
                engines,
                fuelAmountTons,
                measureOfWeight,
                timeLabel,
                burnTimeSec,
                seconds
        ]
    }
    
    private func setButtonLaunches(index: Int) -> UIButton {
        let button = UIButton(frame: CGRect(x: 32,
                                            y: 760,
                                            width: view.frame.size.width - 32 - 32,
                                            height: 56))
        button.tag = index
        button.layer.cornerRadius = 12
        button.setTitle("Посмотреть запуски", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        return button
    }
    
    private func getDate(index: Int) -> String {
        let receivedDate = rockets[index].firstFlight
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        guard let date = dateFormatter.date(from: receivedDate) else { return "Дата отсутствует"}
        let dateF = DateFormatter()
        dateF.timeStyle = .none
        dateF.dateFormat = "d MMMM, yyyy"
        return dateF.string(from: date)
    }
    
    private func getCountry(index: Int) -> String {
        let country = rockets[index].country
        
        switch country {
        case "Republic of the Marshall Islands":
            return "Маршалловы острова"
        case "United States":
            return "США"
        default:
            return "Нет данных"
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        let launchesVC = LaunchesViewController()
        launchesVC.modalPresentationStyle = .fullScreen
        launchesVC.nameRocketLabel.text = rockets[sender.tag].name
        launchesVC.rocket = rockets[sender.tag].id
        present(launchesVC, animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}
