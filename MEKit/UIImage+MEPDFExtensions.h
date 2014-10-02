//
//  UIImage+MEPDFExtensions.h
//  MEKit
//
//  Created by William Towe on 10/2/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MEPDFExtensionsContentMode) {
    MEPDFExtensionsContentModeAspectFit,
    MEPDFExtensionsContentModeAspectFill,
};

typedef NS_OPTIONS(NSInteger, MEPDFExtensionsCacheOptions) {
    MEPDFExtensionsCacheOptionsNone = 0,
    MEPDFExtensionsCacheOptionsFile = 1 << 0,
    MEPDFExtensionsCacheOptionsMemory = 1 << 1,
    MEPDFExtensionsCacheOptionsAll = MEPDFExtensionsCacheOptionsFile | MEPDFExtensionsCacheOptionsMemory,
    MEPDFExtensionsCacheOptionsDefault = MEPDFExtensionsCacheOptionsAll
};

@interface UIImage (MEPDFExtensions)

+ (MEPDFExtensionsContentMode)ME_defaultPDFExtensionsContentMode;
+ (void)setME_defaultPDFExtensionsContentMode:(MEPDFExtensionsContentMode)contentMode;

+ (MEPDFExtensionsCacheOptions)ME_defaultPDFExtensionsCacheOptions;
+ (void)setME_defaultPDFExtensionsCacheOptions:(MEPDFExtensionsCacheOptions)cacheOptions;

+ (UIImage *)ME_imageWithPDFNamed:(NSString *)pdfName size:(CGSize)size;
+ (UIImage *)ME_imageWithPDFNamed:(NSString *)pdfName size:(CGSize)size contentMode:(MEPDFExtensionsContentMode)contentMode;
+ (UIImage *)ME_imageWithPDFNamed:(NSString *)pdfName inBundle:(NSBundle *)bundle size:(CGSize)size contentMode:(MEPDFExtensionsContentMode)contentMode;

@end
