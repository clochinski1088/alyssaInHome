//
//  BarCodeView.swift
//  Lularoe
//
//  Created by Collin Lochinski on 11/15/16.
//  Copyright © 2016 Collin Lochinski. All rights reserved.
//

import UIKit

class BarCodeView: UIView {
    
    var borderLayer : CAShapeLayer?
    var corners : [CGPoint]?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setMyView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func drawBorder(points : [CGPoint]) {
        self.corners = points
        let path = UIBezierPath()
        
        path.move(to: points.first!)
        
        for i in 1..<points.count {
            path.addLine(to: points[i])
        }
        
        path.addLine(to: points.first!)
        borderLayer?.path = path.cgPath
    }
    
    func setMyView() {
        borderLayer = CAShapeLayer()
        borderLayer?.strokeColor = UIColor.red.cgColor
        borderLayer?.lineWidth = 2.0
        borderLayer?.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(borderLayer!)
    }
    
}
