//
//  BQScreenAdaptation.h
//  runtimeDemo
//
//  Created by baiqiang on 15/12/2.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#ifndef BQScreenAdaptation_h
#define BQScreenAdaptation_h

#import <UIKit/UIKit.h>
#import "BQDefine.h"

static inline CGFloat BQAdaptationWidth() {
    return SCREEN_WIDTH / IPHONE6_WIDTH;
}
static inline CGFloat BQAdaptationHeight() {
    return SCREEN_HEIGHT / IPHONE6_HEIGHT;
}
static inline CGSize BQadaptationSize(CGSize size) {
    if (size.width == size.height) {
        size.height *= BQAdaptationWidth();
    }else {
        size.height *= BQAdaptationHeight();
    }
    size.width *= BQAdaptationWidth();
    return size;
}
static inline CGPoint BQadaptationCenter(CGPoint point) {
    point.x *= BQAdaptationWidth();
    point.y *= BQAdaptationHeight();
    return point;
}
static inline CGRect BQAdaptationFrame(CGFloat x,CGFloat y, CGFloat width,CGFloat height)  {
    x *= BQAdaptationWidth();
    y *= BQAdaptationHeight();
    if (width == height) {
        height *= BQAdaptationWidth();
    }else {
        height *= BQAdaptationHeight();
    }
    width *= BQAdaptationWidth();
    CGRect rect = CGRectMake(x, y, width, height);
    return rect;
}
#endif /* BQScreenAdaptation_h */
