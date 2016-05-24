//
//  GTPhotoBrowser.h
//  GTPhotoPicker
//
//  Created by gut on 16/5/23.
//  Copyright © 2016年 gt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@interface GTPhotoBrowser : UIViewController

/**
 *  浏览的图片数组
 */
@property (nonatomic,strong) NSArray<PHAsset *> *selectedImageArray;

/**
 *  删除图片的回调
 */
//@property (nonatomic,copy) void(^DeleteImageBlock)(NSInteger deleteIndex);

@end
