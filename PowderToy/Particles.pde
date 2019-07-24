public class Particles {
   private String[] types;
   private color[] Colors;
   private float[] Mass;
   private float[] Gravity;
   private boolean[] Liquid;
   private int Amount;
   Particles(int amount){
     types = new String[amount];
     Colors = new color[amount];
     Mass = new float[amount];
     Gravity = new float[amount];
     Liquid = new boolean[amount];
     this.Amount = amount;
   }
   
   public void add(int index,String t, color c,float m,float g,boolean l) {
     this.types[index] = t;
     this.Colors[index] = c;
     this.Mass[index] = m;
     this.Gravity[index] = g;
     this.Liquid[index] = l;
   }
}
