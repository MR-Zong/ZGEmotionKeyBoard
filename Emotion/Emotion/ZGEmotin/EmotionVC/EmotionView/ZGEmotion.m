//
//  ZGEmotion.m
//  Emotion
//
//  Created by 徐宗根 on 15/12/12.
//  Copyright © 2015年 Zong. All rights reserved.
//

#import "ZGEmotion.h"
#define EMOTIONBUNDLE @"Emoticons.bundle"

#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);


@implementation ZGEmotion

+ (instancetype)emotionWithDict:(NSDictionary *)dict id:(NSString *)id
{
    ZGEmotion *emotion = [[ZGEmotion alloc] init];
    emotion.ID = id;
    [emotion setValuesForKeysWithDictionary:dict];
    return emotion;
}

+ (instancetype)emotionRemoveButton
{
    ZGEmotion *emotion = [[ZGEmotion alloc] init];
    emotion.isRemoveButton = YES;
    return emotion;
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setPng:(NSString *)png
{
    // 必须记得可能没值
    if (!png) return;
    
    _png = png;
    
    NSString *emotionDiretoryPath = [[[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:EMOTIONBUNDLE] stringByAppendingPathComponent:self.ID];
    
    _imgPath = [emotionDiretoryPath stringByAppendingPathComponent:_png];

}

- (NSString *)code
{
    if (!_code) {
        return nil;
    }
    NSScanner *scanner = [NSScanner scannerWithString:_code];
    unsigned int uintValue = 0;
    [scanner scanHexInt:&uintValue];
    return [self emojiWithCode:uintValue];
}

// 此方法特别重要
- (NSString *)emojiWithCode:(int)code {
    int sym = EMOJI_CODE_TO_SYMBOL(code);
    return [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
}


@end
