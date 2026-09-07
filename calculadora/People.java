public class People {
     private String name;
     private byte age;
     private double height;

    public People(String name, double height, byte age) {
        this.name = name;
        this.height = height;
        this.age = age;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public byte getAge() {
        return age;
    }
    public void setAge(byte age) {
        if(age >= 0 && age <= 120){
            this.age = age;
        } else {
            System.out.println("Edad inválida");
        }
    }
    public double getHeight() {
        return height;
    }
    public void setHeight(double height) {
        if(height > 0 && height < 2){
            this.height = height;
        } else {
            System.out.println("Altura inválida");
        }
    }
    public void saludar() {
        System.out.println("Hola, mi nombre es " + name);
        System.out.println("gusto en conocerte");
   }

        public void cumplirAños(){
            age++;
        }
        public void crecer(double altura){
            height += altura;

    }
}
