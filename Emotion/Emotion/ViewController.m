//
//  ViewController.m
//  Emotion
//
//  Created by Zong on 15/12/11.
//  Copyright © 2015年 Zong. All rights reserved.
//

#import "ViewController.h"
#import "ZGEditToolBarViewController.h"
#import "ZGEmotionViewController.h"
#import "ZGEmotionPackage.h"
#import "ZGEmotion.h"
#import "ZGEmotionTextAttachment.h"


@interface ViewController ()

@property (nonatomic,weak) UIView *editToolBar;

@property (nonatomic,strong) NSLayoutConstraint *editToolBarBottomConstraint;

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,weak) UILabel *label;




@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setUpContentView];

    [self setUpEditToolBar];
    
    
    [self Test];
    
}

- (void)Test
{
    UILabel *label = [[UILabel alloc] init];
    self.label = label;
    label.frame = CGRectMake(5, 100, [UIScreen mainScreen].bounds.size.width, 400);
    label.text = @"zong";
    label.font = [UIFont systemFontOfSize:40];
    [self.contentView addSubview:label];
    
}

- (void)setUpContentView
{
    self.contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.contentView];
    
    NSDictionary *bindings = NSDictionaryOfVariableBindings(_contentView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[_contentView]-0-|" options:0 metrics:nil views:bindings]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_contentView]-0-|" options:0 metrics:nil views:bindings]];
    
//    self.contentView.frame = [UIApplication sharedApplication].keyWindow.bounds;
}

- (void)setUpEditToolBar
{
    // 传入发送按钮的调用block
    __weak typeof(self) weakSelf = self;
    ZGEditToolBarViewController *editToolBarVC = [ZGEditToolBarViewController editToolBarViewController:^(NSString *text) {
        ViewController *strongSelf = weakSelf;
        strongSelf.label.text = text;
    }];
                                                  
    self.editToolBar = editToolBarVC.view;
    [self addChildViewController:editToolBarVC];
    // 这两句必须记住得做
    editToolBarVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    editToolBarVC.view.backgroundColor = [UIColor lightGrayColor];
    
    // 记得只能添加到父控件才能添加约束
    [self.view addSubview:editToolBarVC.view];
    
//    NSDictionary *bindings = NSDictionaryOfVariableBindings(_editToolBar);
    NSDictionary *bindings = @{
                               @"editToolBar":self.editToolBar
                               };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[editToolBar]-0-|" options:NSLayoutFormatAlignAllLeading metrics:nil views:bindings]];
    [self.editToolBar addConstraint: [NSLayoutConstraint constraintWithItem:self.editToolBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0 constant:34]];
    
    self.editToolBarBottomConstraint = [NSLayoutConstraint constraintWithItem:self.editToolBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.view addConstraint:self.editToolBarBottomConstraint];
    
    // KeyboardFrameChange 监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 点击退键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //[self.view endEditing:YES];
    ZGEmotionViewController *emotionVC = [[ZGEmotionViewController alloc] init];
    
//    NSString *str = @"[哈哈]好男人[笑cry]"; // 测试
    NSString *str = self.label.text;
    NSString *pattern = @"\\[.*?\\]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:nil];
    
    NSArray *resultAry = [regex matchesInString:str options:kNilOptions range:NSMakeRange(0, str.length)];
    
    NSMutableAttributedString *resultEmotionStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSInteger index = resultAry.count;
    while (index > 0) {
        NSTextCheckingResult *result = resultAry[--index];
        NSString *emotionStr = [str substringWithRange:result.range];
//        DLog(@"emtionStr %@",emotionStr);
        ZGEmotion *emotion = [self emotionFindInPackages:emotionStr VC:emotionVC];
        
        ZGEmotionTextAttachment *emotionTextAttachment = [ZGEmotionTextAttachment emotionTextAttachment:emotion font:[UIFont systemFontOfSize:14]];
        
        NSAttributedString *pngStr = [NSAttributedString attributedStringWithAttachment:emotionTextAttachment];
        
        [resultEmotionStr replaceCharactersInRange:result.range withAttributedString:pngStr];
    }
    

    self.label.attributedText = resultEmotionStr;
    
}

- (ZGEmotion *)emotionFindInPackages:(NSString *)emotionStr VC:(ZGEmotionViewController *)emotionVC
{
    ZGEmotion *emotion = nil;
    for (ZGEmotionPackage *package in emotionVC.emotionPackages) {
        
        emotion = [package.emotions filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"chs == %@",emotionStr]].firstObject;
        
        if (emotion) {
//            DLog(@"imgPath %@",emotion.imgPath);
            break;
        }
        
    }
    
    return emotion;
}


#pragma mark - NSNotification for KeyboardFrameChange
- (void)keyboardFrameChange:(NSNotification *)note
{
//    DLog(@"note %@",note);
    
    NSDictionary *userInfo = [note valueForKey:@"userInfo"];
    self.editToolBarBottomConstraint.constant = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y - [UIScreen mainScreen].bounds.size.height;
    
//    [UIView animateWithDuration:[[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
//        [self.view layoutIfNeeded];
//    }];
    
//    [UIView animateKeyframesWithDuration:[[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
//         [self.view layoutIfNeeded];
//    } completion:nil];
    
    [UIView animateWithDuration:[[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
         [self.view layoutIfNeeded];
        
    } completion:nil];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
