//
//  NSObject+X.h
//  CommonConfigDemo
//
//  Created by canoe on 2017/12/8.
//  Copyright © 2017年 canoe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (X)
/*!
 *  替换两个方法
 *
 *   className
 *   originalSelector 原始方法
 *   swizzledSelector 替换的方法
 */
+ (void)aop_originalSelector:(SEL)originalSelector
            swizzledSelector:(SEL)swizzledSelector;

@end
