//
//  ViewController.m
//  Numpad
//
//  Created by Andrew on 11/27/12.
//  Copyright (c) 2012 Andrew. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Define a dictionary for easy lookup
    // For those familar with Associative arrays, this works in a similar fashion
    // I can call: [dictLetterTable objectForKey:@"A"]
    // And it will return "2"
    dictLetterTable = [[NSDictionary alloc] initWithObjectsAndKeys:@"2", @"A", @"2", @"B", @"2", @"C", @"3", @"D", @"3", @"E", @"3", @"F", @"4", @"G", @"4", @"H", @"4", @"I", @"5", @"J", @"5", @"K", @"5", @"L", @"6", @"M", @"6", @"N", @"6", @"O", @"7", @"P", @"7", @"Q", @"7", @"R", @"7", @"S", @"8", @"T", @"8", @"U", @"8", @"V",  @"9", @"W", @"9", @"X", @"9", @"Y", @"9", @"Z",  nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Method is called when button is pressed. IBAction allows us to link to the action from the xib
-(IBAction)buttonPressed:(id)sender
{
    // Grab the converted version of the string
    NSString *convertedString = [self getPhoneNumberFromString:textField.text];
    
    // Format it in a way that looks pretty
    convertedString = [self formatPhoneNumberWithString:convertedString];
    
    // Prompt the user to see if they should call
    // Note the delegate is set to 'self'. This allows us to use the alertView delegate methods to detect which button was pressed
    NSString *message = [NSString stringWithFormat:@"Call %@?", convertedString];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    // Show the alert
    [alertView show];
}

// This method does the heavy lifting of replacing all letters with numbers
-(NSString *)getPhoneNumberFromString:(NSString *)string
{
    // Remove all non alphanumericcharacters
    string = [self stripNonAlphaNumericFromString:string];
    
    // Get the string length
    int strLen = [string length];
    
    // Loop through each character
    for (int i = 0; i < strLen; i++)
    {
        char character = [string characterAtIndex:i];
        
        // Use built in C method to check if character is not a digit
        if (!isdigit(character))
        {
            // If it's not, we convert the character to a string...
            NSString *characterString = [NSString stringWithFormat:@"%c", character];
            
            // Then find the corresponding number
            NSString *number = [dictLetterTable objectForKey:characterString];
            
            // Then replace all occurrences of that letter with the replacement number
            string = [string stringByReplacingOccurrencesOfString:characterString withString:number];
            
            // NOTE: This is less than optimal, as we could technical check to see if there are any letters remaining to be converted. I didn't worry about that for this exercise, but it's somethign to be aware of.
        }
    }
    
    return string;
}

// This method takes in a string and returns only letters and numbers
-(NSString *)stripNonAlphaNumericFromString:(NSString *)string
{
    // We are using the alphanumeric character set, but using the INVERTED set
    // This means we are buildign a character set of all NON Alphanumeric characters
    NSCharacterSet *alphanumericSet = [[ NSCharacterSet alphanumericCharacterSet ] invertedSet];
    
    // We replace all nonalphanumeric characters with a blank
    string = [ [ string componentsSeparatedByCharactersInSet:alphanumericSet ] componentsJoinedByString:@"" ];
    
    return string;
}

// This method just makes our phone numbers look pretty
-(NSString *)formatPhoneNumberWithString:(NSString *)string
{
    int length = [string length];

    // If the number is something like 5551234, return 555-1234
    if(length == 7)
    {
        string = [NSString stringWithFormat:@"%@-%@",[string substringToIndex:3],[string substringFromIndex:3]];
    } else if (length == 10)
    // If we have something like 5551234567, return (555) 123-4567
    {
        // This range specifies the first three characters from index 3 in the string
        // This corresponds to positions 4, 5, and 6
        NSRange range = NSMakeRange(3, 3);

        // If you don't understand substrings I would highly recommend looking them up on Google. It's a very simple concept once you take a look at it. You're basically taking a subset of characters from a string
        string = [NSString stringWithFormat:@"(%@) %@-%@",[string substringToIndex:3],[string substringWithRange:range], [string substringFromIndex:6]];
    }
    
    // NOTE: Substring can seem tricky when you're first started
    
    return string;
}

// This delegate method is called when the user chooses whether or not to call
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // The user selected yes
    if (buttonIndex == 1)
    {
        // Check to see if we can even make a phone call
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]])
        {
            // Format a string using the tel:// protocol and the phone number
            NSString *urlString = [NSString stringWithFormat:@"tel://%@", [self stripNonAlphaNumericFromString:textField.text]];
            
            // Open the telephone number in the phone application
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        } else
        // If we can't call, let the user know
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Your device cannot make phone calls" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        }
    }
}

@end
