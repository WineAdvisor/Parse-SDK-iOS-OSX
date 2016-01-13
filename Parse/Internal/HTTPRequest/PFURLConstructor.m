/**
 * Copyright (c) 2015-present, Parse, LLC.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "PFURLConstructor.h"

#import "PFAssert.h"

@implementation PFURLConstructor

///--------------------------------------
#pragma mark - WineAdvisor API
///--------------------------------------
+ (NSString*)useWADapiOrNot:(NSString *)path{
    NSString *serverUrl = @"https://api.parse.com/1";
    
    //Is the path a function ?
    NSArray *pathArray = [path componentsSeparatedByString:@"/"];
    NSString *functionName;
    
    if ([[pathArray objectAtIndex:0] isEqualToString:@"functions"]) {
        //Define functions which will be redirected to api2.wineadvisor.com
        NSArray *webhookFunctions = [NSArray arrayWithObjects:
                                     @"getComments",
                                     @"addComment",
                                     @"updateComment",
                                     @"removeComment",
                                     @"follow",
                                     @"unFollow",
                                     @"getAds",
                                     @"getHistory",
                                     @"getActivity",
                                     @"setActivity",
                                     @"likeWine",
                                     @"unlikeWine",
                                     @"purchaseItem",
                                     @"addWineToWishlist",
                                     @"removeWhishlisted",
                                     @"addTimeline",
                                     @"removeTimeline",
                                     @"updateTimeline",
                                     @"getBadgeView",
                                     @"getPersonalTimeline",
                                     @"getFollowingTimeline",
                                     @"getProTimeline",
                                     @"getTrending",
                                     @"getWineDetails",
                                     @"getWishlist",
                                     @"getUserName",
                                     @"getUserProfile",
                                     @"getFollowing",
                                     @"getFollowers",
                                     @"getCellar",
                                     @"getListing",
                                     @"getToDiscoverWines",
                                     @"getWineLikes",
                                     nil];
        //Enable or disable redirection
        functionName = [pathArray objectAtIndex:1];
        if ([webhookFunctions containsObject:functionName]) {
            serverUrl = @"https://api2.wineadvisor.com/1";
        }
    }
    NSLog([NSString stringWithFormat:@"%@/functions/%@", serverUrl, functionName]);
    return serverUrl;
}

///--------------------------------------
#pragma mark - Basic
///--------------------------------------

+ (NSURL *)URLFromAbsoluteString:(NSString *)string
                            path:(nullable NSString *)path
                           query:(nullable NSString *)query {
    
    string = [self useWADapiOrNot:path]; //Redefine string for WAD API if needed
    
    NSURLComponents *components = [NSURLComponents componentsWithString:string];
    if (path.length != 0) {
        NSString *fullPath = (components.path.length ? components.path : @"/");
        fullPath = [fullPath stringByAppendingPathComponent:path];
        // If the last character in the provided path is a `/` -> `stringByAppendingPathComponent:` will remove it.
        // so we need to append it manually to make sure we contruct with the requested behavior.
        if ([path characterAtIndex:path.length - 1] == '/' &&
            [fullPath characterAtIndex:fullPath.length - 1] != '/') {
            fullPath = [fullPath stringByAppendingString:@"/"];
        }
        components.path = fullPath;
    }
    if (query) {
        components.query = query;
    }
    return components.URL;
}

@end
