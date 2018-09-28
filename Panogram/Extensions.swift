//
//  Extensions.swift
//  Panogram
//
//  Created by Labs on 6/27/17.
//  Copyright © 2017 Tera Mo Labs. All rights reserved.
//

import UIKit

protocol ErrorPresenting {
  func displayAlert(title: String, message: String, action: UIAlertAction?)
}

extension UIColor {
  convenience public init(red: UInt8, green: UInt8, blue: UInt8) {
    let red = CGFloat(Double(red)/255.0)
    let green = CGFloat(Double(green)/255.0)
    let blue = CGFloat(Double(blue)/255.0)

    self.init(red: red, green: green, blue: blue, alpha: 1.0)
  }

  convenience public init(hex: Int) {
    let red = UInt8(((hex >> 16) & 0xFF))
    let green = UInt8(((hex >> 8) & 0xFF))
    let blue = UInt8((hex & 0xFF))
    self.init(red: red, green: green, blue: blue)
  }
}

extension ErrorPresenting where Self: UIViewController {
  func displayAlert(title: String, message: String, action: UIAlertAction?) {
    let alertController = UIAlertController(title: title, message: message,
                                            preferredStyle: .alert)

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel,
                                     handler: nil)
    alertController.addAction(cancelAction)

    if action != nil {
      alertController.addAction(action!)
    }
    present(alertController, animated: true, completion: nil)
  }
}

extension UIImage {
  func pixelBuffer() -> CVPixelBuffer? {
    let width = self.size.width
    let height = self.size.height
    let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                 kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
    var pixelBuffer: CVPixelBuffer?
    let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                     Int(width),
                                     Int(height),
                                     kCVPixelFormatType_32ARGB,
                                     attrs,
                                     &pixelBuffer)

    guard let resultPixelBuffer = pixelBuffer, status == kCVReturnSuccess else {
      return nil
    }

    CVPixelBufferLockBaseAddress(resultPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
    let pixelData = CVPixelBufferGetBaseAddress(resultPixelBuffer)

    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    guard let context = CGContext(data: pixelData,
                                  width: Int(width),
                                  height: Int(height),
                                  bitsPerComponent: 8,
                                  bytesPerRow: CVPixelBufferGetBytesPerRow(resultPixelBuffer),
                                  space: rgbColorSpace,
                                  bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
                                    return nil
    }

    context.translateBy(x: 0, y: height)
    context.scaleBy(x: 1.0, y: -1.0)

    UIGraphicsPushContext(context)
    self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
    UIGraphicsPopContext()
    CVPixelBufferUnlockBaseAddress(resultPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
    return resultPixelBuffer
  }
}
