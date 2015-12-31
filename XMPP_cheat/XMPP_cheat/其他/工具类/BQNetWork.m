//
//  BQNetWork.m
//  网络请求封装
//
//  Created by baiqiang on 15/12/2.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#import "BQNetWork.h"

@implementation BQNetWork

+ (void)getSessionWithUrl:(NSString *)urlString
                parameter:(NSDictionary *)dic
                  Success:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable))successblock
                     fail:(void (^)(NSError * _Nullable))errorBlock {
    
    NSURLSession *session = [NSURLSession sharedSession];
    //利用dataTask 异步线程中使用get请求
    NSURLSessionDataTask  *dataTask = [session dataTaskWithURL:[BQNetWork addUrlString:urlString parameter:dic] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            successblock(data,response);
        }else {
            errorBlock(error);
        }
    }];
    [dataTask resume];
}
//get请求url编码拼接
+ (NSURL *)addUrlString:(NSString *)urlString parameter:(NSDictionary *)dic {
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@?",urlString];
    [string appendString:[BQNetWork dataWithDictionary:dic]];
    return [NSURL URLWithString:string];
}


+ (void)postSessionWithUrl:(NSString *)urlString parameter:(NSDictionary *)dic Success:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable))successblock fail:(void (^)(NSError * _Nullable))errorBlock {
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPBody = [[self dataWithDictionary:dic] dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    [request setValue:@"123" forHTTPHeaderField:@"key"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            successblock(data,response);
        }else{
            errorBlock(error);
        }
    }];
    [dataTask resume];
}

//将传入字典参数字符拼接
+ (NSString *)dataWithDictionary:(NSDictionary *)dic{
    NSMutableString *string = [NSMutableString string];
    for (NSString *key in dic) {
        [string appendFormat:@"&%@=%@",key,[BQNetWork urlEncodeString:dic[key]]];
    }
    return string;
}
//中文编码成url
+ (NSString *)urlEncodeString:(NSString *)string
{
    NSString *result = [string  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet symbolCharacterSet]];
    return result;
}
@end
