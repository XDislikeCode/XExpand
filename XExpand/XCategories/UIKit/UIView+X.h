//
//  UIView+X.h
//  CommonConfigDemo
//
//  Created by canoe on 2017/12/4.
//  Copyright © 2017年 canoe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


#pragma mark - 实用方法
@interface UIView (X)

/** View截图 */
- (nullable UIImage *)snapshotImage;

/** 移除所有子视图 */
- (void)removeAllSubviews;

/** 返回View的ViewController，有可能是nil */
@property (nullable, nonatomic, readonly) UIViewController *viewController;


/** 切圆角 */
-(void)cornerRadius: (CGFloat)radius
         borderWidth: (CGFloat)width
              color: (UIColor *_Nullable)color;


/** 设置阴影 */
-(void)shadowWithColor: (UIColor *_Nullable)color
                offset: (CGSize)offset
               opacity: (CGFloat)opacity
                radius: (CGFloat)radius;

@end





#pragma mark - 代码简写
@interface UIView (XFrame)

@property (nonatomic) CGFloat left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  size;        ///< Shortcut for frame.size.

@end




#pragma mark - 添加手势
typedef void (^GestureActionBlock)(UIGestureRecognizer * _Nullable gestureRecoginzer);
@interface UIView (XGesture)

/**
 *  @brief  添加tap手势
 *
 *  @param block 代码块
 */
- (void)addTapActionWithBlock:(GestureActionBlock _Nullable )block;
/**
 *  @brief  添加长按手势
 *
 *  @param block 代码块
 */
- (void)addLongPressActionWithBlock:(GestureActionBlock _Nullable )block;
@end





#pragma mark - 抖动动画
typedef NS_ENUM(NSInteger, ShakeDirection) {
    ShakeDirectionHorizontal = 0,
    ShakeDirectionVertical
};
@interface UIView (XShake)
/**
 默认抖动动画
 */
- (void)shake;

/**
 @param times 次数
 @param delta 幅度
 */
- (void)shake:(int)times withDelta:(CGFloat)delta;

/**
 @param times 次数
 @param delta 幅度
 @param handler 回调
 */
- (void)shake:(int)times withDelta:(CGFloat)delta completion:(void((^_Nullable)(void)))handler;

/**
 @param times 次数
 @param delta 幅度
 @param interval 速度
 */
- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval;

/**
 @param times 次数
 @param delta 幅度
 @param interval 速度
 @param handler 回调
 */
- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval completion:(void((^_Nullable)(void)))handler;

/**
 @param times 次数
 @param delta 幅度
 @param interval 速度
 @param shakeDirection 方向  竖直和横向
 */
- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ShakeDirection)shakeDirection;

/**
 @param times 次数
 @param delta 幅度
 @param interval 速度
 @param shakeDirection 方向  竖直和横向
 @param completion 回调
 */
- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ShakeDirection)shakeDirection completion:(void(^_Nullable)(void))completion;

@end



#pragma mark - 添加边框
typedef NS_ENUM(NSInteger, UIViewBorderLineType) {
    UIViewBorderLineTypeTop,
    UIViewBorderLineTypeRight,
    UIViewBorderLineTypeBottom,
    UIViewBorderLineTypeLeft,
};
@interface UIView (XBorderLine)

/**
 单独设置边框

 @param color 边框颜色
 @param border 宽度
 @param borderLineType 边框位置
 @return 边框Layer
 */
-(CALayer *_Nullable)addViewBorderWithcolor:(UIColor *_Nullable)color border:(float)border type:(UIViewBorderLineType)borderLineType;


/**
 单独设置边框
 
 @param color 边框颜色
 @param border 宽度
 @param borderLineType 边框位置
 @param margin 边框的向内间距  如果是View外面则为负数
 @return 边框Layer
 */
-(CALayer *_Nullable)addViewBorderWithcolor:(UIColor *_Nullable)color border:(float)border type:(UIViewBorderLineType)borderLineType margin:(CGFloat)margin;

@end