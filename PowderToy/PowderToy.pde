Particles particles;
int[] grid;
int placing = 0;
int size = 1;
void setup() {
  size(1280,720);
  
  particles = new Particles(20);
  //Setting Particle Data
  particles.add(0, "void", color(0, 0, 0), 0, 0, false);
  particles.add(1, "dust", color(255, 220, 180), 85, 0.1, false);
  particles.add(2, "stone", color(160, 160, 160), 90, 0.3, false);
  particles.add(3, "snow", color(192, 224, 255), 50, 0.05, false);
  particles.add(4, "concrete", color(192, 192, 192), 55, 0.3, false);
  particles.add(5, "salt", color(255, 255, 255), 75, 0.3, false);
  particles.add(6, "Broken Metal", color(112, 80, 96), 90, 0.3, false);
  particles.add(7, "Sand", color(255, 208, 144), 90, 0.3, false);
  particles.add(8, "Broken Glass", color(96, 96, 96), 90, 0.3, false);
  particles.add(9, "Yeast", color(238, 224, 192), 80, 0.1, false);
  particles.add(10, "Fuse Powder", color(99, 173, 95), 70, 0.1, false);
  particles.add(11, "Broken Coal", color(51, 51, 51), 90, 0.3, false);
  particles.add(12, "Freeze", color(192, 224, 255), 90, 0.05, false);
  particles.add(13, "Gravity", color(19, 19, 19), 90, 0.01, false);
  particles.add(14, "Anti-Air Particle", color(255, 255, 238), 85, 0, false);
  particles.add(15, "Broken Quartz", color(122, 190, 210), 90, 0.27, false);
  particles.add(16, "Broken Electronics", color(112, 112, 96), 90, 0.18, false);
  particles.add(17, "Clay Dust", color(148, 84, 84), 55, 0.2, false);
  particles.add(18, "Sawdust", color(240, 240, 160), 18, 0.1, false);
  particles.add(19, "Water", color(40, 100, 255), 3, 0.1, true);

  //Setting grid
  grid = new int[width*height];
  frameRate(100000);
  textSize(20);
}

void draw() {
  background(0);
  loadPixels();
  for (int i = grid.length - 1; i >= 0; i --) {
    if (grid[i] != 0) {
      pixels[i] = particles.Colors[grid[i]];
      if (i <= grid.length - width) { 
        updateParticle(i);
      }
    }
  }
  updatePixels();
  fill(255, 200);
  
  text("Size: " + size,5,20);
  text("Selected: " + particles.types[placing],5,40);
  if (mouseX > 0 && mouseX < width & mouseY > 0 && mouseY < height) {
    String text = particles.types[grid[mouseX+mouseY*width]];
    if (text != "void") {
      text("Over: " + text, 5, 60);
    }
  }
  
  if (mousePressed) {
    if (mouseX > 0 && mouseX < width & mouseY > 0 && mouseY < height) {
      for (int i = -size; i < size; i ++) {
        for (int j = -size; j < size; j ++) {
          if (mouseX + i >= 0 && mouseX + i < width && mouseY + j >= 0 && mouseY + j < height) {
            grid[(mouseX+i)+((mouseY+j))*width] = placing;
          }
        }
      }
    }
  }
}

void keyPressed() {
  switch (keyCode) {
    case LEFT:
      placing = (placing - 1 + particles.Amount) % particles.Amount; 
      break;
    case RIGHT:
      placing = (placing + 1) % particles.Amount; 
      break;
    case UP:
      size = min(10, size + 1); 
      break;
    case DOWN:
      size = max(0, size - 1); 
      break;
  }
}


void updateParticle(int index) {
  if (index < grid.length - (width)) {
    if (random(1) < 0.3) {
      if (index+width+1 != grid.length) {
        if (grid[index+width-1] == 0 || particles.Mass[grid[index+width-1]] < particles.Mass[grid[index]] && grid[index+width+1] == 0 || particles.Mass[grid[index+width+1]] < particles.Mass[grid[index]]) {
          if (random(1) < 0.5) {
            fallDownLeft(index);
          } else {
            fallDownRight(index);
          }
        } else if (grid[index+width-1] == 0 || particles.Mass[grid[index+width-1]] < particles.Mass[grid[index]]) {
          fallDownLeft(index);
        } else if (grid[index+width+1] == 0 || particles.Mass[grid[index+width+1]] < particles.Mass[grid[index]]) {
          fallDownRight(index);
        }
      } else {
        if (grid[index+width-1] == 0 || particles.Mass[grid[index+width-1]] < particles.Mass[grid[index]] && grid[index-width+1] == 0 || particles.Mass[grid[index-width+1]] < particles.Mass[grid[index]]) {
          if (random(1) < 0.5) {
            fallDownLeft(index);
          } else {
            fallDownRight(index);
          }
        } else if (grid[index+width-1] == 0 || particles.Mass[grid[index+width-1]] < particles.Mass[grid[index]]) {
          fallDownLeft(index);
        } else if (grid[index-width+1] == 0 || particles.Mass[grid[index-width+1]] < particles.Mass[grid[index]]) {
          fallDownRight(index);
        }
      }
    } else if (grid[index+width] == 0 || particles.Mass[grid[index+width]] < particles.Mass[grid[index]]) {
        fallDown(index);
    } else if (particles.Liquid[grid[index]] == true) {
      if (random(1) < 0.5 && index != 0) {
        if (grid[index-1] == 0) {
          moveLeft(index);
        }
       } else {
         if (grid[index+1] == 0) {
          moveRight(index);
        }
       }
    }
  }
}

void fallDown(int index) {
  int pixelsToMove = floor(random(map((1 / (1 + exp(-particles.Gravity[grid[index]]))), 0.5, 0.8, 0.2, 2)*map(particles.Gravity[grid[index]], 0, 1, 10, 20)));
  int offset = width * pixelsToMove;
  if (index + offset < grid.length) {
    if (grid[index + offset] == 0) {
      grid[index + offset] = grid[index];
      grid[index] = 0;
    } else {
      int dummy = grid[index + offset]; 
      grid[index + offset] = grid[index];
      grid[index] = dummy;
    }
  }
}

void moveLeft(int index) {
  float gravity = particles.Gravity[grid[index]];
  int moveAmount = floor(random(map((1 / (1 + exp(-gravity))), 0.5, 0.8, 0.5, 5)*map(gravity, 0, 1, 10, 20)));
  for (int i = moveAmount; i >= 0; i--) {
    int movedIndex = (index-i > 0) ? index-i : index+width-i;
    if (grid[movedIndex] == 0) {
      grid[movedIndex] = grid[index];
      grid[index] = 0;
    } else {
      int dummy = grid[movedIndex]; 
      grid[movedIndex] = grid[index];
      grid[index] = dummy;
    }  
  }
}

void moveRight(int index) {
  float gravity = particles.Gravity[grid[index]];
  int moveAmount = floor(random(map((1 / (1 + exp(-gravity))), 0.5, 0.8, 0.5, 5)*map(gravity, 0, 1, 10, 20)));
  for (int i = moveAmount; i >= 0; i--) {
    int movedIndex = (index+i < grid.length) ? index+i : index-width+i;
    if (grid[movedIndex] == 0) {
      grid[movedIndex] = grid[index];
      grid[index] = 0;
    } else {
      int dummy = grid[movedIndex]; 
      grid[movedIndex] = grid[index];
      grid[index] = dummy;
    }  
  }
}

void fallDownLeft(int index) {
  int numIterations = floor(random(map((1 / (1 + exp(-particles.Gravity[grid[index]]))), 0.5, 0.8, 0.2, 2)*map(particles.Gravity[grid[index]], 0, 1, 10, 20)));
  int nextIndex = index+(width*numIterations)-1;
  if (nextIndex < 0) {
    nextIndex = index-(width*numIterations)-1;
  }
  if (nextIndex >= 0 && nextIndex < grid.length) {
    if (grid[nextIndex] == 0) {
      grid[nextIndex] = grid[index];
      grid[index] = 0;
    } else {
      int dummy = grid[nextIndex]; 
      grid[nextIndex] = grid[index];
      grid[index] = dummy;
    }
  }
}


void fallDownRight(int index) {
  int numIterations = floor(random(map((1 / (1 + exp(-particles.Gravity[grid[index]]))), 0.5, 0.8, 0.2, 2)*map(particles.Gravity[grid[index]], 0, 1, 10, 20)));
  int nextIndex = index+(width*numIterations)+1;
  if (nextIndex >= grid.length) {
    nextIndex = index-(width*numIterations)+1;
  }
  if (grid[nextIndex] == 0) {
    grid[nextIndex] = grid[index];
    grid[index] = 0;
  } else {
    int dummy = grid[nextIndex]; 
    grid[nextIndex] = grid[index];
    grid[index] = dummy;
  }
}
