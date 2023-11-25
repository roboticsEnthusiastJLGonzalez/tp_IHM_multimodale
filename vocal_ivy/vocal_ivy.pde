/*
 *  vocal_ivy -> Demonstration with ivy middleware
 * v. 1.2
 * 
 * (c) Ph. Truillet, October 2018-2019
 * Last Revision: 22/09/2020
 * Gestion de dialogue oral
 */
 
import fr.dgac.ivy.*;

// data

Ivy bus;
PFont f;
String message= "";
String forme = "" ;
String score = "" ;
String action = "" ;
String couleur = "" ;
String localisation = "" ;
String where = "" ;

int state;
int R ;
int G ;
int B ;
color col ;
float abs_loc ;
float ord_loc ;
float conf;

boolean get_mouse_coord = false;
            
             

public static final int INIT = 0;
public static final int ATTENTE = 1;
public static final int TEXTE = 2;
public static final int CONCEPT = 3;
public static final int NON_RECONNU = 4;

public enum action_type{
  CREER,
  DEPLACER,
  SUPPRIMER
}

public enum create_mae{
  
    RANDOM_COLOR,
    RANDOM_LOC,
    RANDOM_LOC_COLOR,
    CREATE_GIVEN_PARAM,
    NO_CREATE

}

MyTriangle tri;
  
public enum shapes{
  TRIANGL,
  RECTANGLE,
  CERCLE
}

class MyTriangle{
  float x,y,hLen;

  //Center point and side length
  MyTriangle(float cx, float cy,float length){
    x=cx;
    y=cy;
    hLen=length/2;
  }

  void draw(){
    triangle(x-hLen, y-hLen, x+hLen, y-hLen, x, y+hLen);  
  }
}

void drawShape(shapes shape) {
  if(shape == shapes.TRIANGL) {
    tri=new MyTriangle(mouseX,mouseY,100);
    tri.draw();
  }
  else if(shape == shapes.RECTANGLE) {
    rectMode(CENTER);
    rect(mouseX, mouseY, 100, 100);
  }
  else if(shape == shapes.CERCLE) {
    circle(mouseX, mouseY, 100);
  }
}

void randomColorShape(shapes shape){
  color col = color(random(255), random(255), color(255));
  fill(col);
  drawShape(shape);
}

create_mae set_state_mae(){
  if (action == "CREATE"){
    println(conf);
    println(couleur);
    create_mae at ;
      if(couleur == "" && localisation != ""){
        at = create_mae.RANDOM_COLOR;
      }
      else if(localisation == "" && couleur != ""){
          at = create_mae.RANDOM_LOC;
      }
      else if( localisation == "" && couleur == ""){
        at = create_mae.RANDOM_LOC_COLOR;
      }
      else {
        at = create_mae.CREATE_GIVEN_PARAM;
      }
      println(at);
      return at;
  }
  else if (action == "MOVE"){
    
  }
  
  else {
  //error
}

println("NO_CREATE");
return create_mae.NO_CREATE;

}
create_mae state_mae = create_mae.NO_CREATE;



void setup()
{
  size(800,800);
  fill(0,255,0);
  f = loadFont("TwCenMT-Regular-24.vlw");
  state = INIT;
  
  textFont(f,18);
  try
  {
    bus = new Ivy("sra_tts_bridge", " sra_tts_bridge is ready", null);
    bus.start("127.255.255.255:2010");
    
    bus.bindMsg("^sra5 Parsed=action=(.*) where=(.*) form=(.*) color=(.*) localisation=(.*) Confidence=(.*) NP=*", new IvyMessageListener()
    {
      public void receive(IvyClient client,String[] args)
      {
        state = CONCEPT;
        
        action = args[0];
        where = args[1];
        forme = args[2];
        couleur= args[3];
        localisation= args[4];
        
        score = args[5];
        String modifiedString = score.replace(',', '.');
        conf = Float.parseFloat(modifiedString);
        state_mae = set_state_mae();
      }        
    }
    );
    
    bus.bindMsg("^sra5 Event=Speech_Rejected", new IvyMessageListener()
    {
      public void receive(IvyClient client,String[] args)
      {
        message = "Parle mieux mon gaw, moi pas compris "; 
        state = NON_RECONNU;
      }        
    });    
    
    //bus.bindMsg("^sra5 Text=(.*) Confidence=.*", new IvyMessageListener()
    //{
    //  public void receive(IvyClient client,String[] args)
    //  {
    //    message = "Vous avez dit : " + args[0];
    //    state = TEXTE;
    //    forme = args[0];
    //    state_mae = set_state_mae();
    //    println(args[0]);
    //    println(args[1]);
    //  }        
    //});
    
   
  }
  catch (IvyException ie)
  {
  }
}

void draw()
{
  background(0);
 
  switch(state) {
    case INIT:
      message = " Ola mon gaw tu peux parler maintenant là ";
      try {
          bus.sendMsg("ppilot5 Say=" + message); 
      }
      catch (IvyException e) {}
      state = ATTENTE;
      break;
      
    case ATTENTE:
      // cas normal ...
      break;
      
    case TEXTE :
      try {
          bus.sendMsg("ppilot5 Say=" + message); 
      }
      catch (IvyException e) {}
      if (forme == "dessiner triangle vert"){
         triangle(300,300,500,300,400,500);
         try {
          bus.sendMsg("ppilot5 Say= C'est bon mon gaw triangle dessiner" ); 
      }
      catch (IvyException e) {}
       }
      state = ATTENTE;
      break;
      
      
      
      
      
      
      
     case CONCEPT:  
       try {
          bus.sendMsg("ppilot5 Say=" + message); 
          println(conf);
          println("in creat");
       }
       catch (IvyException e) {}
       
       if (conf >= 0.8){
         
         if (action == "CREATE"){
           //dessin function
            switch(state_mae){
              case RANDOM_COLOR :
                 if(forme == "TRIANGLE") {
                   randomColorShape(shapes.TRIANGL);
                 }
                 else if(forme == "RECTANGLE") {
                   randomColorShape(shapes.RECTANGLE);
                 }
                 else if(forme == "CIRCLE") {
                   randomColorShape(shapes.CERCLE);
                 }
                 break;
                 
              case RANDOM_LOC:
                 abs_loc = random(300);
                 ord_loc = random(300);
                 break;
                 
              case RANDOM_LOC_COLOR:
              
                 R = (int)random(0,255);
                 G = (int)random(0,255);
                 B = (int)random(0,255);
                
                 col = color(R,G,B);
                
                 abs_loc = random(300);
                 ord_loc = random(300);
                break;
                
              case CREATE_GIVEN_PARAM:
              
                if (couleur == "RED"){
                  col = color(255, 0, 0);
                }
                else if (couleur == "GREEN" ){
                  col = color(0,255,0);
                }
                else if (couleur == "BLUE" ){
                  col = color(0,0,255);
                }
                else if (couleur == "YELLOW" ){
                  col = color(0,170,170);
                }
                else {  
                  col = color(200,170,0);
                }
                
                if (localisation == "HERE"){
                  get_mouse_coord = true;
                }
                
                break;
              case NO_CREATE:
                println("There is nothing to create");
                break;
                
              default:
                println( "ERROR" );
                break;
            }
         }
         else if( action == "MOVE" ) {
          // move function
          
         }
         else {
           
         }
         
         
           
       }
       state = ATTENTE;
       break; 
       
     case NON_RECONNU:
       state = ATTENTE;
       try {
          bus.sendMsg("ppilot5 Say=" + message); 
       }
       catch (IvyException e) {}
       state = ATTENTE;
       break;
  }
  //triangle(300,300,500,300,400,500);
  //drawShape(shapes.RECTANGLE);
}
