/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * Created by james <https://github.com/mystcolor> on 9/28/11.
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "SDWebImageCompat.h"

/*
 异步对图像进行了一次解压
 由于UIImage的imageWithData函数是每次画图的时候才将Data解压成ARGB的图像，
 所以在每次画图的时候，会有一个解压操作，这样效率很低，但是只有瞬时的内存需求。
 为了提高效率通过SDWebImageDecoder将包装在Data下的资源解压，然后画在另外一张图片上，这样这张新图片就不再需要重复解压了。
 这种做法是典型的空间换时间的做法
 */
@interface UIImage (ForceDecode)

+ (UIImage *)decodedImageWithImage:(UIImage *)image;

@end
