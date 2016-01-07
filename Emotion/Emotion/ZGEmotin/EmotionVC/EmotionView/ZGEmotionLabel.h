//
//  ZGEmotionLabel.h
//  TestEmotionUILabel
//
//  Created by Zong on 15/12/15.
//  Copyright © 2015年 Zong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZGEmotionLabel : UILabel

/**文字与文字间的距离 default 1.0
 */
@property(nonatomic,assign) CGFloat wordInset;

/** 最小行高度 default 24.0
 */
@property(nonatomic,assign) CGFloat minLineHeight;

- (NSAttributedString*)getAttributedTextFromString:(NSString*) string;

+ (CGSize)getHeightFromAttributedText:(NSAttributedString *)string contraintWidth:(CGFloat)width maxShowNumberOfLines:(int )maxShowNumberOfLines countOfLines:(int *)countOfLines maxShowHeight:(int *)maxShowHeight;

@end
