//
//  WZImageBrowseController.h
//  WZPhotoPicker
//
//  Created by admin on 17/6/9.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZImageContainerController.h"
#import "UIImageView+WebCache.h"

@protocol WZProtocol_imageBrowse <NSObject>

- (void)backAction;
- (void)send;

@end

@interface WZImageBrowseController : UIPageViewController

@property (nonatomic, strong) id<WZProtocol_imageBrowse> delegate_imagesBrowse;//代理
@property (nonatomic, strong) NSArray <WZMediaAsset *> *array_mediaAsset;//选中的mdeiaAsset集合
@property (nonatomic, strong) NSArray<WZImageContainerController *> *array_reuseable_imageContainers;//图片容器（复用）
@property (nonatomic, strong) WZImageContainerController *VC_currentContainer;//当前的图片容器
@property (nonatomic, assign) NSInteger integer_currentIndex;//当前图片的角标
@property (nonatomic, assign) NSInteger interger_numberOfIndexs;//图片的角标极值
@property (nonatomic, assign) NSUInteger restrictNumber;//限制选图数目 ＝0时无选图限制
@property (nonatomic, strong) WZMediaAsset *mediaAsset_current;//当前集合

- (void)showInIndex:(NSInteger)index withAnimated:(BOOL)animated;//控制器定位
- (void)matchThumnailImageWith:(WZImageContainerController *)VC;//缩略图
- (void)matchClearImageWith:(WZImageContainerController *)VC;//清晰图

@end
