//
//  VerMensajes.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 18/06/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "VerMensajes.h"
#import "Mensajes.h"
#import "MessageTableViewCell.h"
#import "SpeechBubbleView.h"
#import "MensajesParse.h"


@interface VerMensajes ()

@end

@implementation VerMensajes
@synthesize mensajes, table, scrollView,campoActivo, texto,scrollViewEnviar,us,Vez;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)volver:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)recargar:(id)sender{
    
  
    [table reloadData];
    
   
[table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
    
      

}


-(IBAction)enviar:(id)sender{
    
    
    
    
    //NO ES LLAMADA LA FUNCION CON ELPOST "MENSAJES"
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Mensajes) name:@"Mensajes" object:nil];
    contadorAntiguo= [mensajes count];
    descargado=NO;
    
     BOOL * msj = [[MensajesParse alloc] EnviarMensajeIDM:us.ID usuario:us.usuario privado:@"1" texto:texto.text];

 texto.text = @"";
}

- (void)scrollToNewestMessage
{
	// The newest message is at the bottom of the table
	NSIndexPath* indexPath = [NSIndexPath indexPathForRow:(mensajes.count - 1) inSection:0];
	[table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}



-(void)recargar{
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Mensajes) name:@"Mensajes" object:nil];
    
    NSString * usuarioID = [[NSUserDefaults standardUserDefaults] stringForKey:@"ID_usuario"];
    NSString * usuario = [[NSUserDefaults standardUserDefaults] stringForKey:@"usuario"];
    descargado=YES;
    BOOL  Msn= [[MensajesParse alloc] descargarMensajeIDM: usuarioID usuario:usuario privado:@"1" perfil:@"1"];
    NSLog(@"Reacrgando");
   
}


-(void)Mensajes
{
     NSLog(@"LLamado");
    NSString *vezS = [NSString stringWithFormat:@"%u",[mensajes count]];
    NSLog(@"%@ Count Mensajes",vezS);
    
    [mensajes removeAllObjects];
    mensajes= [[NSMutableArray alloc]init];
    
    if (descargado==YES ) {
    
     NSLog(@"mensajes");
    //  NSDictionary *userInfo = [note userInfo];
    
    // mensajes =  [userInfo objectForKey:@"PasarMensajes"];
    
    //  NSLog(@"%@ Array Pasada", mensajes);
       
        
    NSData *datos = [[NSUserDefaults standardUserDefaults] objectForKey:@"DatosGuardados"];
        NSMutableArray*  arrayGuardado = [NSKeyedUnarchiver unarchiveObjectWithData:datos];
    for (Usuario *user in arrayGuardado) {
        if([user.ID isEqualToString:us.ID])
        if (user.mensajes != nil) {
            for (Mensajes * mensaje in user.mensajes) {
                [mensajes addObject:mensaje];
            }
              NSLog(@"%lu Count Mensajes",(unsigned long)[mensajes  count]);
            NSLog(@"%@ Anadido VerMensajes",mensajes
                  );
      
        }
    }
 
        if (mensajes.count!= 0) {
       /*
           [collection performBatchUpdates:^{
                [collection reloadData];
            } completion:^(BOOL finished) {
                    NSLog(@"Reload");
                [collection setNeedsLayout];
                [collection setNeedsDisplay];
                
                
                [scrollView setNeedsLayout];
                [scrollView setNeedsDisplay];
                [self.view setNeedsLayout];
                [self.view setNeedsDisplay];
                
                
                [self reloadInputViews];
                
            }];
        */
            NSLog(@"Reload");
              //[collection reloadData];
            Vez = [vezS intValue];
            [self didSaveMessage:Nil atIndex:Vez];
            //[collection reloadInputViews];
        }
        
    }
    if (descargado==NO) {
        
      NSLog(@"mensajes NO");
        [self recargar];
    }
}



- (void) viewDidAppear:(BOOL)animated {
   /* self.view.backgroundColor=[UIColor colorWithRed:0.35 green:0.67 blue:0.985 alpha:1];
    barraSuperior.barTintColor =[UIColor colorWithRed:0.35 green:0.67 blue:0.985 alpha:1];
    barraSuperior.tintColor =[UIColor whiteColor];
    barraSuperior.translucent=NO;
     barraInferior.tintColor =[UIColor whiteColor];
    barraInferior.backgroundColor =[UIColor colorWithRed:0.35 green:0.67 blue:0.985 alpha:1];
   */
    
       titulo.text=us.usuario;
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    /*
    self.view.backgroundColor=[UIColor colorWithRed:0.35 green:0.67 blue:0.985 alpha:1];
    barraSuperior.barTintColor =[UIColor colorWithRed:0.35 green:0.67 blue:0.985 alpha:1];
    barraSuperior.tintColor =[UIColor whiteColor];
    barraSuperior.translucent=NO;
    barraInferior.tintColor =[UIColor whiteColor];
    barraInferior.backgroundColor =[UIColor colorWithRed:0.35 green:0.67 blue:0.985 alpha:1];
    
    [self reloadInputViews];
    */
      titulo.text=us.usuario;
    CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in scrollView.subviews)
    {
        scrollViewHeight += view.frame.size.height;
    }
    
    [scrollView setContentSize:(CGSizeMake(320, scrollViewHeight))];
    
	[super viewWillAppear:animated];
 
   
    [table reloadData];
	
     NSLog(@"YES mensajes");
	// Show a label in the table's footer if there are no messages
	if (mensajes.count == 0)
	{
		UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
		label.text = NSLocalizedString(@"You have no messages", nil);
		label.font = [UIFont boldSystemFontOfSize:16.0f];
		label.textAlignment = NSTextAlignmentCenter;
		label.textColor = [UIColor colorWithRed:76.0f/255.0f green:86.0f/255.0f blue:108.0f/255.0f alpha:1.0f];
		label.shadowColor = [UIColor whiteColor];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		//self.collection.fo = label;
	}
	else
	{
		[self scrollToNewestMessage];
	}
}

- (void)viewDidLoad
{
    
    [table setDelegate:self];
    [table setDataSource:self];
    rect= barraInferior.frame;
    titulo.text=us.usuario;
    [barraSuperior addSubview:titulo];
    
    [scrollView setContentSize:self.view.frame.size];
    
    
    scrollView.delegate =self;
    scrollView.scrollEnabled=YES;
    table.backgroundColor = [UIColor colorWithRed:219/255.0 green:226/255.0 blue:237/255.0 alpha:1.0];
    table.delegate=self;
    table.dataSource =self;
    
        
    [texto setDelegate:self];
    [scrollView setContentSize:[[self view] frame].size];
    scrollViewEnviar.scrollEnabled=YES;
    scrollViewEnviar.delegate=self;
    
    
    self.view.backgroundColor=[UIColor colorWithRed:0.35 green:0.67 blue:0.985 alpha:1];
    barraSuperior.barTintColor =[UIColor colorWithRed:0.35 green:0.67 blue:0.985 alpha:1];
    barraSuperior.tintColor =[UIColor whiteColor];
    barraSuperior.translucent=NO;
    barraInferior.tintColor =[UIColor whiteColor];
    barraInferior.backgroundColor =[UIColor colorWithRed:0.35 green:0.67 blue:0.985 alpha:1];
    
    [self.view addSubview:barraInferior];
    [self reloadInputViews];
    
     
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(apareceElTeclado:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(desapareceElTeclado:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //Detección de toques en el scroll view
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewPulsado)];
    [tapRecognizer setCancelsTouchesInView:NO];
    //CGPoint bottomOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.bounds.size.height);
   // [scrollView setContentOffset:bottomOffset animated:YES];
    [super viewDidLoad];
    
   // [collection setFrame:collection.frame];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UICollectionViewDataSource
/*
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([mensajes count] !=0) {
    
    return 1;
    }
    else{
        return 0;
    }
}*/
- (int)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	
 
    if (mensajes.count !=0) {
           NSLog(@" Count: %u", mensajes.count);
        int contador = mensajes.count;
        if ([self isEditing]) {
           contador++;
        }
    return contador;

    }
    else{
        NSLog(@"Contador de Mensajes 0 ");
       // [collection reloadData];
        return 0;
    }
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
   // NSLog(@"Celda mensajes");
	static NSString* CellIdentifier = @"MessageCellIdentifier";
    
	MessageTableViewCell* cell =(MessageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
       
    if (cell == nil){
		cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
}


    if ([mensajes count] != 0) {
     
	Mensajes* messages = [mensajes objectAtIndex:indexPath.row];
	[cell setMessage:messages];
    }
    
 
    
	return cell;
    
}


- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
	// This function is called before cellForRowAtIndexPath, once for each cell.
	// We calculate the size of the speech bubble here and then cache it in the
	// Message object, so we don't have to repeat those calculations every time
	// we draw the cell. We add 16px for the label that sits under the bubble
   //  NSLog(@"Altura");
   
   
    Mensajes* message = [[Mensajes alloc]init];
    message = (mensajes)[indexPath.item];
	message.bubbleSize = [SpeechBubbleView sizeForText:message.Texto];
   /// NSLog(@"Altura : %f", message.bubbleSize.height + 16);
	return message.bubbleSize.height + 16;
    
}



- (void)didSaveMessage:(Mensajes*)message atIndex:(int)index
{
    
    if ([mensajes count] != 0) {
	// This method is called when the user presses Save in the Compose screen,
	// but also when a push notification is received. We remove the "There are
	// no messages" label from the table view's footer if it is present, and
	// add a new row to the table view with a nice animation.
      
   
        if ([self isViewLoaded])
        {
            /*
            collection.tableFooterView = nil;
		[collection insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
		[self scrollToNewestMessage];
    
        [collection reloadData];
             */
            
         /*   NSInteger lastSectionIndex = [collection numberOfSections] - 1;
            
            // Then grab the number of rows in the last section
            NSInteger lastRowIndex = [collection numberOfRowsInSection:lastSectionIndex] - 1;
            
            // Now just construct the index path
            NSIndexPath *pathToLastRow = [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
      
            [collection beginUpdates];
            collection.tableFooterView = nil;
            
            [collection insertRowsAtIndexPaths:[NSArray arrayWithObject:pathToLastRow] withRowAnimation:UITableViewRowAnimationFade];
            [collection endUpdates];
            */
           
            [table reloadData];
            
            
            [self scrollToNewestMessage];
                
          
   
        }
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    Mensajes* message = [[Mensajes alloc]init];
   // message = (mensajes)[indexPath.item];
     message = [mensajes objectAtIndex:indexPath.item];
  //  NSLog(@"Txto: %@  Item: %u", message.Texto, indexPath.item);
  
  
	message.bubbleSize = [SpeechBubbleView sizeForText:message.Texto];
    
   // NSLog(@"Altura : %f", message.bubbleSize.height + 16);
    
    
    CGSize retval = CGSizeMake(320,message.bubbleSize.height + 16);
 return retval;
        
        
    
}
*/


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [texto resignFirstResponder];
        
       
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
   
    textField.layer.borderWidth=2;
    textField.layer.borderColor= [UIColor colorWithRed:0.17 green:0.522 blue:0.725 alpha:1].CGColor;
    
    [self setCampoActivo:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField

{
    [self setCampoActivo:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
   NSLog(@"TEXT");
        CGRect frame = textView.frame;
        frame.size.height = textView.contentSize.height;
        textView.frame = frame;
    texto.frame=frame;
    
}

- (void) apareceElTeclado:(NSNotification *)laNotificacion
{
    NSLog(@"Aparece");
    NSDictionary *infoNotificacion = [laNotificacion userInfo];
    CGSize tamanioTeclado = [[infoNotificacion objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, tamanioTeclado.height, 0);
    [scrollView setContentInset:edgeInsets];
    [scrollView setScrollIndicatorInsets:edgeInsets];
    
    [scrollView scrollRectToVisible:[self campoActivo].frame animated:YES];
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
   
    barraInferior.frame=CGRectMake(0, tamanioTeclado.height+10, barraInferior.frame.size.width, barraInferior.frame.size.height);
    [self reloadInputViews];
    
    [UIView commitAnimations];
    
}

- (void) desapareceElTeclado:(NSNotification *)laNotificacion
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.15];
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    [scrollView setContentInset:edgeInsets];
    [scrollView setScrollIndicatorInsets:edgeInsets];
    
    
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    
    
    barraInferior.frame=rect;
    [UIView commitAnimations];
}

#pragma mark - Métodos de acción adicionales
- (void) scrollViewPulsado
{
    [[self view] endEditing:YES];
}


// 3






@end
