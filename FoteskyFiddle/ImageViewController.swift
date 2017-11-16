//
//  ImageViewController.swift
//  FoteskyFiddle
//
//  Created by Pavel Peroutka on 16/11/2017.
//  Copyright © 2017 Pavel Peroutka. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var cropView: UIScrollView!
    var image: UIImage!
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cropView.delegate = self

        imageView = UIImageView(image: image)
        imageView!.contentMode = .center
        imageView!.backgroundColor = UIColor.brown
        cropView.contentSize = image.size
        cropView.clipsToBounds = false
        cropView.addSubview(imageView!)
        
        let cropWiewSize = cropView.frame.size
        let horizontalScale = cropWiewSize.width / cropView.contentSize.width
        let vertiacalScale = cropWiewSize.height / cropView.contentSize.height
        let scale = max(horizontalScale, vertiacalScale)
        
        cropView.minimumZoomScale = scale
        cropView.maximumZoomScale = 1
        cropView.zoomScale = scale
        
        for recognizer in cropView.gestureRecognizers! {
            view.addGestureRecognizer(recognizer)
        }
        
        let effectView = UIVisualEffectView(
            effect: UIBlurEffect(style: .dark),
            outsideOf: cropView.convert(cropView.bounds, to: view),
            within: view.frame
        )
        view.addSubview(effectView)


    }

//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        if
//
//        let offsetX = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
//        let offsetY = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);
//
//        subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
//                                     scrollView.contentSize.height * 0.5 + offsetY);
//    }
}

extension ImageViewController : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

extension UIVisualEffectView {
    convenience init(effect: UIVisualEffect?, outsideOf innerRect: CGRect, within outerRect: CGRect) {
        self.init(effect: effect)
        self.frame = outerRect
        
        let innerMaskPath = UIBezierPath(rect: innerRect)
        let outerMaskPath = UIBezierPath(rect: outerRect)

        let path = innerMaskPath
        path.append(outerMaskPath)

        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.fillRule = kCAFillRuleEvenOdd
        mask.fillColor = UIColor.green.cgColor

        self.layer.mask = mask
    }
}
