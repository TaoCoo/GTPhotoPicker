//
//  GTPhotoPicker.h
//  GTPhotoPicker
//
//  Created by gt on 16/5/21.
//  Copyright © 2016年 gt. All rights reserved.
//

#ifndef GTPhotoPicker_h
#define GTPhotoPicker_h

// 最大上传数量 9
#define kMaxPhotoPickNumber 9

#define kAlbumPickerScreenW  [UIScreen mainScreen].bounds.size.width
#define kAlbumPickerScreenH [UIScreen mainScreen].bounds.size.height
#define kAlbumPickerRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define kAlbumPickerMainColor [UIColor cyanColor]
#define kAlbumPickerFontWithFloat(float) [UIFont systemFontOfSize:float]

#import "GTCameraPicker.h"
#import "GTAlbumPicker.h"

#endif /* GTPhotoPicker_h */
