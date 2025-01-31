//
//  UIImage + Extension.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/31/25.
//

import UIKit

extension UIImage {
    
    func downSampling(scale: CGFloat) -> UIImage {
        let data = self.pngData()! as CFData
        let imageSource = CGImageSourceCreateWithData(data, nil)!
        let maxPixel = max(self.size.width, self.size.height) * scale
        let options = [
            kCGImageSourceThumbnailMaxPixelSize: maxPixel,
            kCGImageSourceCreateThumbnailFromImageAlways: true
            
        ] as CFDictionary
        
        let scaledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options)!
        print(scaledImage)
        return UIImage(cgImage: scaledImage)
    }
    
}
