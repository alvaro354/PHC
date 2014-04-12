//
//  EtiquetasViewController.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 23/06/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "EtiquetasViewController.h"
#import "UIImageView+AFNetworking.h"

@interface EtiquetasViewController ()

@end

@implementation EtiquetasViewController
@synthesize arrayMostrar,IDS,URLPasar,imageP;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    NSArray * idsArray = [[NSArray alloc]init];
    idsArray = [IDS componentsSeparatedByString:@","];
    arrayMostrar = [[NSMutableArray alloc]init];
    
    NSData *datos = [[NSUserDefaults standardUserDefaults] objectForKey:@"DatosGuardados"];
   NSMutableArray* arrayGuardado = [NSKeyedUnarchiver unarchiveObjectWithData:datos];

    for (NSString * ID in idsArray) {
        for (Usuario * us in arrayGuardado) {
            if ([us.ID isEqualToString:ID]) {
                [arrayMostrar addObject:us];
                NSLog(@"Usuario Etiqueta: %@",us.usuario);
            }
        }
          NSLog(@"Array Etiqueta: %@",arrayMostrar);
        
    }
    
    
}
- (void)viewDidLoad
{
    Urls=[[NSMutableArray alloc]init];
    tabla.backgroundColor = [UIColor clearColor];
    tabla.dataSource=self;
    tabla.delegate=self;
   tabla.separatorColor=[UIColor clearColor];
    
    NSLog(@"Etiquetas");
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.01];
    
    
    self.view.alpha=0;
    
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    
    
    self.view.alpha=1;
    
    [UIView commitAnimations];
     
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(IBAction)volver:(id)sender{
    [Urls removeAllObjects];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    
    self.view.alpha=0;
    [UIView setAnimationDidStopSelector:@selector(volverA)];
    [UIView commitAnimations];
    
    
}
-(void)vovelA{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [arrayMostrar count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // [MBProgressHUD hideHUDForView:self.view animated:YES];
    //CeldaInvitacionesCell *cell = (CeldaInvitacionesCell *)[tableView dequeueReusableCellWithIdentifier:@"CeldaInvitaciones"];
    
    static NSString *CellIdentifier = @"CeldaEtiquetas";
    CeldaInvitacionesCell *cell = (CeldaInvitacionesCell *)[tableView dequeueReusableCellWithIdentifier:@"CeldaInvitaciones"];
    
    if (cell == nil) {
        cell = [[CeldaInvitacionesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    
    if ([ arrayMostrar count] !=0) {
        Usuario *items = [arrayMostrar objectAtIndex:indexPath.row];
        cell.name.text = items.usuario;
      
        
        NSDate* myDate = [NSDate date];
        NSDateFormatter *df = [NSDateFormatter new];
        NSDateFormatter *dma = [NSDateFormatter new];
        [df setDateFormat:@"dd"];
        [dma setDateFormat:@"dd-mm-yyyy"];
        
        NSString* _key = @"alvarol2611995";
        
        
        _key= [_key stringByAppendingString:[df stringFromDate:myDate]];
        
        NSString * tokenID = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
        NSString * usuarioID = [[NSUserDefaults standardUserDefaults] stringForKey:@"ID_usuario"];
        
        NSString *post2=[NSString stringWithFormat:@"&date=%@",[df stringFromDate:myDate]];
        NSString *post3=[NSString stringWithFormat:@"&dia=%@",[dma stringFromDate:myDate]];
        NSString *post4=[NSString stringWithFormat:@"&token=%@",tokenID];
        NSString *post5 =[NSString stringWithFormat:@"&id=%@",usuarioID];
        NSString *post6 =[NSString stringWithFormat:@"&perfil=1"];
        NSString *post7 =[NSString stringWithFormat:@"&vez=0"];
        
        NSString *post =[NSString stringWithFormat:@"idF=%@",items.ID];
        
        NSString *hostStr = @"http://lanchosoftware.es/phc/downloadImage.php?";
        hostStr = [hostStr stringByAppendingString:post];
        hostStr = [hostStr stringByAppendingString:post2];
        hostStr = [hostStr stringByAppendingString:post3];
        hostStr = [hostStr stringByAppendingString:post4];
        hostStr = [hostStr stringByAppendingString:post5];
        hostStr = [hostStr stringByAppendingString:post6];
        hostStr = [hostStr stringByAppendingString:post7];
        
        
        NSString *string = [[NSString alloc] initWithFormat:@"%@",hostStr];
        
        
        NSURL *urlT = [[NSURL alloc]initWithString:string];
            [Urls addObject:string];
        if (items.imagen != nil) {
            NSLog(@"Datos Usuario");
            cell.image.image = items.imagen;
        }
        else{
            __block CeldaInvitacionesCell * cellB = cell;
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:urlT];
            
            [cell.image setImageWithURLRequest:urlRequest
                              placeholderImage:nil
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           cellB.image.image = image;
                                       } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                           NSLog(@"Failed to download image: %@", error);
                                       }];
   
        }
        cell.image.clipsToBounds=YES;
        cell.image.layer.cornerRadius = 8.0;
        cell.image.layer.borderWidth=1.5;
        cell.image.layer.borderColor=[UIColor blackColor].CGColor;
        cell.clipsToBounds=YES;
        cell.layer.cornerRadius = 8.0;
        cell.layer.borderWidth=1;
        cell.layer.borderColor=[UIColor blackColor].CGColor;
    }
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"amigosE"]) {
        
        UINavigationController *nav = [segue destinationViewController];
       Amigos *myVC = (Amigos *)nav.topViewController;
        
        
        //NSLog(@"Url: %@ ID: %@ Amigo: %@",URLPasar,Usupasar.ID,Usupasar.usuario);
        
       [myVC setAmigo:Usupasar.usuario];
 //       [myVC setEstado:Usupasar.Estado];
        [myVC setID:Usupasar.ID];
        [myVC setUrlPasada:URLPasar];
        [myVC setEtiquetas:YES];
        
      
        
    }
    
}





#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
     Usupasar = [arrayMostrar objectAtIndex:indexPath.row];

    URLPasar= [Urls objectAtIndex:indexPath.row];
    
       NSData *datos = [NSKeyedArchiver archivedDataWithRootObject:Usupasar];
    [[NSUserDefaults standardUserDefaults] setObject:datos forKey:@"DatosAmigo"];
    // Cell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_ID"forIndexPath:indexPath];
    
    
    //  NSLog(@"%d CELDA %f x %f y", indexPath.item,cell.center.x, cell.center.y);
    
    [self performSegueWithIdentifier:@"amigosE" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
