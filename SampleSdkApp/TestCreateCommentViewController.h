//
//  TestCreateCommentViewController.h
//  SocializeSDK
//
//  Created by Fawad Haider on 7/29/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Socialize.h"
#import "LoadingView.h"

@interface TestCreateCommentViewController : UIViewController<SocializeServiceDelegate> {

    LoadingView*            _loadingView;
    Socialize*              _socialize;
    
    /*info view */
    IBOutlet UIView*        resultsView;
//    IBOutlet UILabel*       successLabel;
    IBOutlet UILabel*       keyLabel;
    IBOutlet UILabel*       nameLabel;
    IBOutlet UILabel*       commentsLabel;
    
    IBOutlet UITextField*   entityField;
    IBOutlet UITextField*   commentField;
    
    IBOutlet UITextField* resultTextField;
    UIButton* hiddenButton;

    
}
-(IBAction)createComment;
@end
