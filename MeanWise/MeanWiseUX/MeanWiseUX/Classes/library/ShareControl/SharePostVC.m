//
//  SharePostVC.m
//  MeanWiseUX
//
//  Created by Hardik on 08/06/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "SharePostVC.h"
#import "Constant.h"
#import "FTIndicator.h"
#import "ShareDialogue.h"
#import "DataSession.h"

@implementation SharePostVC

-(void)shareOn:(NSDictionary *)dict andNetwork:(int)network withVC:(ViewController *)vc
{
    NSString *text=[dict valueForKey:@"text"];
    mainVCRef=vc;
    
    if(network==0)
    {
        [DataSession sharedInstance].SocialshareStatus=[NSNumber numberWithInteger:1];
        
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
            SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [mySLComposerSheet setInitialText:text];
            
            [mySLComposerSheet addImage:[UIImage imageNamed:@"myImage.png"]];
            
            //        [mySLComposerSheet addURL:[NSURL URLWithString:@"http://stackoverflow.com/questions/12503287/tutorial-for-slcomposeviewcontroller-sharing"]];
            
            [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                
                [DataSession sharedInstance].SocialshareStatus=[NSNumber numberWithInteger:0];
                
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"Post Canceled");
                        break;
                    case SLComposeViewControllerResultDone:
                        NSLog(@"Post Sucessful");
                        break;
                        
                    default:
                        break;
                }
            }];
            
            [vc presentViewController:mySLComposerSheet animated:YES completion:nil];
        }
    }
    else if(network==1)
    {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            
            [DataSession sharedInstance].SocialshareStatus=[NSNumber numberWithInteger:1];
            
            SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            [mySLComposerSheet setInitialText:text];
            
            [mySLComposerSheet addImage:[UIImage imageNamed:@"myImage.png"]];
            
            //            [mySLComposerSheet addURL:[NSURL URLWithString:@"http://stackoverflow.com/questions/12503287/tutorial-for-slcomposeviewcontroller-sharing"]];
            
            [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                
                [DataSession sharedInstance].SocialshareStatus=[NSNumber numberWithInteger:0];
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"Post Canceled");
                        break;
                    case SLComposeViewControllerResultDone:
                        NSLog(@"Post Sucessful");
                        break;
                        
                    default:
                        break;
                }
            }];
            
            [vc presentViewController:mySLComposerSheet animated:YES completion:nil];
        }
        
        
    }
    else if(network==2)
    {
        
        if ([MFMailComposeViewController canSendMail])
        {
            [DataSession sharedInstance].SocialshareStatus=[NSNumber numberWithInteger:1];

            mail = [[MFMailComposeViewController alloc] init];
            mail.mailComposeDelegate = self;
            [mail setMessageBody:text isHTML:NO];
            
//            NSData *jpegData = UIImageJPEGRepresentation(emailInstance.imageAttachment, 1.0);
            
//            NSString *fileName = @"Attachment.jpeg";
//            fileName = [fileName stringByAppendingPathExtension:@"jpeg"];
//            [mail addAttachmentData:jpegData mimeType:@"image/jpeg" fileName:fileName];
            
            
            [mail setSubject:text];
            [vc presentViewController:mail animated:YES completion:nil];
            
            
            //          [controller presentViewController:mail animated:YES completion:NULL];
            //            [mail dismissPopoverAnimated:YES];
            
        }
        else
        {
            [FTIndicator showToastMessage:@"Not able send Email."];

        }

        

        //Email
    }
    else if(network==3)
    {
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString:text];
        
        [FTIndicator showToastMessage:@"Copied to clipboard"];
        
        //Copy
    }
    else if(network==4)
    {
        if([MFMessageComposeViewController canSendText])
        {
            [DataSession sharedInstance].SocialshareStatus=[NSNumber numberWithInteger:1];

            messageController = [[MFMessageComposeViewController alloc] init];

            messageController.body = text;
            // messageController.recipients = [NSArray arrayWithObjects:@"1(234)567-8910", nil];
            messageController.messageComposeDelegate = self;
            
            
           /* if(smsInstance.imageAttachment!=nil)
            {
                NSData *imgData = UIImageJPEGRepresentation(smsInstance.imageAttachment, 1.0);
                
                
                
                BOOL didAttachImage=[messageController addAttachmentData:imgData typeIdentifier:@"image/jpg" filename:@"Tangotab.jpg"];
                
                if (didAttachImage) {
                    NSLog(@"Image Attached.");
                    
                } else {
                    NSLog(@"Image Could Not Be Attached.");
                }
                
                
            }*/
            [vc presentViewController:messageController animated:YES completion:nil];
            
            
            
        }
        else
        {
            [FTIndicator showToastMessage:@"Not able send SMS."];

        }
        

        //sms
    }
    
    

}

- (void)mailComposeController:(MFMailComposeViewController *)controller1 didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [mainVCRef dismissViewControllerAnimated:YES completion:NULL];
    [DataSession sharedInstance].SocialshareStatus=[NSNumber numberWithInteger:0];

    switch (result) {
        case MFMailComposeResultSent:
            
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            //    [self showAlertWithTitle:@"" andMessage:@"Email cancelled."];
            break;
        case MFMailComposeResultFailed:
            
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [DataSession sharedInstance].SocialshareStatus=[NSNumber numberWithInteger:0];
    [mainVCRef dismissViewControllerAnimated:YES completion:NULL];

    
    switch (result) {
        case MessageComposeResultSent:
            NSLog(@"Message sent");
            
            break;
        case MessageComposeResultCancelled:
            //  [self showAlertWithTitle:@"Error!" andMessage:@"SMS cancelled."];
            NSLog(@"Message Cancelled");

            break;
            
        case MessageComposeResultFailed:
            NSLog(@"Message Failed");

            break;
            
        default:
            NSLog(@"Message Other");

            break;
    }
    
    
}

@end
