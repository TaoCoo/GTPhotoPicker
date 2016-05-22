//
//  GTGetAlbumPhotos.h
//  GTPhotoPicker
//
//  Created by gt on 16/5/22.
//  Copyright © 2016年 gt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GTGetAlbumPhotos : NSObject

// 获取系统相册所有图片
- (NSArray *)getAlbumPhotos;

//PHAsset 转换UIImage
-(void)getImageObject:(id)asset complection:(void (^)(UIImage *image, BOOL isDegraded))complection;

@end
