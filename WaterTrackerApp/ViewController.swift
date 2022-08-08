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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(waterWaveView)
        waterWaveView.setupProgress(waterWaveView.progress)

        waterWaveView.widthAnchor.constraint(equalToConstant: screenWidth * 0.5).isActive = true
        waterWaveView.heightAnchor.constraint(equalToConstant: screenWidth * 0.5).isActive = true
        waterWaveView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        waterWaveView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { _ in
            let dr = CGFloat(1.0 / (self.dr/0.01))
            self.waterWaveView.progress += dr
            self.waterWaveView.setupProgress(self.waterWaveView.progress)
            print(self.waterWaveView.progress)
            
            if self.waterWaveView.progress >= 1 {
                self.timer?.invalidate()
                self.timer = nil
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.waterWaveView.percentAnim()
                }
            }
            
        })
    }


}

