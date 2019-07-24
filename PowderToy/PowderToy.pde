Particles particles; //<>//
int[] grid; 
int particleAmount = 0;
int spawnAmount = 0;
int goal = int(random(1000));
int particle;
int spawnX = int(random(width));
float error = 0;
int placing = 0;
void setup() {
  //size(1280,720);
  size(629, 424);
  //fullScreen(2);

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
  particle = floor(random(1, particles.Amount));
  frameRate(60);
  textSize(20);
}

void draw() {
  if (particleAmount < 10 && spawnAmount < goal && grid[spawnX] == 0) {
    if (frameCount % 2 == 0) {
      grid[spawnX] = particle;
      particleAmount ++;
      spawnAmount ++;
      error = 0;
    }
  } else if (particleAmount < 10 && error == 3) {
    error = 0;
    spawnX = int(random(width));
    goal = int(random(1000));
    spawnAmount = 0;
    particle = floor(random(1, particles.Amount));
  } else if (error < 3) {
    error ++;
  } else {
    //int parts = 0;
    //for (int i = 0; i < grid.length; i ++) {
    //  if (grid[i] != 0) {
    //    parts++;
    //  }
    //}
    //print("Particles:"+parts);
  }
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
  if (mouseX > 0 && mouseX < width & mouseY > 0 && mouseY < height) {
  String text = particles.types[grid[mouseX+mouseY*width]];
    if (text != "void") {
      text(text, 10, 50);
    }
  }
  text(particles.types[placing],10,20);
  
  if (mousePressed) {
    if (mouseX > 0 && mouseX < width & mouseY > 0 && mouseY < height) {
      grid[mouseX+(mouseY+1)*width] = placing;
    }
  }
}

void keyPressed() {
  if (keyCode == LEFT) {
   placing = (placing + particles.Amount - 1)%particles.Amount; 
  } else if (keyCode == RIGHT) {
   placing = (placing + 1)%particles.Amount; 
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
      if (random(1) < 0.5) {
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
  for (int i = floor(random(map((1 / (1 + exp(-particles.Gravity[grid[index]]))), 0.5, 0.8, 0.2, 2)*map(particles.Gravity[grid[index]], 0, 1, 10, 20))); i >= 0; i--) {
    if (index+(width*i) < grid.length) {
      if (grid[index+(width*i)] == 0) {
        grid[index+(width*i)] = grid[index];
        grid[index] = 0;
      } else {
        int dummy = grid[index+(width*i)]; 
        grid[index+(width*i)] = grid[index];
        grid[index] = dummy;
      }
    }
  }
}

void moveLeft(int index) {
  for (int i = floor(random(map((1 / (1 + exp(-particles.Gravity[grid[index]]))), 0.5, 0.8, 0.5, 5)*map(particles.Gravity[grid[index]], 0, 1, 10, 20))); i >= 0; i--) {
    if (index-i < grid.length) {
      if (index-i != -1) {
        if (grid[index-i] == 0) {
          grid[index-i] = grid[index];
          grid[index] = 0;
        } else {
          int dummy = grid[index-i]; 
          grid[index-i] = grid[index];
          grid[index] = dummy;
        }
      } else {
        if (grid[index+width-i] == 0) {
          grid[index+width-i] = grid[index];
          grid[index] = 0;
        } else {
          int dummy = grid[index+width-i]; 
          grid[index+width-i] = grid[index];
          grid[index] = dummy;
        }
      }
    }
  }
}

void moveRight(int index) {
  for (int i = floor(random(map((1 / (1 + exp(-particles.Gravity[grid[index]]))), 0.5, 0.8, 0.5, 5)*map(particles.Gravity[grid[index]], 0, 1, 10, 20))); i >= 0; i--) {
    if (index+i < grid.length) {
        if (grid[index+i] == 0) {
          grid[index+i] = grid[index];
          grid[index] = 0;
        } else {
          int dummy = grid[index+i]; 
          grid[index+i] = grid[index];
          grid[index] = dummy;
        }
      } else {
        if (grid[index-width+i] == 0) {
          grid[index-width+i] = grid[index];
          grid[index] = 0;
        } else {
          int dummy = grid[index-width+i]; 
          grid[index-width+i] = grid[index];
          grid[index] = dummy;
        }
    }  
  }
}

void fallDownLeft(int index) {
  for (int i = floor(random(map((1 / (1 + exp(-particles.Gravity[grid[index]]))), 0.5, 0.8, 0.2, 2)*map(particles.Gravity[grid[index]], 0, 1, 10, 20))); i >= 0; i--) {
    if (index+(width*i)-1 < grid.length) {
      if (index+(width*i)-1 != -1) {
        if (grid[index+(width*i)-1] == 0) {
          grid[index+(width*i)-1] = grid[index];
          grid[index] = 0;
        } else {
          int dummy = grid[index+(width*i)-1]; 
          grid[index+(width*i)-1] = grid[index];
          grid[index] = dummy;
        }
      } else {
        if (grid[index+(width*(i+1))-1] == 0) {
          grid[index+(width*(i+1))-1] = grid[index];
          grid[index] = 0;
        } else {
          int dummy = grid[index+(width*(i+1))-1]; 
          grid[index+(width*(i+1))-1] = grid[index];
          grid[index] = dummy;
        }
      }
    }
  }
}

void fallDownRight(int index) {
  for (int i = floor(random(map((1 / (1 + exp(-particles.Gravity[grid[index]]))), 0.5, 0.8, 0.2, 2)*map(particles.Gravity[grid[index]], 0, 1, 10, 20))); i >= 0; i--) {
    if (index+(width*i)+1 < grid.length) {
      if (index+(width*i)+1 != grid.length) {
        if (grid[index+(width*i)+1] == 0) {
          grid[index+(width*i)+1] = grid[index];
          grid[index] = 0;
        } else {
          int dummy = grid[index+(width*i)+1]; 
          grid[index+(width*i)+1] = grid[index];
          grid[index] = dummy;
        }
      } else {
        if (grid[index-(width*i)+1] == 0) {
          grid[index-(width*i)+1] = grid[index];
          grid[index] = 0;
        } else {
          int dummy = grid[index-(width*i)+1]; 
          grid[index-(width*i)+1] = grid[index];
          grid[index] = dummy;
        }
      }
    }
  }
}
