//
//  ViewController.h
//  PlistArrayFromImageInFolder
//
//  Created by Alcanzar Soft on 23/10/13.
//  Copyright (c) 2013 Alcanzar Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPathForDesktop  @"Users/arpitawasthi/Desktop/"
#define kImageFolderName @"ProjectImages"
#define kPlistFileName   @"puzzlelist.plist"

@interface ViewController : UIViewController

@property (strong, nonatomic) NSString *projectFolderName;
@property (strong, nonatomic) IBOutlet UITextField *projectFolderTextField;

- (IBAction)checkForImages:(id)sender;
@end
