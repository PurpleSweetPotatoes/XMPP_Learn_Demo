//
//  BQTool.h
//  runtimeDemo
//
//  Created by baiqiang on 15/11/29.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BQArchiver : NSObject

/**
 *  归档处理操作
 *
 *  @param encodeObject 需要归档的对象
 *  @param aCoder       归档对象的coder
 */
+ (void)encodeWithObject:(NSObject *)encodeObject withcoder:(NSCoder *)aCoder;

/**
 *  解档处理操作
 *
 *  @param unarchObject 需要解档的对象
 *  @param aDecoder     解档对象的coder
 */
+ (void)unencodeWithObject:(NSObject *)unarchObject withcoder:(NSCoder *)aDecoder;
@end
