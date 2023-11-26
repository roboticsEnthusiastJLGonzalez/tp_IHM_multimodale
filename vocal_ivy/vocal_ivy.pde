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

ArrayList<Shape> formes = new ArrayList<>() ;



Shape myShape ;


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
    MOTION,
    NO_CREATE

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
      
    
    return create_mae.MOTION;
    
    
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
                   myShape = new Shape(form.TRIANGL, mouseX, mouseY)   ;
                 }
            else if(forme.equals("RECTANGLE")) {
                  myShape = new Shape(form.RECTANGLE, mouseX, mouseY);
                 }
            else if(forme.equals("CIRCLE")) {
                  myShape = new Shape(form.CERCLE, mouseX, mouseY);
                 }
            else {}
            switch(state_mae){
              
                 
              
              
              
              
              case RANDOM_COLOR :
               
                 myShape.display(true);
                 
                 break;
                
              case CREATE_GIVEN_PARAM:
                if (couleur.equals("RED")){
                  
                  
                 myShape.setColor( color(255, 0, 0));
                 myShape.display(false);
                  
                }
                else if (couleur.equals("GREEN")){
                  myShape.setColor(color(0,255,0));
                  myShape.display(false);

                }
                else if (couleur.equals("BLUE")){
                  myShape.setColor(color(0,0,255));
                  myShape.display(false);

                }
                else if (couleur.equals("YELLOW")){
                  myShape.setColor(color(255,255,0));
                  myShape.display(false);
                }
                else if (couleur.equals("ORANGE")){
                  myShape.setColor(color(255,165,0));
                  myShape.display(false);
                }
                else if (couleur.equals("PURPLE")){
                  myShape.setColor( color(128,0,128));
                  myShape.display(false);
                }
                else {  
                  myShape.setColor(color(0,0,0));
                  myShape.display(false);
                }
                
                
                formes.add(myShape);
                break;
                
              case NO_CREATE:
                println("There is nothing to create");
                break;
                
              default:
                println( "ERROR" );
                break;
            }
         }
         else if( action.equals( "MOVE") ) {
           
           if (mousePressed && formes.size() > 0 ){
             
             for (Shape shape : formes){
             // Check if the mouse is over the shape
            if (shape.isPointInside(mouseX, mouseY)) {
            // Select the shape on the first click
            shape.select();
            println("in here");
            
          }         
            
            else {
          // Move the shape to a new position on the second click
            shape.move(mouseX, mouseY);
              }
          }
                    
        }
          
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
