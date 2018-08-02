//
//  XGIFMakeTool.h
//  LEVE
//
//  Created by canoe on 2017/12/11.
//  Copyright © 2017年 dashuju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XGIFMakeTool : NSObject

/**
 gif分解成多张图片

 @param data gifData
 @return 多张图片数组
 */
+(NSArray *)deCompositionGifData:(NSData *)data;

/**
 多张图片生成gif

 @param imageArray 图片数组
 @return gif地址
 */
+ (NSString *)gifUrlWithImageArray:(NSArray<UIImage *> *)imageArray;

@end
