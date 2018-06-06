//
//  UIGestureRecognizer+X.m
//  TestCategoryDemo
//
//  Created by canoe on 2018/5/23.
//  Copyright © 2018年 canoe. All rights reserved.
//


#import "UIGestureRecognizer+X.h"
#import <objc/runtime.h>

static const void *KGestureRecognizerBlockKey = &KGestureRecognizerBlockKey;
static const void *KGestureRecognizerDelayKey = &KGestureRecognizerDelayKey;
static const void *KGestureRecognizerShouldHandleActionKey = &KGestureRecognizerShouldHandleActionKey;

@interface UIGestureRecognizer (XInternal)

@property (nonatomic, setter = x_setShouldHandleAction:) BOOL x_shouldHandleAction;

- (void)x_handleAction:(UIGestureRecognizer *)recognizer;

@end

@implementation UIGestureRecognizer (X)

+ (instancetype)recognizerWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block delay:(NSTimeInterval)delay
{
    return [[[self class] alloc] initWithHandler:block delay:delay];
}

- (instancetype)initWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block delay:(NSTimeInterval)delay
{
    {
        self = [self initWithTarget:self action:@selector(x_handleAction:)];
        if (!self) return nil;
        
        self.x_handler = block;
        self.x_handlerDelay = delay;
        
        return self;
    }
}

+ (instancetype)recognizerWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block
{
    return [self recognizerWithHandler:block delay:0.0];
}

- (instancetype)initWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block
{
    return (self = [self initWithHandler:block delay:0.0]);
}



- (void)x_handleAction:(UIGestureRecognizer *)recognizer
{
    void (^handler)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) = recognizer.x_handler;
    if (!handler) return;
    
    NSTimeInterval delay = self.x_handlerDelay;
    CGPoint location = [self locationInView:self.view];
    void (^block)(void) = ^{
        if (!self.x_shouldHandleAction) return;
        handler(self, self.state, location);
    };
    
    self.x_shouldHandleAction = YES;
    
    if (!delay) {
        block();
        return;
    }
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

//可以调用这个方法取消调用手势block，需要设置延迟才能生效
- (void)x_cancel
{
    self.x_shouldHandleAction = NO;
}

- (void)x_setHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))handler
{
    objc_setAssociatedObject(self, KGestureRecognizerBlockKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))x_handler
{
    return objc_getAssociatedObject(self, KGestureRecognizerBlockKey);
}

- (void)x_setHandlerDelay:(NSTimeInterval)delay
{
    NSNumber *delayValue = delay ? @(delay) : nil;
    objc_setAssociatedObject(self, KGestureRecognizerDelayKey, delayValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)x_handlerDelay
{
    return [objc_getAssociatedObject(self, KGestureRecognizerDelayKey) doubleValue];
}

- (void)x_setShouldHandleAction:(BOOL)flag
{
    objc_setAssociatedObject(self, KGestureRecognizerShouldHandleActionKey, @(flag), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)x_shouldHandleAction
{
    return [objc_getAssociatedObject(self, KGestureRecognizerShouldHandleActionKey) boolValue];
}


@end
