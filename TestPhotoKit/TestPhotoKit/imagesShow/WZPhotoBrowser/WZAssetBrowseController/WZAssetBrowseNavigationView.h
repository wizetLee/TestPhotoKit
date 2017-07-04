//
//  WZAssetBrowseNavigationView.h
//  WZPhotoPicker
//
//  Created by wizet on 2017/6/9.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WZProtocolAssetBrowseNaviagtion <NSObject>

- (void)backAction;
- (void)selectedAction;

@end

@interface WZAssetBrowseNavigationView : UIView

@property (nonatomic, weak) id<WZProtocolAssetBrowseNaviagtion> delegate;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UILabel *titleLabel;

+ (instancetype)customAssetBrowseNavigationWithDelegate:(id<WZProtocolAssetBrowseNaviagtion>)delegate;

@end
