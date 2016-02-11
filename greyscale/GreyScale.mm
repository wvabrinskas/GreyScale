#import <Preferences/Preferences.h>

@interface GreyScaleListController: PSListController {
}
@end

@implementation GreyScaleListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"GreyScale" target:self] retain];
	}
	return _specifiers;
}


-(void)apply {
    
    system("killall -9 'backboardd'");
    
}

@end

// vim:ft=objc
