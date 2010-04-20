//  The ESNotebookController Packages is released under the MIT License.
//
//  Copyright 2010 (c) Eric J. Schweichler - http:ericschweichler.info
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

#import "ESNotebookController.h"

@implementation ESNotebookController

@synthesize notebookIndex;
@synthesize numberOfNotes;
@synthesize notebookTitle, noteTitle, noteText, noteDate;
@synthesize disableEmail, disableDelete, disableEdit, disableClose, useWithTabbar;
@synthesize notebookTitleLabel, noteTitleLabel, noteTextView;
@synthesize leftButton, rightButton, prevNoteButton, nextNoteButton, emailNoteButton, deleteNoteButton, closeNoteButton, insertDateButton, tools;

@synthesize delegate;

- (void)retrieveTitleNoteAndDateAtIndex:(NSInteger) index{
	if(self.delegate != NULL) {
		noteTitle = ([self.delegate respondsToSelector:@selector(notebookController:titleForNoteAtIndex:)]) ? [delegate notebookController:self titleForNoteAtIndex:index] : nil;
		noteText = ([self.delegate respondsToSelector:@selector(notebookController:textForNoteAtIndex:)]) ? [delegate notebookController:self textForNoteAtIndex:index] : nil;
		noteDate = ([self.delegate respondsToSelector:@selector(notebookController:dateForNoteAtIndex:)]) ? [delegate notebookController:self dateForNoteAtIndex:index] : nil;
	
		noteTitleLabel.text = noteTitle;
		noteTextView.text = noteText;
	}
}

- (void)doneEditingNote {
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(notebookController:didFinishWithNote:atIndex:)]) {
		[noteTextView resignFirstResponder];
		[self setEditing:NO animated:NO];
		[self.delegate notebookController:self didFinishWithNote:noteTextView.text atIndex:notebookIndex];
		rightButton.hidden = YES;
	} 
}

-(void)cancelEditingNote {
	if(self.delegate != NULL && [self.delegate respondsToSelector:@selector(notebookController:didFinishWithNote:atIndex:)]) {
		[noteTextView resignFirstResponder];
		[self setEditing:NO animated:NO];
		[self.delegate notebookController:self didFinishWithNote:nil atIndex:notebookIndex];
	}
}

- (void)viewDidLoad {
	leftButton.titleLabel.text = NSLocalizedString(@"Close",@"Close button for Notebook");
	rightButton.titleLabel.text = NSLocalizedString(@"Done",@"Done button for Notebook");
	if(self.delegate != NULL && [self.delegate respondsToSelector:@selector(titleForNotebookController:)]) {
		notebookTitle = [delegate titleForNotebookController:self];
		notebookTitleLabel.text = notebookTitle;
	}
	
	if(self.delegate != NULL && [self.delegate respondsToSelector:@selector(numberOfNotesInNotebookController:)]) {
		numberOfNotes = [delegate numberOfNotesInNotebookController:self];
	}
	
	if(notebookIndex < 0 || notebookIndex > numberOfNotes) notebookIndex = 0;

	if(notebookIndex < numberOfNotes - 1) nextNoteButton.hidden = NO;
	
	if(notebookIndex > 0) prevNoteButton.hidden = NO;
	
	if(numberOfNotes) {
		
		if(![MFMailComposeViewController canSendMail]) emailNoteButton.enabled = NO;
		
		if(!disableEmail) emailNoteButton.hidden = NO;
		
		if(disableEdit) {
			noteTextView.editable = NO;
			disableDelete = YES;
		}
		
		if(!disableDelete) deleteNoteButton.hidden = NO;
		
		if(disableClose) closeNoteButton.hidden = YES;
		
		if(useWithTabbar) {
			tools.center = CGPointMake(tools.center.x,tools.center.y - 54);
			
			noteTextView.frame = CGRectMake(20, 98, 300, 294);
			CGRect viewFrame = noteTextView.frame;

			viewFrame.size.height -= 44;
			noteTextView.frame = viewFrame;
		}
		
		[self retrieveTitleNoteAndDateAtIndex:notebookIndex];
	}
}
	
- (void)viewDidUnload {
	[noteTitle release];
	noteTitle = nil;
	[noteText release];
	noteText = nil;
	[noteDate release];
	noteDate = nil;
}

- (void)dealloc {
	[super dealloc];
}

-(void)setEditing:(BOOL)editing animated:(BOOL) animated {
	if (editing) {
		rightButton.hidden = NO;
		insertDateButton.hidden = NO;
	}
	else {
		rightButton.hidden = YES;
		insertDateButton.hidden = YES;
	}
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	[self setEditing:YES animated:NO];
	return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
	CGRect viewFrame = [textView frame];
	if(useWithTabbar) viewFrame.size.height -= 96;
	else viewFrame.size.height -= 132;
    textView.frame = viewFrame;
}


- (void)textViewDidEndEditing:(UITextView *)textView {
    CGRect viewFrame = [textView frame];
    if(useWithTabbar) viewFrame.size.height += 96;
	else viewFrame.size.height += 132;
    textView.frame = viewFrame;
}

- (IBAction)insertDate {
	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateFormat:@"dd/MMM/yyyy"];
	[noteTextView insertText:[dateFormat stringFromDate:[NSDate date]]];
}

- (void)nextNote {
	notebookIndex++;
	[self retrieveTitleNoteAndDateAtIndex:notebookIndex];

	if (notebookIndex == numberOfNotes-1) nextNoteButton.enabled = NO;
	prevNoteButton.enabled = YES;

	if (notebookIndex == numberOfNotes-1) nextNoteButton.hidden = YES;;
	prevNoteButton.hidden = NO;;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationWillStartSelector:@selector(transitionWillStart:finished:context:)];
	[UIView setAnimationDidStopSelector:@selector(transitionDidStop:finished:context:)];
	// other animation properties
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp 
						   forView:self.view cache:NO];
	// set view properties
	[UIView commitAnimations];	
}

- (void)prevNote {
	notebookIndex--;
	[self retrieveTitleNoteAndDateAtIndex:notebookIndex];

	if (notebookIndex == 0) prevNoteButton.enabled = NO;
	nextNoteButton.enabled = YES;

	if (notebookIndex == 0) prevNoteButton.hidden = YES;;
	nextNoteButton.hidden = NO;;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationWillStartSelector:@selector(transitionWillStart:finished:context:)];
	[UIView setAnimationDidStopSelector:@selector(transitionDidStop:finished:context:)];
	// other animation properties
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown 
						   forView:self.view cache:NO];
	// set view properties
	[UIView commitAnimations];	

}

- (void)mailNote {
	if ([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
		picker.mailComposeDelegate = self;
		picker.navigationBar.barStyle = UIBarStyleBlack;
		
		if(self.delegate != NULL && [self.delegate respondsToSelector:@selector(emailAddressForNotebookController:)]) {
			NSString *email = [delegate emailAddressForNotebookController:self];
			if([email length] != 0) [picker setToRecipients:[NSArray arrayWithObject:email]];
		}
		// get user's email address from settings and insert it into the email

		[picker setSubject:noteTitle];
		
		// Fill out the email body text
		[picker setMessageBody:noteTextView.text isHTML:NO];
		
		[self presentModalViewController:picker animated:YES];
		[picker release];
	}
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)deleteNote {
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(notebookController:didDeleteNote:atIndex:)]) {
		[self.delegate notebookController:self didDeleteNote:nil atIndex:notebookIndex];
		noteTextView.text = nil;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:1];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationWillStartSelector:@selector(transitionWillStart:finished:context:)];
		[UIView setAnimationDidStopSelector:@selector(transitionDidStop:finished:context:)];
		// other animation properties
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp 
							   forView:self.view cache:NO];
		// set view properties
		[UIView commitAnimations];	
	}
}

- (void)vibrate {
	AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}

-(void)confirmDelete{
	[self vibrate];
	UIActionSheet *deleteSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self
													cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel")
											   destructiveButtonTitle:NSLocalizedString(@"Delete",@"Delete confirm delete button")
													otherButtonTitles:nil];

	[deleteSheet showInView:self.view];
	[deleteSheet setBounds:CGRectMake(0,0,320, 200)];
	[deleteSheet release];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[self deleteNote];
	}
	else { // cancel
		
	}	
}

@end

@interface UIResponder(UIResponderInsertTextAdditions)
- (void) insertText: (NSString*) text;
@end

@implementation UIResponder(UIResponderInsertTextAdditions)

- (void) insertText: (NSString*) text
{
	// Get a refererence to the system pasteboard because that's
	// the only one @selector(paste:) will use.
	UIPasteboard* generalPasteboard = [UIPasteboard generalPasteboard];
	
	// Save a copy of the system pasteboard's items
	// so we can restore them later.
	NSArray* items = [generalPasteboard.items copy];
	
	// Set the contents of the system pasteboard
	// to the text we wish to insert.
	generalPasteboard.string = text;
	
	// Tell this responder to paste the contents of the
	// system pasteboard at the current cursor location.
	[self paste: self];
	
	// Restore the system pasteboard to its original items.
	generalPasteboard.items = items;
	
	// Free the items array we copied earlier.
	[items release];
}

@end
