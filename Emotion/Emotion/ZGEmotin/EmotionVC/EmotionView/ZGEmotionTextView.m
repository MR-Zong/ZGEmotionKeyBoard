//
//  ZGEmotionTextView.m
//  Emotion
//
//  Created by 徐宗根 on 15/12/13.
//  Copyright © 2015年 Zong. All rights reserved.
//

#import "ZGEmotionTextView.h"
#import "ZGEmotion.h"
#import "ZGEmotionTextAttachment.h"

@implementation ZGEmotionTextView



- (NSString *)textFromAttributeText
{
    
    __block NSMutableString *resultStr = [NSMutableString string];
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:kNilOptions usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        //        DLog(@"rang %@",NSStringFromRange(range));
        //        DLog(@"%@",attrs);
        
        ZGEmotionTextAttachment *attachment = attrs[@"NSAttachment"];
        if (attachment) {
            //            DLog(@"表情图片");
            [resultStr appendString:attachment.chs];
        }else {
            //            DLog(@"文字");
            [resultStr appendString:[self.attributedText.string substringWithRange:range]];
            
        }
        //        DLog(@"resultStr %@",resultStr);
        
    }];
    return resultStr;
}

- (void)insertEmotion:(ZGEmotion *)emotion
{
    if (emotion.code) {
        [self replaceRange:self.selectedTextRange withText:emotion.code];
    }
    
    if (emotion.png) {
        
        
        ZGEmotionTextAttachment *emotionTextAttachment = [ZGEmotionTextAttachment emotionTextAttachment:emotion font:self.font];
        
        NSAttributedString *pngStr = [NSAttributedString attributedStringWithAttachment:emotionTextAttachment];
        // 获取输入框的attributedText
        NSMutableAttributedString *mAttributStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        // 把图片表情替换进去
        NSRange range =self.selectedRange;
        [mAttributStr replaceCharactersInRange:range withAttributedString:pngStr];
        // 必须设置字体大小，因为插入的表情图片是依照前一个来设置大小的，而attachmentString有默认的大小！
        [mAttributStr addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(range.location ,1)];
        
        // 再把替换后的结果富文本设置回输入框
        self.attributedText = mAttributStr;
        
        // 千万记得把光标设置到插入图片表情的后面
        self.selectedRange = NSMakeRange(range.location + 1, 0);
        
    }
    
}


@end
