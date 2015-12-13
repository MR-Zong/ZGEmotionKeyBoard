//
//  ZGEmotionViewController.h
//  Emotion
//
//  Created by 徐宗根 on 15/12/12.
//  Copyright © 2015年 Zong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZGEmotion;
typedef void (^InsertEmotion)(ZGEmotion *emotion);

@interface ZGEmotionViewController : UIViewController

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,copy) NSArray *emotionPackages;


+ (instancetype)emotionViewController:(InsertEmotion )insertEmotion;

@end
