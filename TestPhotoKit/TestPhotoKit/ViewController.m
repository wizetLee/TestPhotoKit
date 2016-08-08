//
//  ViewController.m
//  TestPhotoKit
//
//  Created by admin on 16/7/8.
//  Copyright © 2016年 admin. All rights reserved.
//
#import <Photos/Photos.h>
#import "ViewController.h"
#import "AlbumController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)jump:(UIButton *)sender {//全部相册
    AlbumController *ACVC = [[AlbumController alloc] init];
    [self.navigationController pushViewController:ACVC animated:YES];
}




- (IBAction)video:(UIButton *)sender {//test
    /*
     1、 首次加载APP时出现的问题：仅会获取相应的权限 而不会响应方法
     */
    //每次访问相册都会调用这个handler  检查改app的授权情况
    //PHPhotoLibrary 
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
          //code
        }
    }];
    
    /*
     2、获取所有图片（注意不能在胶卷中获取图片，因为胶卷中的图片包含了video的显示图）
     */
    [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];//这样获取
    
    /*
     3、使用PHImageManager请求时的回调同步or异步时、block回调次数的问题
     */
    
    /*
     4、回调得出的图片size的问题: 由3个参数决定
     */
    /*
     在ShowAlbumViewController 中观察
     
     在PHImageContentModeAspectFill 下  图片size 有一个分水岭  {125,125}   {126,126}
     当imageOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
     时: 设置size 小于{125,125}时，你得到的图片size 将会是设置的1/2
     
     而在PHImageContentModeAspectFit 分水岭  {120,120}   {121,121}
     */
    
    
    /*
     5、回调中info字典key消失的问题: 当最终获取到的图片的size的高／宽没有一个能达到原有的图片size的高／宽时 部分key 会消失
     */
    
    
    //    PHAsset 用户照片库中一个单独的资源，简单而言就是单张图片或者视音频的元数据吧
    
    //    PHAsset 组合而成 PHAssetCollection(PHCollection)   一个单独的资源集合(PHAssetCollection)可以是照片库中相簿中一个相册或者照片中一个时刻，或者是一个特殊的“智能相册”。这种智能相册包括所有的视频集合，最近添加的项目，用户收藏，所有连拍照片等
    
    //    PHCollectionList 则是包含PHAssetCollection的PHAssetCollection。因为它本身就是 PHCollection，所以集合列表可以包含其他集合列表，它们允许复杂的集合继承。例子：年度->精选->时刻

    //    PHFetchResult 某个系列（PHAssetCollection）或者是相册（PHAsset）的返回结果，一个集合类型，PHAsset 或者 PHAssetCollection 的类方法均可以获取到
    
    //    PHImageManager 处理图片加载，加载图片过程有缓存处理
    
    //    PHCachingImageManager(PHImageManager的抽象) 处理图像的整个加载过程的缓存 要加载大量资源的缩略图时可以使用该类的startCachingImage... 预先将一些图像加载到内存中，达到预先缓冲的效果
    
    //    PHImageRequestOptions 设置加载图片方式的参数()
    
    //    PHFetchOptions 集合资源的配置方式（按一定的(时间)顺序对资源进行排列、隐藏/显示某一个部分的资源集合）
    
    
    
    
    /*
     PHAssetCollectionTypeMoment      Moment中
     PHAssetCollectionTypeAlbum       用户创建的相册
     PHAssetCollectionTypeSmartAlbum  系统相册中//系统本来就拥有的相册 如Favorites、Videos、Camera Roll等
     */
    /*
     // PHAssetCollectionTypeAlbum regular subtypes
     PHAssetCollectionSubtypeAlbumRegular         = 2,
     PHAssetCollectionSubtypeAlbumSyncedEvent     = 3,
     PHAssetCollectionSubtypeAlbumSyncedFaces     = 4,
     PHAssetCollectionSubtypeAlbumSyncedAlbum     = 5,
     PHAssetCollectionSubtypeAlbumImported        = 6,
     
     // PHAssetCollectionTypeAlbum shared subtypes
     PHAssetCollectionSubtypeAlbumMyPhotoStream   = 100,//照片流
     PHAssetCollectionSubtypeAlbumCloudShared     = 101,//iCloud 分享
     
     // PHAssetCollectionTypeSmartAlbum subtypes
     PHAssetCollectionSubtypeSmartAlbumGeneric    = 200,//一般
     PHAssetCollectionSubtypeSmartAlbumPanoramas  = 201,//全景
     PHAssetCollectionSubtypeSmartAlbumVideos     = 202,//视频
     PHAssetCollectionSubtypeSmartAlbumFavorites  = 203,//收藏
     PHAssetCollectionSubtypeSmartAlbumTimelapses = 204,//定时拍摄
     PHAssetCollectionSubtypeSmartAlbumAllHidden  = 205,//
     PHAssetCollectionSubtypeSmartAlbumRecentlyAdded = 206,//最近添加
     PHAssetCollectionSubtypeSmartAlbumBursts     = 207,//连拍
     PHAssetCollectionSubtypeSmartAlbumSlomoVideos = 208,//慢动作视频
     PHAssetCollectionSubtypeSmartAlbumUserLibrary = 209,//用户相册
     PHAssetCollectionSubtypeSmartAlbumSelfPortraits NS_AVAILABLE_IOS(9_0) = 210,   //头像\肖像
     PHAssetCollectionSubtypeSmartAlbumScreenshots NS_AVAILABLE_IOS(9_0) = 211,     //截屏
     // Used for fetching, if you don't care about the exact subtype
     PHAssetCollectionSubtypeAny = NSIntegerMax
     */
    
    
    NSMutableArray *nameArr = [NSMutableArray array];//用于存储assets's名字
    NSMutableArray *assetArr = [NSMutableArray array];//用于存储assets's内容
    
    // 获取系统设置的相册信息(其实也不完全  譬如没有<照片流>等)
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    //此处option是对获取得到对 Collection 的配置
   /*
//         例如按资源的创建时间排序
         PHFetchOptions *options = [[PHFetchOptions alloc] init];
//    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];

         options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]]; //其中：key是PHAsset类的属性   这是一个kvc
         PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
         NSLog(@"获取所有资源(photo/video)image的集合并且按照时间创建时间排序 = %ld",assetsFetchResults.count);
    */
    
    NSLog(@"系统相册的数目 = %ld",smartAlbums.count);
    for (PHAssetCollection *collection in smartAlbums) {
        PHFetchResult *results = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        NSLog(@"相册名:%@，有%ld张图片",collection.localizedTitle,results.count);
        
        [nameArr addObject:collection.localizedTitle];//存储assets's名字
        [assetArr addObject:results];//存储assets's内容
        
//        for (PHAsset *asset in results) {
//             PHImageRequestOptions *opts = [[PHImageRequestOptions alloc] init]; // assets的配置设置
//             opts.synchronous = YES;//同步 or 异步
//             opts.resizeMode = PHImageRequestOptionsResizeModeExact;//assets中图片获取的模式
//             opts.deliveryMode  = PHImageRequestOptionsDeliveryModeHighQualityFormat;
//             [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(300, 300) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//                            
//             }];
//        }
    }
    
//  用户自定义的资源
    PHFetchResult *customCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in customCollections) {
        PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        [nameArr addObject:collection.localizedTitle];
        [assetArr addObject:assets];
    }
    
    //如果要添加照片流 可以打开此下的注释
//    PHFetchResult *stream = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
//    for (PHAssetCollection *collection in stream) {
//        PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
//        [nameArr addObject:collection.localizedTitle];
//        [assetArr addObject:assets];
//    }/
    
    SmartAblumTableVC *SATVC = [[SmartAblumTableVC alloc] init];
    SATVC.albumNameArr = [NSMutableArray arrayWithArray:nameArr];
    SATVC.albumAssetsArr = [NSMutableArray arrayWithArray:assetArr];
    [self.navigationController pushViewController:SATVC animated:YES];
}
@end
