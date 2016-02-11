

@interface WVImageController : NSObject
+ (id)sharedInstance;
- (UIImage *)imageToGreyImage:(UIImage *)image;
- (UIImage *)applyBlurToImage:(UIImage *)image;
- (UIImage *)image:(UIImage*)image withColor:(UIColor *)color;
@end
