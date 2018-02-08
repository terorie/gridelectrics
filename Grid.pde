class Grid {
  int w, h;
  int[][] grid;
  static final int M_EMPTY = 0x00;
  static final int M_WIRE = 0x01;
  static final int M_WIRE_HIGH = 0x02;
  static final int M_WIRE_PRIME = 0x03;
  static final int M_WIRE_LOW = 0x04;
  static final int M_WIRE_WAIT = 0x05;
  
  Grid(int w, int h) {
    this.w = w; this.h = h;
    grid = new int[w][h];
  }
  
  void putWire(int x, int y) {
    write(x, y, M_WIRE);
  }
  
  void removeWire(int x, int y) {
    write(x, y, M_EMPTY);
  }
  
  boolean write(int x, int y, int v) {
    if (wrapAround) {
      x = (w+x)%w;
      y = (h+y)%h;
    }
    
    boolean canWrite = x >= 0 && x < w && y >= 0 && y < h;
    if (canWrite)
      grid[x][y] = v;
    return canWrite;
  }
  
  int read(int x, int y) {
    if (wrapAround) {
      x = (w+x)%w;
      y = (h+y)%h;
    }
    
    boolean canRead = x >= 0 && x < w && y >= 0 && y < h;
    int v = 0;
    if (canRead)
      v = grid[x][y];
    return v;
  }
  
  void draw() {
    //drawGridLines();
    for (int x = 0; x <= w; x++)
      for (int y = 0; y <= h; y++)
        drawBlock(x, y);
  }
  
  void update() {
    for (int x = 0; x < w; x++) {
      for (int y = 0; y < h; y++) {
        int src = read(x, y);
        switch (src) {
        case M_WIRE_PRIME: {
          sendPulse(x+1, y);
          sendPulse(x-1, y);
          sendPulse(x, y+1);
          sendPulse(x, y-1);
          write(x, y, M_WIRE_LOW);
          break;
        }
        }
      }
    }
    
    for (int x = 0; x < w; x++) {
      for (int y = 0; y < h; y++) {
        int src = read(x, y);
        switch (src) {
        case M_WIRE_HIGH: write(x, y, M_WIRE_PRIME); break;
        case M_WIRE_LOW: {
          write(x, y, M_WIRE_WAIT);
          break;
        }
        case M_WIRE_WAIT: {
          write(x, y, fuse ? M_EMPTY : M_WIRE);
          break;
        }
        }
      }
    }
  }
  
  void sendPulse(int x, int y) {
    int tgt = read(x, y);
    if (tgt == M_WIRE) {
      write(x, y, M_WIRE_HIGH);
    } else if(tgt == M_WIRE_PRIME) {
      write(x, y, M_WIRE_LOW);
    }
  }
  
  void drawBlock(int x, int y) {
    int block = read(x, y);
    strokeWeight(1);
    stroke(0x44);
    switch (block) {
      case M_EMPTY: fill(0x00); break;
      case M_WIRE:  fill(0x12, 0x23, 0x00); break;
      case M_WIRE_HIGH:
      case M_WIRE_PRIME: fill(0xCC, 0xFF, 0x00); break;
      case M_WIRE_LOW:
      case M_WIRE_WAIT:  fill(0x44, 0xCC, 0x00); break;
    }
    rect(x*bs, y*bs, bs, bs);
  }
}