//
//  ViewController.m
//  HomePwner
//
//  Created by Leonard Bogdonoff on 10/22/14.
//  Copyright (c) 2014 New Public Art Foundation. All rights reserved.
//

#import "ATRDetailViewController.h"
#import "ATRItemsViewController.h"
#import "ATRItemStore.h"
#import "ATRItem.h"
#import "ATRItemCell.h"

@interface ATRItemsViewController ()

@property (nonatomic, strong) IBOutlet UIView *headerView;

@end

@implementation ATRItemsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ATRDetailViewController *detailViewController = [[ATRDetailViewController alloc] initForNewItem:NO];
    
    NSArray *items = [[ATRItemStore sharedStore] allItems];
    ATRItem *selectedItem = items[indexPath.row];
    
    // Give detail view controller a pointer to the item object in row
    detailViewController.item = selectedItem;
    
    // Push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (IBAction)addNewItem:(id)sender
{
    // Create a new ATRItem and add it to the store
    ATRItem *newItem = [[ATRItemStore sharedStore] createItem];
    
    ATRDetailViewController *detailViewController = [[ATRDetailViewController alloc] initForNewItem:YES];
    
    detailViewController.item = newItem;
   
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];

    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:navController animated:YES completion:NULL];
}

- (instancetype)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homepwner";
        
        // Create a new bar button itme that will send
        // addNewItem: to ATRItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                              target:self
                                                                              action:@selector(addNewItem:)];
        
        // Set this bar button item as the right item in the navigationItem
        navItem.rightBarButtonItem = bbi;
        
        navItem.leftBarButtonItem = self.editButtonItem;
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"ATRItemCell" bundle:nil];
    
    // Register this NIB, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ATRItemCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get a new or recycled cell
    ATRItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ATRItemCell"
                                                        forIndexPath:indexPath];
    
    NSArray *items = [[ATRItemStore sharedStore] allItems];
    ATRItem *item = items[indexPath.row];

    // configure the cell with the ATRItem
    cell.nameLabel.text = item.itemName;
    cell.serialNumberLabel.text = item.serialNumber;
    cell.valueLabel.text = [NSString stringWithFormat:@"$%d", item.valueInDollars];
    
    cell.thumbnailView.image = item.thumbnail;
   
    cell.actionBlock = ^{
        NSLog(@"Going to show image for %@", item);
    };
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ATRItemStore sharedStore] allItems] count];
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[ATRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row
                                        toIndex:destinationIndexPath.row];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                                            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete){
        NSArray *items = [[ATRItemStore sharedStore] allItems];
        ATRItem *item = items[indexPath.row];
        [[ATRItemStore sharedStore] removeItem:item];
        
        // Also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}


@end
