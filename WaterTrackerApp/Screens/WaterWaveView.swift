//
//  WaterWaveView.swift
//  WaterTrackerApp
//
//  Created by Hakan Or on 8.08.2022.
//

import UIKit

class WaterWaveView: UIView {
    // MARK: - Properties
    private let firstLayer = CAShapeLayer()
    private let secondLayer = CAShapeLayer()
    
    private let percentLabel = UILabel()
    
    private var firstColor: UIColor = .clear
    private var secondColor: UIColor = .clear
    
    private let twoPi: CGFloat = .pi*2
    private var offset: CGFloat = 0.0
    private let width = screenWidth
    private let height = screenHeight
    
    var showSingleWave = false
    private var start = false
    var progress: CGFloat = 0.0
    var waveHeight: CGFloat = 0.0
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Setups

extension WaterWaveView {
    private func setupViews(){
        bounds = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        clipsToBounds = true
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        layer.masksToBounds = true
        
        waveHeight = 7.0
        firstColor = .systemTeal
        secondColor = .systemTeal.withAlphaComponent(0.4)
        createFirstLayer()
        
        if !showSingleWave {
            createSecondLayer()
        }
        
        createPercentageLabel()
        
    }
    
    private func createFirstLayer() {
        firstLayer.frame = bounds
        firstLayer.anchorPoint = .zero
        firstLayer.fillColor = firstColor.cgColor
        layer.addSublayer(firstLayer)
    }
    
    private func createSecondLayer() {
        secondLayer.frame = bounds
        secondLayer.anchorPoint = .zero
        secondLayer.fillColor = secondColor.cgColor
        layer.addSublayer(secondLayer)
    }
    
    private func createPercentageLabel() {
        percentLabel.font = UIFont.boldSystemFont(ofSize: 35)
        percentLabel.textAlignment = .center
        percentLabel.text = ""
        percentLabel.textColor = .white.withAlphaComponent(0.7)
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(percentLabel)
        percentLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        percentLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func percentAnim() {
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.duration = 2
        anim.fromValue = 0
        anim.toValue = 1
        anim.repeatCount = .infinity
        anim.isRemovedOnCompletion = false
        
        percentLabel.layer.add(anim, forKey: nil)
    }
    
    func addProgress(_ pr: CGFloat) {
        if(progress <= 1 && (progress+pr) <= 1 ){
            progress += pr
        }
        
        else if(progress+pr > 1 ){
            progress = 1
        }
        
        if progress >= 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.percentAnim()
            }
        }
    }
    
    func setupProgress(_ pr: CGFloat) {
        progress = pr
        percentLabel.text = String(format: "%ld%%", NSNumber(value: Float(pr*100)).intValue)
        let top: CGFloat = pr * bounds.size.height
        firstLayer.setValue(height-top, forKeyPath: "position.y")
        secondLayer.setValue(height-top, forKeyPath: "position.y")
        
        if !start{
            DispatchQueue.main.async {
                self.startAnim()
            }
        }
    }
    
    private func startAnim() {
        start = true
        waterVaweAnim()
    }
    
    private func waterVaweAnim() {
        let w = bounds.size.width
        let h = bounds.size.height
        
        let bezier = UIBezierPath()
        let path = CGMutablePath()
        let startOffsetY = waveHeight * CGFloat(sinf(Float(offset * twoPi / w)))
        var originOffsetY: CGFloat = 0.0
        
        path.move(to: CGPoint(x: 0, y: startOffsetY),transform: .identity)
        bezier.move(to: CGPoint(x: 0, y: startOffsetY))
        
        for i in stride(from: 0.0, to: w*1000, by: 1){
            originOffsetY = waveHeight * CGFloat(sinf(Float(twoPi / w * i + offset * twoPi / w)))
            bezier.addLine(to: CGPoint(x: i, y: originOffsetY))
        }
        
        bezier.addLine(to: CGPoint(x: w*1000, y: originOffsetY))
        bezier.addLine(to: CGPoint(x: w*1000, y: h))
        bezier.addLine(to: CGPoint(x: 0.0, y: h))
        bezier.addLine(to: CGPoint(x: 0.0, y: startOffsetY))
        bezier.close()
        
        let anim = CABasicAnimation(keyPath: "transform.translation.x")
        anim.duration = 2.0
        anim.fromValue = -w * 0.5
        anim.toValue = -w - w * 0.5
        anim.repeatCount = .infinity
        anim.isRemovedOnCompletion = false
        
        firstLayer.fillColor = firstColor.cgColor
        firstLayer.path = bezier.cgPath
        firstLayer.add(anim, forKey: nil)
        
        if !showSingleWave {
            let bezier = UIBezierPath()
            
            let startOffsetY = waveHeight * CGFloat(sinf(Float(offset * twoPi / w)))
            var originOffsetY: CGFloat = 0.0
            
            bezier.move(to: CGPoint(x: 0, y: startOffsetY))
            
            for i in stride(from: 0.0, to: w*1000, by: 1){
                originOffsetY = waveHeight * CGFloat(cosf(Float(twoPi / w * i + offset * twoPi / w)))
                bezier.addLine(to: CGPoint(x: i, y: originOffsetY))
            }
            
            bezier.addLine(to: CGPoint(x: w*1000, y: originOffsetY))
            bezier.addLine(to: CGPoint(x: w*1000, y: h))
            bezier.addLine(to: CGPoint(x: 0.0, y: h))
            bezier.addLine(to: CGPoint(x: 0.0, y: startOffsetY))
            bezier.close()
            
            secondLayer.fillColor = secondColor.cgColor
            secondLayer.path = bezier.cgPath
            secondLayer.add(anim, forKey: nil)
        }
        
    }
}
