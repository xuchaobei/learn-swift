//
//  FaceView.swift
//  Happiness
//
//  Created by xu on 15/9/5.
//  Copyright (c) 2015年 xu. All rights reserved.
//

import UIKit

protocol FaceViewDataSource : class {
    func smilinessForFaceView (sender : FaceView) -> Double?
}

@IBDesignable
class FaceView: UIView {

    @IBInspectable
    var lineWidth : CGFloat = 3 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var color : UIColor = UIColor.blueColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var scale : CGFloat = 0.9 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    weak var dataSource : FaceViewDataSource?
    
    var faceCenter : CGPoint {
        return convertPoint(center, fromView : superview)
    }
    
    var faceRadius : CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    private struct Scaling {
        static let FaceRadiusToEyeRadiusRatio : CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio : CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio : CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio : CGFloat = 1
        static let FaceRadiusToMouthHeigthRatio : CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio : CGFloat = 3
    }
    
    private enum Eye {
        case Left, Right
    }
   
    func scale(gesture : UIPinchGestureRecognizer){
        if(gesture.state == .Changed){
            scale *= gesture.scale
            gesture.scale = 1
        }
    
    }
    
    private func bezierPathForEye(whichEye : Eye) -> UIBezierPath
    {
        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        let eyeOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeSeperation = faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeOffset
        switch(whichEye){
        case .Left :
            eyeCenter.x -= eyeSeperation / 2
            break
        case .Right :
            eyeCenter.x += eyeSeperation / 2
            break
        }
        
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    
    private func bezierPathForMouth(fractionOfMaxMile : Double) -> UIBezierPath
    {
        let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeigthRatio
        let mouthOffset = faceRadius / Scaling.FaceRadiusToMouthOffsetRatio
        
        var smileHeight = CGFloat(max(min(fractionOfMaxMile, 1), -1)) * mouthHeight
        
        let start = CGPoint(x:faceCenter.x - mouthWidth/2, y:faceCenter.y + mouthOffset )
        let end = CGPoint(x: faceCenter.x + mouthWidth/2, y: start.y)
        let cp1 = CGPoint(x : start.x + mouthWidth/3, y: start.y + smileHeight)
        let cp2 = CGPoint(x : start.x + 2*mouthWidth/3, y: start.y + smileHeight)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2 : cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        
        bezierPathForEye(Eye.Left).stroke()
        bezierPathForEye(Eye.Right).stroke()
        
        let smiliness = dataSource?.smilinessForFaceView(self) ?? 0.0
        let smilePath = bezierPathForMouth(smiliness)
        
        smilePath.stroke()
    }


}
