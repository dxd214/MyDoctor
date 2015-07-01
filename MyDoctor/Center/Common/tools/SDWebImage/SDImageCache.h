/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "SDWebImageCompat.h"


/*
 根据URL的MD5摘要对图片进行存储和读取（实现存在内存中或者存在硬盘上两种实现）
 实现图片和内存清理工作
 
 
 SDImageCache分两个部分，一个是内存层面的，一个是硬盘层面的。
 内存层面的相当是个缓存器，以Key-Value的形式存储图片。当内存不够的时候会清除所有缓存图片。
 用搜索文件系统的方式做管理，文件替换方式是以时间为单位，剔除时间大于一周的图片文件。
 当SDWebImageManager向SDImageCache要资源时，先搜索内存层面的数据，如果有直接返回，没有的话去访问磁盘，将图片从磁盘读取出来，然后做Decoder，将图片对象放到内存层面做备份，再返回调用层。
 
 
 图片内存缓存是用NSCache来管理
 图片硬盘存储是存储在library cache底下的子目录里，注意这个目录apple itunes备份是不保存的，放在这里最合理，图片太多
 图片写入到硬盘是放在一个serial queue里，一个线程顺序的写入到本地
 
 */


typedef NS_ENUM(NSInteger, SDImageCacheType) {
    /**
     * The image wasn't available the SDWebImage caches, but was downloaded from the web.
     */
    
    //这种类型的图片   不能直接从缓存中获得  所以可以通过从网络加载
    SDImageCacheTypeNone,
    /**
     * The image was obtained from the disk cache.
     */
    
    //从磁盘获得
    SDImageCacheTypeDisk,
    /**
     * The image was obtained from the memory cache.
     */
    
    //从内存获得
    SDImageCacheTypeMemory
};

//定义一个block类型
typedef void(^SDWebImageQueryCompletedBlock)(UIImage *image, SDImageCacheType cacheType);

typedef void(^SDWebImageCheckCacheCompletionBlock)(BOOL isInCache);

typedef void(^SDWebImageCalculateSizeBlock)(NSUInteger fileCount, NSUInteger totalSize);

/**
 * SDImageCache maintains a memory cache and an optional disk cache. Disk cache write operations are performed
 * asynchronous so it doesn’t add unnecessary latency to the UI.
 */
@interface SDImageCache : NSObject

/**
 * The maximum "total cost" of the in-memory image cache. The cost function is the number of pixels held in memory.
 */
@property (assign, nonatomic) NSUInteger maxMemoryCost;

/**
 * The maximum length of time to keep an image in the cache, in seconds
 */
@property (assign, nonatomic) NSInteger maxCacheAge;

/**
 * The maximum size of the cache, in bytes.
 */
@property (assign, nonatomic) NSUInteger maxCacheSize;

/**
 * Returns global shared cache instance
 *
 * @return SDImageCache global instance
 */

//返回单例 全局缓存对象
+ (SDImageCache *)sharedImageCache;

/**
 * Init a new cache store with a specific namespace
 *
 * @param ns The namespace to use for this cache store
 */

//初始化一个具有特定命名空间的缓存仓库
- (id)initWithNamespace:(NSString *)ns;

/**
 * Add a read-only cache path to search for images pre-cached by SDImageCache
 * Useful if you want to bundle pre-loaded images with your app
 *
 * @param path The path to use for this read-only cache path
 */

//如果你的应用想绑定一个预加载的图片
- (void)addReadOnlyCachePath:(NSString *)path;

/**
 * Store an image into memory and disk cache at the given key.
 *
 * @param image The image to store
 * @param key   The unique image cache key, usually it's image absolute URL
 */

//根据所给的key 将图片存储到磁盘和内存中
- (void)storeImage:(UIImage *)image forKey:(NSString *)key;

/**
 * Store an image into memory and optionally disk cache at the given key.
 *
 * @param image  The image to store
 * @param key    The unique image cache key, usually it's image absolute URL
 * @param toDisk Store the image to disk cache if YES
 */

//根据所给的key 将图片存储到内存中，根据BOOL判断是否需要存进磁盘中
- (void)storeImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk;

/**
 * Store an image into memory and optionally disk cache at the given key.
 *
 * @param image       The image to store
 * @param recalculate BOOL indicates if imageData can be used or a new data should be constructed from the UIImage
 * @param imageData   The image data as returned by the server, this representation will be used for disk storage
 *                    instead of converting the given image object into a storable/compressed image format in order
 *                    to save quality and CPU
 * @param key         The unique image cache key, usually it's image absolute URL
 * @param toDisk      Store the image to disk cache if YES
 */

//根据所给的key 将图片存储到内存中，recalculate表明服务器返回的数据imageData是否可用或者是否该从一个一个image中从新构建imageData，根据BOOL判断是否需要存进磁盘中
- (void)storeImage:(UIImage *)image recalculateFromImage:(BOOL)recalculate imageData:(NSData *)imageData forKey:(NSString *)key toDisk:(BOOL)toDisk;

/**
 * Query the disk cache asynchronously.
 *
 * @param key The unique key used to store the wanted image
 */

//异步从磁盘缓存查找图片
- (NSOperation *)queryDiskCacheForKey:(NSString *)key done:(SDWebImageQueryCompletedBlock)doneBlock;

/**
 * Query the memory cache synchronously.
 *
 * @param key The unique key used to store the wanted image
 */

//异步从内存查找图片
- (UIImage *)imageFromMemoryCacheForKey:(NSString *)key;

/**
 * Query the disk cache synchronously after checking the memory cache.
 *
 * @param key The unique key used to store the wanted image
 */

//异步从磁盘查找图片 key用于存储你想存储的图片
- (UIImage *)imageFromDiskCacheForKey:(NSString *)key;

/**
 * Remove the image from memory and disk cache synchronously
 *
 * @param key The unique image cache key
 */

//根据key异步从内存磁盘中移除图片
- (void)removeImageForKey:(NSString *)key;


/**
 * Remove the image from memory and disk cache synchronously
 *
 * @param key             The unique image cache key
 * @param completionBlock An block that should be executed after the image has been removed (optional)
 */

//根据key异步从内存磁盘中移除图片  完成后有回调
- (void)removeImageForKey:(NSString *)key withCompletion:(SDWebImageNoParamsBlock)completion;

/**
 * Remove the image from memory and optionally disk cache synchronously
 *
 * @param key      The unique image cache key
 * @param fromDisk Also remove cache entry from disk if YES
 */

//根据key异步从内存中移除图片  if  YES  那么也从磁盘移除图片缓存
- (void)removeImageForKey:(NSString *)key fromDisk:(BOOL)fromDisk;

/**
 * Remove the image from memory and optionally disk cache synchronously
 *
 * @param key             The unique image cache key
 * @param fromDisk        Also remove cache entry from disk if YES
 * @param completionBlock An block that should be executed after the image has been removed (optional)
 */

//根据key异步从内存中移除图片  if  YES  那么也从磁盘移除图片缓存   完成有回调
- (void)removeImageForKey:(NSString *)key fromDisk:(BOOL)fromDisk withCompletion:(SDWebImageNoParamsBlock)completion;

/**
 * Clear all memory cached images
 */

//清除内存
- (void)clearMemory;

/**
 * Clear all disk cached images. Non-blocking method - returns immediately.
 * @param completionBlock An block that should be executed after cache expiration completes (optional)
 */

//清除所有磁盘上的缓存
- (void)clearDiskOnCompletion:(SDWebImageNoParamsBlock)completion;

/**
 * Clear all disk cached images
 * @see clearDiskOnCompletion:
 */

//清除磁盘上所有缓存
- (void)clearDisk;

/**
 * Remove all expired cached image from disk. Non-blocking method - returns immediately.
 * @param completionBlock An block that should be executed after cache expiration completes (optional)
 */

//清除磁盘缓存 完成后有回调
- (void)cleanDiskWithCompletionBlock:(SDWebImageNoParamsBlock)completionBlock;

/**
 * Remove all expired cached image from disk
 * @see cleanDiskWithCompletionBlock:
 */

//清除磁盘缓存
- (void)cleanDisk;

/**
 * Get the size used by the disk cache
 */

//计算磁盘缓存空间已用大小
- (NSUInteger)getSize;

/**
 * Get the number of images in the disk cache
 */

//计算磁盘缓存中图片的张数
- (NSUInteger)getDiskCount;

/**
 * Asynchronously calculate the disk cache's size.
 */

//异步计算磁盘缓存空间的大小
- (void)calculateSizeWithCompletionBlock:(SDWebImageCalculateSizeBlock)completionBlock;

/**
 *  Async check if image exists in disk cache already (does not load the image)
 *
 *  @param key             the key describing the url
 *  @param completionBlock the block to be executed when the check is done.
 *  @note the completion block will be always executed on the main queue
 */

//判断图片是否存在于磁盘缓存中 判断完后  即回到主线程
- (void)diskImageExistsWithKey:(NSString *)key completion:(SDWebImageCheckCacheCompletionBlock)completionBlock;

/**
 *  Check if image exists in disk cache already (does not load the image)
 *
 *  @param key the key describing the url
 *
 *  @return YES if an image exists for the given key
 */

//返回图片是否存在于磁盘缓存中的结果
- (BOOL)diskImageExistsWithKey:(NSString *)key;

/**
 *  Get the cache path for a certain key (needs the cache path root folder)
 *
 *  @param key  the key (can be obtained from url using cacheKeyForURL)
 *  @param path the cach path root folder
 *
 *  @return the cache path
 */

//根据某一个key  得到他的缓存路径 path：缓存路径的根目录
- (NSString *)cachePathForKey:(NSString *)key inPath:(NSString *)path;

/**
 *  Get the default cache path for a certain key
 *
 *  @param key the key (can be obtained from url using cacheKeyForURL)
 *
 *  @return the default cache path
 */

//根据某一个key  得到他的默认缓存路径
- (NSString *)defaultCachePathForKey:(NSString *)key;

@end
