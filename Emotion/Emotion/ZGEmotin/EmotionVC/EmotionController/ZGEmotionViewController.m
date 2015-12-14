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
#import "ZGEmotion.h"



static NSString *emotionCellIdentifier = @"emotionCell";

static int const emotionCountInOnePage = 21;


@interface ZGEmotionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>


@property (nonatomic,assign) NSInteger index;

@property (nonatomic,strong) InsertEmotion insertEmotion;


@end

@implementation ZGEmotionViewController
{

    UIPageControl *_pageControl;
    UIToolbar *_toolBar;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 一进来就选择默认表情那一栏
    self.index = 1;
    
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
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    
    // 注册cell
    [_collectionView registerClass:[ZGEmotionCell class] forCellWithReuseIdentifier:emotionCellIdentifier];
    [self.view addSubview:_collectionView];
    
    
    // pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    _pageControl = pageControl;
    _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    _pageControl.numberOfPages = 3;
//    CGRect tmpPageControlFrame = _pageControl.frame;
//    tmpPageControlFrame.size.height = 0;
//    _pageControl.backgroundColor = [UIColor blackColor];
//    _pageControl.frame = tmpPageControlFrame;
    [self.view addSubview:pageControl];

    
    // toolBar
    _toolBar = [[UIToolbar alloc] init];
    _toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    _toolBar.tintColor = [UIColor whiteColor];
    _toolBar.backgroundColor = [UIColor blackColor];
//    CGRect tmpFrame = _toolBar.frame;
//    tmpFrame.size.height = 44;
//    _toolBar.frame = tmpFrame;
    
    [self.view addSubview:_toolBar];

    NSArray *tabTitleList = @[@"最近", @"默认",@"Emoji",@"浪小花"];
    NSMutableArray *mary = [NSMutableArray array];
    
    int i=0;
    for (NSString *title in tabTitleList) {
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(toolBarTabClick:)];
//        barButtonItem setBackgroundImage:[UIImage] forState:<#(UIControlState)#> barMetrics:<#(UIBarMetrics)#>

        barButtonItem.tag = i++;
        
        [mary addObject:barButtonItem];
        
        UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [mary addObject:flexItem];
    }
    
    [mary removeLastObject];
    _toolBar.items = [mary copy];
    
    NSDictionary *bindings = @{
                               @"collectionView" : _collectionView,
                               @"pageControl" : _pageControl,
                               @"toolBar": _toolBar
                               };
    // add VFL
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray: [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[collectionView]-0-|" options:kNilOptions metrics:nil views:bindings]];
    [constraints addObjectsFromArray: [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[pageControl]-0-|" options:kNilOptions metrics:nil views:bindings]];
    [constraints  addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[toolBar]-0-|" options:kNilOptions metrics:nil views:bindings]];
    [constraints  addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collectionView]-0-[pageControl(10)]-[toolBar]-0-|" options:kNilOptions metrics:nil views:bindings]];
    
    [self.view addConstraints:[constraints copy]];

}


#pragma mark - class func
+ (instancetype)emotionViewController:(InsertEmotion)insertEmotion
{
    ZGEmotionViewController *emotionVC = [[ZGEmotionViewController alloc] init];
    emotionVC.insertEmotion = insertEmotion;
    return emotionVC;
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
    _pageControl.currentPage = 0;
    self.index = barButtonItem.tag;
    [_collectionView reloadData];
    [_collectionView setContentOffset:CGPointMake(0, 0)];
    

    
}

#pragma mark - <>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x / _collectionView.bounds.size.width;

}



#pragma mark - <UICollectionViewDataSource,UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    ZGEmotionPackage *package = self.emotionPackages[self.index];
    // 计算分页的页数，这是一个分页算法，记住它吧
    _pageControl.numberOfPages = (package.emotions.count + emotionCountInOnePage)/ emotionCountInOnePage -1;
    return package.emotions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZGEmotionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:emotionCellIdentifier forIndexPath:indexPath];

//    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0f];
    ZGEmotionPackage *package = self.emotionPackages[self.index];
    
    cell.emotion = package.emotions[indexPath.item];
    
    return cell;
}

//
//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
// 永远警示自己，要仔细看代理方法，用错了很难发现bug的！！
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZGEmotionPackage *selectEmotionPackage = self.emotionPackages[self.index];
    ZGEmotion *selectedEmotion = selectEmotionPackage.emotions[indexPath.item];
    
    // 1,添加到最近使用表情
    if (!selectedEmotion.isRemoveButton) {
        
        
        selectedEmotion.userCount ++;
        ZGEmotionPackage *lastEmotionPackage = self.emotionPackages[0];
        
        [lastEmotionPackage.emotions removeLastObject];
        if (![lastEmotionPackage.emotions containsObject:selectedEmotion]) {
            
            [lastEmotionPackage.emotions removeLastObject];
            
            [lastEmotionPackage.emotions addObject:selectedEmotion];
            
            
        }
        
        // 排序有问题，它居然不排序
        NSArray *sortAry = [lastEmotionPackage.emotions sortedArrayUsingComparator:^NSComparisonResult(ZGEmotion *emotion1, ZGEmotion *emotion2) {
            return emotion1.userCount < emotion2.userCount;
        }];
        
        
        lastEmotionPackage.emotions = [NSMutableArray arrayWithArray:sortAry];
        
        [lastEmotionPackage.emotions addObject:[ZGEmotion emotionRemoveButton]];
        
        
    }
    
    
    // 2,调用insertEmotionBlock
    self.insertEmotion ? self.insertEmotion(selectedEmotion) : nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
