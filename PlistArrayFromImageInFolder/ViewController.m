//
//  ViewController.m
//  PlistArrayFromImageInFolder
//
//  Created by Alcanzar Soft on 23/10/13.
//  Copyright (c) 2013 Alcanzar Soft. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

}

- (NSString *) pathForProjectFolder : (NSString *) projectFolderName{
    return [kPathForDesktop stringByAppendingPathComponent:projectFolderName];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *) pathForDocumentDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (IBAction)checkForImages:(id)sender {
    if (![_projectFolderTextField.text length]) {
        [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please enter folder name!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    
    [_projectFolderTextField resignFirstResponder];
    _projectFolderName = [self pathForProjectFolder:_projectFolderTextField.text];
    
    //create a folder at path
    NSString *dataFolderPath = [kPathForDesktop stringByAppendingFormat:@"Data_%@", _projectFolderTextField.text];//where modified data will be stored
    [[NSFileManager defaultManager] createDirectoryAtPath:dataFolderPath withIntermediateDirectories:NO attributes:nil error:nil];
    NSString *pathForImageFolder = [dataFolderPath stringByAppendingString:@"/ProjectImages"];
    [[NSFileManager defaultManager] createDirectoryAtPath:pathForImageFolder withIntermediateDirectories:NO attributes:nil error:nil];
    
    //retrive file names
    NSArray *fileNamesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_projectFolderName error:nil];
    NSMutableArray *randomizeArray = [NSMutableArray array];
    NSLog(@"fileNamesArray = %@", fileNamesArray);
    
    //randomize file names
    for (int i = 0; i < [fileNamesArray count]; i++) {
        NSString *fileName = [fileNamesArray objectAtIndex:i];
        UIImage *image = [UIImage imageWithContentsOfFile:[_projectFolderName stringByAppendingPathComponent:fileName]];
        
        //remove instruction
        while (![[fileName pathExtension] isEqualToString:@""]) {
            fileName = [fileName stringByDeletingPathExtension];
            fileName = [fileName lowercaseString];
        }
        [fileName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        NSString *newString = [fileName stringByReplacingOccurrencesOfString:@" " withString:@""];
        newString = [newString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        if ([newString length] > 14)
            continue;
        
        //save images
        NSString *imagePath = [pathForImageFolder stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:@"png"]];
        
        [self performSelector:@selector(writeImage:ToFolder:) withObject:image withObject:imagePath];
        
        //capitalize the string
        fileName = [fileName uppercaseString];
        [randomizeArray addObject:fileName];
    }
  
    //randomize data
    int countOfArray = (int)[randomizeArray count];
    for (int i = countOfArray - 1; i > 0; i--) {
        int j = arc4random() % (i+1);
        [randomizeArray exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    
    NSLog(@"randomizeArray = %@", randomizeArray);
    
    //write file to desktop
    [randomizeArray writeToFile:[dataFolderPath stringByAppendingString:[NSString stringWithFormat:@"/%@",kPlistFileName]] atomically:YES];
}

- (void) writeImage : (UIImage *) image ToFolder : (NSString *) imagePath{
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
}

@end