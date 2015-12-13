//
//  ZGEmotionTextAttachment.h
//  Emotion
//
//  Created by 徐宗根 on 15/12/13.
//  Copyright © 2015年 Zong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZGEmotion;

@interface ZGEmotionTextAttachment : NSTextAttachment


@property (nonatomic,copy) NSString *chs;

+ (instancetype)emotionTextAttachment:(ZGEmotion *)emotion font:(UIFont *)font;

@end
