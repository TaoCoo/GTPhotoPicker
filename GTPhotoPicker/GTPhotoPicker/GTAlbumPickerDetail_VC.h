//
//  GTAlbumPickerDetail_VC.h
//  GTPhotoPicker
//
//  Created by gt on 16/5/22.
//  Copyright © 2016年 gt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AlbumPickerResult)(NSArray *imgArray);

@interface GTAlbumPickerDetail_VC : UIViewController

// 选择结果
@property (nonatomic,copy) AlbumPickerResult result;

// 选择照片张数
@property (assign,nonatomic) NSInteger pickNumber;

@end
