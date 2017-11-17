//
//  WithHoleInItVisualEffectView.swift
//  FoteskyFiddle
//
//  Created by Pavel Peroutka on 16/11/2017.
//  Copyright © 2017 Pavel Peroutka. All rights reserved.
//

import UIKit

class WithHoleInItVisualEffectView: UIVisualEffectView {

    @IBOutlet weak var holeView: UIView?
    @IBOutlet weak var button: UIButton?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let holeView = self.holeView {
            // Ensures to use the current background color to set the filling color
            self.backgroundColor?.setFill()
            UIRectFill(rect)
            
            let layer = CAShapeLayer()
            let path = CGMutablePath()
            
            // Make hole in view's overlay
            // NOTE: Here, instead of using the transparentHoleView UIView we could use a specific CFRect location instead...
            path.addRect(holeView.frame)
            path.addRect(button!.frame)
            
            path.addRect(bounds)
            
            layer.path = path
            layer.fillRule = kCAFillRuleEvenOdd
            self.layer.mask = layer
        }
    }

}
