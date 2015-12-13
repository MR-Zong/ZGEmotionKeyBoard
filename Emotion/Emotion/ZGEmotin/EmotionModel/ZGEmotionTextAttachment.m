//
//  ZGEmotionTextAttachment.m
//  Emotion
//
//  Created by 徐宗根 on 15/12/13.
//  Copyright © 2015年 Zong. All rights reserved.
//

#import "ZGEmotionTextAttachment.h"
#import "ZGEmotion.h"

@implementation ZGEmotionTextAttachment

+ (instancetype)emotionTextAttachment:(ZGEmotion *)emotion font:(UIFont *)font
{
    
    // 根据图片表情，创建一个attributeString
    ZGEmotionTextAttachment *attach = [[ZGEmotionTextAttachment alloc] init];
    // 给自定义的attachment赋值。
    attach.chs = emotion.chs;
    attach.image = [UIImage imageWithContentsOfFile:emotion.imgPath];
    CGFloat lineHeight = font.lineHeight;
    // 特别注意小细节，y=-4 width height 减5是为了让图片表情跟emoji一样大小
//    attach.bounds = CGRectMake(0, -4, lineHeight - 5, lineHeight -5);
    attach.bounds = CGRectMake(0, -4, lineHeight, lineHeight);
    return attach;
    
}


@end
