//
//  BQTool.m
//  runtimeDemo
//
//  Created by baiqiang on 15/11/29.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#import "BQArchiver.h"
#import <objc/runtime.h>


@implementation BQArchiver

+ (void)encodeWithObject:(NSObject *)encodeObject withcoder:(NSCoder *)aCoder{
    //获取传入类
    Class cla = [encodeObject class];
    while (cla != [NSObject class]) {
        //判断是否为传入类
        BOOL isSubClass = (cla == [encodeObject class]);
        unsigned int ivarCount = 0;
        unsigned int proCount = 0;
        //获取传入类成员变量列表
        Ivar *ivarArray = isSubClass ? class_copyIvarList(cla, &ivarCount) : NULL;
        //获取传入类父类的属性列表
        objc_property_t *proArray = isSubClass ? NULL : class_copyPropertyList(cla, &proCount);
        //设置数组次数
        unsigned int count = isSubClass ? ivarCount : proCount;
        //循环遍历数组
        for (int i = 0; i < count; i ++) {
            //得到变量名字
            const char *name = isSubClass ? ivar_getName(ivarArray[i]) : property_getName(proArray[i]);
            //char* 转化为 NSString 类型
            NSString *ivarKey = [NSString stringWithUTF8String:name];
            //通过kvc得到值
            id value = [encodeObject valueForKey:ivarKey];
            //归档设置
            [aCoder encodeObject:value forKey:ivarKey];
        }
        //释放数组
        free(ivarArray);
        free(proArray);
        //将类别指向其父类
        cla = class_getSuperclass(cla);
    }
    
}

+ (void)unencodeWithObject:(NSObject *)unarchObject withcoder:(NSCoder *)aDecoder{
    //获取传入类
    Class cla = [unarchObject class];
    while (cla != [NSObject class]) {
        //判断是否为传入类
        BOOL isSubClass = (cla == [unarchObject class]);
        unsigned int ivarCount = 0;
        unsigned int proCount = 0;
        //获取传入类成员变量列表
        Ivar *ivarArray = isSubClass ? class_copyIvarList(cla, &ivarCount) : NULL;
        //获取传入类父类的属性列表
        objc_property_t *proArray = isSubClass ? NULL : class_copyPropertyList(cla, &proCount);
        //设置遍历数组次数
        unsigned int count = isSubClass ? ivarCount : proCount;
        //循环遍历数组
        for (int i = 0; i < count; i ++) {
            //得到变量名字
            const char *name = isSubClass ? ivar_getName(ivarArray[i]) : property_getName(proArray[i]);
            //char* 转化为 NSString 类型
            NSString *ivarKey = [NSString stringWithUTF8String:name];
            //通过kvc得到值
            id value = [aDecoder decodeObjectForKey:ivarKey];
            //解档设置
            [unarchObject setValue:value forKey:ivarKey];
        }
        free(ivarArray);
        free(proArray);
        //将类别指向其父类
        cla = class_getSuperclass(cla);
    }
}
@end
