//
//  ZGEditToolBarViewController.m
//  Emotion
//
//  Created by 徐宗根 on 15/12/12.
//  Copyright © 2015年 Zong. All rights reserved.
//

#import "ZGEditToolBarViewController.h"
#import "ZGEmotionViewController.h"

 
@interface ZGEditToolBarViewController () 
@end

@implementation ZGEditToolBarViewController
{
    UIButton *_editTypeBtn;
    UIButton *_emotionBtn;
    UIButton *_sendBtn;
    UITextView *_inputTextView;
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
 
    ZGEmotionViewController *emotionVC = [[ZGEmotionViewController alloc] init];
    _emotionVC = emotionVC;
    [self addChildViewController:emotionVC];
    _emotionKeyBoard = emotionVC.view;
    // 设置下拉退键盘
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
    
    
    _inputTextView = [[UITextView alloc] init];
    //_inputTextView.placeholder = @"说点什么吧";
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
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
