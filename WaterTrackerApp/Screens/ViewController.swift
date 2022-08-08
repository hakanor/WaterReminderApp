//
//  ViewController.swift
//  WaterTrackerApp
//
//  Created by Hakan Or on 4.08.2022.
//

import UIKit
let screenWidth = UIScreen.main.bounds.size.width

class ViewController: UIViewController {
    
    let waterWaveView = WaterWaveView()
    
    let dr: TimeInterval = 10.0
    var timer: Timer?
    
    // MARK: - Subviews
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var glass: UIImageView = {
        let icon = UIImageView()
        var image = UIImage(named:"Glass")
        icon.backgroundColor = .gray
        icon.image = image
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.isUserInteractionEnabled = true
        return icon
    }()
    
    private lazy var bottle: UIImageView = {
        let icon = UIImageView()
        var image = UIImage(named:"Bottle")
        icon.backgroundColor = .gray
        icon.image = image
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.isUserInteractionEnabled = true
        return icon
    }()
    
    private lazy var flask: UIImageView = {
        let icon = UIImageView()
        var image = UIImage(named:"Flask")
        icon.backgroundColor = .gray
        icon.image = image
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.isUserInteractionEnabled = true
        return icon
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [waterWaveView , containerView].forEach(view.addSubview)
        waterWaveView.setupProgress(waterWaveView.progress)
        
        waterWaveView.widthAnchor.constraint(equalToConstant: screenWidth * 0.5).isActive = true
        waterWaveView.heightAnchor.constraint(equalToConstant: screenWidth * 0.5).isActive = true
        waterWaveView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        waterWaveView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        [glass , bottle, flask].forEach(view.addSubview)
        
        glass.topAnchor.constraint(equalTo: waterWaveView.bottomAnchor,constant: 26).isActive = true
        glass.trailingAnchor.constraint(equalTo: bottle.leadingAnchor,constant: -16).isActive = true

        bottle.topAnchor.constraint(equalTo: waterWaveView.bottomAnchor,constant: 26).isActive = true
        bottle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
  
        flask.topAnchor.constraint(equalTo: waterWaveView.bottomAnchor,constant: 26).isActive = true
        flask.leadingAnchor.constraint(equalTo: bottle.trailingAnchor,constant: 16).isActive = true

        let tapGestureBottle = UITapGestureRecognizer(target: self, action:#selector(handleGestureBottle(_:)))
        bottle.addGestureRecognizer(tapGestureBottle)

        let tapGestureFlask = UITapGestureRecognizer(target: self, action:#selector(handleGestureFlask(_:)))
        flask.addGestureRecognizer(tapGestureFlask)
        
        let tapGestureGlass = UITapGestureRecognizer(target: self, action:#selector(handleGestureGlass(_:)))
        glass.addGestureRecognizer(tapGestureGlass)
        
    }
    
    @objc private func handleGestureGlass(_ sender: UITapGestureRecognizer? = nil) {
        print("tapped")
        self.waterWaveView.addProgress(0.1)
        self.waterWaveView.setupProgress(self.waterWaveView.progress)
        print(self.waterWaveView.progress)
    }
    
    @objc private func handleGestureBottle(_ sender: UITapGestureRecognizer? = nil) {
        print("tapped")
        self.waterWaveView.addProgress(0.2)
        self.waterWaveView.setupProgress(self.waterWaveView.progress)
        print(self.waterWaveView.progress)
    }
    
    @objc private func handleGestureFlask(_ sender: UITapGestureRecognizer? = nil) {
        print("tapped")
        self.waterWaveView.addProgress(0.3)
        self.waterWaveView.setupProgress(self.waterWaveView.progress)
        print(self.waterWaveView.progress)
    }
    
 
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }


}

