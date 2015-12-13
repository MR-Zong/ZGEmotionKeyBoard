//
//  ZGEditToolBarViewController.m
//  Emotion
//
//  Created by 徐宗根 on 15/12/12.
//  Copyright © 2015年 Zong. All rights reserved.
//

#import "ZGEditToolBarViewController.h"
#import "ZGEmotionViewController.h"
#import "ZGEmotion.h"
#import "ZGEmotionTextAttachment.h"
#import "ZGEmotionTextView.h"

typedef void (^InsertEmotion)(ZGEmotion *emotion);
 
@interface ZGEditToolBarViewController ()

@property (nonatomic,strong) SendBlock sendBlock;

@end

@implementation ZGEditToolBarViewController
{
    UIButton *_editTypeBtn;
    UIButton *_emotionBtn;
    UIButton *_sendBtn;
    ZGEmotionTextView *_inputTextView;
    UIView *_emotionKeyBoard;
    ZGEmotionViewController *_emotionVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpEmotionVC];
    

    [self setUpToolBarView];
    
}


- (void)setUpEmotionVC
{
 
    // 要传入一个block处理collectionView的点击
    __weak ZGEditToolBarViewController * weakSelf = self;
    ZGEmotionViewController *emotionVC = [ZGEmotionViewController emotionViewController:^(ZGEmotion *emotion) {

       
        ZGEditToolBarViewController *strongSelf = weakSelf;
        
        if (emotion.isRemoveButton) {
            DLog(@"isRemoveButton click");
            [strongSelf->_inputTextView deleteBackward];
        }else {
            [strongSelf->_inputTextView insertEmotion:emotion];
        }
        
    }];
                                           
    _emotionVC = emotionVC;
    [self addChildViewController:emotionVC];
    _emotionKeyBoard = emotionVC.view;
    _inputTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
}



- (void)setUpToolBarView
{
    _editTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editTypeBtn setTitle:@"语音" forState:UIControlStateNormal];
    _editTypeBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_editTypeBtn addTarget:self action:@selector(editTypeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_editTypeBtn];
    
    
    _emotionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_emotionBtn setTitle:@"表情" forState:UIControlStateNormal];
    _emotionBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_emotionBtn addTarget:self action:@selector(emotionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_emotionBtn];
    
    
    _inputTextView = [[ZGEmotionTextView alloc] init];
    //_inputTextView.placeholder = @"说点什么吧";
//    _inputTextView.font = [UIFont systemFontOfSize:40];
    _inputTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_inputTextView];
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    _sendBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendBtn];
    
    // 参数\数值
    NSDictionary *mertrics = @{
                               @"margin" : @10,
                               @"smallMargin" : @5
                               };
    
    NSDictionary *bindings = NSDictionaryOfVariableBindings(_editTypeBtn,_inputTextView,_emotionBtn,_sendBtn);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[_editTypeBtn(40)]-margin-[_inputTextView]-margin-[_emotionBtn(40)]-margin-[_sendBtn(40)]-margin-|" options:0 metrics:mertrics views:bindings]];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-smallMargin-[_editTypeBtn]-smallMargin-|" options:NSLayoutFormatAlignAllLeading metrics:mertrics views:bindings]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-smallMargin-[_inputTextView]-smallMargin-|" options:NSLayoutFormatAlignAllLeading metrics:mertrics views:bindings]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-smallMargin-[_emotionBtn]-smallMargin-|" options:NSLayoutFormatAlignAllLeading metrics:mertrics views:bindings]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-smallMargin-[_sendBtn]-smallMargin-|" options:NSLayoutFormatAlignAllLeading metrics:mertrics views:bindings]];
    
    
    
}

#pragma mark - class func
+ (instancetype)editToolBarViewController:(SendBlock)sendBlock
{
    ZGEditToolBarViewController *editVC = [[ZGEditToolBarViewController alloc] init];
    editVC.sendBlock = sendBlock;
    return editVC;
}

#pragma mark - Button Click listen
- (void)editTypeBtnClick
{
    DLog(@"editTypeBtnClick");
}

- (void)emotionBtnClick
{
    //    DLog(@"emotionBtnClick");
    _emotionBtn.selected = !_emotionBtn.selected;
    if (_emotionBtn.selected) {
        
        _inputTextView.inputView = _emotionKeyBoard;
        // 这个要特别注意
        [_emotionVC.collectionView reloadData];
    }else {
        _inputTextView.inputView = nil;
    }
    
    [_inputTextView resignFirstResponder];
    
    dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 0.25*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        
        [_inputTextView becomeFirstResponder];
    });
}

- (void)sendBtnClick
{
    DLog(@"sendBtnClick");
    self.sendBlock ? self.sendBlock([_inputTextView textFromAttributeText]) : nil;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
