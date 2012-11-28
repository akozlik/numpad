//
//  ViewController.h
//  Numpad
//
//  Created by Andrew on 11/27/12.
//  Copyright (c) 2012 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIAlertViewDelegate>
{
    IBOutlet UITextField *textField;
    IBOutlet UIButton *convertButton;
    NSDictionary *dictLetterTable;
}

-(IBAction)buttonPressed:(id)sender;

@end
