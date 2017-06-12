//
//  WZRemoteImageNavigationView.m
//  WZPhotoPicker
//
//  Created by admin on 17/6/9.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import "WZRemoteImageNavigationView.h"

@implementation WZRemoteImageNavigationView

+ (instancetype)customAssetBrowseNavigationWithDelegate:(id<WZProtocol_assetBrowseNaviagtion>)delegate {
    WZRemoteImageNavigationView *navigation = [super customAssetBrowseNavigationWithDelegate:delegate];
    navigation.button_selected.hidden = true;
    return navigation;
}

@end
