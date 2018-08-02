//
//  XGIFMakeTool.m
//  LEVE
//
//  Created by canoe on 2017/12/11.
//  Copyright © 2017年 dashuju. All rights reserved.
//

#import "XGIFMakeTool.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation XGIFMakeTool

+(NSArray *)deCompositionGifData:(NSData *)data
{
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    //    gif分解成为一帧一帧的图片
    size_t count = CGImageSourceGetCount(source);
    NSLog(@"count: %ld",count);
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    //    获取每一帧图片
    for (size_t i = 0; i < count; i++){
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
        //        将单帧数据转化为UIImage
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        //        将图片添加进数组中
        [tempArray addObject:image];
        //        释放掉缓存
        CGImageRelease(imageRef);
    }
    //    释放掉图片资源
    CFRelease(source);
    return  [tempArray copy];
}

+(NSString *)gifUrlWithImageArray:(NSArray<UIImage *> *)imageArray
{
    //    创建GIF文件
    NSArray *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentStr = [document objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *textDic = [documentStr stringByAppendingString:@"/gif"];
    [fileManager createDirectoryAtPath:textDic withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *path = [textDic stringByAppendingString:@"/mine.gif"];
    NSLog(@"path = %@",path);
    //    配置GIF属性
    CGImageDestinationRef destion;
    CFURLRef url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)path, kCFURLPOSIXPathStyle, false);
    destion = CGImageDestinationCreateWithURL(url, kUTTypeGIF, imageArray.count, NULL);
    NSDictionary *frameDic = [NSDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0.3],kCGImagePropertyGIFDelayTime, nil] forKey:(NSString *)kCGImagePropertyGIFDelayTime];
    NSMutableDictionary *gifDic = [NSMutableDictionary dictionaryWithCapacity:2];
    [gifDic setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCGImagePropertyGIFHasGlobalColorMap];
    [gifDic setObject:(NSString *)kCGImagePropertyColorModelRGB forKey:(NSString *)kCGImagePropertyColorModel];
    [gifDic setObject:[NSNumber numberWithUnsignedInt:8] forKey:(NSString *)kCGImagePropertyDepth];
    [gifDic setObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount];
    
    NSDictionary *gifProperty = [NSDictionary dictionaryWithObject:gifDic forKey:(NSString *)kCGImagePropertyGIFDictionary];
    
    //    单帧图片天际进Gif
    for (UIImage *image in imageArray) {
        CGImageDestinationAddImage(destion, image.CGImage,(__bridge CFDictionaryRef)frameDic);
    }
    
    CGImageDestinationSetProperties(destion, (__bridge CFDictionaryRef)gifProperty);
    
    CGImageDestinationFinalize(destion);
    
    CFRelease(destion);
    
    return path;
}

@end
