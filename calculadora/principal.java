public class principal {
    public static void main(String[] args) {
        int[]n = {1, 2, 3, 4, 10, 12};
        for (int i = 1; i < n.length; i+= 2) {
            System.out.println(n[i]);
        }
        System.out.println(" ***********************************");
        
        System.out.println(n.length);
        
    }
}