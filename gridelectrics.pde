final int bs = 10;
int w, h;
int latency = 2;
boolean wait = false;
boolean redraw = false;
Grid g;

boolean fuse = true;
boolean wrapAround = true;

void setup() {
  fullScreen(P2D);
  w = width/bs;
  h = height/bs;
  g = new Grid(w, h);
}

long tick = 0;
void draw() {
  tick++;
  
  handleMouse();
  if(redraw)
    g.draw();
  
  if (tick % latency == 0) {
    if (!wait) g.update();
    g.draw();
  }
  
  redraw = false;
}