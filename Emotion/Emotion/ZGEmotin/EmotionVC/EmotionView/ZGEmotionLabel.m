//
//  ZGEmotionLabel.m
//  TestEmotionUILabel
//
//  Created by Zong on 15/12/15.
//  Copyright © 2015年 Zong. All rights reserved.
//

#import "ZGEmotionLabel.h"
#import "EmojiBoardView.h"
#import <CoreText/CoreText.h>


static NSString *const facePrefix = @"[/";
static NSString *const faceSuffix = @"]";
static NSString *const faceSpace = @" ";
static NSString *const faceImageName = @"imageName";
static NSInteger const emotionImageWidth = 24;

#define _facePadding_ 3.0
#define _textPadding_ 5.0


@implementation ZGEmotionLabel

- (void)drawRect:(CGRect)rect
{
    CGContextRef contxt = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(contxt, CGAffineTransformIdentity);
    
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, self.bounds.size.height);
    CGContextConcatCTM(contxt, flipVertical);
    
    
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"1.设置字形变换矩阵为CGAffineTransformIdentity，也就是说每一个字形都不做图形变换，将当前context的坐标系进行flip，2.为图片设置CTRunDelegate,delegate决定留给图片的空间大小。 3.把图片画上去" ];
    if(self.text == nil || [self.text isEqual:[NSNull null]])
        return;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[self getAttributedTextFromString:self.text]];
    
//    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, [attributedString length])];
    
    
//    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0.0, 10)];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(10, 20)];
    
//    //创建图片位置
//    NSString *taobaoImageName = @"meile.png";
//    CTRunDelegateCallbacks imageCallbacks;
//    imageCallbacks.version = kCTRunDelegateVersion1;
//    imageCallbacks.dealloc = RunDelegateDeallocCallback;
//    imageCallbacks.getAscent = RunDelegateGetAscentCallback;
//    imageCallbacks.getDescent = RunDelegateGetDescentCallback;
//    imageCallbacks.getWidth = RunDelegateGetWidthCallback;
//    
//    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, (__bridge void *)taobaoImageName);
//    NSMutableAttributedString *imageAttributedString =[[NSMutableAttributedString alloc]initWithString:@" "];//创建一个空格，来使attributedString生效
//    [imageAttributedString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:NSMakeRange(0, 1)];//设置回调
//    CFRelease(runDelegate);
//    
//    [imageAttributedString addAttribute:@"imageName" value:taobaoImageName range:NSMakeRange(0, 1)];
//    [attributedString insertAttributedString:imageAttributedString atIndex:30];//把attribute 插入到一个特定的位置
    
    //创建图片位置至此完成那个
    
    
    CTFramesetterRef ctFrameSetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)attributedString);
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect bounds = CGRectMake(0.0, 20.0, self.bounds.size.width, self.bounds.size.height-20);
    CGPathAddRect(path, NULL, bounds);
    
    CTFrameRef ctFrame = CTFramesetterCreateFrame(ctFrameSetter, CFRangeMake(0, 0), path, NULL);
    CTFrameDraw(ctFrame, contxt);
    
    //现在开始画图片
    CFArrayRef lines = CTFrameGetLines(ctFrame);
    CGPoint lineOrigins [CFArrayGetCount(lines)]; //这是一个方法
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    
    for (int i = 0; i < CFArrayGetCount(lines); i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading;
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
        
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        for (int j = 0; j < CFArrayGetCount(runs); j++) {
            CGFloat runAscent;
            CGFloat runDescent;
            CGPoint lineOrigin = lineOrigins[i];
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(run);
            CGRect runRect;
            runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
            
            runRect=CGRectMake(lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL), lineOrigin.y - runDescent, runRect.size.width, runAscent + runDescent);
            
            NSString *imageName = [attributes objectForKey:faceImageName];
            //图片渲染逻辑
            if (imageName)
            {
                UIImage *image = [UIImage imageNamed:imageName];
                if (image)
                {
                    CGRect imageDrawRect;
//                    imageDrawRect.size = image.size;
                    imageDrawRect.size = CGSizeMake(emotionImageWidth, emotionImageWidth);
                    imageDrawRect.origin.x = runRect.origin.x + lineOrigin.x;
                    imageDrawRect.origin.y = lineOrigin.y +lineDescent+10;// 怎么精确计算
                    CGContextDrawImage(contxt, imageDrawRect, image.CGImage);
                }
            }
        }
    }
    
    
    //画图片结束
    
    CFRelease(ctFrame);
    CFRelease(path);
    CFRelease(ctFrameSetter);
}



#pragma mark-CTRunDelegateCallbacks

void RunDelegateDeallocCallback(void* refCon)
{
    
}

CGFloat RunDelegateGetAscentCallback(void* refCon)
{
    //    NSString *imageName = (NSString*)refCon;
    //    UIImage *image = [UIImage imageNamed:imageName];
    //    return image.size.height;
    return 0;
}

CGFloat RunDelegateGetDescentCallback(void* refCon)
{
    return 0;
}

CGFloat RunDelegateGetWidthCallback(void* refCon)
{
//    return [UIImage imageNamed:(__bridge NSString *) refCon].size.width + _facePadding_;
    return emotionImageWidth;
}


#pragma mark-private method

- (NSAttributedString*)getAttributedTextFromString:(NSString*) string
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    
    if(string == nil || [string isEqual:[NSNull null]]) return nil;
 
    
    //获取表情
    [self faceRangeFromStr:string withAttributedText:attributedText];
    
    
    CTFontRef font = CTFontCreateWithName((CFStringRef)self.font.fontName, self.font.pointSize, NULL);
    [attributedText addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)font  range:NSMakeRange(0, attributedText.length)];
    [attributedText addAttribute:(NSString*)kCTKernAttributeName value:[NSNumber numberWithFloat:self.wordInset] range:NSMakeRange(0, attributedText.length)];
    [attributedText addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)self.textColor.CGColor range:NSMakeRange(0, attributedText.length)];
    CFRelease(font);
    
    //  NSLog(@"%@",attributedText.string);

    
    return attributedText;
}



#pragma mark-图片筛选

// 筛选表情
- (void)faceRangeFromStr:(NSString*) str withAttributedText:(NSMutableAttributedString*) attributedText
{
    if(str == nil || [str isEqual:[NSNull null]])
        return;
    
    NSRange prefixRange = [str rangeOfString:facePrefix];
    NSRange suffixRange = [str rangeOfString:faceSuffix];
    
    if(prefixRange.location != NSNotFound && suffixRange.location != NSNotFound && suffixRange.location > prefixRange.location)
    {
        // NSLog(@"表情");
        NSString *forwordStr = [str substringToIndex:prefixRange.location];
        // NSLog(@"forwordStr = %@",forwordStr);
        if(forwordStr.length > 0)
        {
            NSAttributedString *text = [[NSAttributedString alloc] initWithString:forwordStr];
            [attributedText appendAttributedString:text];

        }
        
        // NSLog(@"%@",attributedText.string);
        //获取表情名称
        NSRange faceRange = NSMakeRange(prefixRange.location, suffixRange.location - prefixRange.location + suffixRange.length);
        NSString *faceName = [str substringWithRange:faceRange];
        
        NSLog(@"faceName = %@ ,length = %zd",faceName,faceName.length);
        // 通过faceName 获取表情图片名称
        NSString *imageName = [self getImageNameFromStr:faceName];
        
        //  NSLog(@"imageName = %@",imageName);
        //设定图片绘制代理
        CTRunDelegateCallbacks imageCallBack;
        imageCallBack.version = kCTRunDelegateVersion1;
        imageCallBack.dealloc = RunDelegateDeallocCallback;
        imageCallBack.getAscent = RunDelegateGetAscentCallback;
        imageCallBack.getDescent = RunDelegateGetDescentCallback;
        imageCallBack.getWidth = RunDelegateGetWidthCallback;
        
        CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallBack, (__bridge void * _Nullable)(imageName));
        
        if(runDelegate != NULL)
        {
            //设定图片属性
            NSMutableAttributedString *image = [[NSMutableAttributedString alloc] initWithString:faceSpace];
            [image addAttribute:(NSString*)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:NSMakeRange(0, faceSpace.length)];
            [image addAttribute:faceImageName value:imageName range:NSMakeRange(0, faceSpace.length)];
            
            [attributedText appendAttributedString:image];
            
            CFRelease(runDelegate);
        }
        
        NSString *backStr = [str substringFromIndex:suffixRange.location + suffixRange.length];
        // NSLog(@"%@",attributedText.string);
        if(backStr.length > 0)
        {
            [self faceRangeFromStr:backStr withAttributedText:attributedText];
        }
    }
    else
    {
        // NSLog(@"结束");
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:str];
        [attributedText appendAttributedString:text];

    }
}

// 获取表情图片名称
- (NSString*)getImageNameFromStr:(NSString*) str
{
  return [EmojiBoardView EmojiImageNameFromCoder:str];
}



@end
