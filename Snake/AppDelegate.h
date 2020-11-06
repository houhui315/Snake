//
//  AppDelegate.h
//  Snake
//
//  Created by MacBook on 11-10-25.
//  Copyright __MyCompanyName__ 2011年. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	RootViewController	*viewController;
}

@property (strong, nonatomic) UIWindow *window;


@end
