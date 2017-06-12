//
//  WZAssetBrowseNavigationView.h
//  WZPhotoPicker
//
//  Created by wizet on 2017/6/9.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WZProtocol_assetBrowseNaviagtion <NSObject>

- (void)backAction;
- (void)selectedAction;

@end

@interface WZAssetBrowseNavigationView : UIView

@property (nonatomic, weak) id<WZProtocol_assetBrowseNaviagtion> delegate;
@property (nonatomic, strong) UIButton *button_back;
@property (nonatomic, strong) UIButton *button_selected;
@property (nonatomic, strong) UILabel *label_title;

+ (instancetype)customAssetBrowseNavigationWithDelegate:(id<WZProtocol_assetBrowseNaviagtion>)delegate;

@end
