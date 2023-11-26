/*
 *  vocal_ivy -> Demonstration with ivy middleware
 * v. 1.2
 * 
 * (c) Ph. Truillet, October 2018-2019
 * Last Revision: 22/09/2020
 * Gestion de dialogue oral
 */
 
import fr.dgac.ivy.*;
import 

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
shapes myShape ;


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

void colorShape(shapes shape, color col){

  fill(col);
  drawShape(shape);

}

create_mae set_state_mae(){
  println("CREATE");
  if (action.equals("CREATE")){
    println("in creat");
      if(couleur.equals("undefined")){
        println("in random_color");
        return create_mae.RANDOM_COLOR;
      }
      else {
        return create_mae.CREATE_GIVEN_PARAM;
      }
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
        
        println("action = " + action);
        println("where = " + where);
        println("forme = " + forme);
        println("couleur = " + couleur);
        println("localisation = " + localisation);
        
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
        message = "Veuillez je vous prie vous exprimez plus clairement en articulant lentement"; 
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
  switch(state) {
    case INIT:
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
          println("in CONCEPT");
       }
       catch (IvyException e) {}
       
       if (conf >= 0.8){
         println("conf >= 0.8");
         if (action.equals("CREATE")){
            println("in CREATE");
            if(!mousePressed){
                   break;
                 }
                 
            if(forme.equals("TRIANGLE")) {
                   myShape =  shapes.TRIANGL;
                 }
            else if(forme.equals("RECTANGLE")) {
                   myShape = shapes.RECTANGLE;
                 }
            else if(forme.equals("CIRCLE")) {
                  myShape = shapes.CERCLE;
                 }
            else {}
            switch(state_mae){
              
                 
              
              
              
              
              case RANDOM_COLOR :
               
                 randomColorShape(myShape);
                 
                 break;
                
              case CREATE_GIVEN_PARAM:
                if (couleur.equals("RED")){
                  
                  
                  col = color(255, 0, 0);
                  colorShape(myShape, col);
                  
                }
                else if (couleur.equals("GREEN")){
                  col = color(0,255,0);
                  colorShape(myShape, col);

                }
                else if (couleur.equals("BLUE")){
                  col = color(0,0,255);
                  colorShape(myShape, col);

                }
                else if (couleur.equals("YELLOW")){
                  col = color(255,255,0);
                  colorShape(myShape, col);
                }
                else if (couleur.equals("ORANGE")){
                  col = color(255,165,0);
                  colorShape(myShape, col);
                }
                else if (couleur.equals("PURPLE")){
                  col = color(128,0,128);
                  colorShape(myShape, col);
                }
                else {  
                  col = color(0,0,0);
                  colorShape(myShape, col);
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
