//
//  VerPopularesViewController.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 16/11/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "VerPopularesViewController.h"
#import"UIImageView+AFNetworking.h"

@interface VerPopularesViewController ()

@end

@implementation VerPopularesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

@synthesize ViewFotos;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.topItem.title=@"Populares";
    
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:0.35 green:0.67 blue:0.985 alpha:1];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}


- (void)viewDidLoad
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.topItem.title=@"Populares";
    
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:0.35 green:0.67 blue:0.985 alpha:1];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    

    
    self.tableView.delegate=self;
    
    
    
    [self imagenes];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagenes{
    
    NSLog(@"Obteniendo datos");
    NSDate *myDate = [NSDate date];
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"dd"];
    
    NSString * tokenID = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    NSString * usuarioID = [[NSUserDefaults standardUserDefaults] stringForKey:@"ID_usuario"];
    
    NSString *post1 =[NSString stringWithFormat:@"id=%@",usuarioID];
    NSString *post2 =[NSString stringWithFormat:@"&vez=0"];
    NSString *post3=[NSString stringWithFormat:@"&date=%@",[df stringFromDate:myDate]];
    NSString *post4=[NSString stringWithFormat:@"&token=%@",tokenID];
    NSString *post5 =[NSString stringWithFormat:@"&idF=%@",usuarioID];
    NSString *post6 =[NSString stringWithFormat:@"&perfil=3"];
    
    
    
    NSString *hostStr = @"http://lanchosoftware.es/phc/downloadImage.php?";
    hostStr = [hostStr stringByAppendingString:post1];
    
    hostStr = [hostStr stringByAppendingString:post3];
    hostStr = [hostStr stringByAppendingString:post4];
    hostStr = [hostStr stringByAppendingString:post5];
    hostStr = [hostStr stringByAppendingString:post2];
    hostStr = [hostStr stringByAppendingString:post6];
    
    NSLog(@"%@ URL Imagenes",hostStr);
    
    
    /*
     
     self.flUploadEngine = [[fileUploadEngine alloc] initWithHostName:@"lanchosoftware.es" customHeaderFields:nil];
     [self.flUploadEngine cacheMemoryCost];
     
     
     __weak typeof(self) weakSelf = self;
     self.flOperation = [self.flUploadEngine postDataToServer:nil path:hostStr post:NO];
     [self.flOperation addCompletionHandler:^(MKNetworkOperation* operation) {
     
     
     if([operation isCachedResponse]) {
     NSLog(@"Data from cache");
     }
     else {
     NSLog(@"Data from server");
     }
     
     NSData *datas = [operation responseData];
     NSString *_key = @"alvarol2611995";
     
     
     _key= [_key stringByAppendingString:[df stringFromDate:myDate]];
     CCOptions padding = kCCOptionECBMode;
     NSString *string = [[NSString alloc] initWithData:datas encoding:NSASCIIStringEncoding];
     NSData *_secretData = [NSData dataWithBase64EncodedString:string];
     
     NSData *encryptedData = [crypto decrypt:_secretData  key:[_key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];
     
     NSString *returnString = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
     
     if ([returnString isEqualToString:@"No"]) {
     [ weakSelf.flUploadEngine cancelAllOperations];
     if ([ weakSelf.items count]==0) {
     [ weakSelf.carousel removeFromSuperview];
     }
     else{
     NSLog(@"Array: %@",  weakSelf.items);
     NSLog(@"Terminado numero: %lu", (unsigned long)[ weakSelf.items count]);
     // [timer invalidate];
     //   Imagen= [items objectAtIndex:3];
     //  Img.image=Imagen;
     vez=0;
     [ weakSelf.carousel reloadData];
     }
     
     
     }
     else{
     if (![self isJPEGValid:encryptedData]) {
     NSLog(@"Invalido");
     }
     UIImage *imagen =[[UIImage alloc]initWithData:encryptedData];
     if (imagen != nil) {
     [items addObject:imagen];
     NSLog(@"Imagen data: %lu , Vez: %d", (unsigned long)[encryptedData length], vez);
     }
     
     else{
     NSLog(@"Invalido NIL");
     }
     vez++;
     [self imagenes];
     
     }}
     
     errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
     NSLog(@"%@", error);
     UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Error"
     message:[error localizedDescription]
     delegate:nil
     cancelButtonTitle:@"Dismiss"
     otherButtonTitles:nil];
     [alert2 show];
     }];
     
     [self.flUploadEngine useCache];
     [self.flUploadEngine enqueueOperation:self.flOperation ];
     
     */
    __block int vez=0;
    terminado=NO;
    
    
    URLs = [[NSMutableArray alloc]init];
    
    [URLs removeAllObjects];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:hostStr]];
    
    NSOperationQueue *cola = [NSOperationQueue new];
    [NSURLConnection sendAsynchronousRequest:request queue:cola completionHandler:^(NSURLResponse *response, NSData *datas, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *  serverOutput = [[NSString alloc] initWithData:datas encoding: NSASCIIStringEncoding];
             int fotos = serverOutput.intValue;
             NSLog(@"Fotos Int : %d",fotos);
             while (vez<fotos) {
                 
                 NSString *vezS = [NSString stringWithFormat:@"%d", vez];
                 NSDate* myDate = [NSDate date];
                 NSDateFormatter *df = [NSDateFormatter new];
                 NSDateFormatter *dma = [NSDateFormatter new];
                 [df setDateFormat:@"dd"];
                 [dma setDateFormat:@"dd-mm-yyyy"];
                 
                 NSString* _key = @"alvarol2611995";
                 
                 
                 _key= [_key stringByAppendingString:[df stringFromDate:myDate]];
                 
                 NSString * tokenID = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
                 NSString * usuarioID = [[NSUserDefaults standardUserDefaults] stringForKey:@"ID_usuario"];
                 
                 NSString *post2=[NSString stringWithFormat:@"date=%@",[df stringFromDate:myDate]];
                 NSString *post3=[NSString stringWithFormat:@"&dia=%@",[dma stringFromDate:myDate]];
                 NSString *post4=[NSString stringWithFormat:@"&token=%@",tokenID];
                 NSString *post5 =[NSString stringWithFormat:@"&id=%@",usuarioID];
                 NSString *post6 =[NSString stringWithFormat:@"&perfil=0"];
                 NSString *post7 =[NSString stringWithFormat:@"&vez=%@",vezS];
                 NSString *post8 =[NSString stringWithFormat:@"&borde=0"];
                 
                 NSString *post =[NSString stringWithFormat:@"&idF=%@",usuarioID];
                 
                 NSString *hostStr = @"http://lanchosoftware.es/phc/downloadImage.php?";
                 
                 hostStr = [hostStr stringByAppendingString:post2];
                 hostStr = [hostStr stringByAppendingString:post3];
                 hostStr = [hostStr stringByAppendingString:post4];
                 hostStr = [hostStr stringByAppendingString:post5];
                 hostStr = [hostStr stringByAppendingString:post];
                 hostStr = [hostStr stringByAppendingString:post7];
                 hostStr = [hostStr stringByAppendingString:post6];
                 hostStr = [hostStr stringByAppendingString:post8];
                 
                 
                 //  hostStr = [hostStr stringByAppendingString:post6];
                 
                 [URLs addObject:[NSURL URLWithString:hostStr]];
                 
                 vez ++;
             }
             
             NSLog(@"Terminado2");
             if (URLs != nil ) {
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     // ViewFotos= [[PopularesView alloc] init];
                     
                     terminado=YES;
                     [self.tableView reloadData];
                     
                     
                     
                 });
                 
                 //[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(recargar) userInfo:nil repeats:NO];
                 
             }
             else{
                 NSLog(@"No tiene Fotos");
             }
             
             
         }); }];
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [URLs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   	static NSString* CellIdentifier = @"PopularesView";
    
	PopularesView* cell =(PopularesView*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    __block PopularesView* cellB=cell;
    NSLog(@"Celda");
    
    if (cell == nil){
		cell = [[PopularesView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.Imagen=[[ImagenView alloc]init];
        
        
    }
    
    if (terminado){
        NSLog(@"Terminado");
        
       //   [cell ImagenesDe:[URLs objectAtIndex:indexPath.row]];
       
        //ASIGNAR MEDIANTE LA URL LOS DATOS  A LA IMAGEN
        
        [cell.Imagen iniciarConUrl:[URLs objectAtIndex:indexPath.row]];
        [cell.Imagen setImageWithURLRequest:[NSURLRequest requestWithURL:[URLs objectAtIndex:indexPath.row]]
                           placeholderImage:nil
                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                        cellB.Imagen.image = image;
                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                        NSLog(@"Failed to download image: %@", error);
                                    }];

        
        
    }
    
    
    
	return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
