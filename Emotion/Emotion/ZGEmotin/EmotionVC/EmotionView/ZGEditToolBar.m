//
//  ZGEditToolBar.m
//  Emotion
//
//  Created by Zong on 15/12/11.
//  Copyright © 2015年 Zong. All rights reserved.
//

#import "ZGEditToolBar.h"
#import "ZGEmotionKeyboardView.h"

 static NSString *emotionCellIdentifier = @"emotionCell";


@interface ZGEditToolBar () <UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation ZGEditToolBar
{
    UIButton *_editTypeBtn;
    UIButton *_emotionBtn;
    UIButton *_sendBtn;
    UITextField *_inputTextField;
    ZGEmotionKeyboardView *_emotionKeyBoard;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // ZGEmotionKeyboardView UICollectionView
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _emotionKeyBoard = [[ZGEmotionKeyboardView alloc] initWithFrame:CGRectMake(0, 0, 20, 200) collectionViewLayout:flowLayout];
        _emotionKeyBoard.delegate = self;
        _emotionKeyBoard.dataSource = self;
        [_emotionKeyBoard registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:emotionCellIdentifier];
        
        _editTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editTypeBtn setTitle:@"语音" forState:UIControlStateNormal];
        _editTypeBtn.translatesAutoresizingMaskIntoConstraints = NO;
        
        [_editTypeBtn addTarget:self action:@selector(editTypeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_editTypeBtn];
        
        
        _emotionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emotionBtn setTitle:@"表情" forState:UIControlStateNormal];
        _emotionBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_emotionBtn addTarget:self action:@selector(emotionBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_emotionBtn];
        
        
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.placeholder = @"说点什么吧";
        _inputTextField.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_inputTextField];
        
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sendBtn];
        
        // 参数\数值
        NSDictionary *mertrics = @{
                                   @"margin" : @10,
                                   @"smallMargin" : @5
                                   };
        
        NSDictionary *bindings = NSDictionaryOfVariableBindings(_editTypeBtn,_inputTextField,_emotionBtn,_sendBtn);
        
       [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[_editTypeBtn(40)]-margin-[_inputTextField]-margin-[_emotionBtn(40)]-margin-[_sendBtn(40)]-margin-|" options:0 metrics:mertrics views:bindings]];
        
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-smallMargin-[_editTypeBtn]-smallMargin-|" options:NSLayoutFormatAlignAllLeading metrics:mertrics views:bindings]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-smallMargin-[_inputTextField]-smallMargin-|" options:NSLayoutFormatAlignAllLeading metrics:mertrics views:bindings]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-smallMargin-[_emotionBtn]-smallMargin-|" options:NSLayoutFormatAlignAllLeading metrics:mertrics views:bindings]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-smallMargin-[_sendBtn]-smallMargin-|" options:NSLayoutFormatAlignAllLeading metrics:mertrics views:bindings]];
        
        
    }
    return self;
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
        _inputTextField.inputView = _emotionKeyBoard;
    }else {
        _inputTextField.inputView = nil;
    }
    
    [_inputTextField resignFirstResponder];
    
    dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 0.25*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        
        [_inputTextField becomeFirstResponder];
    });
}

- (void)sendBtnClick
{
    DLog(@"sendBtnClick");
}


#pragma mark - <UICollectionViewDataSource,UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 21;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:emotionCellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0f];
    
    return cell;
}



@end
