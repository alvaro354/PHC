//
//  MensajesViewController.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 20/05/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "MensajesViewController.h"
#import "MensajesParse.h"
#import "Mensajes.h"
#import "Usuario.h"
#import "CeldaInvitacionesCell.h"
#import "MBProgressHUD.h"
//#import "ChatViewController.h"
#import "AsyncImageView.h"
#import "VerMensajes.h"
#import "UIImageView+AFNetworking.h"
#import "Amigos.h"
@interface MensajesViewController ()

@end

@implementation MensajesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
     NSLog(@"Aparecer");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Mensajes) name:@"Mensajes" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"Desaparecer");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Mensajes" object:nil];
}
- (void)viewDidLoad
{
    
        self.navigationController.navigationBar.topItem.title=@"Mensajes";
    

    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor colorWithRed:0.35 green:0.67 blue:0.985 alpha:1];
    [refreshControl addTarget:self action:@selector(recargar) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    
  arrayMostrar=[[NSMutableArray alloc]init];
    arrayGuardado=[[NSMutableArray alloc]init];
    [self Mensajes];

    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
    
    [self recargar];
   
}
-(void)recargar{
    [arrayMostrar removeAllObjects];
    NSString * usuarioID = [[NSUserDefaults standardUserDefaults] stringForKey:@"ID_usuario"];
    NSString * usuario = [[NSUserDefaults standardUserDefaults] stringForKey:@"usuario"];
    BOOL  Msn= [[MensajesParse alloc] descargarMensajeIDM: usuarioID usuario:usuario privado:@"1" perfil:@"1"];
   NSLog(@"%c Array",Msn);
    [refreshControl endRefreshing];
}


-(void)Mensajes
{
   //  NSDictionary *userInfo = [note userInfo];
 
   // mensajes =  [userInfo objectForKey:@"PasarMensajes"];
    
  //  NSLog(@"%@ Array Pasada", mensajes);
    
     NSLog(@"Mensajes");
    
    NSData *datos = [[NSUserDefaults standardUserDefaults] objectForKey:@"DatosGuardados"];
    arrayGuardado = [NSKeyedUnarchiver unarchiveObjectWithData:datos];
    for (Usuario *user in arrayGuardado) {
    
        if (user.mensajes != nil) {
            [arrayMostrar addObject:user];
            NSLog(@"%@ Anadido Mensajes View",user.mensajes);
            self.tableView.tableFooterView = nil;
        }
    }
    if ([arrayMostrar count] == 0) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/2)];
         label.text = NSLocalizedString(@"You have no messages", nil);
         label.font = [UIFont boldSystemFontOfSize:16.0f];
         label.textAlignment = NSTextAlignmentCenter;
         label.textColor = [UIColor colorWithRed:76.0f/255.0f green:86.0f/255.0f blue:108.0f/255.0f alpha:1.0f];
         label.shadowColor = [UIColor whiteColor];
         label.shadowOffset = CGSizeMake(0.0f, 1.0f);
         label.backgroundColor = [UIColor clearColor];
         label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
         self.tableView.tableFooterView = label;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
      NSLog(@"%lu Numero Anadido",(unsigned long)[arrayMostrar count]);
    if ([arrayMostrar count] == 0) {
   /* UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    label.text = NSLocalizedString(@"You have no messages", nil);
    label.font = [UIFont boldSystemFontOfSize:16.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:76.0f/255.0f green:86.0f/255.0f blue:108.0f/255.0f alpha:1.0f];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label.backgroundColor = [UIColor clearColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.tableView.tableFooterView = label;*/
        return 0;
    }
    if ([arrayMostrar count]!=0) {
    return [arrayMostrar count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //CeldaInvitacionesCell *cell = (CeldaInvitacionesCell *)[tableView dequeueReusableCellWithIdentifier:@"CeldaInvitaciones"];
    
    static NSString *CellIdentifier = @"CeldaInvitaciones";
    CeldaInvitacionesCell *cell = (CeldaInvitacionesCell *)[tableView dequeueReusableCellWithIdentifier:@"CeldaInvitaciones"];
    
    UISwipeGestureRecognizer* gestureR;
    gestureR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(ArrastrarCelda:)];
    gestureR.direction = UISwipeGestureRecognizerDirectionLeft;
    [cell addGestureRecognizer:gestureR];
    
    
    if (cell == nil) {
        cell = [[CeldaInvitacionesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    
    if ([arrayMostrar count] !=0) {
        Usuario *items = [arrayMostrar objectAtIndex:indexPath.row];
        cell.name.text = items.usuario;
        Mensajes *texto = [items.mensajes lastObject];
        cell.datos.text=texto.Texto;
        cell.sUsuarioID=items.ID;
        cell.sNombre=items.usuario;
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
        NSString *post6 =[NSString stringWithFormat:@"&perfil=1"];
        NSString *post7 =[NSString stringWithFormat:@"&vez=0"];
        
        NSString *post =[NSString stringWithFormat:@"&idF=%@",items.ID];
        
        NSString *hostStr = @"http://lanchosoftware.es/phc/downloadImage.php?";
       
        hostStr = [hostStr stringByAppendingString:post2];
        hostStr = [hostStr stringByAppendingString:post3];
         hostStr = [hostStr stringByAppendingString:post];
        hostStr = [hostStr stringByAppendingString:post4];
        hostStr = [hostStr stringByAppendingString:post5];
        hostStr = [hostStr stringByAppendingString:post6];
        hostStr = [hostStr stringByAppendingString:post7];
        
        
        NSString *string = [[NSString alloc] initWithFormat:@"%@",hostStr];
        
        
        NSURL *urlT = [[NSURL alloc]initWithString:string];
        
        __block CeldaInvitacionesCell * cellB = cell;
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:urlT];
        
        [cell.image setImageWithURLRequest:urlRequest
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       cellB.image.image = image;
                                   } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       NSLog(@"Failed to download image: %@", error);
                                   }];
        cell.image.clipsToBounds=YES;
        cell.image.layer.cornerRadius = 8.0;
        cell.image.layer.borderWidth=1.5;
        cell.image.layer.borderColor=[UIColor blackColor].CGColor;

    }
    else{
        /*
        Usuario *items = [amigos objectAtIndex:indexPath.row];
        cell.name.text = items.usuario;
        NSLog(@"%@ Nombre",items.usuario );
        if (items.imagen == nil) {
            cell.image.backgroundColor = [UIColor grayColor];
            NSLog(@"NO Imagen");
        }
        else{
            cell.image.image= items.imagen;
        }
        cell.image.clipsToBounds=YES;
        cell.image.layer.cornerRadius = 8.0;
        cell.image.layer.borderWidth=1.5;
        cell.image.layer.borderColor=[UIColor blackColor].CGColor;
         */
        
    }
    
    cell.viewSuperior.alpha=1;
    cell.viewInferior.hidden=YES;
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
-(void)viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBar.backItem.title = @"Perfil";
    self.navigationController.navigationBar.topItem.title=@"Mensajes";
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
      if ([arrayMostrar count] != 0) {
     if ([segue.identifier isEqualToString:@"ChatS"]) {

         Usuario * u = [arrayMostrar objectAtIndex:[self.tableView indexPathForSelectedRow].row];
         [segue.destinationViewController setUs:u];
     [segue.destinationViewController setMensajes:u.mensajes];
         }
     }
    if ([segue.identifier isEqualToString:@"amigosMensajes"]) {
        
        UINavigationController *nav = [segue destinationViewController];
        Amigos *myVC = (Amigos *)nav.topViewController;
        
        
        //NSLog(@"Url: %@ ID: %@ Amigo: %@",URLPasar,Usupasar.ID,Usupasar.usuario);
        
        [myVC setAmigo:usuarioPasar];
        //       [myVC setEstado:Usupasar.Estado];
        [myVC setID:idUsuarioPasar];
        [myVC setUrlP:Nil];
        [myVC setEtiquetas:YES];
        
        
        
    }
  
}
/*
-(void)ArrastrarCelda:(UISwipeGestureRecognizer *)recognizer{
    
    
    CGPoint swipeLocation = [recognizer locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
    
    MessageTableViewCell *cell = (MessageTableViewCell*)[self.tableView cellForRowAtIndexPath:swipedIndexPath];
    
    usuarioPasar= [[NSString alloc]initWithString:cell.sNombre];
    idUsuarioPasar= [[NSString alloc]initWithString:cell.sUsuarioID];
    
    [cell.bPerfil addTarget:self action:@selector(MostrarPerfil:) forControlEvents:UIControlEventTouchUpInside];
    NSLog(@"Swipe Cell: %@",cell.sNombre);
    if (cell.vistaSuperiorOculta==NO){
        NSLog(@"Descolocar");
        [UIView beginAnimations:nil context:(__bridge void *)(cell)];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView setAnimationDelegate:self];
        cell.viewInferior.hidden=NO;
        
        cell.viewSuperior.frame= CGRectMake(cell.viewSuperior.frame.origin.x-480, cell.viewSuperior.frame.origin.y, cell.viewSuperior.frame.size.width, cell.viewSuperior.frame.size.height);
        cell.viewSuperior.alpha=0.5;
        cell.viewInferior.alpha=1;
        [UIView commitAnimations];
    }
    
    else
    {
        NSLog(@"Colocar");
        [UIView beginAnimations:nil context:(__bridge void *)(cell)];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView setAnimationDelegate:self];
        
        cell.viewSuperior.frame= CGRectMake(cell.viewSuperior.frame.origin.x+480, cell.viewSuperior.frame.origin.y, cell.viewSuperior.frame.size.width, cell.viewSuperior.frame.size.height);
        cell.viewSuperior.alpha=1;
        cell.viewInferior.hidden=YES;
        [UIView commitAnimations];
        
    }
    
}
 */
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag context:(void *)context {
    MessageTableViewCell *cell = (__bridge  MessageTableViewCell*)context;
    if (cell.vistaSuperiorOculta==NO){
        NSLog(@"Ocultar");
        
        cell.vistaSuperiorOculta=YES;
    }
    else{
        NSLog(@"Mostrar");
        
        cell.vistaSuperiorOculta=NO;
        
    }
}
-(void)MostrarPerfil:(id)sender{
    [self performSegueWithIdentifier:@"amigosMensajes" sender:self];
}








#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */

    
        [self performSegueWithIdentifier:@"ChatS" sender:self];
    
  //  UIViewController* secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Chat"];
   // [self.navigationController pushViewController:secondViewController animated:YES];
}

@end
