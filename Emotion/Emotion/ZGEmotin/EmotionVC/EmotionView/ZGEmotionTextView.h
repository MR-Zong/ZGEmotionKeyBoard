//
//  ZGEmotionTextView.h
//  Emotion
//
//  Created by 徐宗根 on 15/12/13.
//  Copyright © 2015年 Zong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZGEmotion;
@interface ZGEmotionTextView : UITextView

- (NSString *)textFromAttributeText;
- (void)insertEmotion:(ZGEmotion *)emotion;


@end
