#import "WVImageController.h"

static NSMutableDictionary *rootObj;
static BOOL enabled = YES;
static CGFloat alpha;

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


%hook SBFStaticWallpaperView

-(id)_displayedImage {
  WVImageController *cont = [WVImageController sharedInstance];
  UIImage *orig = %orig;
  NSLog(@"wall-image");
  return %orig;
}


%end