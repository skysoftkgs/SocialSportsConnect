//
//  ObjcUtils.h
//  SocialSportsConnect
//
//  Created by PingLi on 5/20/19.
//  Copyright © 2019 Li Ping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObjcUtils : NSObject

+ (void)shareToFacebookStory:(UIImage*) imageData;
+ (void)backgroundImage:(NSData *)backgroundImage
         attributionURL:(NSString *)attributionURL
                  appID:(NSString *)appID;

@end

NS_ASSUME_NONNULL_END
