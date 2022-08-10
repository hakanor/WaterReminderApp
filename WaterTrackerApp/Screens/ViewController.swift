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
    
    // MARK: - Subviews
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.numberOfLines = 3
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var waterLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var glass: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "Glass")
        button.tintColor = .white
        button.setImage(image, for: .normal)
        button.backgroundColor = UIColor(red: 33/255, green: 30/255, blue: 36/255, alpha: 1)
        button.layer.cornerRadius = 10
        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleGestureGlass(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var bottle: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "Bottle")
        button.tintColor = .white
        button.setImage(image, for: .normal)
        button.backgroundColor = UIColor(red: 33/255, green: 30/255, blue: 36/255, alpha: 1)
        button.layer.cornerRadius = 10
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleGestureBottle(_:)), for: .touchUpInside)
        return button
    }()
 
    private lazy var flask: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "Flask")
        button.tintColor = .white
        button.setImage(image, for: .normal)
        button.backgroundColor = UIColor(red: 33/255, green: 30/255, blue: 36/255, alpha: 1)
        button.layer.cornerRadius = 10
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleGestureFlask(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var glassLabel: UILabel = {
        let label = UILabel()
        label.text = "200ml"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bottleLabel: UILabel = {
        let label = UILabel()
        label.text = "500ml"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var flaskLabel: UILabel = {
        let label = UILabel()
        label.text = "800ml"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAppereance()
        
        view.backgroundColor = .black
        
        [waterWaveView , containerView, waterLabel , titleLabel].forEach(view.addSubview)
        waterWaveView.setupProgress(waterWaveView.progress)
        
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        waterLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 10).isActive = true
        waterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16).isActive = true
        waterLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        waterWaveView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        waterWaveView.heightAnchor.constraint(equalToConstant: screenHeight).isActive = true
        waterWaveView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        waterWaveView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        [glass , bottle, flask].forEach(view.addSubview)
        
        glass.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -screenHeight/8).isActive = true
        glass.trailingAnchor.constraint(equalTo: bottle.leadingAnchor,constant: -16).isActive = true
        
        bottle.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -screenHeight/8).isActive = true
        bottle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        flask.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -screenHeight/8).isActive = true
        flask.leadingAnchor.constraint(equalTo: bottle.trailingAnchor,constant: 16).isActive = true
        view.sendSubviewToBack(waterWaveView)
        
        [glassLabel , bottleLabel, flaskLabel].forEach(view.addSubview)
        glassLabel.topAnchor.constraint(equalTo: glass.bottomAnchor,constant: 10).isActive = true
        glassLabel.centerXAnchor.constraint(equalTo: glass.centerXAnchor).isActive = true
        bottleLabel.topAnchor.constraint(equalTo: bottle.bottomAnchor,constant: 10).isActive = true
        bottleLabel.centerXAnchor.constraint(equalTo: bottle.centerXAnchor).isActive = true
        flaskLabel.topAnchor.constraint(equalTo: flask.bottomAnchor,constant: 10).isActive = true
        flaskLabel.centerXAnchor.constraint(equalTo: flask.centerXAnchor).isActive = true
        
        let tapGestureBottle = UITapGestureRecognizer(target: self, action:#selector(handleGestureBottle(_:)))
        bottle.addGestureRecognizer(tapGestureBottle)
        
        let tapGestureFlask = UITapGestureRecognizer(target: self, action:#selector(handleGestureFlask(_:)))
        flask.addGestureRecognizer(tapGestureFlask)
        
        let tapGestureGlass = UITapGestureRecognizer(target: self, action:#selector(handleGestureGlass(_:)))
        glass.addGestureRecognizer(tapGestureGlass)
        
    }
    
    @objc private func handleGestureGlass(_ sender: UIButton!) {
        consumeWater(amount: 200)
    }
    
    @objc private func handleGestureBottle(_ sender: UIButton!) {
        consumeWater(amount: 500)
    }
    
    @objc private func handleGestureFlask(_ sender: UIButton!) {
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
        let remainingAmount = targetAmount - currentWaterAmount
        updateLabels(amount: remainingAmount)
    }
    
    private func updateLabels(amount: Double) {
        let amountToTarget = (amount) / 1000
        
        if amount < targetAmount && amount >= 0{
            let subtitleText = String(format: "You have to drink %glt of water \nto meet daily recommendations.", amountToTarget)
            waterLabel.text = subtitleText
            if amount == 0 {
                titleLabel.text = "Hello! \nDid you drink water today?"
            } else {
                titleLabel.text = "Congratulations! \nKeep going..."
            }
        } else if amount < targetAmount && amount < 0 {
            let currentWaterAmount = waterStore.getCurrentAmount()
            titleLabel.text = "Wonderful! \nMay the force be with you."
            waterLabel.text = "Well done soldier. \nYou drank \(currentWaterAmount/1000) liters of water today."
        } else {
            titleLabel.text = "Hello! \nDid you drink water today?"
            let subtitleText = String(format: "You have to drink %glt of water \nto meet daily recommendations.", amountToTarget)
            waterLabel.text = subtitleText
        }
    }

}

