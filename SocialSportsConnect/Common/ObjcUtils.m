//
//  ObjcUtils.m
//  SocialSportsConnect
//
//  Created by PingLi on 5/20/19.
//  Copyright © 2019 Li Ping. All rights reserved.
//

#import "ObjcUtils.h"

@implementation ObjcUtils

+ (void)shareToFacebookStory:(UIImage*) imageData {
    [self backgroundImage:UIImagePNGRepresentation(imageData)
           attributionURL:@"http://your-deep-link-url"
                    appID:@"2342452632651499"];
}

+ (void)backgroundImage:(NSData *)backgroundImage
         attributionURL:(NSString *)attributionURL
                  appID:(NSString *)appID {
    
    // Verify app can open custom URL scheme, open if able
    NSURL *urlScheme = [NSURL URLWithString:@"facebook-stories://share"];
    if ([[UIApplication sharedApplication] canOpenURL:urlScheme]) {
        
        // Assign background image asset and attribution link URL to pasteboard
        NSArray *pasteboardItems = @[@{@"com.facebook.sharedSticker.backgroundImage" : backgroundImage,
                                       @"com.facebook.sharedSticker.contentURL" : attributionURL,
                                       @"com.facebook.sharedSticker.appID" : appID}];
        NSDictionary *pasteboardOptions = @{UIPasteboardOptionExpirationDate : [[NSDate date] dateByAddingTimeInterval:60 * 5]};
        // This call is iOS 10+, can use 'setItems' depending on what versions you support
        [[UIPasteboard generalPasteboard] setItems:pasteboardItems options:pasteboardOptions];
        
        [[UIApplication sharedApplication] openURL:urlScheme options:@{} completionHandler:nil];
    } else {
        // Handle older app versions or app not installed case
    }
}

@end
