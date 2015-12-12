//
//  ZGEmotionCell.h
//  Emotion
//
//  Created by 徐宗根 on 15/12/12.
//  Copyright © 2015年 Zong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZGEmotion;

@interface ZGEmotionCell : UICollectionViewCell

@property (nonatomic,strong) UIButton *emotionBtn;

@property (nonatomic,strong) ZGEmotion *emotion;

@end
