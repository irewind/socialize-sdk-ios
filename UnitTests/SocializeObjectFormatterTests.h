//
//  SocializeObjectParserTests.h
//  SocializeSDK
//
//  Created by William Johnson on 5/23/11.
//  Copyright 2011 Socialize, Inc. All rights reserved.
//
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

//  Application unit tests contain unit test code that must be injected into an application to run correctly.
//  Define USE_APPLICATION_UNIT_TEST to 0 if the unit test code is designed to be linked into an independent test executable.

#import <GHUnitIOS/GHUnit.h>
#import <UIKit/UIKit.h>
#import <OCMock/OCMock.h>
#import "SocializeObjectFactory.h"
#import <SZJSONKit/JSONKit.h>

@interface SocializeObjectFormatterTests : GHTestCase 
{
  
    SocializeObjectFactory * _factory;  //We should mock this.
}  

- (void)setUpClass;
- (void)tearDownClass;
- (id)mockFactory;

//Helper methods: put these in a unitTestHelper Category for Formatters

-(NSString *)helperGetJSONStringFromFile:(NSString *)fileName;

@end
