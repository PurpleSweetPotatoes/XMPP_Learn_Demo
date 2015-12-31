//
//  BQNetWork.h
//  网络请求封装
//
//  Created by baiqiang on 15/12/2.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface BQNetWork : NSObject
+ (void)getSessionWithUrl:(NSString * _Nullable)urlString
                parameter:(NSDictionary * _Nullable)dic
                  Success:(void(^ _Nullable)(NSData * _Nullable data, NSURLResponse * _Nullable response))successblock
                     fail:(void(^ _Nullable)(NSError * _Nullable error))errorBlock;
+ (void)postSessionWithUrl:(NSString * _Nullable)urlString
                 parameter:(NSDictionary * _Nullable)dic
                   Success:(void(^ _Nullable)(NSData * _Nullable data, NSURLResponse * _Nullable response))successblock
                      fail:(void(^ _Nullable)(NSError * _Nullable error))errorBlock;



@end
