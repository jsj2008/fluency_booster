//
//  KKFluencyBoosterSelectionViewController.m
//  Fluency Booster
//
//  Created by Arthur Rocha de Menezes on 06/08/12.
//  Copyright (c) 2012 Arthur Rocha de Menezes. All rights reserved.
//

#import "KKFluencyBoosterSelectionViewController.h"

#import "KKRootViewController.h"
#import "KKAppDelegate.h"

#import "KKHelpViewController.h"

@interface KKFluencyBoosterSelectionViewController ()

@property(strong) NSArray* fluencyBoosters;
@property (strong, nonatomic) IBOutlet UITableView *fluencyBoosterTableView;
@property (strong, nonatomic) IBOutlet UIImageView *introHelpImageView;
@property (strong, nonatomic) IBOutlet UIImageView *footerImageView;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation KKFluencyBoosterSelectionViewController

@synthesize fluencyBoosterTableView;

@synthesize fluencyBoosters;
@synthesize introHelpImageView;
@synthesize footerImageView;
@synthesize headerImageView;
@synthesize backgroundImageView;

@synthesize managedObjectContext;

//NSString* const helpViewControllerIdentifier = @"KKHelpViewController";

-(id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder]))
	{
		KKAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = appDelegate.managedObjectContext;
        
        NSFetchRequest* fetchRequest = [[NSFetchRequest alloc]init];
        NSEntityDescription* entity = [NSEntityDescription entityForName:@"KKFluencyBooster" inManagedObjectContext:self.managedObjectContext];
        fetchRequest.entity = entity;
        NSError* erro;
        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        NSArray* sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        self.fluencyBoosters = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&erro] sortedArrayUsingDescriptors:sortDescriptors];
	}
	return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    //Make the background of the table view transparent
    //We can set the fluencyBoosterTableView.backgroundView to a ImageView.
    self.fluencyBoosterTableView.backgroundView = nil;
    
    self.headerImageView.image = [UIImage imageWithContentsOfFile:[self.screenPath stringByAppendingPathComponent:@"headerSelection.png"]];
    self.backgroundImageView.image = [UIImage imageWithContentsOfFile:[self.screenPath stringByAppendingPathComponent:@"backgroundFluencyBoosterSelection.png"]];
    self.footerImageView.image = [UIImage imageWithContentsOfFile:[self.screenPath stringByAppendingPathComponent:@"footer.png"]];
    self.introHelpImageView.image = [UIImage imageWithContentsOfFile:[self.helpPath stringByAppendingPathComponent:@"openHelp.png"]];
    
    self.helpImageFileNameWithExtension = @"help1.png";
}

- (void)viewDidUnload
{
    [self setFluencyBoosterTableView:nil];
    [self setIntroHelpImageView:nil];
    [self setFooterImageView:nil];
    [self setHeaderImageView:nil];
    [self setBackgroundImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqual:@"PushFluencyBooster"]) {
        KKRootViewController* destinationController = segue.destinationViewController;
        
        UITableViewCell* senderCell = sender;
        NSIndexPath* indexPath = [self.fluencyBoosterTableView indexPathForCell:senderCell];
        destinationController.fluencyBooster = [self.fluencyBoosters objectAtIndex:indexPath.section];
        
        destinationController.managedObjectContext = self.managedObjectContext;
        
        destinationController.title = [[self.fluencyBoosters objectAtIndex:indexPath.section] name];
    }
}

#pragma mark - UITableViewControllerDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.fluencyBoosters count];
//    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FluencyBoosterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = [[self.fluencyBoosters objectAtIndex:indexPath.section] name];
//    cell.textLabel.backgroundColor = [UIColor clearColor];
//    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell.png"]];
    
    return cell;
}


#pragma mark - UITableViewControllerDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Make de selected cell blink after tapped.
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
