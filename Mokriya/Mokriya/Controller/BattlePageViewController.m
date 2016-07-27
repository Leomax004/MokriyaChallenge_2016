

#import "BattlePageViewController.h"
#import "Information.h"
#import "UserTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ResultViewController.h"

@interface BattlePageViewController () <UITableViewDelegate,UITableViewDataSource>


-(void)jsonRead :(void (^)(NSArray *array, NSError *error))callback;
@property (strong,nonatomic) NSMutableArray *userArray;
@property(nonatomic,strong)NSMutableArray *participants;
@property(nonatomic)BOOL checkBoxSelected;
@end

@implementation BattlePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.userArray = [[NSMutableArray alloc]init];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]]];
    //[self.view setBackgroundColor:[UIColor orangeColor]];
    self.participants = [[NSMutableArray alloc]init];
    self.userListTableView.pagingEnabled = YES;
    self.userListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.userListTableView setBackgroundColor:[UIColor clearColor]];
    
    
[self jsonRead:^(NSArray *array, NSError *error) {
    
    [self.userArray addObjectsFromArray:array];
    
    [self.userListTableView reloadData];
}];

    self.userListTableView.delegate = self;
   
    self.userListTableView.dataSource = self;
    
    
    [self.userListTableView setBackgroundColor:[UIColor clearColor]];
    
    [self.userListTableView reloadData];
    
    [self.userListTableView setShowsVerticalScrollIndicator:NO];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.userArray count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat tableBorderLeft = self.view.frame.origin.x + 10;
    CGFloat tableBorderRight = self.view.frame.size.width - 20;
    
    CGRect tableRect = self.userListTableView.frame;
    tableRect.origin.x = tableBorderLeft;
    tableRect.size.width = tableBorderRight;
    tableView.frame = tableRect;
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
     UserTableViewCell *cell = (UserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    Information *obj = [self.userArray objectAtIndex:indexPath.section];
    cell.userName.text = obj.name;
    cell.rating.text = [NSString stringWithFormat:@"%@",obj.rating];
    [cell.layer setCornerRadius:5];
    [cell.layer setMasksToBounds:YES];
    
   
    
    [cell.selectButton addTarget:self action:@selector(collectionViewCellButtonPressed:)forControlEvents:UIControlEventTouchUpInside];

    
    
    return  cell;
}

- (void)collectionViewCellButtonPressed:(UIButton *)sender
{
   
    NSLog(@"%ld",(long)sender.tag);
    NSIndexPath *indexPath = [self.userListTableView indexPathForCell:(UITableViewCell *)sender.superview.superview];
    NSLog(@"located at index--->%ld",(long)indexPath.section);
    
   

    
    
}
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath {
    
    [theTableView deselectRowAtIndexPath:[theTableView indexPathForSelectedRow] animated:NO];
    UserTableViewCell *cell = [theTableView cellForRowAtIndexPath:newIndexPath];
    
   
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        if([self.participants count] < 2)
        {
         
            [self.participants addObject:[self.userArray objectAtIndex:newIndexPath.section]];
             [cell.selectButton setImage:[UIImage imageNamed:@"Checked Checkbox-64.png"] forState:UIControlStateNormal];
        }
        else
        {
            NSLog(@"over flow");
        }
        // Reflect selection in data model
    } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
      
        [self.participants removeObject:[self.userArray objectAtIndex:newIndexPath.section]];
        [cell.selectButton setImage:[UIImage imageNamed:@"Unchecked Checkbox-64.png"] forState:UIControlStateNormal];
        

        // Reflect deselection in data model
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 110;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.; // you can have your own choice, of course
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}




#pragma mark - Json

-(void)jsonRead :(void (^)(NSArray *array, NSError *error))callback
{
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"userList" ofType:@"json"];
    
    if (fileName) {
        NSLog(@"File received");
        NSData *partyData = [[NSData alloc] initWithContentsOfFile:fileName];
        NSError *error;
        NSDictionary *party = [NSJSONSerialization JSONObjectWithData:partyData
                                                              options:0
                                                                error:&error];
        if (!error)
        {
            NSArray *totalUsers = [party objectForKey:@"legends"];
            NSLog(@"Total no of users %ld",[totalUsers count]);
            NSMutableArray *array2 = [[NSMutableArray alloc]init];
            
            
            
            for(  int  i = 0; i < [totalUsers count]; i++ )
           {
                Information *info = [[Information alloc] init];
                NSDictionary *dic = [totalUsers objectAtIndex:i];
                info.name = [dic objectForKey:@"name"];
                info.rating = [dic objectForKey:@"rating"];
                [array2 addObject:info];
               
            }
            Information *objUser = nil;
           
            if([array2 count] > 0)
               
           {
               objUser = (Information *)array2[0];
            }
           
           callback(array2, nil);
            
        }
        else
        {
            callback(nil, error);
            NSLog(@"Something went wrong! %@", error.localizedDescription);
        }
        
    }
    else {
        NSLog(@"Couldn't find file!");
    }
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)playButton:(id)sender {
    
    if([self.participants count] == 2 )
    {
     ResultViewController *resultView = [[ResultViewController alloc]init];
    
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    
    for(int i=0; i < [self.participants count]; i++)
    {
        Information *obj = [self.participants objectAtIndex:i];
        NSLog(@"Name--->%@ score--->%@",obj.name,obj.rating);
        [temp addObject:obj.rating];
        
    }
    [resultView setIdArray:temp];
    [self.participants removeAllObjects];
    [self presentViewController:resultView animated:YES completion:nil];
    
    }
    else
    {
        NSLog(@"less layers");
    }
}
@end
