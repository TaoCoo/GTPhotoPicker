//
//  GTGetAlbumPhotos.m
//  GTPhotoPicker
//
//  Created by gt on 16/5/22.
//  Copyright © 2016年 gt. All rights reserved.
//

#import "GTGetAlbumPhotos.h"
#import <Photos/Photos.h>

@implementation GTGetAlbumPhotos

- (NSArray *)getAlbumPhotos{
  
    PHFetchResult *fetchResult = [self getFetchResultWithAssetCollection:[self getPHAssetCollection][0]];
    
    return [self getPhotosWithFetchResult:fetchResult];
}

-(void)getImageObject:(id)asset complection:(void (^)(UIImage *image, BOOL isDegraded))complection{
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = (PHAsset *)asset;
        
        CGFloat photoWidth = [UIScreen mainScreen].bounds.size.width;
        
        CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
        CGFloat multiple = [UIScreen mainScreen].scale;
        CGFloat pixelWidth = photoWidth * multiple;
        CGFloat pixelHeight = pixelWidth / aspectRatio;
        
        [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:CGSizeMake(pixelWidth, pixelHeight) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinined) {
                if (complection) complection(result,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
            }
        }];
    }
}


#pragma mark - private

// 根据图片集获取result
- (PHFetchResult *)getFetchResultWithAssetCollection:(PHAssetCollection *)assetCollection{
    
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    return fetchResult;
}

// 获取全部相册
- (NSMutableArray *)getPHAssetCollection{
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc]init];
    
    PHFetchResult *smartAlbumsFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:fetchOptions];
    
    [dataArray addObject:[smartAlbumsFetchResult objectAtIndex:0]];
    
    PHFetchResult *smartAlbumsFetchResult1 = [PHAssetCollection fetchTopLevelUserCollectionsWithOptions:fetchOptions];
    
    for (PHAssetCollection *sub in smartAlbumsFetchResult1)
    {
        [dataArray addObject:sub];
    }
    
    return dataArray;
}

-(NSMutableArray *)getPhotosWithFetchResult:(PHFetchResult *)fetchResult{
    
    NSMutableArray *dataArray = [NSMutableArray array];
    for (PHAsset *asset in fetchResult) {
        //只添加图片类型资源，去除视频类型资源
        //当mediaType == 2时，这个资源则为视频资源
        if (asset.mediaType == 1) {
            [dataArray addObject:asset];
        }
        
    }
    return dataArray;
}

@end
