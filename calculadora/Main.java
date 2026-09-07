public class Main {
    public static void main(String[] args) {
        People persona1 = new People("Juan", 1.75, (byte) 25);
        
        
    
    persona1.setName("Carlos");
    persona1.setAge((byte) 30);
    persona1.setHeight(1.80);
    System.out.println("El nuevo nombre de persona1 es: " + persona1.getName());
    persona1.saludar();
    persona1.cumplirAños();
    persona1.crecer(0.05);
    System.out.println("La edad de persona1 es: " + persona1.getAge());
    System.out.println("La altura de persona1 es: " + persona1.getHeight());

    
        
        
        

    }
}