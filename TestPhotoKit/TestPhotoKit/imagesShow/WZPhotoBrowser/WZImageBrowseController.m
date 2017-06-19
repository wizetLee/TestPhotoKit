//
//  WZImageBrowseController.m
//  WZPhotoPicker
//
//  Created by admin on 17/6/9.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import "WZImageBrowseController.h"

#pragma mark WZImageBrowseController
@interface WZImageBrowseController ()<
UIPageViewControllerDataSource,
UIPageViewControllerDelegate,
UIViewControllerTransitioningDelegate,
WZProtocol_ImageScrollView
>

@end

@implementation WZImageBrowseController

#pragma Initialize
- (instancetype)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary<NSString *,id> *)options {
    NSMutableDictionary *configOptions = [NSMutableDictionary dictionaryWithDictionary:options?:@{}];
    //页面间隔设置
    configOptions[UIPageViewControllerOptionInterPageSpacingKey] = @(10);
    if (self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:navigationOrientation options:configOptions]) {
        //自定义模态跳转模式
        //        self.modalPresentationStyle = UIModalPresentationCustom;
        //模态过渡模式
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        /*
         UIModalTransitionStyleCoverVertical：画面从下向上徐徐弹出，关闭时向下隐 藏（默认方式）。
         UIModalTransitionStyleFlipHorizontal：从前一个画面的后方，以水平旋转的方式显示后一画面。
         UIModalTransitionStyleCrossDissolve：前一画面逐渐消失的同时，后一画面逐渐显示。
         */
        //自定义跳转代理
        //        self.transitioningDelegate = self;
        _integer_currentIndex = 0;
        //        _numberOfIndexs = 9;
        ////        _datas
        //        NSMutableArray *array = [NSMutableArray array];
        //        for (int i = 0; i< 10; i++) {
        //            WZMediaAsset *asset = [[WZMediaAsset alloc] init];
        //            asset.name = [NSString stringWithFormat:@"我是%d号",i];
        //            [array addObject:asset];
        //        }
        //        _datas = [NSArray arrayWithArray:array];
    }
    return self;
}

#pragma mark Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.dataSource = self;
    self.delegate = self;
    [self createViews];
}

- (void)createViews {
}

#pragma mark WZProtocol_imageBrowseNavigationView
- (void)leftButtunAction {
    [self dismissViewControllerAnimated:true completion:^{}];
}
- (void)rightButtunAction {
}

#pragma mark Match VC use index
- (WZImageContainerController *)matchControllerIndexWithIndex:(NSInteger)index {
    
    if (index < 0
        || index > _interger_numberOfIndexs) {
        return nil;
    }
    
    WZImageContainerController *VC = self.array_reuseable_imageContainers[index % self.array_reuseable_imageContainers.count];
    VC.integer_index = index;
    [self matchThumnailImageWith:VC];
    return VC;
}

#pragma mark Show VC in index
- (void)showInIndex:(NSInteger)index withAnimated:(BOOL)animated {
    
    if (index <= 0) {index = 0;}
    if (index > _interger_numberOfIndexs) {index = _interger_numberOfIndexs;}
    _integer_currentIndex  = index;
    
    WZImageContainerController *VC = [self matchControllerIndexWithIndex:_integer_currentIndex];
    [self matchClearImageWith:VC];
    [self setViewControllers:@[VC] direction:UIPageViewControllerNavigationDirectionForward animated:animated completion:^(BOOL finished) {}];
    self.VC_currentContainer = VC;
}


#pragma mark Match image
- (void)matchThumnailImageWith:(WZImageContainerController *)VC {
    if (!VC) {
        return;
    }
    NSUInteger index = VC.integer_index;
    if (index >= _array_mediaAsset.count) {
        return;
    }
}

- (void)matchClearImageWith:(WZImageContainerController *)VC {
    if (!VC) {
        return;
    }
    NSUInteger index = VC.integer_index;
    if (index >= _array_mediaAsset.count) {
        return;
    }
}

#pragma mark WZProtocol_ImageScrollView
- (void)singleTap:(UIGestureRecognizer *)gesture {
    //单击
}

- (void)doubleTap:(UIGestureRecognizer *)gesture  {
    //变焦动画
    [self.VC_currentContainer focusingWithGesture:gesture];
}

- (void)longPress:(UIGestureRecognizer *)gesture {
    //保存图片
    
}

#pragma mark WZProtocol_ImageContainer

#pragma mark UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    WZImageContainerController *VC = pageViewController.viewControllers.firstObject;
    if (self.VC_currentContainer != VC) {
        [self matchClearImageWith:VC];
    }
}

#pragma mark UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(WZImageContainerController *)viewController {
    return [self matchControllerIndexWithIndex:viewController.integer_index - 1];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(WZImageContainerController *)viewController {
    return [self matchControllerIndexWithIndex:viewController.integer_index + 1];
}

#pragma mark UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return nil;
}

#pragma mark Accessor
- (NSArray <WZImageContainerController *>*)array_reuseable_imageContainers {
    if (!_array_reuseable_imageContainers) {
        NSMutableArray *tmpMArr = [NSMutableArray array];
        NSUInteger reuseCount = 5;
        for (NSUInteger i = 0; i < reuseCount; i++) {
            WZImageContainerController *VC = [[WZImageContainerController alloc] init];
            VC.integer_index = i;
            VC.delegate = (id<WZProtocol_ImageContainer>)self;
            VC.VC_main = self;
            [tmpMArr addObject:VC];
        }
        _array_reuseable_imageContainers = [NSArray arrayWithArray:tmpMArr];
    }
    return _array_reuseable_imageContainers;
}

- (void)setArray_mediaAsset:(NSArray<WZMediaAsset *> *)array_mediaAsset {
    if ([array_mediaAsset isKindOfClass:[NSArray class]]) {
        _array_mediaAsset = array_mediaAsset;
        _interger_numberOfIndexs = _array_mediaAsset.count - 1;
        if (_interger_numberOfIndexs < 0) {
            _interger_numberOfIndexs = 0;
        }
    }
}

@end
