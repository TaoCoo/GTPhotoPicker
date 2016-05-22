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
