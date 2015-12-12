//
//  ZGEmotionPackage.h
//  Emotion
//
//  Created by 徐宗根 on 15/12/12.
//  Copyright © 2015年 Zong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZGEmotionPackage : NSObject

// 当前组文件夹的名称
@property (nonatomic,copy) NSString *ID;
 // 当前组所有的表情模型
@property (nonatomic,strong) NSMutableArray *emotions;
// 当前组名称
@property (nonatomic,copy) NSString *group_name_cn;


+ (NSArray *)loadEmotionPackage;


@end
