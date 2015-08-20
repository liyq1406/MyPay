//
//  Util.h
//  VojoUtil
//
//  Created by hunkzeng on 14-3-20.
//  Copyright (c) 2014年 hunkzeng. All rights reserved.
//
#import  <Foundation/Foundation.h>
#import  <UIKit/UIKit.h>
@interface JBIGUtil : NSObject;
+(NSData*)JBIGCompress:(UIImage *)image;
+(NSData*)JBIGCompressVerticalReverse:(UIImage *)image;
+(NSData*)JBIGCompressColorReverse:(UIImage *)image;
+(UIImage*)JBIGDecompress:(NSData*)jbgData;
+(UIImage*)JBIGDecompressColorReverse:(NSData*)jbgData;
+(NSData*)JBIGDecompressAsBMPFormat:(NSData*)jbgData;
+(NSData*)JBIGDecompressColorReverseAsBMPFormat:(NSData*)jbgData;
+(NSData*)saveAsBMPFormat:(UIImage*)image;
+(NSData *)createBMPHeader:(UIImage*)image;
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
