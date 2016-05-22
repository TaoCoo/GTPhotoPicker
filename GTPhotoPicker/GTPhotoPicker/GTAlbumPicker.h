//
//  GTAlbumPicker.h
//  GTPhotoPicker
//
//  Created by gt on 16/5/22.
//  Copyright © 2016年 gt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^AlbumPickerResult)(NSArray *imgArray);

@interface GTAlbumPicker : NSObject

// 选择照片的最多张数
@property(assign,nonatomic) NSInteger maxPhotoPickNumber;

// 回调
- (void)loadImageFromeViewController:(UIViewController *)viewController result:(AlbumPickerResult)result;

@end
