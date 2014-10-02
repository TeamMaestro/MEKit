//
//  UIImage+MEPDFExtensions.m
//  MEKit
//
//  Created by William Towe on 10/2/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "UIImage+MEPDFExtensions.h"
#import <MEFoundation/NSString+MEExtensions.h>
#import <MEFoundation/MEDebugging.h>

#import <objc/runtime.h>

@interface UIImage (MEPDFExtensionsPrivate)
+ (NSURL *)_ME_PDFExtensionsCacheDirectoryURL;
+ (UIImage *)_ME_PDFExtensionsImageWithPDFURL:(NSURL *)url size:(CGSize)size scale:(CGFloat)scale contentMode:(MEPDFExtensionsContentMode)contentMode;
@end

@implementation UIImage (MEPDFExtensions)

static void const *kME_defaultPDFExtensionsContentModeKey = &kME_defaultPDFExtensionsContentModeKey;

+ (MEPDFExtensionsContentMode)ME_defaultPDFExtensionsContentMode; {
    return [objc_getAssociatedObject(self, kME_defaultPDFExtensionsContentModeKey) integerValue];
}
+ (void)setME_defaultPDFExtensionsContentMode:(MEPDFExtensionsContentMode)contentMode; {
    objc_setAssociatedObject(self, kME_defaultPDFExtensionsContentModeKey, @(contentMode), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

static void const *kME_defaultPDFExtensionsCacheOptionsKey = &kME_defaultPDFExtensionsCacheOptionsKey;

+ (MEPDFExtensionsCacheOptions)ME_defaultPDFExtensionsCacheOptions; {
    return [objc_getAssociatedObject(self, kME_defaultPDFExtensionsCacheOptionsKey) integerValue];
}
+ (void)setME_defaultPDFExtensionsCacheOptions:(MEPDFExtensionsCacheOptions)cacheOptions; {
    objc_setAssociatedObject(self, kME_defaultPDFExtensionsCacheOptionsKey, @(cacheOptions), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (UIImage *)ME_imageWithPDFNamed:(NSString *)pdfName size:(CGSize)size; {
    return [self ME_imageWithPDFNamed:pdfName inBundle:nil size:size contentMode:[self ME_defaultPDFExtensionsContentMode]];
}
+ (UIImage *)ME_imageWithPDFNamed:(NSString *)pdfName size:(CGSize)size contentMode:(MEPDFExtensionsContentMode)contentMode; {
    return [self ME_imageWithPDFNamed:pdfName inBundle:nil size:size contentMode:contentMode];
}
+ (UIImage *)ME_imageWithPDFNamed:(NSString *)pdfName inBundle:(NSBundle *)bundle size:(CGSize)size contentMode:(MEPDFExtensionsContentMode)contentMode; {
    NSParameterAssert(pdfName);
    NSParameterAssert(!CGSizeEqualToSize(size, CGSizeZero));
    
    static dispatch_queue_t kFileCache;
    static NSCache *kMemoryCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kFileCache = dispatch_queue_create("org.maestro.mekit.pdfextensions.file-cache", DISPATCH_QUEUE_SERIAL);
        
        kMemoryCache = [[NSCache alloc] init];
        
        [kMemoryCache setName:@"org.maestro.mekit.pdfextensions.memory-cache"];
    });
    
    if (pdfName.pathExtension.length == 0)
        pdfName = [pdfName stringByAppendingPathExtension:@"pdf"];
    
    if (!bundle)
        bundle = [NSBundle mainBundle];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@%@%@%@",bundle.bundleURL.absoluteString.ME_MD5String,pdfName,NSStringFromCGSize(size),@(contentMode),@(scale)];
    
    void(^cacheToMemory)(UIImage *image) = ^(UIImage *image){
        NSParameterAssert(image);
        
        [kMemoryCache setObject:image forKey:cacheKey cost:image.size.width * image.size.height];
    };
    
    void(^cacheToFile)(UIImage *image, NSURL *url) = ^(UIImage *image, NSURL *url){
        dispatch_async(kFileCache, ^{
            NSData *data = UIImagePNGRepresentation(image);
            
            NSError *outError;
            if (![data writeToURL:url options:0 error:&outError])
                MELogObject(outError);
        });
    };
    
    MEPDFExtensionsCacheOptions cacheOptions = [self ME_defaultPDFExtensionsCacheOptions];
    UIImage *retval = [kMemoryCache objectForKey:cacheKey];
    
    if (!retval) {
        NSURL *fileCacheURL = [[self _ME_PDFExtensionsCacheDirectoryURL] URLByAppendingPathComponent:cacheKey isDirectory:NO];
        
        if ([fileCacheURL checkResourceIsReachableAndReturnError:NULL]) {
            retval = [UIImage imageWithContentsOfFile:fileCacheURL.path];
            
            if ((cacheOptions & MEPDFExtensionsCacheOptionsMemory) != 0) {
                cacheToMemory(retval);
            }
        }
        
        if (!retval) {
            NSURL *fileURL = [bundle URLForResource:pdfName.stringByDeletingPathExtension withExtension:pdfName.pathExtension];
            
            retval = [self _ME_PDFExtensionsImageWithPDFURL:fileURL size:size scale:scale contentMode:contentMode];
            
            if (retval) {
                if ((cacheOptions & MEPDFExtensionsCacheOptionsFile) != 0) {
                    cacheToFile(retval,fileCacheURL);
                }
                
                if ((cacheOptions & MEPDFExtensionsCacheOptionsMemory) != 0) {
                    cacheToMemory(retval);
                }
            }
        }
    }
    
    return retval;
}

@end

@implementation UIImage (MEPDFExtensionsPrivate)

+ (NSURL *)_ME_PDFExtensionsCacheDirectoryURL; {
    NSURL *directoryURL = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask].lastObject;
    NSURL *retval = [directoryURL URLByAppendingPathComponent:@"org.maestro.mekit.pdfextensions.cache" isDirectory:YES];
    
    if (![retval checkResourceIsReachableAndReturnError:NULL]) {
        NSError *outError;
        if (![[NSFileManager defaultManager] createDirectoryAtURL:retval withIntermediateDirectories:YES attributes:nil error:&outError])
            MELogObject(outError);
    }
    
    return retval;
}

+ (UIImage *)_ME_PDFExtensionsImageWithPDFURL:(NSURL *)url size:(CGSize)size scale:(CGFloat)scale contentMode:(MEPDFExtensionsContentMode)contentMode; {
    NSParameterAssert(url);
    NSParameterAssert(!CGSizeEqualToSize(CGSizeZero, size));
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef contextRef = CGBitmapContextCreate(NULL, size.width * scale, size.height * scale, 8, 0, colorSpaceRef, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
    CGColorSpaceRelease(colorSpaceRef);
    
    CGContextScaleCTM(contextRef, scale, scale);
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    CGContextTranslateCTM(contextRef, 0.0, -size.height);
    
    CGPDFDocumentRef documentRef = CGPDFDocumentCreateWithURL((__bridge CFURLRef)url);
    CGPDFPageRef pageRef = CGPDFDocumentGetPage(documentRef, 1);
    CGRect mediaRect = CGPDFPageGetBoxRect(pageRef, kCGPDFCropBox);
    
    CGContextScaleCTM(contextRef, size.width / CGRectGetWidth(mediaRect), size.height / CGRectGetHeight(mediaRect));
    CGContextTranslateCTM(contextRef, -CGRectGetMinX(mediaRect), -CGRectGetMinY(mediaRect));
    
    CGContextDrawPDFPage(contextRef, pageRef);
    
    CGPDFDocumentRelease(documentRef);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(contextRef);
    
    CGContextRelease(contextRef);
    
    UIImage *retval = [[UIImage alloc] initWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
    
    CGImageRelease(imageRef);
    
    return retval;
}

@end
