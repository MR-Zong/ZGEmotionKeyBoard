//
//  ZGEmotionCell.m
//  Emotion
//
//  Created by 徐宗根 on 15/12/12.
//  Copyright © 2015年 Zong. All rights reserved.
//

#import "ZGEmotionCell.h"
#import "ZGEmotion.h"

@implementation ZGEmotionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIButton *emotionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.emotionBtn = emotionBtn;
        [self.contentView addSubview:emotionBtn];
        // CGRectInset 返回一个左右，上下有4内边距的CGRect！！
        emotionBtn.frame = CGRectInset(self.contentView.bounds, 4, 4);
        emotionBtn.backgroundColor = [UIColor whiteColor];
        
        // 设置emoji表情的大小,为什么是32呢，是因为其他表情图片是32x32大小的
        emotionBtn.titleLabel.font = [UIFont systemFontOfSize:32];
    }
    
    return self;
}

- (void)setEmotion:(ZGEmotion *)emotion
{
    _emotion = emotion;
    
    if (emotion.png) {
        [self.emotionBtn setTitle:nil forState:UIControlStateNormal];
        UIImage *img = [UIImage imageWithContentsOfFile:emotion.imgPath];
        [self.emotionBtn setImage:img forState:UIControlStateNormal];
    }else {
        [self.emotionBtn setImage:nil forState:UIControlStateNormal];
        DLog(@"emotion.code %@",emotion.code);
        [self.emotionBtn setTitle:emotion.code forState:UIControlStateNormal];
    }
    

    
}

@end
