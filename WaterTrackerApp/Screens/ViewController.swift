//
//  ViewController.swift
//  WaterTrackerApp
//
//  Created by Hakan Or on 4.08.2022.
//

import UIKit
let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let targetAmount = 2700.0

class ViewController: UIViewController {
    
    // MARK: - Properties
    let waterStore = DataService()
    let waterWaveView = WaterWaveView()
    var remainingAmount : Double = 0
    
    // MARK: - Subviews
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 36, weight: .regular)
        label.numberOfLines = 2
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var waterLabel: UILabel = {
        let label = UILabel()
        label.text = String(remainingAmount)
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var glass: UIImageView = {
        let icon = UIImageView()
        var image = UIImage(named:"Glass")
        icon.backgroundColor = UIColor(red: 33/255, green: 30/255, blue: 36/255, alpha: 1)
        icon.image = image
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        icon.layer.cornerRadius = 10
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.isUserInteractionEnabled = true
        return icon
    }()
    
    private lazy var bottle: UIImageView = {
        let icon = UIImageView()
        var image = UIImage(named:"Bottle")
        icon.backgroundColor = UIColor(red: 33/255, green: 30/255, blue: 36/255, alpha: 1)
        icon.image = image
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        icon.layer.cornerRadius = 10
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.isUserInteractionEnabled = true
        return icon
    }()
    
    private lazy var flask: UIImageView = {
        let icon = UIImageView()
        var image = UIImage(named:"Flask")
        icon.backgroundColor = UIColor(red: 33/255, green: 30/255, blue: 36/255, alpha: 1)
        icon.image = image
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        icon.layer.cornerRadius = 10
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.isUserInteractionEnabled = true
        return icon
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAppereance()
        
        view.backgroundColor = .white
        
        [waterWaveView , containerView, waterLabel , titleLabel].forEach(view.addSubview)
        waterWaveView.setupProgress(waterWaveView.progress)
       
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        waterLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        waterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        waterLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
       
        waterWaveView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        waterWaveView.heightAnchor.constraint(equalToConstant: screenHeight).isActive = true
        waterWaveView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        waterWaveView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        [glass , bottle, flask].forEach(view.addSubview)
        
        glass.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -30).isActive = true
        glass.trailingAnchor.constraint(equalTo: bottle.leadingAnchor,constant: -16).isActive = true

        bottle.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -30).isActive = true
        bottle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
  
        flask.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -30).isActive = true
        flask.leadingAnchor.constraint(equalTo: bottle.trailingAnchor,constant: 16).isActive = true
        view.sendSubviewToBack(waterWaveView)
        
        let tapGestureBottle = UITapGestureRecognizer(target: self, action:#selector(handleGestureBottle(_:)))
        bottle.addGestureRecognizer(tapGestureBottle)

        let tapGestureFlask = UITapGestureRecognizer(target: self, action:#selector(handleGestureFlask(_:)))
        flask.addGestureRecognizer(tapGestureFlask)
        
        let tapGestureGlass = UITapGestureRecognizer(target: self, action:#selector(handleGestureGlass(_:)))
        glass.addGestureRecognizer(tapGestureGlass)
        
    }
    
    @objc private func handleGestureGlass(_ sender: UITapGestureRecognizer? = nil) {
        consumeWater(amount: 200)
    }
    
    @objc private func handleGestureBottle(_ sender: UITapGestureRecognizer? = nil) {
        consumeWater(amount: 500)
    }
    
    @objc private func handleGestureFlask(_ sender: UITapGestureRecognizer? = nil) {
        consumeWater(amount: 800)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: -Functions
    private func consumeWater(amount:Double) {
        self.waterWaveView.addProgress(amount/targetAmount)
        self.waterWaveView.setupProgress(self.waterWaveView.progress)
        waterStore.addWater(amount: amount)
        let currentWaterAmount = waterStore.getCurrentAmount()
        updateLabels(amount: targetAmount - currentWaterAmount)
    }
    
    private func fillWater(amount:Double) {
        self.waterWaveView.addProgress(amount/targetAmount)
        self.waterWaveView.setupProgress(self.waterWaveView.progress)
    }
    
    private func updateAppereance() {
        let currentWaterAmount = waterStore.getCurrentAmount()
        fillWater(amount: currentWaterAmount)
        remainingAmount = targetAmount - currentWaterAmount
        updateLabels(amount: remainingAmount)
    }
    
    private func updateLabels(amount: Double) {
        let amountToTarget = (amount) / 1000
        
        if amount < targetAmount && amount >= 0{
            let subtitleText = String(format: "Bugünkü su ihtiyacını karşılamak için \n%g litre daha su içmelisin.", amountToTarget)
            waterLabel.text = subtitleText
            
            if amount == 0 {
                titleLabel.text = "Merhaba! \nBugün su içtin mi?"
            } else {
                titleLabel.text = "Tebrikler! \nDoğru yoldasın."
            }
        } else if amount < targetAmount && amount < 0 {
            titleLabel.text = "Muhteşem! \nKendine iyi baktın."
            waterLabel.text = "Bugün vücüdun için gereken su miktarının tamamını karşıladın."
        } else {
            titleLabel.text = "Merhaba! \nBugün su içtin mi?"
            let subtitleText = String(format: "Bugünkü su ihtiyacını karşılamak için \n%g litre daha su içmelisin.", amountToTarget)
            waterLabel.text = subtitleText
        }
    }

}

