//
//  ZGEmotionPackage.m
//  Emotion
//
//  Created by 徐宗根 on 15/12/12.
//  Copyright © 2015年 Zong. All rights reserved.
//

#import "ZGEmotionPackage.h"
#import "ZGEmotion.h"

#define EMOTIONS_LIST @"emoticons.plist"
#define EMOTIONBUNDLE @"Emoticons.bundle"
#define INFO_PLIST @"info.plist"

static int const emotionCountInOnePage = 21;

@implementation ZGEmotionPackage

+ (NSArray *)loadEmotionPackage
{
    NSString *filePath =[[NSBundle mainBundle] pathForResource:EMOTIONS_LIST ofType:nil inDirectory:EMOTIONBUNDLE];
    
    NSDictionary *rootAry = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    NSArray *packages = rootAry[@"packages"];
    
    NSMutableArray *mary = [NSMutableArray array];
    // 资源包里面是没有最近表情的 所以手动加个空的
    ZGEmotionPackage *lastEmotionPackage = [[ZGEmotionPackage alloc] init];
    [mary addObject:lastEmotionPackage];
    [lastEmotionPackage addEmptyEmotions];
    
    for (NSDictionary *dict in packages) {
        ZGEmotionPackage *package = [[ZGEmotionPackage alloc] init];
        package.ID = dict[@"id"];
        
        [package loadEmoticons];
        
        [package addEmptyEmotions];
        [mary addObject:package];
    }
    
    return mary.copy;
    
}



- (void)loadEmoticons
{
    NSString *emotionDiretoryPath = [[[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:EMOTIONBUNDLE] stringByAppendingPathComponent:self.ID];
    
    NSString *infoListFilePath = [emotionDiretoryPath stringByAppendingPathComponent:INFO_PLIST];
    
    NSDictionary *rootDict = [NSDictionary dictionaryWithContentsOfFile:infoListFilePath];
    
    self.group_name_cn = rootDict[@"group_name_cn"];
    
    NSArray *emotions = rootDict[@"emoticons"];
    NSMutableArray *mary = [NSMutableArray array];
    int index =0;
    for (NSDictionary *dict in emotions) {
        
        ZGEmotion *emotion =[ZGEmotion emotionWithDict:dict id:self.ID];
        [mary addObject:emotion];
        index++;
        if (index == 20) {
            [mary addObject:[ZGEmotion emotionRemoveButton]];
            index =0;
        }
        
    }
    
    self.emotions = mary;
    
    
}

- (void)addEmptyEmotions
{
    // 最后一页已经占了多少个表情
    int alreadyHaveCount = self.emotions.count % emotionCountInOnePage;
    // 特别注意必须判断alreadyHaveCount ！= 0 因为等于零，还没到最后那要补空白cell一页
    if (alreadyHaveCount) {
        for (int i=alreadyHaveCount; i<emotionCountInOnePage - 1; i++) {
            
            [self.emotions addObject:[[ZGEmotion alloc] init]];
        }
        [self.emotions addObject:[ZGEmotion emotionRemoveButton]];
    }
}

@end
