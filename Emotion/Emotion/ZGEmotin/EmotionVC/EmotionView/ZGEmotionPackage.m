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

@implementation ZGEmotionPackage

+ (NSArray *)loadEmotionPackage
{
    NSString *filePath =[[NSBundle mainBundle] pathForResource:EMOTIONS_LIST ofType:nil inDirectory:EMOTIONBUNDLE];
    
    NSDictionary *rootAry = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    NSArray *packages = rootAry[@"packages"];
    
    NSMutableArray *mary = [NSMutableArray array];
    for (NSDictionary *dict in packages) {
        ZGEmotionPackage *package = [[ZGEmotionPackage alloc] init];
        package.ID = dict[@"id"];
        
        [package loadEmoticons];
        
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
    for (NSDictionary *dict in emotions) {
        
        ZGEmotion *emotion =[ZGEmotion emotionWithDict:dict id:self.ID];
        [mary addObject:emotion];
        
    }
    
    self.emotions = [mary copy];
    
    
}

@end
