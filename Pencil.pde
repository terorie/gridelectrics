import java.lang.Character;

int pencilMode;
static final int PENCIL_NONE = 0;
static final int PENCIL_DRAW = 1;
static final int PENCIL_DELETE = 2;

void mousePressed() {
  switch (mouseButton) {
    case LEFT:  pencilMode = PENCIL_DRAW; break;
    case RIGHT: pencilMode = PENCIL_DELETE; break;
  }
}

void mouseReleased() {
  pencilMode = PENCIL_NONE;
}

void keyPressed() {
  switch (Character.toLowerCase(key)) {
  case ' ': {
    int bx = mouseX/bs;
    int by = mouseY/bs;
    g.sendPulse(bx, by);
    break;
  }
  case 'a': {
    for (int x = 0; x < w; x++)
      for (int y = 0; y < h; y++)
        g.write(x, y, Grid.M_WIRE);
    break;
  }
  
  case 'w': {
    wait = !wait;
    redraw = true;
    break;
  }
  
  case 'f': {
    fuse = !fuse;
    redraw = true;
    break;
  }
  }
}

void handleMouse() {
  redraw |= _handleMouse();
}

boolean _handleMouse() {
  int bx = mouseX/bs;
  int by = mouseY/bs;
  switch (pencilMode) {
    case PENCIL_DRAW: g.putWire(bx, by); return true;
    case PENCIL_DELETE: g.removeWire(bx, by); return true;
    default: return false;
  }
}