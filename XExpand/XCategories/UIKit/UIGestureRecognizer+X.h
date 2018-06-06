//
//  UIGestureRecognizer+X.h
//  TestCategoryDemo
//
//  Created by canoe on 2018/5/23.
//  Copyright © 2018年 canoe. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (X)

/**
 一个可以设置延迟并且会自动释放的手势操作

 @param block 手势block
 @param delay 延迟时间
 @return 手势
 */
+ (instancetype)recognizerWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block delay:(NSTimeInterval)delay;

- (instancetype)initWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block delay:(NSTimeInterval)delay NS_REPLACES_RECEIVER;

+ (instancetype)recognizerWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block;

- (instancetype)initWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block NS_REPLACES_RECEIVER;

//可以让手势操作的block在触发之后也可以再次修改
@property (nonatomic, copy, setter = x_setHandler:) void (^x_handler)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location);

//可以修改延迟时间
@property (nonatomic, setter = x_setHandlerDelay:) NSTimeInterval x_handlerDelay;

//可以调用这个方法取消调用手势block，需要设置延迟才能生效
- (void)x_cancel;

@end
