#import "WVImageController.h"

static NSMutableDictionary *rootObj;
static BOOL enabled = YES;
static CGFloat alpha;

@interface SBIconView : UIView
@end
@interface SBFolderIconView : SBIconView
@end

@interface SBIconImageView : UIImageView
@end
@interface SBFWallpaperView : UIView 
-(id)_blurredImage;
-(void)setGeneratesBlurredImages:(BOOL)arg1 ;
@end

@interface SBFStaticWallpaperView : SBFWallpaperView 
@end

@interface SBWallpaperController : NSObject
+(id)sharedInstance;
-(UIColor *)averageColorForVariant:(long long)arg1 ;
@end

@interface SBFolderIconBackgroundView : UIView 
@end

static void syncPreferences() { //call this to force syncronize your prefs when you change them
    
    CFStringRef appID = CFSTR("com.irepo.greyscale");
    
    CFPreferencesSynchronize(appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    
    
}
static void PreferencesChangedCallback() { // call this on tweak load to initialize the dictionary and then call it when you need to reference the plist
    
    syncPreferences();
    
    CFStringRef appID = CFSTR("com.irepo.greyscale");
    CFArrayRef keyList = CFPreferencesCopyKeyList(appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    
    if (!keyList) {
        
        return;
        
    }
    
    rootObj = (NSMutableDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));
    
    if (!rootObj) {
           
    }
    
    CFRelease(keyList);
    
}

%ctor  {

  BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/com.irepo.greyscale.plist"];

  if (!fileExists) {

      NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:@{@"enabled" : [NSNumber numberWithBool:YES] , @"alpha" : [NSNumber numberWithFloat:1.0]}];

      [tempDict writeToFile:@"/var/mobile/Library/Preferences/com.irepo.greyscale.plist" atomically:YES];

  }

  PreferencesChangedCallback();

  enabled = [[rootObj objectForKey:@"enabled"] boolValue];
  alpha = [[rootObj objectForKey:@"alpha"] floatValue];
}


%hook SBIconImageView 

-(UIImage *)contentsImage {
    WVImageController *cont = [WVImageController sharedInstance];
    UIImage *orig = %orig;
   	if (enabled) {
    	self.alpha = alpha;
    	return [cont imageToGreyImage:orig];
	} else {
		self.alpha = 1.0;
		return orig;
	}
}

%end



@interface SBFolderIconImageView : UIImageView
@end 

static CGFloat newSize = 30.0f;
static CGFloat scaleRatio = 1.0f;

%hook SBFolderIconBackgroundView 
-(id)initWithDefaultSize {
    UIView *origView = %orig;
    CGRect orig = origView.frame;
    origView.frame = CGRectMake(orig.origin.x,orig.origin.y,newSize,newSize);
    return origView;
}
%end

%hook SBFolderIconView
-(CGRect)frameForMiniIconAtIndex:(unsigned long long)arg1 {
  CGRect orig = %orig;
  return CGRectMake(orig.origin.x * scaleRatio,orig.origin.y * scaleRatio,orig.size.width * scaleRatio,orig.size.height * scaleRatio);
}

%end

%hook SBFolderIconImageView

-(CGRect)frameForMiniIconAtIndex:(unsigned long long)arg1 {
  CGRect orig = %orig;
  return CGRectMake(orig.origin.x * scaleRatio,orig.origin.y * scaleRatio,orig.size.width * scaleRatio,orig.size.height * scaleRatio);
}

-(void)layoutSubviews {
  %orig;
  UIView *wrapper = MSHookIvar<UIView*>(self,"_leftWrapperView");
  CGRect orig = wrapper.frame;
  wrapper.frame = CGRectMake(orig.origin.x * scaleRatio, orig.origin.y * scaleRatio, orig.size.width * scaleRatio, orig.size.height * scaleRatio);

  UIView *rightWrapper = MSHookIvar<UIView*>(self,"_rightWrapperView");
  CGRect rOrig = rightWrapper.frame;
  rightWrapper.frame = CGRectMake(rOrig.origin.x * scaleRatio, rOrig.origin.y * scaleRatio, rOrig.size.width * scaleRatio, rOrig.size.height * scaleRatio);
}
%end

%hook SBIconView 
-(void)layoutSubviews {
  %orig;
  UIView *wrapper = MSHookIvar<UIView*>(self,"_iconImageView");
  CGRect orig = wrapper.frame;
  scaleRatio = orig.size.width / newSize;
  wrapper.frame = CGRectMake(orig.origin.x,orig.origin.y,newSize,newSize);
}

/*-(CGRect)frame {
    CGRect orig = %orig;
  return CGRectMake(orig.origin.x ,orig.origin.y,newSize,newSize);
}*/
/*-(CGRect)_frameForImageView {
  CGRect orig = %orig;
  if (![self isKindOfClass:CLASS(SBFolderIconView)]) {
    return CGRectMake(orig.origin.x,orig.origin.y,newSize,newSize);
  } else {
    return %orig;
  }
}
-(CGPoint)iconImageCenter {
  if (![self isKindOfClass:CLASS(SBFolderIconView)]) {
    return CGPointMake(30,30);
  } else {
    return %orig;
  }

} */
%end



