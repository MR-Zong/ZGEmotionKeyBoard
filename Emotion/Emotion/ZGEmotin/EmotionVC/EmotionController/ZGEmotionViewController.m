//
//  ZGEmotionViewController.m
//  Emotion
//
//  Created by 徐宗根 on 15/12/12.
//  Copyright © 2015年 Zong. All rights reserved.
//

#import "ZGEmotionViewController.h"
#import "ZGEmotionFlowLayout.h"
#import "ZGEmotionCell.h"
#import "ZGEmotionPackage.h"



static NSString *emotionCellIdentifier = @"emotionCell";


@interface ZGEmotionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,copy) NSArray *emotionPackages;

@end

@implementation ZGEmotionViewController
{

    UIPageControl *_pageControl;
    UIToolbar *_toolBar;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeView];
    
    
}

- (void)initializeView
{
    // ZGEmotionKeyboardView UICollectionView
    ZGEmotionFlowLayout *flowLayout = [[ZGEmotionFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    
    // 注册cell
    [_collectionView registerClass:[ZGEmotionCell class] forCellWithReuseIdentifier:emotionCellIdentifier];
    [self.view addSubview:_collectionView];
    
    
    // pageControl
//    UIPageControl *pageControl = [[UIPageControl alloc] init];
//    _pageControl = pageControl;
//    _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
//    _pageControl.numberOfPages = 3;
//    [self.view addSubview:pageControl];
//
    
    // toolBar
    _toolBar = [[UIToolbar alloc] init];
    _toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    _toolBar.tintColor = [UIColor whiteColor];
    _toolBar.backgroundColor = [UIColor blackColor];
    CGRect tmpFrame = _toolBar.frame;
    tmpFrame.size.height = 44;
    _toolBar.frame = tmpFrame;
    
    [self.view addSubview:_toolBar];

    NSArray *tabTitleList = @[@"最近", @"默认",@"Emoji",@"浪小花"];
    NSMutableArray *mary = [NSMutableArray array];
    
    int i=0;
    for (NSString *title in tabTitleList) {
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(toolBarTabClick:)];
        barButtonItem.tag = i++;
        
        [mary addObject:barButtonItem];
        
        UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [mary addObject:flexItem];
    }
    
    [mary removeLastObject];
    _toolBar.items = [mary copy];
    
    NSDictionary *bindings = @{
                               @"collectionView" : _collectionView,
//                               @"pageControl" : _pageControl,
                               @"toolBar": _toolBar
                               };
    // add VFL
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray: [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[collectionView]-0-|" options:kNilOptions metrics:nil views:bindings]];
    [constraints  addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[toolBar]-0-|" options:kNilOptions metrics:nil views:bindings]];
    [constraints  addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collectionView]-0-[toolBar]-0-|" options:kNilOptions metrics:nil views:bindings]];
    
    [self.view addConstraints:[constraints copy]];

}

#pragma mark - lazyLoad
- (NSArray *)emotionPackages
{
    if (!_emotionPackages) {
        _emotionPackages = [ZGEmotionPackage loadEmotionPackage];
    }
    return _emotionPackages;

}

#pragma mark - toolBarTabClick
- (void)toolBarTabClick:(UIBarButtonItem *)barButtonItem
{
    DLog(@"barButtonItem.tag %zd",barButtonItem.tag);
}
#pragma mark - <UICollectionViewDataSource,UICollectionViewDelegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.emotionPackages.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    ZGEmotionPackage *package = self.emotionPackages[section];
    return package.emotions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZGEmotionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:emotionCellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0f];
    
    
    ZGEmotionPackage *package = self.emotionPackages[indexPath.section];
    
    cell.emotion = package.emotions[indexPath.row];
    
    return cell;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
