//
//  EditView.h
//  XMPP_cheat
//
//  Created by baiqiang on 15/12/19.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditView : UIView

+ (void)showEditViewWithTitle:(NSString *)title text:(NSString *)text UsingBlock:(void (^)(NSString *text))successBlock;

@end
