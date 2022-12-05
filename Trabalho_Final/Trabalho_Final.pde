PImage background, canoCima, canoBaixo, imgFrame1, imgFrame21, imgFrame22, imgFrame3;
PFont atari;
int backgroundX, backgroundY, protX, protY;
float VprotY, g; //mudei ele de int pra float pra poder controlar melhor a gravidade e a velocidade
int[] canoX, canoY; // criar arrays para animar os canos
int gameState, score;
float rotacao; //rotação do flappy bird
int distanciaCanos; //padronizar a distancia de um par para o outro

//mef
final int FRAME1 = 0;
final int FRAME21 = 1;
final int FRAME22 = 2;
final int FRAME3 = 3;
int tempo = 0;
int estadoProt = 0;

void setup() {
  size(700, 500);
  background = loadImage("background.png");
  atari = createFont("EightBit Atari-90.ttf", 32);
  imgFrame1 = loadImage("frame1.png");
  imgFrame21 = loadImage("frame2.1.png");
  imgFrame22 = loadImage("frame2.2.png");
  imgFrame3 = loadImage("frame3.png");
  canoBaixo = loadImage("canoBaixo.png");
  canoCima = loadImage("canoCima.png");
  protX = 100;
  protY = 50;
  g = .6; //é pra ser a gravidade
  canoX = new int[3];
  canoY = new int[canoX.length];
  distanciaCanos = 300;
  for (int i = 0; i < canoX.length; i++) {
    canoX[i] = (200)+(distanciaCanos*i);
    canoY[i] = (int)random(-150, 0);
  }
  gameState = -1;
}
void mouseClicked() {
}

//LOOP PRINCIPAL DO JOGO
void draw() {
  textFont(atari);
  if (gameState==-1)
  {
    startScreen();
  } else if (gameState==0) {
    if (mousePressed && protY > -30) {
      VprotY = -7.5; //velocidade de subida
    }
    setBackground();
    setChao();
    setCanos();
    controlaProt();
    score();
  } else
  {
    textSize(80);
    fill(0);
    text("PERDEU!", 90, 250);
    textSize(25);
    text("Aperte ENTER para jogar", 75, 300);
  }
}

void score()
{
  textSize(20);
  fill(0);
  text("pontos: " + score, 490, 50);
}

void startScreen()
{
  image(background, 0, 0);
  textSize(20);
  fill(255);
  text("FlappyBird demake.", 175, 50);
  text("Clica com o mouse pra começar!", 50, 100);
  fill(0,193,255);
  textSize(15);
  text("ISADORA SOUZA GRANATO", 50, 380);
  text("REBEKA GIOVANNA LEITE LIMA DE SOUZA", 50, 400);
  if (mousePressed) {
    protY = height/2;
    gameState = 0;
  }
}
void setChao() {
  noStroke();
  fill(22, 158, 2);
  rect(0, height-60, width, height);
}
void setCanos() {
  for (int i = 0; i < canoX.length; i++)
  {
    image(canoCima, canoX[i], canoY[i] + 450);
    image(canoBaixo, canoX[i], canoY[i]);
    canoX[i] -= 2;
    if (canoX[i] < -200) {
      canoX[i] = width;
      canoY[i] = (int)random(-150, 0); //aleatoriza a posição do cano quando for reaparecer
    }
    if (protX + 15 > (canoX[i]) && protX - 15 < (canoX[i]+100) ) { 
      if (!(protY - 15 > canoY[i] + 260 && protY + 15 < canoY[i] + 450))
      {
        gameState = 1;
      } else if (protX==canoX[i] || protX == canoX[i] + 1)
      {
        score++;
      }
    } else println("");
  }
}

void controlaProt() {
  if (rotacao < 0) { //Fazer o calculo da rotação dependendo da velocidade que vai de -10 até 10
    rotacao = radians(VprotY*4); // se ta subindo fica a 30 graus
  } else {
    rotacao = radians(VprotY*9); // se ta descendo ele vai até ficar a 90 graus
  }
  pushMatrix(); //push e pop matrix pra não deixar essas alterações influenciarem o resto do código
  translate(protX, protY); //modificar aonde vai ser desenhado para ficar na posição do flappybird
  rotate(rotacao); //rotacionar ele
  
  //gerar a imagem do passaro
  if (estadoProt == FRAME21) {
    tempo++;
    if (tempo>=10) {
      tempo = 0;
      estadoProt = FRAME1;
    }
  }
  if (estadoProt == FRAME1) {
    tempo++;
    if (tempo>=10) {
      tempo = 0;
      estadoProt = FRAME22;
    }
  }
  if (estadoProt == FRAME22) {
    tempo++;
    if (tempo>=10) {
      tempo = 0;
      estadoProt = FRAME3;
    }
  }
  if (estadoProt == FRAME3) {
    tempo++;
    if (tempo>=10) {
      tempo = 0;
      estadoProt = FRAME21;
    }
  }
  if (estadoProt == FRAME21 || estadoProt == FRAME22) {
    image(imgFrame21, -25, -12.5);
  } else if (estadoProt == FRAME1) {
    image(imgFrame1, -25, -12.5);
  } else if (estadoProt == FRAME3) {
    image(imgFrame3, -25, -12.5);
  }
  popMatrix();

  protY = protY + int(VprotY);
  if (VprotY < 10) { //delimitiar a velocidade que ta caindo
    VprotY = VprotY + g;
  }
  if (protY > height - 60)
  {
    gameState=1;
  }
}
void setBackground() {
  image(background, backgroundX, backgroundY);
  image(background, backgroundX + background.width, backgroundY);
  backgroundX = backgroundX - 1;
  if (backgroundX < -background.width) {
    backgroundX = 0; //reseta a imagem toda vida que ela chegar no final
  }
}


void reset() {
  setup();
}

void keyPressed() {
  if (key == ENTER) {
    reset();
  }
}  
