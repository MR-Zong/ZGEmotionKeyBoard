//
//  ZGEmotion.h
//  Emotion
//
//  Created by 徐宗根 on 15/12/12.
//  Copyright © 2015年 Zong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZGEmotion : NSObject

/// 表情所属的文件夹名称
@property (nonatomic,copy) NSString *ID;

/// 表情名称
@property (nonatomic,copy) NSString *chs;
/// 表情对应的图片
@property (nonatomic,copy) NSString *png;

/// 表情图片的绝对路径
@property (nonatomic,copy) NSString *imgPath;

/// emoji表情的字符串
@property (nonatomic,copy) NSString *code;

/// 表情类型（图片还是emoji）
@property (nonatomic,copy) NSString *type;

// 是否是删除按钮
@property (nonatomic,assign) BOOL isRemoveButton;

// 表情被使用次数
@property (nonatomic,assign) NSInteger userCount;

+ (instancetype)emotionWithDict:(NSDictionary *)dict id:(NSString *)id;
+ (instancetype)emotionRemoveButton;

@end
