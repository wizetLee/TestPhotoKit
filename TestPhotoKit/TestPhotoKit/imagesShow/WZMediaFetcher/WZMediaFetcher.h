//
//  WZMediaFetcher.h
//  WZPhotoPicker
//
//  Created by admin on 17/6/7.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "NSObject+WZCommon.h"
#define WZMediaAsset_customSize CGSizeMake(2000, 2000)
#define WZMediaAsset_thumbnailSize CGSizeMake(250, 250)

@class WZMediaAsset;
@protocol WZProtocol_mediaAsset <NSObject>

@optional

- (void)fetchAssets:(NSArray <WZMediaAsset *> *)assets;

//同步获取图片数据 images + loading + end + callback
- (void)fetchImages:(NSArray <UIImage *> *)images;

@end

typedef NS_ENUM(NSUInteger, WZMediaType) {
    WZMediaType_unknow = 0,
    WZMediaType_photo = 1,
    WZMediaType_video = 2,
    WZMediaType_audio = 3,
};

@interface WZMediaAsset : NSObject

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL origion;

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, assign) WZMediaType mediaType;

@property (nonatomic, strong) UIImage *image_clear;
@property (nonatomic, strong) UIImage *image_thumbnail;

@property (nonatomic, strong) NSURL *url_media;
@property (nonatomic, strong) NSString *string_clearPath;

- (void)fetchThumbnailImageSynchronous:(BOOL)synchronous handler:(void (^)(UIImage *image))handler;
- (void)fetchOrigionImageSynchronous:(BOOL)synchronous handler:(void (^)(UIImage *image))handler;

@end

@interface WZMediaAssetCollection : NSObject

@property (nonatomic, strong) NSArray <WZMediaAsset *>* array_mediaAsset;
@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property (nonatomic, strong) NSString *string_title;
@property (nonatomic, strong) WZMediaAsset *coverAssset;//默认是 assetMArray 首个元素

//自定义封面
- (void)customCoverWithMediaAsset:(WZMediaAsset *)mediaAsset withCoverHandler:(void(^)(UIImage *image))handler;
//默认封面
- (void)coverHandler:(void(^)(UIImage *image))handler;

@end

@interface WZMediaFetcher : NSObject

+ (NSMutableArray <WZMediaAssetCollection *> *)fetchAssetCollection;

#pragma mark Fetch Picture
+ (int32_t)fetchThumbnailWith:(PHAsset *)mediaAsset synchronous:(BOOL)synchronous handler:(void(^)(UIImage *thumbnail))handler ;

+ (int32_t)fetchOrigionWith:(PHAsset *)mediaAsset synchronous:(BOOL)synchronous handler:(void(^)(UIImage *origion))handler;

+ (int32_t)fetchImageWith:(PHAsset *)mediaAsset costumSize:(CGSize)customSize synchronous:(BOOL)synchronous handler:(void(^)(UIImage *origion))handler;

+ (int32_t)fetchImageWith:(PHAsset *)asset synchronous:(BOOL)synchronous handler:(void (^)(NSData *  imageData, NSString *  dataUTI, UIImageOrientation orientation, NSDictionary *  info))handler;

#pragma mark Fetch Video



#pragma mark Fetch Audio

@end
