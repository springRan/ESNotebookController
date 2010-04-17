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

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol ESNotebookControllerDelegate;

@interface ESNotebookController : UIViewController <UIActionSheetDelegate, UITextViewDelegate, MFMailComposeViewControllerDelegate> {

	NSInteger numberOfNotes;
	NSInteger notebookIndex;
	NSString *notebookTitle;
	NSString *noteTitle;
	NSString *noteText;
	NSDate *noteDate;
	BOOL disableEmail;
	BOOL disableDelete;
	BOOL disableEdit;
	BOOL disableClose;
	BOOL useWithTabbar;
	
	IBOutlet UILabel *notebookTitleLabel;
	IBOutlet UILabel *noteTitleLabel;
	IBOutlet UITextView *noteTextView;
	IBOutlet UIButton *leftButton;
	IBOutlet UIButton *rightButton;
	IBOutlet UIButton *nextNoteButton;
	IBOutlet UIButton *prevNoteButton;
	IBOutlet UIButton *emailNoteButton;
	IBOutlet UIButton *deleteNoteButton;
	IBOutlet UIButton *closeNoteButton;
	IBOutlet UIButton *insertDateButton;
	IBOutlet UIView *tools;
	
	id<ESNotebookControllerDelegate> delegate;
}

@property (nonatomic) NSInteger numberOfNotes;
@property (nonatomic) NSInteger notebookIndex;
@property (nonatomic,retain) NSString *notebookTitle;
@property (nonatomic,retain) NSString *noteTitle;
@property (nonatomic,retain) NSString *noteText;
@property (nonatomic,retain) NSDate *noteDate;
@property (nonatomic) BOOL disableEmail;
@property (nonatomic) BOOL disableDelete;
@property (nonatomic) BOOL disableEdit;
@property (nonatomic) BOOL disableClose;
@property (nonatomic) BOOL useWithTabbar;

@property (assign) UILabel *notebookTitleLabel;
@property (assign) UILabel *noteTitleLabel;
@property (assign) UITextView *noteTextView;
@property (assign) UIButton *leftButton;
@property (assign) UIButton *rightButton;
@property (assign) UIButton *prevNoteButton;
@property (assign) UIButton *nextNoteButton;
@property (assign) UIButton *emailNoteButton;
@property (assign) UIButton *deleteNoteButton;
@property (assign) UIButton *closeNoteButton;
@property (assign) UIButton *insertDateButton;
@property (assign) UIView *tools;

@property (assign) id<ESNotebookControllerDelegate> delegate;

- (IBAction)doneEditingNote;
- (IBAction)cancelEditingNote;
- (IBAction)prevNote;
- (IBAction)nextNote;
- (IBAction)mailNote;
- (IBAction)confirmDelete;
- (IBAction)insertDate;
- (void)deleteNote;
- (void)retrieveTitleNoteAndDateAtIndex:(NSInteger) anIndex;
- (void)vibrate;

@end

@protocol ESNotebookControllerDelegate <NSObject>
@optional
- (NSInteger)numberOfNotesInNotebookController:(ESNotebookController *) notebookController;
- (void)notebookController:(ESNotebookController *)notebookController didFinishWithNote:(NSString *)note atIndex:(NSInteger) index;
- (void)notebookController:(ESNotebookController *)notebookController didDeleteNote:(NSString *)note atIndex:(NSInteger) index;

- (NSString *)titleForNotebookController:(ESNotebookController *)notebookController;
- (NSDate *)notebookController:(ESNotebookController *)notebookController dateForNoteAtIndex:(NSInteger) index;
- (NSString *)notebookController:(ESNotebookController *)notebookController titleForNoteAtIndex:(NSInteger) index;
- (NSString *)notebookController:(ESNotebookController *)notebookController textForNoteAtIndex:(NSInteger) index;
- (NSString *)emailAddressForNotebookController:(ESNotebookController *)notebookController;
@end


