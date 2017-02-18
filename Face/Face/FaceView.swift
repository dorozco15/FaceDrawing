//
//  FaceView.swift
//  Face
//
//  Created by Danny Orozco on 2017-02-17.
//  Copyright © 2017 Danny Orozco. All rights reserved.
//

import UIKit

class FaceView: UIView {
    
    var mouthCurvature: CGFloat = 1.0
    var scale: CGFloat = 0.9
    
    private var faceRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height)/2 * scale
    }
    private var faceCenter: CGPoint{
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    
    
    private enum Eye {
        case right
        case left
    }
    private struct Ratios {
        static let FaceRadiusToEyeOffset: CGFloat = 3
        static let FaceRadiusToEyeRadius: CGFloat = 10
        static let FaceRadiusToMouthWidth: CGFloat = 1
        static let FaceRadiusToMouthHeight: CGFloat = 3
        static let FaceRadiusToMouthOffset: CGFloat = 3
    }
    
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2*M_PI),
            clockwise: false
        )
        path.lineWidth = 4.0
        return path
    }
    private func getEyeCenter(eye: Eye) -> CGPoint{
        let eyeOffset = faceRadius/Ratios.FaceRadiusToEyeOffset
        var eyeCenter = faceCenter
        switch eye {
        case .left: eyeCenter.x -= eyeOffset
        case .right: eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    private func pathForEye(eye: Eye) -> UIBezierPath{
        let eyeRadius = faceRadius / Ratios.FaceRadiusToEyeRadius
        let eyeCenter = getEyeCenter(eye: eye)
        return pathForCircleCenteredAtPoint(midPoint: eyeCenter, withRadius: eyeRadius)
    }
    private func pathForMouth() -> UIBezierPath{
        let mouthWidth = faceRadius/Ratios.FaceRadiusToMouthWidth
        let mouthHeight = faceRadius/Ratios.FaceRadiusToMouthHeight
        let mouthOffset = faceRadius/Ratios.FaceRadiusToMouthOffset
        
        let mouthRect = CGRect(x: faceCenter.x - mouthWidth/2, y: faceCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let controlPoint1 = CGPoint(x:start.x + mouthRect.width/3, y: start.y + smileOffset)
        let cp2 = CGPoint(x:start.x + 2 * mouthRect.width/3, y: start.y + smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: controlPoint1, controlPoint2: cp2 )
        path.lineWidth = 4.0
        return path
        
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let face = pathForCircleCenteredAtPoint(midPoint: faceCenter, withRadius: faceRadius)
        UIColor.blue.set()
        face.stroke()
        
        pathForEye(eye: .left).stroke()
        pathForEye(eye: .right).stroke()
        pathForMouth().stroke()
        
    }
    

}
