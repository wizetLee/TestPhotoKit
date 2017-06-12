//
//  WZAssetBrowseController.m
//  WZPhotoPicker
//
//  Created by wizet on 2017/6/9.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import "WZAssetBrowseController.h"
#import "WZAssetBrowseNavigationView.h"
#import "WZAssetBrowseToolView.h"

@interface WZAssetBrowseController ()

@property (nonatomic, strong) WZAssetBrowseNavigationView *custom_navigation;
@property (nonatomic, strong) WZAssetBrowseToolView *custom_tool;

@end

@implementation WZAssetBrowseController

#pragma mark Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark CreateViews
- (void)createViews {
    [self.view addSubview:self.custom_navigation];
    [self.view addSubview:self.custom_tool];
    [self caculateSelected];
}

#pragma mark WZProtocol_assetBrowseNaviagtion
- (void)backAction {
    if ([self.delegate_imagesBrowse respondsToSelector:@selector(backAction)]) {
        [self.delegate_imagesBrowse backAction];
    }
    [self dismissViewControllerAnimated:true completion:^{}];
}

- (void)selectedAction {
    if ([self overloadJudgement] && !self.mediaAsset_current.selected) {
        return;
    }
    
    self.mediaAsset_current.selected = !self.mediaAsset_current.selected;
    _custom_navigation.button_selected.selected = self.mediaAsset_current.selected;
    [self caculateSelected];
}

#pragma mark WZProtocol_assetBrowseTool
- (void)selectedOrigionAction {
    self.mediaAsset_current.origion = !self.mediaAsset_current.origion;
    self.custom_tool.button_selectedClear.selected = self.mediaAsset_current.origion;
    [self fetchOrigion];
}

- (void)completeAction {
    [self dismissViewControllerAnimated:false completion:^{
        if ([self.delegate_imagesBrowse respondsToSelector:@selector(send)]) {
            [self.delegate_imagesBrowse send];
        }
    }];
}

#pragma mark Match image
- (void)matchThumnailImageWith:(WZImageContainerController *)VC {
    [super matchThumnailImageWith:VC];
    
    NSUInteger index = VC.integer_index;
    if (index < self.array_mediaAsset.count ) {
        WZMediaAsset *asset = self.array_mediaAsset[index];
        if (asset.image_thumbnail) {
            [VC matchingPicture:asset.image_thumbnail];
        } else {
            [WZMediaFetcher fetchThumbnailWith:asset.asset synchronous:false handler:^(UIImage *thumbnail) {
                asset.image_thumbnail = thumbnail;
                [VC matchingPicture:asset.image_thumbnail];
            }];
        }
    }
}

- (void)matchClearImageWith:(WZImageContainerController *)VC {
    [super matchClearImageWith:VC];
    
    NSUInteger index = VC.integer_index;
    WZMediaAsset *asset = nil;
    if (index < self.array_mediaAsset.count ) {
        asset = self.array_mediaAsset[index];
        
        if (asset.string_clearPath || asset.image_clear) {
            if (asset.image_clear) {
                [VC matchingPicture:asset.image_clear];
                [self caculateImageDataWithImage:asset.image_clear];
            } else {
                UIImage *image = [UIImage imageWithContentsOfFile:asset.string_clearPath];
                [VC matchingPicture:image];
                [self caculateImageDataWithImage:image];
            }
           
        }  else if (asset.asset) {
            //根据 PHAsset callback
            //block回调可能会引起图片紊乱(重用)  请求前先将之前的request cancel掉
            
            [[PHImageManager defaultManager] cancelImageRequest:_imageRequestID];
            [[PHImageManager defaultManager] cancelImageRequest:_imageRequestID_data];
            
            if (asset.origion) {
                _imageRequestID = [WZMediaFetcher fetchOrigionWith:asset.asset synchronous:false handler:^(UIImage *origion) {
                    [VC matchingPicture:origion];
                }];
            } else {
                //渲染成本太高 不选源图
                _imageRequestID = [WZMediaFetcher fetchImageWith:asset.asset costumSize:WZMediaAsset_customSize synchronous:false handler:^(UIImage *image) {
                    [VC matchingPicture:image];
                }];
            }
            
            _imageRequestID_data = [WZMediaFetcher fetchImageWith:asset.asset synchronous:false handler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                [self caculateImageDataWithData:imageData];
            }];
        }
    }
    
    {
        //配置其他的属性
        self.mediaAsset_current = asset;
        self.VC_currentContainer = VC;
        self.custom_navigation.button_selected.selected = self.mediaAsset_current.selected;
        self.custom_tool.button_selectedClear.selected = self.mediaAsset_current.origion;
        self.custom_navigation.label_title.text = [NSString stringWithFormat:@"当前页面ID:%ld", index];
       
    }
}

#pragma mark private method
- (void)caculateSelected {
    NSUInteger restrictNumber = 0;
    for (WZMediaAsset *asset in self.array_mediaAsset) {
        if (asset.selected == true) {
            restrictNumber = restrictNumber + 1;
        }
    }
    self.custom_tool.restrictNumber(restrictNumber);
}

- (BOOL)overloadJudgement {
    if (self.restrictNumber == 0) {
        return false;
    }
    
    NSUInteger restrictNumber = 0;
    for (WZMediaAsset *asset in self.array_mediaAsset) {
        if (asset.selected == true) {
            restrictNumber = restrictNumber + 1;
        }
    }
    
    if (self.restrictNumber <= restrictNumber) {
        return true;
    }
    
    return false;
}

- (void)caculateImageDataWithImage:(UIImage *)image {
    NSData *data = UIImagePNGRepresentation(image);
    [self caculateImageDataWithData:data];
}

- (void)caculateImageDataWithData:(NSData *)data {
    self.custom_tool.fetchClearInfo([NSString stringWithFormat:@"%.3lf M", data.length / 1000.0 / 1000.0]);
}

- (void)fetchOrigion {
    if (self.mediaAsset_current.origion) {
        [WZMediaFetcher fetchOrigionWith:self.mediaAsset_current.asset synchronous:true handler:^(UIImage *origion) {
            [self.VC_currentContainer matchingPicture:origion];
        }];
    }
}

#pragma mark Accessor
- (WZAssetBrowseNavigationView *)custom_navigation {
    if (!_custom_navigation) {
        _custom_navigation = [WZAssetBrowseNavigationView customAssetBrowseNavigationWithDelegate:(id<WZProtocol_assetBrowseNaviagtion>)self];
    }
    return _custom_navigation;
}

- (WZAssetBrowseToolView *)custom_tool {
    if (!_custom_tool) {
        _custom_tool = [WZAssetBrowseToolView customAssetBrowseToolWithDelegate:(id<WZProtocol_assetBrowseTool>)self];
    }
    return _custom_tool;
}

@end
