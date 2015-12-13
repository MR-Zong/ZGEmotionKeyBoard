//
//  ZGEditToolBarViewController.h
//  Emotion
//
//  Created by 徐宗根 on 15/12/12.
//  Copyright © 2015年 Zong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SendBlock)(NSString *text);
@interface ZGEditToolBarViewController : UIViewController

+ (instancetype)editToolBarViewController:(SendBlock) sendBlock;
@end
