import java.util.*;

block player;

void setup(){
  size(450,500);
  player = new block();
}
void draw(){
  if(player.gameover){
    textSize(25);
    fill(color(255,255,0));
    text("GameOver,Press R to restart",10, 150);
    player.reset();
  }else{
  background(0);
  fill(255);
  rect(250,0,10,500);
  delay(185);
  textSize(35);
  text("SCORE:"+player.score,260, 50);
  
  player.playerinput();
  player.falling(player.checkfinishfalling());
  
  if(player.buffer != 10){
    player.buffer ++;
  }else if (player.buffer == 10){
    player.cangenerateblock();
    player.buffer = 0;
  }
  
  player.clearline();
  player.display();
  }
}

class block{
  
  
  int[][] map = new int [22][12];
  int pivotXcoord =0;
  int pivotYcoord =0;
  int score = 0;// +1 every line cleared
  int buffer = 0;
  boolean gameover=false;
  
  block(){
    
    for(int i = 0; i <22; i++){
      for(int j = 0; j<12;j++){
        
        if(i == 21|| i == 0){
          map[i][j] = 1;  
        }else if(j==0|| j==11){
          map[i][j] = 1;
        }else{
          map[i][j] = 0;
        }
      }
    }
    cangenerateblock(); 
    
  }
  void reset(){
     if(keyPressed){
      if(key == 'r'||key == 'R' ){
          pivotXcoord =0;
          pivotYcoord =0;
          score = 0;// +1 every line cleared
          buffer = 0;
          gameover =false;
          for(int i= 1; i<21;i++){
            for(int j = 1; j<11;j++){
              map[i][j] =0;
            }
          }
       }
    }
  }
  
  void playerinput(){
    // arrows keys
    boolean validtomove =true;
    
    if(keyPressed){
        if(key == ' '){ //rotates
           int [][] temp = new int[22][12];
           boolean validtorotae=true;
           for(int i = 0; i<22;i++){
             for(int j =0; j<12;j++){
               if(map[i][j]!= 2){
                 temp[i][j] = map[i][j];
               }
             }
           }
              //check if rotatable?
              for(int i = 1; i<21;i++){  // find every falling block with exception of pviot and then print its rotate position into another temp map
               for(int j = 1; j<11;j++){
                 if(map[i][j] == 2 && i != pivotYcoord && j != pivotXcoord){
                   // apply formula
                   int vectorxr = j-pivotXcoord;
                   int vectoryr = i-pivotYcoord;
                   
                   int vectorxt = ((0)*(vectorxr)) + ((-1)*(vectoryr));
                   int vectoryt = ((1)*(vectorxr))+ ((0)*(vectoryr));
                    if(map[pivotYcoord+vectoryt][pivotXcoord+vectorxt] == 1 || map[pivotYcoord+vectoryt][pivotXcoord+vectorxt] == 3 ){
                      validtorotae = false;
                    }
                 }
               }
              }
              //if rotate able transfer all coordinate
              
              if(validtorotae){
                
                for(int i = 1; i<21;i++){  // find every falling block with exception of pviot and then print its rotate position into another temp map
               for(int j = 1; j<11;j++){
                 if(i == pivotYcoord && j == pivotXcoord){
                   temp[i][j]= 2;
                   //transfer pviot coordinate
                 }else if(map[i][j] == 2){
                   int vectorxr = j-pivotXcoord;
                   int vectoryr = i-pivotYcoord;
                   
                   int vectorxt = ((0)*(vectorxr)) + ((-1)*(vectoryr));
                   int vectoryt = ((1)*(vectorxr))+ ((0)*(vectoryr));
                   
                   temp[pivotYcoord+vectoryt][pivotXcoord+vectorxt] = 2;
                 }
             }
           }
           for(int i = 0; i<22;i++){
                 for(int j =0; j<12;j++){
                    map[i][j] = temp[i][j];
               }
           }
              //if not don't do anything   
             //replace map with temp map with everything same except for falling block  
         }
        }
        
        if(key == 'a'|| key == 'A'){
          int leftmostcolumn =10;
           for(int i = 1; i <21; i++){
            for(int j = 1; j<11;j++){
              if(map[i][j] == 2){
                if(leftmostcolumn >j){
                  leftmostcolumn = j;
                }
              }
            }
           }
           
           for(int i = 1; i <21;i++){
             if(map[i][leftmostcolumn] == 2){
               if(map[i][leftmostcolumn-1] != 0){
                 validtomove = false;
               }
             }
           }
           if(validtomove){
              for(int i = 1; i <21; i++){
                for(int j = 1; j<11;j++){
                  if(map[i][j] == 2){
                    if(i == pivotYcoord && j == pivotXcoord){
                       pivotYcoord = i;
                       pivotXcoord= j-1;
                    }
                    
                    map[i][(j-1)] = 2;
                    map[i][j] =0;
                  }
              } 
            } 
           }
           
           
        }
        if(key == 'd'|| key=='D'){
          
          int rightmostcolumn =0;
           for(int i = 1; i <21; i++){
            for(int j = 1; j<11;j++){
              if(map[i][j] == 2){
                if(rightmostcolumn < j){
                  rightmostcolumn = j;
                }
              }
            }
           }
           
           for(int i = 1; i <21;i++){
             if(map[i][rightmostcolumn] == 2){
               if(map[i][rightmostcolumn+1] != 0){
                 validtomove = false;
               }
             }
           }
           if(validtomove){
              for(int i = 21; i > 0; i--){
                for(int j = 11; j> 0;j--){
                  if(map[i][j] == 2){
                    if(i == pivotYcoord && j == pivotXcoord){
                       pivotYcoord = i;
                       pivotXcoord= j+1;
                    }
                    
                    map[i][(j+1)] = 2;
                    map[i][j] =0;
                  }
              } 
            } 
          }
        }
    }
  }
  
  void clearline(){
     // if bottom line have all 10 then erased bottom line + move everything above down

    int count =0;
    int countbottomline =20;
    int linecleared= 0;
    int[][] temp= new int[22][12];
    
    
    for(int i = 1; i < 21;i++){
      for(int j = 1 ; j<11;j++){
        temp[i][j]=map[i][j];
      }
    }
    
    for(int i= 20; i>0;i--){
      for(int j = 10; j > 0;j--){
        if(map[i][j] == 3){
            count++;
         }
      }
      if(count == 10){
        //clear line 
        for(int q = 1; q<11; q++){
          map[i][q] = 0;
        }
        linecleared++;
      }else{
        //reconstruction
        for(int q = 1; q<11; q++){
          temp[countbottomline][q] = map[i][q];
        }
        countbottomline--;
      }
      count = 0;
    }
    for(int i = 0; i < linecleared ;i++){
      for(int j = 0; j> 11;j++){
        temp[countbottomline][j] = 0;
      }
      countbottomline--;
    }
    for(int i = 1; i < 21;i++){
      for(int j = 1 ; j<11;j++){
        map[i][j] = temp[i][j];
      }
    }
    
    score += linecleared;
    //for amount of lines cleared create new stuff into the top of the temp map
  }
   
  
  boolean checkfinishfalling(){

      for(int i = 1; i <21; i++){
        for(int j = 1; j<11;j++){
          if(map[i][j] == 2 &&  (map[i+1][j] == 3 ||map[i+1][j] == 1 )){ // this is a falling block. 3 is stable block
            return true;
          }
        } // find the blottom row of the block
      }
      
      
      return false;
      
  }
  
  
  void falling(boolean finishfalling){
    //block falls. Refreash from bottom to top
    //stop when a single part of the block touches border or when  touches another stable block
    
    if(finishfalling){
      for(int i = 1; i <21; i++){
      for(int j = 1; j<11;j++){
        if(map[i][j] == 2){ // this is a falling block. 3 is stable block
          map[i][j] = 3;
        }
      }
    }
    }else{
      // check if all part of the bottom of the block is empty. // fall down bois
      for(int i = 21; i > 0; i--){
        for(int j = 11; j> 0;j--){
          if(map[i][j] == 2){ // this is a falling block. 3 is stable block
            if(i == pivotYcoord && j == pivotXcoord){
              pivotYcoord = i+1;
              pivotXcoord= j;
            }
            map[i][j] = 0;
            map[i+1][j] = 2;
          }
        }
      }
    }
    
    
    
  }
  boolean cangenerateblock(){ // if not generated  falling block then gg
     //see if have 2s anywhere on map
     for(int i = 1;i<21;i++){
       for(int j = 1;j<11;j++){
         if(map[i][j] ==2){
           //cannot generate
           return false;
         }
       }
     }
     
     Random rand = new Random();
     int block = rand.nextInt(7);
     
     if(block == 0){ // straight
       if(map[1][3]==0&& map[1][4]==0&& map[1][5]==0&& map[1][6]==0){
         pivotXcoord =4;
         pivotYcoord =1;
         
         
         map[1][3]=2; map[1][4]=2; map[1][5]=2;map[1][6]=2;
         return true;
       }else{
         gameover = true;
       }
       
       // generate shape
       // map is empty at coordnates then generate a shape
     }else if(block == 1){ 
       if(map[1][5] == 0&& map[1][6]==0 && map[2][5]==0 && map[2][4]==0){
         pivotXcoord =5;
         pivotYcoord =2;
         map[1][5] = 2;map[1][6] = 2;map[2][5] = 2;map[2][4] = 2;
         return true;
       }else{
         gameover = true;
       }
       //re z
     }else if(block == 2){ 
       if(map[1][4] == 0&& map[2][3] ==0&& map[2][4]==0&& map[2][5]==0){
         pivotXcoord =4;
         pivotYcoord =2;
         map[1][4] = 2; map[2][3] = 2;map[2][4] = 2; map[2][5] = 2;
         return true;
      }else{
        gameover = true;
       }
       //wasd
     }else if(block == 3){ // z
       if(map[1][4]==0 && map[1][5]==0 && map[2][5]==0&& map[2][6]==0){
         pivotXcoord =5;
         pivotYcoord =2;
         map[1][4]=2; map[1][5]=2;map[2][5]=2; map[2][6]=2;
         return true;
       }else{
         gameover = true;
       }
     }else if(block == 4){ // left 
       if(map[1][3]==0&& map[2][3]==0&& map[2][4] ==0&& map[2][5]==0){
         pivotXcoord =4;
         pivotYcoord =2;
         map[1][3]=2; map[2][3]=2; map[2][4] =2; map[2][5]=2;
         return true;
       }else{
         gameover = true;
       }
     }else if(block == 5){ // right
       if(map[1][5]==0&& map[2][5]==0 && map[2][4]==0 && map[2][3]==0){
         pivotXcoord =4;
         pivotYcoord =2;
         map[1][5]=2; map[2][5]=2; map[2][4]=2; map[2][3]=2;
         return true;
     }else{
         gameover = true;
       }
     }else if(block == 6){ //cube
       if(map[1][4]==0&& map[1][5]==0 && map[2][4]==0 && map[2][5] ==0){
         pivotXcoord =4;
         pivotYcoord =2;
         map[1][4]=2; map[1][5]=2; map[2][4]=2; map[2][5] =2;
         return true;
       }else{
         gameover = true;
       }
     }
    return false;
  }
  
  void display(){
    int ycord =0; // 21
    
    int xcord =0; // 10
    
    for(int i =1; i <21; i++){
      for(int j = 1; j<11; j++){
        
        if(map[i][j]!= 0){
          square(xcord,ycord,25);
        }
        xcord += 25;
      }
      xcord = 0;
      ycord += 25;
    }
    
  }
  
}
