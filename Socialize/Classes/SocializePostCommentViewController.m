//
//  SocializePostCommentViewController.m
//  SocializeSDK
//
//  Created by Nathaniel Griswold on 11/10/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializePostCommentViewController.h"
#import "SocializeLocationManager.h"
#import "CommentMapView.h"
#import "UINavigationController+Socialize.h"

@implementation SocializePostCommentViewController
@synthesize facebookSwitch = facebookSwitch_;
@synthesize commentObject = commentObject_;
@synthesize commentSentToFacebook = commentSentToFacebook_;

+ (UINavigationController*)postCommentViewControllerInNavigationControllerWithEntityURL:(NSString*)entityURL {
    SocializePostCommentViewController *postCommentViewController = [self postCommentViewControllerWithEntityURL:entityURL];
    UINavigationController *navigationController = [UINavigationController socializeNavigationControllerWithRootViewController:postCommentViewController];
    return navigationController;    
}

+ (SocializePostCommentViewController*)postCommentViewControllerWithEntityURL:(NSString*)entityURL {
    SocializePostCommentViewController *postCommentViewController = [[[SocializePostCommentViewController alloc]
                                                       initWithNibName:@"SocializePostCommentViewController" bundle:nil entityUrlString:entityURL]
                                                      autorelease];
    return postCommentViewController;
}

- (void)dealloc {
    self.facebookSwitch = nil;
    self.commentObject = nil;

    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"New Comment";
    
    self.facebookSwitch.hidden = ![self.socialize isAuthenticatedWithFacebook];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.facebookSwitch = nil;
}

- (void)createCommentOnSocializeServer {
    [self startLoading];
    
    if(self.locationManager.shouldShareLocation)
    {
        NSNumber* latitude = [NSNumber numberWithFloat:mapOfUserLocation.userLocation.location.coordinate.latitude];
        NSNumber* longitude = [NSNumber numberWithFloat:mapOfUserLocation.userLocation.location.coordinate.longitude];        
        [self.socialize createCommentForEntityWithKey:self.entityURL comment:commentTextView.text longitude:longitude latitude:latitude];
    }
    else
        [self.socialize createCommentForEntityWithKey:self.entityURL comment:commentTextView.text longitude:nil latitude:nil];
}

- (BOOL)shouldSendToFacebook {
    return self.facebookSwitch.on && !self.facebookSwitch.hidden;
}

- (void)dismissSelf {
    // Double animated dismissal does not work on iOS5 (but works in iOS4)
    // Allow previous modal dismisalls to complete. iOS5 added dismissViewControllerAnimated:completion:, which
    // we would use here if backward compatibility was not required.   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, MIN_MODAL_DISMISS_INTERVAL * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self stopLoadAnimation];
        [self dismissModalViewControllerAnimated:YES];
    });
}

- (void)finishCreateComment {
    
    // Create the comment object if not already created.
    if (self.commentObject == nil) {
        [self createCommentOnSocializeServer];
        return;
    }
    
    // Send activity to facebook if the user requested it
    if (!self.commentSentToFacebook && [self shouldSendToFacebook]) {
        [self sendActivityToFacebookFeed:self.commentObject];
        return;
    }
    
    [self stopLoading];
    [self dismissSelf];
}

- (void)afterUserRejectedFacebookAuthentication {
    [self finishCreateComment];
}

- (void)bobbleView:(UIView*)view yOffset:(CGFloat)yOffset count:(NSInteger)count {
    if (count > 0) {
        [UIView animateWithDuration:0.2
                              delay:0
                            options:0
                         animations:^{
                             CGRect current = view.frame;
                             view.frame = CGRectMake(current.origin.x, current.origin.y + yOffset, current.size.width, current.size.height);
                         } completion:^(BOOL done) {
                             [self bobbleView:view yOffset:-yOffset count:count-1];
                         }];
    }
}

- (void)afterFacebookLoginAction {
    self.facebookSwitch.hidden = NO;
    [self bobbleView:self.facebookSwitch yOffset:3 count:4];
}

-(void)sendButtonPressed:(UIButton*)button {
    if (![self.socialize isAuthenticatedWithFacebook]) {
        [self presentModalViewController:self.authViewController animated:YES];
    } else {
        [self finishCreateComment];
    }
}

- (void)sendActivityToFacebookFeedSucceeded {
    self.commentSentToFacebook = YES;
    [self finishCreateComment];
}

- (void)sendActivityToFacebookFeedCancelled {
}

-(void)service:(SocializeService *)service didCreate:(id<SocializeObject>)object {
    if ([object conformsToProtocol:@protocol(SocializeComment)]) {
        self.commentObject = (id<SocializeComment>)object;
        [self finishCreateComment];
    }
}

- (void)authorizationSkipped {
    [self finishCreateComment];
}

-(void)didAuthenticate:(id<SocializeUser>)user {
    // FIXME [#20995319] auth flow in wrong place
    // Also, we give the user an opportunity to adjust the facebook switch
    [self afterFacebookLoginAction];
    [self finishCreateComment];
}

@end
