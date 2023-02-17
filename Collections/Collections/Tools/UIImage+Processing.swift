//
//  UIImage+Processing.swift
//  SwiftTest
//
//  Created by wangxiangzhao on 2023/2/16.
//

import UIKit
import Accelerate

extension UIImage {
    ///图片解码
    ///size：想要重设成的大小，默认：zero，代表不重设大小
    ///scale：缩放，默认0，代表按照屏幕像素缩放
    ///isCache：解码后的数据是否要缓存在内存中，默认缓存
    func decode(to size: CGSize = .zero, scale: CGFloat = 0, isCache: Bool = true) -> UIImage? {
        guard let pngData = self.pngData() else { return nil }
        guard let imageSource = CGImageSourceCreateWithData(pngData as CFData, nil) else { return nil }
        var options: [CFString : Any] = [
            kCGImageSourceShouldCache: isCache,
            kCGImageSourceShouldCacheImmediately: isCache,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
        ]
        if CGSizeEqualToSize(.zero, size) == false {
            var maxPixelSize = max(size.width, size.height)
            if scale != 0 {
                maxPixelSize *= scale
            } else {
                maxPixelSize *= UIScreen.main.scale
            }
            options[kCGImageSourceThumbnailMaxPixelSize] = maxPixelSize
        }
        guard let resizedCGImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) else { return nil }
        return UIImage(cgImage: resizedCGImage)
    }
    
    ///图片解码
    ///size：想要重设成的大小，默认：zero，代表不重设大小
    ///scale：缩放，默认0，代表按照屏幕像素缩放
    ///isCache：解码后的数据是否要缓存在内存中，默认缓存
    static func decode(at url: URL, to size: CGSize = .zero, scale: CGFloat = 0, isCache: Bool = true) -> UIImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, imageSourceOptions) else {
            return nil
        }
        var options: [CFString : Any] = [
            kCGImageSourceShouldCache: isCache,
            kCGImageSourceShouldCacheImmediately: isCache,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
        ]
        if CGSizeEqualToSize(.zero, size) == false {
            var maxPixelSize = max(size.width, size.height)
            if scale != 0 {
                maxPixelSize *= scale
            } else {
                maxPixelSize *= UIScreen.main.scale
            }
            options[kCGImageSourceThumbnailMaxPixelSize] = maxPixelSize
        }
        guard let resizedCGImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) else { return nil }
        return UIImage(cgImage: resizedCGImage)
    }
}
