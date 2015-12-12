//
//  ZGEmotionFlowLayout.m
//  Emotion
//
//  Created by 徐宗根 on 15/12/12.
//  Copyright © 2015年 Zong. All rights reserved.
//

#import "ZGEmotionFlowLayout.h"

@implementation ZGEmotionFlowLayout

- (void)prepareLayout
{
    CGFloat ItemW = [UIScreen mainScreen].bounds.size.width / 7;
    self.itemSize = CGSizeMake(ItemW, ItemW);
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;
    self.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    
    // 压挤Item之间的行空隙
//    DLog(@"_collectionView.height %f",self.collectionView.frame.size.height);
    // 建议乘以0.49 如果用0.5的话有可能在iphone4/4s上又问题
    CGFloat margin = (self.collectionView.frame.size.height -  ItemW *3) * 0.49;
    self.collectionView.contentInset = UIEdgeInsetsMake(margin, 0, margin, 0);
    
    self.collectionView.bounces = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;

    
}

@end
